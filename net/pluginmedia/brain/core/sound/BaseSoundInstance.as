package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import net.pluginmedia.brain.core.sound.event.BrainSoundEvent;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   
   public class BaseSoundInstance extends EventDispatcher implements IBrainSoundInstance
   {
      
      protected var _loop:Number;
      
      protected var _onStart:Function;
      
      protected var _volumeMult:Number;
      
      protected var _progress:Number = 0;
      
      protected var _offset:Number;
      
      protected var _volume:Number;
      
      protected var _id:String;
      
      protected var _soundTransform:SoundTransform = new SoundTransform();
      
      protected var _soundChannel:SoundChannel;
      
      protected var _onComplete:Function;
      
      protected var _isPaused:Boolean;
      
      protected var _pan:Number;
      
      protected var _channelVolume:Number;
      
      public function BaseSoundInstance(param1:String, param2:Number = 1, param3:Number = 1, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Function = null, param8:Function = null)
      {
         super();
         _id = param1;
         _volume = param2;
         _volumeMult = param3;
         _loop = param4;
         _pan = param5;
         _offset = param6;
         _onComplete = param8;
         _onStart = param7;
         updateTransform();
      }
      
      public function set channelVolume(param1:Number) : void
      {
         _channelVolume = param1;
         updateTransform();
      }
      
      public function stop() : void
      {
         _soundChannel = null;
         _progress = 0;
         dispatchEvent(new BrainSoundEvent(BrainSoundEvent.STOP));
      }
      
      protected function doStartCallback() : void
      {
         if(_onStart is Function)
         {
            _onStart();
         }
      }
      
      public function set onStart(param1:Function) : void
      {
         _onStart = param1;
      }
      
      public function get offset() : Number
      {
         return _offset;
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get pan() : Number
      {
         return _pan;
      }
      
      protected function removeChannelListeners(param1:SoundChannel) : void
      {
         if(param1)
         {
            param1.removeEventListener(Event.SOUND_COMPLETE,handleSoundComplete);
         }
      }
      
      public function updateTransform() : void
      {
         _soundTransform.volume = _volume * _volumeMult * _channelVolume;
         _soundTransform.pan = _pan;
      }
      
      protected function handleSoundComplete(param1:Event) : void
      {
         _soundChannel = null;
         _progress = 1;
         doCompleteCallback();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get position() : Number
      {
         return 0;
      }
      
      public function get loop() : Number
      {
         return _loop;
      }
      
      public function get onComplete() : Function
      {
         return _onComplete;
      }
      
      protected function addChannelListeners(param1:SoundChannel) : void
      {
         if(param1)
         {
            param1.addEventListener(Event.SOUND_COMPLETE,handleSoundComplete);
         }
      }
      
      public function set offset(param1:Number) : void
      {
         _offset = param1;
      }
      
      public function set pan(param1:Number) : void
      {
         _pan = param1;
         _soundTransform.pan = _pan;
         updateTransform();
      }
      
      public function resume() : void
      {
         _isPaused = false;
         dispatchEvent(new BrainSoundEvent(BrainSoundEvent.RESUME));
      }
      
      public function set loop(param1:Number) : void
      {
         _loop = param1;
      }
      
      public function get onStart() : Function
      {
         return _onStart;
      }
      
      public function set volume(param1:Number) : void
      {
         _volume = param1;
         updateTransform();
      }
      
      protected function doCompleteCallback() : void
      {
         if(_onComplete is Function)
         {
            _onComplete();
         }
      }
      
      public function play() : void
      {
         _isPaused = false;
         dispatchEvent(new BrainSoundEvent(BrainSoundEvent.PLAY));
      }
      
      public function get progress() : Number
      {
         return _progress;
      }
      
      public function set volumeMult(param1:Number) : void
      {
         _volumeMult = param1;
         updateTransform();
      }
      
      public function get length() : Number
      {
         return 0;
      }
      
      public function set onComplete(param1:Function) : void
      {
         _onComplete = param1;
      }
      
      public function get volumeMult() : Number
      {
         return _volumeMult;
      }
      
      public function pause() : void
      {
         _isPaused = true;
         dispatchEvent(new BrainSoundEvent(BrainSoundEvent.PAUSE));
      }
      
      public function get channelVolume() : Number
      {
         return _channelVolume;
      }
      
      public function get isPaused() : Boolean
      {
         return _isPaused;
      }
   }
}

