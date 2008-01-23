package dNdLib.events
{
	import flash.events.Event;
	
	import mx.core.IUIComponent;
	
	public class DnDEvent extends Event
	{
		static public const START_DnD:String = "startDragNDrop";
		static public const ENTER_DnD:String = "enterDragNDrop";
		static public const EXIT_DnD:String = "exitDragNDrop";
		static public const DROP_DnD:String = "dropDragNDrop";
		static public const COMPLETE_DnD:String = "completeDragNDrop";
		
		public var dragInitiator:IUIComponent;
		
		public var originalIndex:uint;
		public var originalContainer:IUIComponent;
		
		public var destinationIndex:uint;
		public var destinationContainer:IUIComponent;
		
		public function DnDEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone ():Event
		{
			var evt:DnDEvent = new DnDEvent(type, bubbles, cancelable);
			
			evt.dragInitiator = dragInitiator;
			evt.originalIndex = originalIndex;
			evt.originalContainer = originalContainer;
			evt.destinationIndex = destinationIndex;
			evt.destinationContainer = destinationContainer;
			
			return evt;
		}
	}
}