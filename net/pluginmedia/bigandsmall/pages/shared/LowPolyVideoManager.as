package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class LowPolyVideoManager
   {
      
      public var triggerVariation:uint = 200;
      
      protected var active:Boolean = false;
      
      protected var clipList:Array;
      
      protected var animList:Array;
      
      protected var prevClip:int = -1;
      
      public var triggerTime:uint = 700;
      
      private var parent:BigAndSmallPage3D;
      
      protected var frameList:Array;
      
      protected var matList:Array;
      
      protected var animTimer:Timer;
      
      public function LowPolyVideoManager(param1:BigAndSmallPage3D)
      {
         super();
         parent = param1;
         frameList = [];
         matList = [];
         animList = [];
         clipList = [];
      }
      
      protected function setupTimer() : void
      {
         var _loc1_:uint = Math.random() * 2 - 1;
         var _loc2_:uint = triggerTime + triggerVariation * _loc1_;
         animTimer = new Timer(_loc2_,1);
         animTimer.addEventListener(TimerEvent.TIMER_COMPLETE,timerDone);
         animTimer.start();
      }
      
      public function addFrame(param1:DisplayObject3D, param2:MovieClip) : void
      {
         var _loc3_:MovieClip = param2.clip as MovieClip;
         var _loc4_:MovieMaterial = new MovieMaterial(param2,false,false,false,param2.getRect(param2));
         param1.material = _loc4_;
         frameList.push(param1);
         matList.push(_loc4_);
         animList.push(param2);
         clipList.push(_loc3_);
      }
      
      public function playFrame(param1:uint) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 < animList.length)
         {
            _loc2_ = clipList[param1];
            _loc2_.addEventListener("animationComplete",onFrameAnimationComplete);
            _loc2_.addEventListener(Event.ENTER_FRAME,onClipEnterFrame);
            _loc2_.play();
         }
      }
      
      protected function onClipEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:int = getClipIndex(param1.target as MovieClip);
         var _loc4_:DisplayObject3D = frameList[_loc3_];
         var _loc5_:MovieMaterial = matList[_loc3_];
         _loc2_ = clipList[_loc3_];
         if(!_loc4_.container)
         {
            return;
         }
         var _loc6_:Array = _loc4_.container.filters.concat();
         _loc4_.container.filters = [];
         var _loc7_:Rectangle = _loc5_.rect;
         var _loc8_:Matrix = new Matrix(1,0,0,1,-_loc7_.x,-_loc7_.y);
         _loc5_.bitmap.draw(_loc5_.movie,_loc8_,_loc5_.movie.transform.colorTransform,null);
         _loc4_.container.filters = _loc6_;
      }
      
      protected function timerDone(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject3D = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieMaterial = null;
         if(frameList.length > 0)
         {
            _loc2_ = Math.random() * frameList.length;
            if(_loc2_ == prevClip)
            {
               _loc2_ = Math.random() * frameList.length;
            }
            _loc3_ = frameList[_loc2_];
            _loc4_ = animList[_loc2_];
            _loc5_ = clipList[_loc2_];
            _loc6_ = matList[_loc2_];
            _loc5_.addEventListener("animationComplete",onFrameAnimationComplete);
            _loc5_.addEventListener(Event.ENTER_FRAME,onClipEnterFrame);
            _loc5_.play();
            prevClip = _loc2_;
         }
      }
      
      protected function getClipIndex(param1:MovieClip) : int
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < clipList.length)
         {
            _loc2_ = clipList[_loc3_];
            if(_loc2_ == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      protected function onFrameAnimationComplete(param1:Event) : void
      {
         var _loc2_:int = getClipIndex(param1.target as MovieClip);
         var _loc3_:DisplayObject3D = frameList[_loc2_];
         var _loc4_:MovieClip = animList[_loc2_];
         var _loc5_:MovieClip = clipList[_loc2_];
         var _loc6_:MovieMaterial = matList[_loc2_];
         _loc5_.gotoAndStop(1);
         _loc5_.removeEventListener("animationComplete",onFrameAnimationComplete);
         _loc5_.removeEventListener(Event.ENTER_FRAME,onClipEnterFrame);
         if(!animTimer.running && active)
         {
            setupTimer();
         }
      }
      
      public function activate() : void
      {
         active = true;
         setupTimer();
      }
      
      public function deactivate() : void
      {
         active = false;
         if(animTimer.running)
         {
            animTimer.stop();
         }
      }
   }
}

