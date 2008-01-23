package dNdLib.containers
{
	import mx.core.IUIComponent;
	
	public interface IDnDContainer extends IUIComponent
	{
		function get allowDragOut ():Boolean;
		function set allowDragOut (value:Boolean):void;
		
		function get allowDropIn ():Boolean;
		function set allowDropIn (value:Boolean):void;
		
		function get allowSelfDrop ():Boolean;
		function set allowSelfDrop (value:Boolean):void;
		
		function get overFlowTarget ():IUIComponent;
		function set overFlowTarget (value:IUIComponent):void;
		
		function get maximumNumChildren ():uint;
		function set maximumNumChildren (value:uint):void;
	}
}