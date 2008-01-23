package dNdLib.managers
{
	import dNdLib.containers.IDnDContainer;
	
	import mx.core.IUIComponent;
	
	public interface IDnDManager
	{
		function get isDragging ():Boolean;
		
		function registerContainer (target:IDnDContainer):Boolean;
	}
}