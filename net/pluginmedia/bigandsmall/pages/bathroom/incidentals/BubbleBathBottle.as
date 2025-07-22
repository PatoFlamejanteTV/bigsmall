package net.pluginmedia.bigandsmall.pages.bathroom.incidentals
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.pages.bathroom.BubbleManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class BubbleBathBottle extends Incidental
   {
      
      private var bubbleManager:BubbleManager;
      
      private var squeezeTimer:Timer = new Timer(2000);
      
      private var bmFrameFreqSqueeze:int = 5;
      
      private var smallClip:MovieClip;
      
      private var squeezing:Boolean = false;
      
      private var mat:MovieMaterial;
      
      private var currentAnim:AnimationOld;
      
      private var clickSoundRef:String;
      
      private var bigClip:MovieClip;
      
      private var bigAnim:AnimationOld;
      
      private var bmFrameFreqIdle:int = 0;
      
      private var smallAnim:AnimationOld;
      
      private var planeObj:Plane;
      
      private var overSoundRef:String;
      
      public function BubbleBathBottle(param1:String, param2:BubbleManager, param3:MovieClip, param4:MovieClip, param5:String, param6:String, param7:Number = 0, param8:Number = 0, param9:Number = 1)
      {
         super(param1);
         bubbleManager = param2;
         clickSoundRef = param6;
         overSoundRef = param5;
         bigClip = param3;
         smallClip = param4;
         bigAnim = new AnimationOld(param3);
         smallAnim = new AnimationOld(smallClip);
         rigTimelineListeners(bigAnim);
         rigTimelineListeners(smallAnim);
         var _loc10_:Number = param3.width * param9;
         var _loc11_:Number = param3.height * param9;
         currentAnim = bigAnim;
         mat = new MovieMaterial(currentAnim,true,false,false);
         planeObj = new Plane(mat,_loc10_,_loc11_,param7,param8);
         addChild(planeObj);
         planeObj.rotationY = 180;
         squeezeTimer.addEventListener(TimerEvent.TIMER,handleSqueezeTimer);
         bubbleManager.frameDeployFreq = 100;
      }
      
      override public function handleClick() : void
      {
         play();
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         currentPOV = param1;
         if(param1 == CharacterDefinitions.BIG)
         {
            currentAnim = bigAnim;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            currentAnim = smallAnim;
         }
         mat.movie = currentAnim;
         mat.drawBitmap();
      }
      
      private function handleSqueezeTimer(param1:TimerEvent) : void
      {
         doReleasePhase();
      }
      
      private function rigTimelineListeners(param1:AnimationOld) : void
      {
         param1.subjectClip.addEventListener("SQUEEZE_PEAK",handleSqueezePeak);
         param1.addEventListener(AnimationOldEvent.PROGRESS,handleAnimProgress);
      }
      
      override public function rollover() : void
      {
         super.rollover();
         doOverSpoogePhase();
      }
      
      private function doSpoogePhase() : void
      {
         stop();
         mat.animated = true;
         currentAnim.playOutLabel("squeeze");
         squeezeTimer.delay = 2000 + Math.random() * 2000;
         SoundManagerOld.playSound(clickSoundRef);
      }
      
      private function handleSqueezePeak(param1:Event) : void
      {
         holdSpoogePhase();
      }
      
      override public function stop() : void
      {
         super.stop();
         squeezeTimer.stop();
         squeezeTimer.reset();
         currentAnim.gotoAndStop(1);
         mat.drawBitmap();
         mat.animated = false;
         bubbleManager.frameDeployFreq = bmFrameFreqIdle;
         currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleReleaseComplete);
      }
      
      private function doOverSpoogePhase() : void
      {
         stop();
         mat.animated = true;
         currentAnim.playOutLabel("squeeze");
         squeezeTimer.delay = Math.random() * 1000;
         SoundManagerOld.playSound(overSoundRef);
      }
      
      private function doReleasePhase() : void
      {
         squeezeTimer.stop();
         squeezeTimer.reset();
         bubbleManager.frameDeployFreq = bmFrameFreqIdle;
         mat.animated = true;
         currentAnim.playOutLabel("release");
         currentAnim.addEventListener(AnimationOldEvent.COMPLETE,handleReleaseComplete);
      }
      
      private function holdSpoogePhase() : void
      {
         mat.animated = false;
         bubbleManager.frameDeployFreq = bmFrameFreqSqueeze;
         squeezeTimer.start();
      }
      
      private function handleAnimProgress(param1:AnimationOldEvent) : void
      {
         dispatchEvent(new Event("DIRTY_RENDER"));
      }
      
      private function endReleasePhase() : void
      {
         mat.animated = false;
         currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleReleaseComplete);
      }
      
      override public function play() : void
      {
         super.play();
         doSpoogePhase();
      }
      
      private function handleReleaseComplete(param1:AnimationOldEvent) : void
      {
         endReleasePhase();
      }
   }
}

