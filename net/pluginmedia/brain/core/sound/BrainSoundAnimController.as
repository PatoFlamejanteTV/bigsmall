package net.pluginmedia.brain.core.sound
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import net.pluginmedia.brain.core.sound.event.BrainSoundEvent;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   
   public class BrainSoundAnimController extends EventDispatcher
   {
      
      private var playheadTime:int = 0;
      
      private var startTime:int = 0;
      
      private var vol:Number;
      
      private var pausePlayheadTime:int = 0;
      
      private var subjClip:MovieClip;
      
      private var pan:Number;
      
      private var offset:Number;
      
      private var loop:Number;
      
      private var channelID:String;
      
      private var targFrameRate:int = 25;
      
      private var label:String;
      
      private var soundInst:IBrainSoundInstance;
      
      private var forceStartFrame:int = 1;
      
      private var onComplete:Function;
      
      public function BrainSoundAnimController(param1:MovieClip, param2:String, param3:String = null, param4:int = -1, param5:Number = 1, param6:Number = 0, param7:Number = 0, param8:int = 0, param9:Function = null)
      {
         super();
         if(!param3)
         {
            param3 = SoundManager.CHANNEL_DEFAULT;
         }
         this.label = param2;
         this.channelID = param3;
         this.vol = param5;
         this.pan = param6;
         this.offset = param7;
         this.loop = param8;
         this.onComplete = param9;
         subjClip = param1;
         if(param4 == -1 && Boolean(subjClip.stage))
         {
            param4 = subjClip.stage.frameRate;
         }
         else if(param4 == -1 && !subjClip.stage)
         {
            param4 = 25;
         }
         else
         {
            targFrameRate = param4;
         }
      }
      
      public function play() : void
      {
         soundInst = SoundManager.playSoundOnChannel(label,channelID,vol,pan,offset,loop,handleSoundComplete);
         addSoundInstListeners();
         subjClip.gotoAndStop(1);
         startTime = getTimer();
         addSubjectListener();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         playheadTime = pausePlayheadTime + (_loc2_ - startTime);
         var _loc3_:int = playheadTime / (1000 / targFrameRate);
         subjClip.gotoAndStop(_loc3_);
      }
      
      private function handleTargetSoundResume(param1:BrainSoundEvent) : void
      {
         startTime = getTimer();
         addSubjectListener();
      }
      
      private function addSoundInstListeners() : void
      {
         soundInst.addEventListener(BrainSoundEvent.PAUSE,handleTargetSoundPause);
         soundInst.addEventListener(BrainSoundEvent.RESUME,handleTargetSoundResume);
         soundInst.addEventListener(BrainSoundEvent.STOP,handleTargetSoundStop);
      }
      
      private function handleTargetSoundStop(param1:BrainSoundEvent) : void
      {
         startTime = 0;
         pausePlayheadTime = 0;
         playheadTime = 0;
         removeSubjectListener();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function removeSubjectListener() : void
      {
         subjClip.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function addSubjectListener() : void
      {
         subjClip.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function handleTargetSoundPause(param1:BrainSoundEvent) : void
      {
         pausePlayheadTime = playheadTime;
         removeSubjectListener();
      }
      
      private function handleSoundComplete() : void
      {
         removeSubjectListener();
         removeSoundInstListeners();
         soundInst = null;
         if(onComplete is Function)
         {
            onComplete();
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function removeSoundInstListeners() : void
      {
         soundInst.removeEventListener(BrainSoundEvent.PAUSE,handleTargetSoundPause);
         soundInst.removeEventListener(BrainSoundEvent.RESUME,handleTargetSoundResume);
         soundInst.removeEventListener(BrainSoundEvent.STOP,handleTargetSoundStop);
      }
   }
}

