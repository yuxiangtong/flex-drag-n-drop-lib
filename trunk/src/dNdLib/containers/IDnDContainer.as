package dNdLib.containers
{
	import mx.core.IUIComponent;
	import flash.display.DisplayObject;
	
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
		
		function get layout ():String;
		function set layout (value:String):void;
		
		//hooking into UIComponent child methods
		function get numChildren ():int;
		
		function addChild (child:DisplayObject):DisplayObject;
		function addChildAt (child:DisplayObject, index:int):DisplayObject;
		
		function getChildAt (index:int):DisplayObject;
		function getChildByName (name:String):DisplayObject;
		function getChildIndex (child:DisplayObject):int;
		function getChildren ():Array;
		
		function removeAllChildren ():void;
		function removeChild (child:DisplayObject):DisplayObject;
		function removeChildAt (index:int):DisplayObject;
	}
}