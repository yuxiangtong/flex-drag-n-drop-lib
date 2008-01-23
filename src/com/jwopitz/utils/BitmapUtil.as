package com.jwopitz.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	public class BitmapUtil
	{
		static public function render (target:DisplayObject):Bitmap
		{
			var d:BitmapData = new BitmapData(target.width, target.height);
			d.draw(target);
			
			return new Bitmap(d);
		}
		
		static public function renderOutline (target:DisplayObject, borderColor:uint = 0x000000,
			borderThickness:int = 2, backgroudColor:uint = 0xFFFFFF, backgroundAlpha:Number = 0.5):UIComponent
		{
			var s:Sprite = new Sprite();
			s.width = target.width;
			s.height = target.height;
			s.graphics.lineStyle(borderThickness, borderColor);
			s.graphics.beginFill(backgroudColor, backgroundAlpha);
			s.graphics.drawRect(0, 0, s.width, s.height);
			
			var box:UIComponent = new UIComponent()
			box.addChild(s);
			
			return box;
		}
			
	}
}