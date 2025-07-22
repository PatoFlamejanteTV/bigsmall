package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import flash.media.SoundTransform;
   
   public class BrainSoundCollectionOld extends BrainSounderBaseOld
   {
      
      public static var ROTATIONTYPE_RANDOM:int = 0;
      
      public static var ROTATIONTYPE_SEQUENCE:int = 1;
      
      public static var ROTATIONTYPE_PSEUDOSEQ:int = 2;
      
      private var counter:int = 0;
      
      private var lastPlayed:int = -1;
      
      public var rotationType:int = ROTATIONTYPE_PSEUDOSEQ;
      
      public var autoPlaySeq:Boolean = false;
      
      private var _sounds:Array = [];
      
      private var _currentSound:BrainSoundOld = null;
      
      private var overrideChildInfo:Boolean = true;
      
      public function BrainSoundCollectionOld(param1:String, param2:SoundInfoOld = null, param3:Boolean = true)
      {
         overrideChildInfo = param3;
         super(param1,param2);
      }
      
      private function handleComplete(param1:Event) : void
      {
         if(autoPlaySeq)
         {
            if(lastPlayed == _sounds.length - 1)
            {
               dispatchEvent(new Event("RotationComplete"));
            }
            else
            {
               _currentSound.onComplete();
               play();
               _currentSound.onBegin();
            }
         }
         else
         {
            dispatchEvent(param1);
            _currentSound = null;
         }
      }
      
      override public function stop(param1:Number = 0) : void
      {
         var _loc2_:BrainSoundOld = null;
         for each(_loc2_ in _sounds)
         {
            if(_loc2_)
            {
               _loc2_.stop(param1);
            }
         }
         _currentSound = null;
      }
      
      public function get sounds() : Array
      {
         return _sounds;
      }
      
      public function pushSound(param1:BrainSoundOld) : void
      {
         _sounds.push(param1);
         addBrainSoundListeners(param1);
      }
      
      public function get currentSound() : BrainSoundOld
      {
         return _currentSound;
      }
      
      override public function onBegin() : void
      {
         if(overrideChildInfo)
         {
            super.onBegin();
            return;
         }
         if(_currentSound !== null)
         {
            _currentSound.onBegin();
         }
      }
      
      private function removeBrainSoundListeners(param1:BrainSoundOld) : void
      {
         param1.removeEventListener(Event.SOUND_COMPLETE,handleComplete);
      }
      
      private function addBrainSoundListeners(param1:BrainSoundOld) : void
      {
         param1.addEventListener(Event.SOUND_COMPLETE,handleComplete);
      }
      
      override public function onPosition() : void
      {
         if(!_currentSound || !_currentSound.soundChannel)
         {
            return;
         }
         var _loc1_:Number = _currentSound.soundChannel.position;
         if(overrideChildInfo)
         {
            if(_soundInfo.onPositionFunc !== null)
            {
               _soundInfo.onPositionFunc(_loc1_);
            }
         }
         else if(_currentSound.soundInfo.onPositionFunc !== null)
         {
            _currentSound.soundInfo.onPositionFunc(_loc1_);
         }
      }
      
      public function getSoundByID(param1:String) : BrainSoundOld
      {
         var _loc2_:BrainSoundOld = null;
         var _loc3_:int = 0;
         while(_loc3_ < _sounds.length)
         {
            _loc2_ = _sounds[0] as BrainSoundOld;
            if(_loc2_.strID == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      override public function onProgress() : void
      {
         if(!_currentSound || !_currentSound.soundChannel)
         {
            return;
         }
         var _loc1_:Number = _currentSound.soundChannel.position / _currentSound.sound.length;
         if(overrideChildInfo)
         {
            if(_soundInfo.onProgressFunc !== null)
            {
               _soundInfo.onProgressFunc(_loc1_);
            }
         }
         else if(_currentSound.soundInfo.onProgressFunc !== null)
         {
            _currentSound.soundInfo.onProgressFunc(_loc1_);
         }
      }
      
      override public function updateTransform(param1:SoundTransform) : void
      {
         if(_currentSound)
         {
            _currentSound.updateTransform(param1);
         }
      }
      
      override public function onComplete() : void
      {
         if(overrideChildInfo)
         {
            super.onComplete();
            return;
         }
         if(_currentSound !== null)
         {
            _currentSound.onComplete();
         }
      }
      
      override public function play(param1:SoundInfoOld = null) : void
      {
         var _loc2_:int = 0;
         if(rotationType == ROTATIONTYPE_PSEUDOSEQ)
         {
            if(_sounds.length > 1)
            {
               do
               {
                  _loc2_ = Math.floor(Math.random() * _sounds.length);
               }
               while(_loc2_ == lastPlayed);
               
            }
            else
            {
               _loc2_ = 0;
            }
         }
         else if(rotationType == ROTATIONTYPE_SEQUENCE)
         {
            _loc2_ = lastPlayed + 1;
            if(_loc2_ > _sounds.length - 1)
            {
               _loc2_ = 0;
            }
         }
         else if(rotationType == ROTATIONTYPE_RANDOM)
         {
            _loc2_ = Math.floor(Math.random() * _sounds.length) + 1;
         }
         _currentSound = _sounds[_loc2_] as BrainSoundOld;
         if(overrideChildInfo)
         {
            _currentSound.play(param1);
         }
         else
         {
            _currentSound.play();
         }
         lastPlayed = _loc2_;
      }
   }
}

