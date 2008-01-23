package dNdLib.managers
{
	import com.jwopitz.utils.BitmapUtil;
	
	import dNdLib.containers.DnDContainer;
	import dNdLib.containers.IDnDContainer;
	import dNdLib.events.DnDEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
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
		
		private var _originalDnDContainer:DnDContainer;
		private var _originalIndex:int;
	
		private var _destinationDnDContainer:DnDContainer;
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
			_originalDnDContainer = DnDContainer(_dragInitiator.parent);
			_originalIndex = _originalDnDContainer.getChildIndex(_dragInitiator);
			_destinationDnDContainer = DnDContainer(_dragInitiator.parent);
			
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
		
		private function canAcceptDrop (destination:DnDContainer):Boolean
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
			evt.destinationContainer = _destinationDnDContainer;
			
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
			_destinationDnDContainer = DnDContainer(evt.target);
			
			//for now plop it into index = 0;
			_originalDnDContainer.removeChild(_dragInitiator);
			_destinationDnDContainer.addChildAt(_dragInitiator, 0);
			
			dispatchDnDEvent(new DnDEvent(DnDEvent.DROP_DnD));
		}
		
		private function onDragEnter (evt:DragEvent):void
		{
			_destinationDnDContainer = DnDContainer(evt.target);
			
			if (!_destinationDnDContainer.allowSelfDrop && _destinationDnDContainer == _originalDnDContainer)
				return;
				
			if (_destinationDnDContainer.allowDropIn)// && canAcceptDrop(_destinationDnDContainer))
				DragManager.acceptDragDrop(_destinationDnDContainer);
				
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