package net.pluginmedia.brain.managers
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Manager;
   import net.pluginmedia.brain.core.interfaces.IBrainSounderOld;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.events.BrainSoundPlayEvent;
   
   public class SoundManagerOld extends Manager
   {
      
      public static var instance:SoundManagerOld;
      
      public static var soundLibrary:Dictionary = new Dictionary();
      
      public static var activeChannels:Dictionary = new Dictionary(true);
      
      public static var soundQueue:Array = [];
      
      private static var _muted:Boolean = false;
      
      private static var prePauseMuteState:Boolean = false;
      
      private static var preMuteTransform:SoundTransform = new SoundTransform();
      
      public function SoundManagerOld()
      {
         super();
         addListeners();
         instance = this;
      }
      
      public static function channelOccupied(param1:*) : Boolean
      {
         if(activeChannels[param1] !== null && activeChannels[param1] !== undefined)
         {
            return true;
         }
         return false;
      }
      
      public static function getFreeChannel(param1:int = 8) : int
      {
         var _loc2_:Number = param1;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         while(!_loc4_)
         {
            if(!activeChannels.hasOwnProperty(String(_loc2_)))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function doMute(param1:Boolean = true) : void
      {
         _muted = param1;
         if(_muted)
         {
            SoundMixer.soundTransform = new SoundTransform(0);
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(1);
         }
      }
      
      public static function toggleMute() : void
      {
         if(_muted)
         {
            doMute(false);
         }
         else
         {
            doMute(true);
         }
      }
      
      public static function playSoundSimple(param1:String, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:Number = 0) : Boolean
      {
         var _loc6_:IBrainSounderOld = soundLibrary[param1] as IBrainSounderOld;
         if(!_loc6_)
         {
            return false;
         }
         var _loc7_:SoundInfoOld = new SoundInfoOld(param2,param3,param4,param5);
         _loc6_.play(_loc7_);
         return true;
      }
      
      public static function stopSoundChannel(param1:int, param2:Number = 0) : void
      {
         BrainLogger.out("SoundManager :: stopSoundChannel",param1,activeChannels[param1]);
         var _loc3_:BrainSoundOld = activeChannels[param1] as BrainSoundOld;
         if(_loc3_ !== null)
         {
            _loc3_.stop(param2);
         }
         unSelectChannel(param1);
      }
      
      public static function unSelectChannel(param1:*) : void
      {
         if(activeChannels[param1])
         {
            activeChannels[param1] = null;
            delete activeChannels[param1];
         }
         else
         {
            BrainLogger.out("SoundManager :: unSelectChannel :: cannot unselect channel",param1," - channel is null");
         }
      }
      
      public static function playSyncedSound(param1:String, param2:MovieClip, param3:int, param4:Function = null, param5:int = 25) : Boolean
      {
         var _loc6_:SoundInfoOld = null;
         _loc6_ = new SoundInfoOld();
         _loc6_.targetChannel = param3;
         _loc6_.onCompleteFunc = param4;
         _loc6_.controlMC = param2;
         _loc6_.controlMCFrameRate = param5;
         return playSound(param1,_loc6_);
      }
      
      public static function updateTransform(param1:String, param2:Number = 1, param3:Number = 0) : Boolean
      {
         var _loc4_:IBrainSounderOld = soundLibrary[param1];
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:SoundTransform = new SoundTransform(param2,param3);
         _loc4_.updateTransform(_loc5_);
         return true;
      }
      
      public static function stopSounds(param1:Number = 0) : void
      {
         var _loc2_:IBrainSounderOld = null;
         BrainLogger.out("SoundManager :: stopSounds");
         for each(_loc2_ in soundLibrary)
         {
            if(_loc2_ !== null)
            {
               _loc2_.stop(param1);
            }
         }
         activeChannels = new Dictionary();
      }
      
      public static function selectChannel(param1:*, param2:* = "OCCUPIED") : void
      {
         if(!activeChannels[param1])
         {
            activeChannels[param1] = param2;
         }
         else
         {
            BrainLogger.out("SoundManager :: selectChannel :: cannot select channel",param1," - channel is occupied");
         }
      }
      
      public static function getSoundByID(param1:String) : IBrainSounderOld
      {
         return soundLibrary[param1];
      }
      
      public static function stopSound(param1:String, param2:Number = 0) : void
      {
         BrainLogger.out("SoundManager :: stopSound",param1);
         var _loc3_:IBrainSounderOld = soundLibrary[param1] as IBrainSounderOld;
         if(_loc3_ !== null)
         {
            _loc3_.stop();
            unSelectChannel(_loc3_.soundInfo.channel);
         }
      }
      
      public static function addSound(param1:String, param2:Sound, param3:SoundInfoOld = null) : BrainSoundOld
      {
         var _loc4_:BrainSoundOld = new BrainSoundOld(param1,param2,param3);
         registerSound(_loc4_);
         return _loc4_;
      }
      
      public static function registerSoundCollection(param1:BrainSoundCollectionOld) : BrainSoundCollectionOld
      {
         BrainLogger.out("SoundManager :: registerCollection... ");
         soundLibrary[param1.strID] = param1;
         instance.addSoundListeners(param1);
         return param1;
      }
      
      public static function registerSound(param1:BrainSoundOld) : BrainSoundOld
      {
         BrainLogger.out("SoundManager :: registerSound... ",param1.strID);
         instance.addSoundListeners(param1);
         soundLibrary[param1.strID] = param1;
         return param1;
      }
      
      public static function playSound(param1:String, param2:SoundInfoOld = null) : Boolean
      {
         var _loc3_:IBrainSounderOld = soundLibrary[param1];
         BrainLogger.out("SoundManager :: playSound",param1);
         if(_loc3_ === null)
         {
            BrainLogger.out("SoundManager :: WARNING :: Could not locate sound for provided ref : " + param1);
            return false;
         }
         if(!param2)
         {
            param2 = _loc3_.soundInfo;
         }
         var _loc4_:Number = param2.targetChannel;
         if(_loc4_ > -1)
         {
            if(channelOccupied(_loc4_))
            {
               BrainLogger.out("SoundManager :: Target channel is occupied ::",_loc4_);
               if(param2.onConflictResponse == SoundInfoOld.CHANCONFLICT_SKIP)
               {
                  BrainLogger.out("SoundManager :: CHANCONFLICT_SKIP");
                  return false;
               }
               if(param2.onConflictResponse == SoundInfoOld.CHANCONFLICT_QUEUE)
               {
                  BrainLogger.out("SoundManager :: CHANCONFLICT_QUEUE");
                  return false;
               }
               if(param2.onConflictResponse == SoundInfoOld.CHANCONFLICT_OVERRIDE)
               {
                  BrainLogger.out("SoundManager :: CHANCONFLICT_OVERRIDE");
                  stopSound(IBrainSounderOld(activeChannels[_loc4_]).strID);
               }
            }
         }
         else
         {
            _loc4_ = getFreeChannel();
         }
         selectChannel(_loc4_,_loc3_);
         param2.channel = _loc4_;
         _loc3_.play(param2);
         _loc3_.onBegin();
         return true;
      }
      
      private function handleSoundComplete(param1:Event) : void
      {
         var _loc2_:IBrainSounderOld = param1.target as IBrainSounderOld;
         var _loc3_:SoundInfoOld = _loc2_.soundInfo as SoundInfoOld;
         unSelectChannel(_loc3_.channel);
         _loc2_.onComplete();
         if(soundQueue.length > 0)
         {
            popQueuedSound();
         }
      }
      
      private function addSoundListeners(param1:EventDispatcher) : void
      {
         param1.addEventListener(Event.SOUND_COMPLETE,handleSoundComplete);
      }
      
      private function popQueuedSound() : void
      {
         var _loc1_:BrainSoundPlayEvent = soundQueue.shift() as BrainSoundPlayEvent;
         playSound(_loc1_.strID,_loc1_.soundInfo);
      }
      
      private function removeSoundListeners(param1:EventDispatcher) : void
      {
         param1.removeEventListener(Event.SOUND_COMPLETE,handleSoundComplete);
      }
      
      public function mute(param1:Boolean) : void
      {
         if(param1)
         {
            preMuteTransform.volume = SoundMixer.soundTransform.volume;
            preMuteTransform.pan = SoundMixer.soundTransform.pan;
            SoundMixer.soundTransform = new SoundTransform(0,0);
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(preMuteTransform.volume,preMuteTransform.pan);
         }
      }
      
      private function removeListeners() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in activeChannels)
         {
            if(_loc2_ is IBrainSounderOld)
            {
               _loc2_.onPosition();
               _loc2_.onProgress();
            }
         }
      }
      
      override public function pause(param1:Boolean = true) : void
      {
         if(_paused == param1)
         {
            return;
         }
         super.pause(param1);
         if(param1)
         {
            prePauseMuteState = _muted;
            SoundManagerOld.doMute(true);
         }
         else
         {
            SoundManagerOld.doMute(prePauseMuteState);
         }
      }
      
      private function addListeners() : void
      {
         this.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
   }
}

