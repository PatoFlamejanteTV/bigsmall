package net.pluginmedia.pv3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class FadeChangeableBitmapMaterial extends ChangeableBitmapMaterial
   {
      
      public static const FADE_COMPLETE:String = "fadeComplete";
      
      protected var _fadeFrames:uint;
      
      protected var _fadeBitmapList:Array;
      
      protected var enterFrameObj:Shape = new Shape();
      
      protected var _fadeEndBitmap:BitmapData;
      
      protected var _fadeStartBitmap:BitmapData;
      
      protected var fadeTransform:ColorTransform = new ColorTransform();
      
      protected var fadeProgress:uint;
      
      protected var ZERO_POINT:Point = new Point();
      
      public function FadeChangeableBitmapMaterial(param1:BitmapData = null, param2:String = "default", param3:uint = 128, param4:uint = 128, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      public function getBitmap(param1:String) : BitmapData
      {
         return this.bitmapDict[param1];
      }
      
      protected function endFade() : void
      {
         drawIntoTexture(_fadeEndBitmap);
         enterFrameObj.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
         dispatchEvent(new Event(FADE_COMPLETE));
      }
      
      public function set fadeFrames(param1:uint) : void
      {
         _fadeFrames = param1;
      }
      
      protected function startFade() : void
      {
         fadeProgress = 0;
         if(enterFrameObj.hasEventListener(Event.ENTER_FRAME))
         {
            BrainLogger.out("HAS EVENT LISTENER!!!");
         }
         enterFrameObj.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      override public function set activeBitmap(param1:String) : void
      {
         if(_activeBitmap != param1)
         {
            if(_fadeFrames > 0 && _activeBitmap !== null)
            {
               if(super._prevActiveBitmap == param1 && _fadeBitmapList !== null)
               {
                  _fadeStartBitmap = bitmap.clone();
                  super.activeBitmap = param1;
                  _fadeEndBitmap = bitmap.clone();
                  drawIntoTexture(_fadeStartBitmap);
                  _fadeBitmapList.reverse();
               }
               else
               {
                  _fadeStartBitmap = bitmap.clone();
                  super.activeBitmap = param1;
                  _fadeEndBitmap = bitmap.clone();
                  drawIntoTexture(_fadeStartBitmap);
               }
               startFade();
            }
            else
            {
               if(super._prevActiveBitmap == param1 && _fadeBitmapList !== null)
               {
                  _fadeBitmapList.reverse();
               }
               _fadeStartBitmap = bitmap.clone();
               super.activeBitmap = param1;
               _fadeEndBitmap = bitmap.clone();
               drawIntoTexture(_fadeStartBitmap);
               endFade();
            }
         }
         else
         {
            dispatchEvent(new Event(FADE_COMPLETE));
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         ++fadeProgress;
         if(fadeProgress <= _fadeFrames)
         {
            _loc2_ = fadeProgress / _fadeFrames;
            if(_loc2_ > _fadeFrames)
            {
               _loc2_ = 1;
            }
            fadeIntoTexture(_fadeStartBitmap,_fadeEndBitmap,_loc2_);
         }
         else
         {
            endFade();
         }
      }
      
      override protected function drawIntoTexture(param1:BitmapData) : void
      {
         m.identity();
         if(param1.width != bitmap.width || param1.height != bitmap.height)
         {
            m.scale(bitmap.width / param1.width,bitmap.height / param1.height);
         }
         bitmap.copyPixels(param1,param1.rect,ZERO_POINT);
      }
      
      protected function fadeIntoTexture(param1:BitmapData, param2:BitmapData, param3:Number) : void
      {
         m.identity();
         if(param2.width != bitmap.width || param2.height != bitmap.height)
         {
            m.scale(bitmap.width / param2.width,bitmap.height / param2.height);
         }
         fadeTransform.alphaMultiplier = param3;
         bitmap.copyPixels(param1,param1.rect,ZERO_POINT);
         bitmap.draw(param2,m,fadeTransform);
      }
   }
}

