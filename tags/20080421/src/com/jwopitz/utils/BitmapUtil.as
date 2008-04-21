package com.jwopitz.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	/**
	 * Util class for generating rendered images of display objects.
	 */
	public class BitmapUtil
	{
		/**
		 * Renders a simple bitmap object of a targeted display object.
		 * 
		 * @param target The display object to be rendered.
		 * @return Bitmap The rendered image data
		 */
		static public function render (target:DisplayObject):Bitmap
		{
			var d:BitmapData = new BitmapData(target.width, target.height);
			d.draw(target);
			
			return new Bitmap(d);
		}
		
		/**
		 * Renders a simple outline object of a targeted display object.
		 * 
		 * @param target The display object whose outline is to be rendered.
		 * @param borderColor The color of the rendered outline.
		 * @param borderThickness The thickness of the rendered outline.
		 * @param backgroundColor The internal fill color of the rendered outline.
		 * @param backgrounAlpha The alpha of the fill of the renedered outline.
		 * 
		 * @return UIComponent The rendered outline in a UIComponent.
		 */
		static public function renderOutline (target:DisplayObject, borderColor:uint = 0x000000,
			borderThickness:int = 2, backgroudColor:uint = 0xFFFFFF, backgroundAlpha:Number = 0.5):UIComponent
		{
			var s:Sprite = new Sprite();
			s.width = target.width;
			s.height = target.height;
			s.graphics.lineStyle(borderThickness, borderColor);
			s.graphics.beginFill(backgroudColor, backgroundAlpha);
			s.graphics.drawRect(0, 0, s.width, s.height);
			
			var box:UIComponent = new UIComponent();
			box.addChild(s);
			
			return box;
		}
			
	}
}