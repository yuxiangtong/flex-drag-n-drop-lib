package dNdLib.containers
{
	import flash.events.Event;
	
	import mx.containers.Box;
	import mx.core.IUIComponent;
	import dNdLib.managers.DnDManager;

	public class DnDContainer extends Box implements IDnDContainer
	{
		public function DnDContainer()
		{
			super();
			
			DnDManager.getInstance().registerContainer(this);
		}
		
		private var _dragOut:Boolean = true;
		
		[Bindable("allowDragOutChanged")]
		public function get allowDragOut ():Boolean
		{
			return _dragOut;
		}
		
		public function set allowDragOut (value:Boolean):void
		{
			if (_dragOut != value)
			{
				_dragOut = value;
				
				dispatchEvent(new Event("allowDragOutChanged"));
			}
		}
		
		private var _dropIn:Boolean = true;
		
		[Bindable("allowDropInChanged")]
		public function get allowDropIn ():Boolean
		{
			return _dropIn;
		}
		
		public function set allowDropIn (value:Boolean):void
		{
			if (_dropIn != value)
			{
				_dropIn = value;
				
				dispatchEvent(new Event("allowDropInChanged"));
			}
		}
		
		private var _selfDrop:Boolean = true;
		
		[Bindable("allowSelfDropChanged")]
		public function get allowSelfDrop ():Boolean
		{
			return _selfDrop;
		}
		
		public function set allowSelfDrop (value:Boolean):void
		{
			if (_selfDrop != value)
			{
				_selfDrop = value;
				
				dispatchEvent(new Event("allowSelfDropChanged"));
			}
		}
		
		private var _overFlow:IUIComponent;
		
		public function get overFlowTarget ():IUIComponent
		{
			return _overFlow;
		}
		
		public function set overFlowTarget (value:IUIComponent):void
		{
			
		}
		
		private var _maxChildren:uint = 0;
		
		public function get maximumNumChildren ():uint
		{
			return _maxChildren;
		}
		
		public function set maximumNumChildren (value:uint):void
		{
			
		}
	}
}