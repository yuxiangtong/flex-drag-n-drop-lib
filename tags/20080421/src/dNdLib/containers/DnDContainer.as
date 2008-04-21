package dNdLib.containers
{
	import dNdLib.managers.DnDManager;
	
	import flash.events.Event;
	
	import mx.containers.Box;
	import mx.core.IUIComponent;
	
	/**
	 * A container class that works with the DnDManager to allow for children drag and drop operations.
	 */
	public class DnDContainer extends Box implements IDnDContainer
	{
		////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function DnDContainer()
		{
			super();
			
			DnDManager.getInstance().registerContainer(this);
		}
		
		////////////////////////////////////////////////////////////////////
		//	LAYOUT
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		[Bindable("layoutChanged")]
		public function get layout ():String
		{
			return direction;
		}
		
		/**
		 * @private
		 */
		public function set layout (value:String):void
		{
			direction = value;
			
			dispatchEvent(new Event("layoutChanged"));
		}
		
		////////////////////////////////////////////////////////////////////
		//	ALLOW DRAG OUT
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _dragOut:Boolean = true;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("allowDragOutChanged")]
		public function get allowDragOut ():Boolean
		{
			return _dragOut;
		}
		
		/**
		 * @private
		 */
		public function set allowDragOut (value:Boolean):void
		{
			if (_dragOut != value)
			{
				_dragOut = value;
				
				dispatchEvent(new Event("allowDragOutChanged"));
			}
		}
		
		////////////////////////////////////////////////////////////////////
		//	ALLOW DROP IN
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _dropIn:Boolean = true;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("allowDropInChanged")]
		public function get allowDropIn ():Boolean
		{
			return _dropIn;
		}
		
		/**
		 * @private
		 */
		public function set allowDropIn (value:Boolean):void
		{
			if (_dropIn != value)
			{
				_dropIn = value;
				
				dispatchEvent(new Event("allowDropInChanged"));
			}
		}
		
		////////////////////////////////////////////////////////////////////
		//	ALLOW SELF DROP
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _selfDrop:Boolean = true;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("allowSelfDropChanged")]
		public function get allowSelfDrop ():Boolean
		{
			return _selfDrop;
		}
		
		/**
		 * @private
		 */
		public function set allowSelfDrop (value:Boolean):void
		{
			if (_selfDrop != value)
			{
				_selfDrop = value;
				
				dispatchEvent(new Event("allowSelfDropChanged"));
			}
		}
		
		////////////////////////////////////////////////////////////////////
		//	OVER FLOW TARGET
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _overFlow:IUIComponent;
		
		/**
		 * @inheritDoc
		 */
		public function get overFlowTarget ():IUIComponent
		{
			return _overFlow;
		}
		
		/**
		 * @private
		 */
		public function set overFlowTarget (value:IUIComponent):void
		{
			
		}
		
		////////////////////////////////////////////////////////////////////
		//	RELATED CONTAINERS
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _relatedContainers:Array = [];
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("String")]
		public function get relatedContainers ():Array
		{
			return _relatedContainers;
		}
		
		/**
		 * @private
		 */
		public function set relatedContainers (value:Array):void
		{
			_relatedContainers = value;
				
			dispatchEvent(new Event("relatedContainersChanged"));
		}
		
		////////////////////////////////////////////////////////////////////
		//	MAXIMUM NUM CHILDREN
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _maxChildren:uint = 0;
		
		/**
		 * @inheritDoc
		 */
		public function get maximumNumChildren ():uint
		{
			return _maxChildren;
		}
		
		/**
		 * @private
		 */
		public function set maximumNumChildren (value:uint):void
		{
			
		}
	}
}