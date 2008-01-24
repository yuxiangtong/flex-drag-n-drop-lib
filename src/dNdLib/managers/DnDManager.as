package dNdLib.managers
{
	import com.jwopitz.utils.BitmapUtil;
	
	import dNdLib.containers.IDnDContainer;
	import dNdLib.events.DnDEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	public class DnDManager extends EventDispatcher implements IDnDManager
	{
		public function get isDragging ():Boolean
		{
			return DragManager.isDragging;
		}
		
		///////////////////////////////////////////////////////////////
		//	REGISTER
		///////////////////////////////////////////////////////////////
		
		private var _dNdContainers:ArrayCollection = new ArrayCollection();
		
		public function registerContainer (target:IDnDContainer):Boolean
		{
			//determine if target is registered or not
			if (_dNdContainers.contains(target))
				return false;
			
			//if not then add it
			_dNdContainers.addItem(target);
			
			//register for DnDContainer prop change events
			target.addEventListener("allowDropInChanged", updateDnDContainerEventHandlers);
			registerDnDContainerForDragEvents(target);
			
			//let them know it was a success
			return true;
		}
		
		///////////////////////////////////////////////////////////////
		//	DO DRAG
		///////////////////////////////////////////////////////////////
		
		private var _dragInitiator:UIComponent;
		
		private var _originalDnDContainer:IDnDContainer;
		private var _originalIndex:int;
	
		private var _destinationContainer:IDnDContainer;
		private var _destinationIndex:int;
		
		private var _dropTargetImage:UIComponent;
		
		public var useDropTargetImage:Boolean = true;
		public var useSimpleDragProxy:Boolean = true;
		
		public function doDrag (evt:MouseEvent):void
		{
			if (isDragging)
				return;
			
			//get some info about the DnD
			_dragInitiator = UIComponent(evt.target);
			_originalDnDContainer = IDnDContainer(_dragInitiator.parent);
			_originalIndex = _originalDnDContainer.getChildIndex(_dragInitiator);
			_destinationContainer = IDnDContainer(_dragInitiator.parent);
			
			//check to see if we are allowing a drag out
			if (!_originalDnDContainer.allowDragOut)
				return;
			
			var dragSource:DragSource = new DragSource();
			var dragProxy:UIComponent;
			
			/*if (!useSimpleDragProxy)
			{
				var s:Sprite = BitmapUtil.render(_dragInitiator);
				
				dragProxy = new UIComponent();
				dragProxy.addChild(s);
			}*/
			
			DragManager.doDrag(_dragInitiator, dragSource, evt);
			
			/*if (useDropTargetImage)
			{
				_dropTargetImage = BitmapUtil.renderOutline(_dragInitiator);
				_dropTargetImage.id = "dropTargetImage";
				
				_originalDnDContainer.removeChild(_dragInitiator);
				_originalDnDContainer.addChildAt(_dropTargetImage, _originalIndex);
			}*/
			
			dispatchDnDEvent(new DnDEvent(DnDEvent.START_DnD));
		}
		
		///////////////////////////////////////////////////////////////
		//	MISC METHODS
		///////////////////////////////////////////////////////////////
		
		//can be overridden for use with a DnDContainer that has a custom layout i.e. circular layout
		protected function calculateDestinationIndex ():int
		{
			if (_destinationContainer.layout == "horizontal")
				return calculateHorizontalIndex();
				
			else if (_destinationContainer.layout == "vertical")
				return calculateVerticalIndex();
			
			else
				return 0;//later on we can calc for custom layouts --- wayyyyy into the future
		}
			
		private function calculateHorizontalIndex ():int
		{
			return 0;
		}
		
		private function calculateVerticalIndex ():int
		{
			var pt:Point = new Point();
			pt.x = UIComponent(_destinationContainer).stage.mouseX;
			pt.y = UIComponent(_destinationContainer).stage.mouseY;
			pt = UIComponent(_destinationContainer).globalToContent(pt);
			
			var prevChild:DisplayObject;
			var child:DisplayObject;
			var i:int;
			for (i; i < _destinationContainer.numChildren; i++)
			{
				//if the child hits the pt, then no need for further calculation
				child = _destinationContainer.getChildAt(i);
				if (child.y <= pt.y && pt.y <= child.y + child.height)
					return i;
					
				//for first child, are we inside the padding at the top?
				if (i == 0)
				{
					if (pt.y < child.y)
						return 0;
				}
				
				//does the pt reside betw. two children?
				if (prevChild)
				{
					if (prevChild.y + prevChild.height < pt.y && pt.y < child.y)
						return i;
				}
				
				prevChild = child;					
			}
			
			return -1; //tells us that the destination container should use addChild instead of addChildAt
		}
		
		private function canAcceptDrop (destination:IDnDContainer):Boolean
		{
			if (destination.maximumNumChildren == 0)
				return true;
				
			if (destination.numChildren < destination.maximumNumChildren)
				return true;
			
			if (destination.numChildren >= destination.maximumNumChildren && destination.overFlowTarget)
				return true;
				
			return false;
		}
		
		///////////////////////////////////////////////////////////////
		//	REDISPATCH DnD EVENT
		///////////////////////////////////////////////////////////////
		
		private function dispatchDnDEvent (evt:DnDEvent):Boolean
		{
			evt.dragInitiator = _dragInitiator;
			evt.originalIndex = _originalIndex;
			evt.originalContainer = _originalDnDContainer;
			evt.destinationIndex = _destinationIndex;
			evt.destinationContainer = _destinationContainer;
			
			return dispatchEvent(evt);
		}
		
		///////////////////////////////////////////////////////////////
		//	DRAG EVENT HANDLERS
		///////////////////////////////////////////////////////////////
		
		private function onDragComplete (evt:DragEvent):void
		{
			dispatchDnDEvent(new DnDEvent(DnDEvent.COMPLETE_DnD));
		}
		
		private function onDragDrop (evt:DragEvent):void
		{
			_destinationContainer = IDnDContainer(evt.target);
			_destinationIndex = calculateDestinationIndex();
			
			//for now plop it into index = 0;
			_originalDnDContainer.removeChild(_dragInitiator);
			
			if (_destinationIndex == -1)
				_destinationContainer.addChild(_dragInitiator);
				
			else
				_destinationContainer.addChildAt(_dragInitiator, _destinationIndex);
			
			dispatchDnDEvent(new DnDEvent(DnDEvent.DROP_DnD));
		}
		
		private function onDragEnter (evt:DragEvent):void
		{
			_destinationContainer = IDnDContainer(evt.target);
			
			if (!_destinationContainer.allowSelfDrop && _destinationContainer == _originalDnDContainer)
				return;
				
			if (_destinationContainer.allowDropIn)// && canAcceptDrop(_destinationContainer))
				DragManager.acceptDragDrop(_destinationContainer);
				
			dispatchDnDEvent(new DnDEvent(DnDEvent.ENTER_DnD));
		}
		
		private function onDragExit (evt:DragEvent):void
		{
			dispatchDnDEvent(new DnDEvent(DnDEvent.EXIT_DnD));
		}
		
		private function onDragOver (evt:DragEvent):void
		{
			
		}
		
		private function onDragStart (evt:DragEvent):void
		{
			
		}
		
		///////////////////////////////////////////////////////////////
		//	DRAG EVENT REGISTRATION
		///////////////////////////////////////////////////////////////
		
		private function updateDnDContainerEventHandlers (evt:Event):void
		{
			registerDnDContainerForDragEvents(IDnDContainer(evt.target));
		}
		
		private function registerDnDContainerForDragEvents (target:IDnDContainer):void
		{
			if (!target.allowDropIn)
			{
				target.removeEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
				target.removeEventListener(DragEvent.DRAG_DROP, onDragDrop);
				target.removeEventListener(DragEvent.DRAG_ENTER, onDragEnter);
				target.removeEventListener(DragEvent.DRAG_EXIT, onDragExit);
				//target.removeEventListener(DragEvent.DRAG_OVER, onDragOver);
				//target.removeEventListener(DragEvent.DRAG_START, onDragStart);
			}
			
			else
			{
				if (!target.hasEventListener(DragEvent.DRAG_COMPLETE))
					target.addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
				
				if (!target.hasEventListener(DragEvent.DRAG_DROP))
					target.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
				
				if (!target.hasEventListener(DragEvent.DRAG_ENTER))
					target.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
				
				if (!target.hasEventListener(DragEvent.DRAG_EXIT))
					target.addEventListener(DragEvent.DRAG_EXIT, onDragExit);
				
				/*if (!target.hasEventListener(DragEvent.DRAG_OVER))
					target.addEventListener(DragEvent.DRAG_OVER, onDragOver);
				
				if (!target.hasEventListener(DragEvent.DRAG_START))
					target.addEventListener(DragEvent.DRAG_START, onDragStart);*/
			}
		}
		
		///////////////////////////////////////////////////////////////
		//	SINGLETON
		///////////////////////////////////////////////////////////////
		
		static private var _instance:DnDManager;
		
		static public function getInstance ():DnDManager
		{
			if (!_instance)
				_instance = new DnDManager();
				
			return _instance;
		}
		
		function DnDManager ()
		{
			super();
		}
	}
}