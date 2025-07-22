package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class LowPolyVideo extends Plane
   {
      
      public static var DIRTY:String = "LowPolyVideo.DIRTY";
      
      private var movieMat:MovieMaterial;
      
      private var anim:AnimationOld;
      
      private var _animDelay:Number = 10000;
      
      private var animTimer:Timer = new Timer(_animDelay);
      
      public function LowPolyVideo(param1:MovieClip, param2:Number = 100, param3:Number = 100, param4:int = 0, param5:int = 0)
      {
         anim = new AnimationOld(param1);
         rigAnimListeners(anim);
         movieMat = new MovieMaterial(anim,false,false,false,param1.getRect(param1));
         super(movieMat,param2,param3,param4,param5);
         animTimer.addEventListener(TimerEvent.TIMER,handleAnimTimer);
      }
      
      public function set animDelay(param1:Number) : void
      {
         _animDelay = param1;
         animTimer.delay = _animDelay;
      }
      
      public function setCharacter(param1:String) : void
      {
      }
      
      public function park() : void
      {
      }
      
      public function activate() : void
      {
         animTimer.start();
      }
      
      private function handleAnimTimer(param1:TimerEvent) : void
      {
         doAnim();
      }
      
      private function handleAnimProgress(param1:Event) : void
      {
         dispatchEvent(new Event(DIRTY));
      }
      
      public function get animDelay() : Number
      {
         return _animDelay;
      }
      
      private function handleAnimComplete(param1:Event) : void
      {
         movieMat.animated = false;
      }
      
      public function deactivate() : void
      {
         anim.gotoAndStop(1);
         animTimer.reset();
         animTimer.stop();
         dispatchEvent(new Event(DIRTY));
      }
      
      public function doAnim() : void
      {
         movieMat.animated = true;
         anim.loop(1);
      }
      
      private function rigAnimListeners(param1:AnimationOld) : void
      {
         param1.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         param1.addEventListener(AnimationOldEvent.PROGRESS,handleAnimProgress);
      }
   }
}

