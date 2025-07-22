package net.pluginmedia.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   
   public class PluginStats extends Sprite
   {
      
      private var timer:Number = 0;
      
      private var ms:Number = 0;
      
      private var fs:Number = 0;
      
      private var graph:BitmapData;
      
      private var mem:Number = 0;
      
      private var memText:TextField;
      
      private var bgFill:Shape = new Shape();
      
      private var fps:Number = 0;
      
      private var graphBGCol:Number = 1426063360;
      
      private var msText:TextField;
      
      private var fpsText:TextField;
      
      private var widgetBGCol:int = 0;
      
      private var msPrev:Number = 0;
      
      private var format:TextFormat;
      
      public function PluginStats(param1:Number = 64)
      {
         super();
         var _loc2_:int = 20;
         addChild(bgFill);
         format = new TextFormat("_sans",8);
         format.color = 16777215;
         format.align = TextFormatAlign.RIGHT;
         fpsText = new TextField();
         fpsText.width = param1;
         fpsText.height = 30;
         fpsText.selectable = false;
         fpsText.text = "FPS: ";
         fpsText.setTextFormat(format);
         addChild(fpsText);
         msText = new TextField();
         msText.width = param1;
         msText.height = 30;
         msText.y = fpsText.y + fpsText.textHeight;
         msText.selectable = false;
         msText.text = "MS: ";
         msText.setTextFormat(format);
         addChild(msText);
         memText = new TextField();
         memText.width = param1;
         memText.height = 30;
         memText.y = msText.y + msText.textHeight;
         memText.selectable = false;
         memText.text = "MEM: ";
         memText.setTextFormat(format);
         addChild(memText);
         graph = new BitmapData(param1,_loc2_,true,graphBGCol);
         var _loc3_:Bitmap = new Bitmap(graph);
         _loc3_.y = memText.y + memText.textHeight + 5;
         addChild(_loc3_);
         bgFill.graphics.beginFill(widgetBGCol,0.3);
         bgFill.graphics.drawRect(0,0,param1,height);
         bgFill.graphics.endFill();
         bgFill.cacheAsBitmap = true;
         addEventListener(MouseEvent.CLICK,handleMouseClick);
         addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         timer = getTimer();
         ++fs;
         if(timer - 1000 > msPrev)
         {
            msPrev = timer;
            fps = Math.min(stage.frameRate,fs);
            _loc1_ = stage.frameRate;
            _loc2_ = graph.height / stage.frameRate;
            _loc3_ = Math.round(stage.frameRate * _loc2_);
            _loc4_ = Math.round(fps * _loc2_);
            _loc5_ = graph.width - 1;
            _loc6_ = graph.height - 1;
            graph.scroll(-1,0);
            graph.fillRect(new Rectangle(_loc5_,0,1,graph.height),graphBGCol);
            _loc7_ = fps / _loc1_;
            _loc8_ = _loc3_ - _loc4_;
            _loc9_ = graph.height - _loc8_;
            if(_loc7_ <= 0.8)
            {
               graph.fillRect(new Rectangle(_loc5_,_loc9_,1,_loc8_),4294901760);
            }
            else if(_loc7_ <= 0.9)
            {
               graph.fillRect(new Rectangle(_loc5_,_loc9_,1,_loc8_),4294945536);
            }
            else
            {
               graph.fillRect(new Rectangle(_loc5_,_loc9_,1,_loc8_),4278255360);
            }
            graph.setPixel32(_loc5_,_loc6_,4278255360);
            mem = Number((System.totalMemory / 1048576).toFixed(3));
            fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
            fpsText.setTextFormat(format);
            memText.text = "MEM: " + mem;
            memText.setTextFormat(format);
            fs = 0;
         }
         msText.text = "MS: " + (timer - ms);
         msText.setTextFormat(format);
         ms = timer;
      }
      
      private function sprogFPS() : void
      {
         if(this.mouseY > this.height * 0.35)
         {
            --stage.frameRate;
         }
         ++stage.frameRate;
         fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
         fpsText.setTextFormat(format);
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         sprogFPS();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         update();
      }
   }
}

