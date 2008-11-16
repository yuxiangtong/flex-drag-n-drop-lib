package dNdLib.events
{
	import flash.events.Event;
	
	import mx.core.IUIComponent;
	
	/**
	 * Drag and Drop events are triggered by using the DnD Framework.
	 */
	public class DnDEvent extends Event
	{
		//////////////////////////////////////////////////////
		// CONST
		//////////////////////////////////////////////////////
		
		/**
		 * Event type triggered when a DnD operation starts.
		 */
		static public const START_DnD:String = "dNdStart";
		
		/**
		 * Event type triggered when a DnD operation enters the space of a IDnDContainer.
		 */
		static public const ENTER_DnD:String = "dNdEnter";
		
		/**
		 * Event type triggered when a DnD operation exits the space of a IDnDContainer.
		 */
		static public const EXIT_DnD:String = "dNdExit";
		
		/**
		 * Event type triggered when a DnD operation's content is dropped onto a target.
		 */
		static public const DROP_DnD:String = "dNdDrop";
		
		/**
		 * Event type triggered when a DnD operation's content is dropped onto a target.
		 */
		static public const OVER_DnD:String = "dNdOver";
		
		/**
		 * Event type triggered when a DnD operation has completed.
		 */
		static public const COMPLETE_DnD:String = "dNdComplete";
		
		//////////////////////////////////////////////////////
		// VARS
		//////////////////////////////////////////////////////
		
		/**
		 * The IDnDContainer who initiated the DnD operation.
		 */
		public var dragInitiator:IUIComponent;
		
		/**
		 * The index of the DnD operation's content
		 */
		public var originalIndex:uint;
		
		/**
		 * The original parent of the DnD operation's content.
		 * This may or may not be the dragInitiator depending on the implementation.
		 */
		public var originalContainer:IUIComponent;
		
		/**
		 * The target index intended for the DnD operation's content upon a successful drop.
		 */
		public var destinationIndex:uint;
		
		/**
		 * The target parent that receives the DnD operation's content upon a successful drop.
		 */
		public var destinationContainer:IUIComponent;
		
		//////////////////////////////////////////////////////
		// CONSTRUCTOR
		//////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function DnDEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		//////////////////////////////////////////////////////
		// OVERRIDES
		//////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
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