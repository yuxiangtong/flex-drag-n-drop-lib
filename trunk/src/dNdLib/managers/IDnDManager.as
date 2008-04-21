package dNdLib.managers
{
	import dNdLib.containers.IDnDContainer;
	
	import mx.core.IUIComponent;
	
	/**
	 * Interface for registering a IDnDContainer for DnD operations.
	 */
	public interface IDnDManager
	{
		/**
		 * Flag indicating if a DnD operation is currently taking place.
		 */
		function get isDragging ():Boolean;
		
		/**
		 * Registers the target container for DnD operations.
		 * 
		 * @param target The target container intended to perform DnD operations.
		 * 
		 * @return Boolean True if the registration was successful, otherwise false.
		 */
		function registerContainer (target:IDnDContainer):Boolean;
	}
}