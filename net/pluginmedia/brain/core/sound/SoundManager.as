package net.pluginmedia.brain.core.sound
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   
   public class SoundManager
   {
      
      private static var _isMuted:Boolean;
      
      public static var CHANNEL_DEFAULT:String = "SoundManager.CHANNEL_DEFAULT";
      
      private static var registeredSounds:Dictionary = new Dictionary();
      
      private static var registeredChannels:Dictionary = new Dictionary();
      
      private static var animControllers:Array = [];
      
      private static var masterSoundTransform:SoundTransform = new SoundTransform();
      
      private static var fadeManager:BrainSoundFadeManager = new BrainSoundFadeManager(30);
      
      public function SoundManager()
      {
         super();
      }
      
      private static function getChannelFromID(param1:String) : BrainSoundChannel
      {
         if(param1 == CHANNEL_DEFAULT && !registeredChannels[CHANNEL_DEFAULT])
         {
            createChannel(CHANNEL_DEFAULT);
         }
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(!_loc2_)
         {
            _loc2_ = getChannelFromID(CHANNEL_DEFAULT);
         }
         return _loc2_;
      }
      
      public static function pauseAllChannels() : void
      {
         var _loc1_:BrainSoundChannel = null;
         for each(_loc1_ in registeredChannels)
         {
            _loc1_.pause();
         }
      }
      
      public static function set volume(param1:Number) : void
      {
         masterSoundTransform.volume = param1;
         if(!isMuted())
         {
            SoundMixer.soundTransform = masterSoundTransform;
         }
      }
      
      public static function getChannelVolume(param1:String) : Number
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(_loc2_ !== null)
         {
            return _loc2_.volume;
         }
         throw new Error("Channel" + param1 + " not found");
      }
      
      public static function queueSoundOnChannel(param1:String, param2:String, param3:Number = 1, param4:int = 0, param5:Number = 0, param6:Number = 0, param7:Function = null, param8:Function = null) : IBrainSoundInstance
      {
         var _loc11_:IBrainSoundInstance = null;
         var _loc9_:BrainSoundChannel = getChannelFromID(param2);
         var _loc10_:BrainSoundFactory = registeredSounds[param1];
         if(!_loc10_)
         {
            throw new Error("Sound not found :: " + param1);
         }
         _loc11_ = _loc10_.factorySoundInstance(param3,param4,param5,param6,param7,param8);
         _loc9_.queueSound(_loc11_);
         return _loc11_;
      }
      
      public static function playSyncAnimSound(param1:MovieClip, param2:String, param3:String, param4:int = 25, param5:Number = 1, param6:Number = 0, param7:Number = 0, param8:int = 0, param9:Function = null) : void
      {
         var _loc10_:BrainSoundAnimController = new BrainSoundAnimController(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         _loc10_.play();
         _loc10_.addEventListener(Event.COMPLETE,handleAnimControllerComplete);
         animControllers.push(_loc10_);
      }
      
      public static function playOneOffSound(param1:Sound, param2:String = null, param3:Number = 1, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Function = null) : IBrainSoundInstance
      {
         var _loc8_:BrainSoundChannel = getChannelFromID(param2);
         var _loc9_:BrainSoundInstance = new BrainSoundInstance("oneOffSound" + Math.random(),param1,param3,1,param4,param5,param6,null,param7);
         _loc8_.playSound(_loc9_);
         return _loc9_;
      }
      
      public static function resumeChannel(param1:String) : void
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(_loc2_)
         {
            _loc2_.resume();
            return;
         }
         throw new Error("Channel " + param1 + " not defined");
      }
      
      public static function isChannelBusy(param1:String) : Boolean
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(_loc2_ !== null)
         {
            return _loc2_.isBusy();
         }
         throw new Error("ERROR - Channel of id " + param1 + ", does not exist");
      }
      
      public static function get volume() : Number
      {
         return masterSoundTransform.volume * int(!_isMuted);
      }
      
      public static function channelIsPaused(param1:String) : Boolean
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(_loc2_)
         {
            return _loc2_.isPaused;
         }
         throw new Error("Channel " + param1 + " not defined");
      }
      
      public static function setChannelVolume(param1:String, param2:Number) : void
      {
         var _loc3_:BrainSoundChannel = registeredChannels[param1];
         if(_loc3_ !== null)
         {
            _loc3_.volume = param2;
         }
      }
      
      public static function mute(param1:String = null) : void
      {
         var _loc2_:BrainSoundChannel = null;
         if(param1 != null)
         {
            _loc2_ = registeredChannels[param1];
            if(_loc2_ !== null)
            {
               _loc2_.mute();
               return;
            }
            throw new Error("Channel" + param1 + " not found");
         }
         _isMuted = true;
         SoundMixer.soundTransform = new SoundTransform(0,0);
      }
      
      public static function stopChannel(param1:String, param2:Number = 0, param3:Function = null) : Boolean
      {
         var _loc6_:BrainSoundInstance = null;
         var _loc4_:BrainSoundChannel = registeredChannels[param1];
         var _loc5_:Array = _loc4_.removeAll();
         if(param2 == 0)
         {
            for each(_loc6_ in _loc5_)
            {
               _loc6_.stop();
            }
            if(param3 is Function)
            {
               param3();
            }
         }
         else
         {
            fadeManager.pushBatch(_loc5_,param2,param3);
         }
         return Boolean(_loc5_.length);
      }
      
      public static function createChannel(param1:String) : void
      {
         var _loc2_:BrainSoundChannel = new BrainSoundChannel();
         registeredChannels[param1] = _loc2_;
      }
      
      public static function isMuted(param1:String = null) : Boolean
      {
         var _loc2_:BrainSoundChannel = null;
         if(param1 != null)
         {
            _loc2_ = registeredChannels[param1];
            if(_loc2_ !== null)
            {
               return _loc2_.isMuted();
            }
            throw new Error("Channel" + param1 + " not found");
         }
         return _isMuted;
      }
      
      public static function resumeAllChannels() : void
      {
         var _loc1_:BrainSoundChannel = null;
         for each(_loc1_ in registeredChannels)
         {
            _loc1_.resume();
         }
      }
      
      public static function registerSound(param1:BrainSoundFactory) : void
      {
         registeredSounds[param1.id] = param1;
      }
      
      public static function stopSound(param1:String, param2:Number = 0, param3:Function = null) : Boolean
      {
         var _loc6_:BrainSoundChannel = null;
         var _loc7_:Array = null;
         var _loc8_:BrainSoundInstance = null;
         var _loc4_:Array = [];
         var _loc5_:Boolean = false;
         for each(_loc6_ in registeredChannels)
         {
            _loc7_ = _loc6_.removeSound(param1);
            _loc4_ = _loc4_.concat(_loc7_);
         }
         if(param2 == 0)
         {
            for each(_loc8_ in _loc4_)
            {
               _loc8_.stop();
            }
            if(param3 is Function)
            {
               param3();
            }
         }
         else
         {
            fadeManager.pushBatch(_loc4_,param2,param3);
         }
         return Boolean(_loc4_.length);
      }
      
      private static function handleAnimControllerComplete(param1:Event) : void
      {
         var _loc4_:BrainSoundAnimController = null;
         var _loc2_:BrainSoundAnimController = param1.target as BrainSoundAnimController;
         var _loc3_:int = 0;
         while(_loc3_ < animControllers.length)
         {
            _loc4_ = animControllers[_loc3_] as BrainSoundAnimController;
            if(_loc4_ === _loc2_)
            {
               animControllers.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      public static function playSoundOnChannel(param1:String, param2:String, param3:Number = 1, param4:Number = 0, param5:Number = 0, param6:int = 0, param7:Function = null) : IBrainSoundInstance
      {
         var _loc10_:IBrainSoundInstance = null;
         var _loc8_:BrainSoundChannel = getChannelFromID(param2);
         var _loc9_:BrainSoundFactory = registeredSounds[param1];
         if(!_loc9_)
         {
            throw new Error("Sound not found :: " + param1);
         }
         _loc10_ = _loc9_.factorySoundInstance(param3,param6,param4,param5,null,param7);
         _loc8_.playSound(_loc10_);
         return _loc10_;
      }
      
      public static function pauseChannel(param1:String) : void
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         if(_loc2_)
         {
            _loc2_.pause();
            return;
         }
         throw new Error("Channel " + param1 + " not defined");
      }
      
      public static function destroyChannel(param1:String) : void
      {
         var _loc2_:BrainSoundChannel = registeredChannels[param1];
         stopChannel(param1,0);
         registeredChannels[param1] = null;
         delete registeredChannels[param1];
      }
      
      public static function unmute(param1:String = null) : void
      {
         var _loc2_:BrainSoundChannel = null;
         if(param1 != null)
         {
            _loc2_ = registeredChannels[param1];
            if(_loc2_ !== null)
            {
               _loc2_.unmute();
               return;
            }
            throw new Error("Channel" + param1 + " not found");
         }
         _isMuted = false;
         volume = volume;
      }
      
      public static function playSound(param1:String, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:int = 0, param6:Function = null) : IBrainSoundInstance
      {
         return playSoundOnChannel(param1,CHANNEL_DEFAULT,param2,param3,param4,param5,param6);
      }
      
      public static function quickRegisterSound(param1:String, param2:*, param3:Number = 1) : void
      {
         var _loc4_:Sound = null;
         if(param2 is Sound)
         {
            _loc4_ = param2;
         }
         else if(param2 is Class)
         {
            _loc4_ = new param2();
         }
         var _loc5_:BrainSoundFactory = new BrainSoundFactory(param1,param2,param3);
         registerSound(_loc5_);
      }
   }
}

