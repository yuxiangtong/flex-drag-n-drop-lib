package dNdLib.containers
{
	import flash.display.DisplayObject;
	
	import mx.core.IUIComponent;
	
	/**
	 * Feature set needed for performing DnD operations.
	 */
	public interface IDnDContainer extends IUIComponent
	{
		////////////////////////////////////////////////////////////////////
		//	ALLOW DRAG OUT
		////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if items within this container can be used for drag operations
		 */
		function get allowDragOut ():Boolean;
		
		/**
		 * @private
		 */
		function set allowDragOut (value:Boolean):void;
		
		////////////////////////////////////////////////////////////////////
		//	ALLOW DROP IN
		////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if this container can receive a drag item.
		 */
		function get allowDropIn ():Boolean;
		
		/**
		 * @private
		 */
		function set allowDropIn (value:Boolean):void;
		
		////////////////////////////////////////////////////////////////////
		//	ALLOW SELF DROP
		////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if an item dragged from this container can be dropped in this container
		 */
		function get allowSelfDrop ():Boolean;
		
		/**
		 * @private
		 */
		function set allowSelfDrop (value:Boolean):void;
		
		////////////////////////////////////////////////////////////////////
		//	OVER FLOW TARGET
		////////////////////////////////////////////////////////////////////
		
		/**
		 * If maximumNumChildren is set, when numChidren reaches that value,
		 * the overflow target receives the children on its behalf.
		 * 
		 * @see #maximumNumChildren
		 */
		function get overFlowTarget ():IUIComponent;
		
		/**
		 * @private
		 */
		function set overFlowTarget (value:IUIComponent):void;
		
		////////////////////////////////////////////////////////////////////
		//	MAXIMUM NUM CHILDREN
		////////////////////////////////////////////////////////////////////
		
		/**
		 * If an overflow target is set, when numChidren reaches this value,
		 * the overflow target receives the children on its behalf.
		 * 
		 * @see #overFlowTarget
		 */
		function get maximumNumChildren ():uint;
		
		/**
		 * @private
		 */
		function set maximumNumChildren (value:uint):void;
		
		////////////////////////////////////////////////////////////////////
		//	RELATED CONTAINERS
		////////////////////////////////////////////////////////////////////
		
		/**
		 * A list of IDnDContainer ids.  If this array is empty, the the IDnDContainer will allow drag operations from any other origin container.
		 * If there are ids present in this list, this IDnDContainer will only accept drag operations from those IDnDContainers whose ids are present.
		 * This property does not interfere with the other drag operation restriction properties and is the last to be evaluated.
		 */
		function get relatedContainers ():Array;
		
		/**
		 * @private
		 */
		function set relatedContainers (value:Array):void;
		
		////////////////////////////////////////////////////////////////////
		//	LAYOUT
		////////////////////////////////////////////////////////////////////
		
		/**
		 * The box direction of this container.  
		 */
		function get layout ():String;
		
		/**
		 * @private
		 */
		function set layout (value:String):void;
		
		////////////////////////////////////////////////////////////////////
		//	UIComponent CHILD METHODS
		////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get id ():String
		
		//hooking into UIComponent child methods
		/**
		 * @private
		 */
		function get numChildren ():int;
		
		/**
		 * @private
		 */
		function addChild (child:DisplayObject):DisplayObject;
		/**
		 * @private
		 */
		function addChildAt (child:DisplayObject, index:int):DisplayObject;
		
		/**
		 * @private
		 */
		function getChildAt (index:int):DisplayObject;
		
		/**
		 * @private
		 */
		function getChildByName (name:String):DisplayObject;
		
		/**
		 * @private
		 */
		function getChildIndex (child:DisplayObject):int;
		
		/**
		 * @private
		 */
		function getChildren ():Array;
		
		/**
		 * @private
		 */
		function removeAllChildren ():void;
		
		/**
		 * @private
		 */
		function removeChild (child:DisplayObject):DisplayObject;
		
		/**
		 * @private
		 */
		function removeChildAt (index:int):DisplayObject;
	}
}