package dNdLib.managers
{
	import dNdLib.containers.IDnDContainer;
	import dNdLib.events.DnDEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	/**
	 * Singleton class that conducts DnD operations.
	 */
	public class DnDManager extends EventDispatcher implements IDnDManager
	{
		/**
		 * @inheritDoc
		 */
		public function get isDragging ():Boolean
		{
			return DragManager.isDragging;
		}
		
		///////////////////////////////////////////////////////////////
		//	REGISTER
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _dNdContainers:ArrayCollection = new ArrayCollection();
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @private
		 */
		private var _dragInitiator:UIComponent;
		
		/**
		 * @private
		 */
		private var _originalDnDContainer:IDnDContainer;
		
		/**
		 * @private
		 */
		private var _originalIndex:int;
	
		/**
		 * @private
		 */
		private var _destinationContainer:IDnDContainer;
		
		/**
		 * @private
		 */
		private var _destinationIndex:int;
		
		/**
		 * @private
		 */
		private var _dropTargetImage:UIComponent;
		
		/**
		 * Flag indicating if a target index indicator is used during the DnD operation.
		 * This feature is currently not in use.
		 */
		public var useDropTargetImage:Boolean = false;
		
		//public var dropTargetStyle:String = "none"; //"simple", "complex"
		
		/**
		 * Flag indicating whether to use a simple drag proxy image or a more complex rendering.
		 */
		public var useSimpleDragProxy:Boolean = true;
		
		/**
		 * Initiates a DnD operation.
		 * 
		 * @param evt The mouse event triggered from the drag initiator.
		 */
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
		
		/**
		 * Depending on the destination container's layout, this will calculated the intended index to add the DnD content.
		 * Future features will accommodate custom layouts.
		 * 
		 * @return int The destination index for the DnD content.
		 */
		//can be overridden for use with a DnDContainer that has a custom layout i.e. circular layout
		protected function calculateDestinationIndex ():int
		{
			if (_destinationContainer.layout == "horizontal")
				return calculateHorizontalIndex();
				
			else if (_destinationContainer.layout == "vertical")
				return calculateVerticalIndex();
			
			else
				return -1;//later on we can calc for custom layouts --- wayyyyy into the future
		}
		
		/**
		 * @private
		 */
		private function calculateHorizontalIndex ():int
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
				if (child.x <= pt.x && pt.x <= child.x + child.width)
					return i;
					
				//for first child, are we inside the padding at the top?
				if (i == 0)
				{
					if (pt.x < child.x)
						return 0;
				}
				
				//does the pt reside betw. two children?
				if (prevChild)
				{
					if (prevChild.x + prevChild.width < pt.x && pt.x < child.x)
						return i;
				}
				
				prevChild = child;			
			}
			
			return -1; //tells us that the destination container should use addChild instead of addChildAt
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function updateDropTargetPosition ():void
		{
			//are we doing psuedo-positioning or actually adding a drop target to the destination container?
			
		}
		
		///////////////////////////////////////////////////////////////
		//	REDISPATCH DnD EVENT
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function onDragComplete (evt:DragEvent):void
		{
			dispatchDnDEvent(new DnDEvent(DnDEvent.COMPLETE_DnD));
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function onDragEnter (evt:DragEvent):void
		{
			_destinationContainer = IDnDContainer(evt.target);
			
			if (_destinationContainer.allowDropIn)
			{
				//dropping in same container? can we?
				if (_destinationContainer == _originalDnDContainer)
				{
					if (_destinationContainer.allowSelfDrop)
					{
						DragManager.acceptDragDrop(_destinationContainer);
						dispatchDnDEvent(new DnDEvent(DnDEvent.ENTER_DnD));
					}
					
					return;
				}
				
				//do we have limitations set via related containers?
				else if (_destinationContainer.relatedContainers.length > 0)
				{
					var item:String;
					for each (item in _destinationContainer.relatedContainers)
					{
						if (_originalDnDContainer.id == item)
						{
							DragManager.acceptDragDrop(_destinationContainer);
							dispatchDnDEvent(new DnDEvent(DnDEvent.ENTER_DnD));
							
							return;
						}
					}
				}
				
				else
				{	
					DragManager.acceptDragDrop(_destinationContainer);
					dispatchDnDEvent(new DnDEvent(DnDEvent.ENTER_DnD));
				}
			}
		}
		
		/**
		 * @private
		 */
		private function onDragExit (evt:DragEvent):void
		{
			dispatchDnDEvent(new DnDEvent(DnDEvent.EXIT_DnD));
		}
		
		/**
		 * @private
		 */
		private function onDragOver (evt:DragEvent):void
		{
		}
		
		/**
		 * @private
		 */
		private function onDragStart (evt:DragEvent):void
		{
		}
		
		///////////////////////////////////////////////////////////////
		//	DRAG EVENT REGISTRATION
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function updateDnDContainerEventHandlers (evt:Event):void
		{
			registerDnDContainerForDragEvents(IDnDContainer(evt.target));
		}
		
		/**
		 * @private
		 */
		private function registerDnDContainerForDragEvents (target:IDnDContainer):void
		{
			if (!target.allowDropIn)
			{
				target.removeEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
				target.removeEventListener(DragEvent.DRAG_DROP, onDragDrop);
				target.removeEventListener(DragEvent.DRAG_ENTER, onDragEnter);
				target.removeEventListener(DragEvent.DRAG_EXIT, onDragExit);
				target.removeEventListener(DragEvent.DRAG_OVER, onDragOver);
				target.removeEventListener(DragEvent.DRAG_START, onDragStart);
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
				
				if (!target.hasEventListener(DragEvent.DRAG_OVER))
					target.addEventListener(DragEvent.DRAG_OVER, onDragOver);
				
				if (!target.hasEventListener(DragEvent.DRAG_START))
					target.addEventListener(DragEvent.DRAG_START, onDragStart);
			}
		}
		
		///////////////////////////////////////////////////////////////
		//	SINGLETON
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		static private var _instance:DnDManager;
		
		/**
		 * DnDManager is a Singleton implementor.
		 * 
		 * @returns DnDManager The singlular instance.
		 */
		static public function getInstance ():DnDManager
		{
			if (!_instance)
				_instance = new DnDManager();
				
			return _instance;
		}
		
		/**
		 * @private
		 */
		function DnDManager ()
		{
			super();
		}
	}
}