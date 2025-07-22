package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import gs.TweenMax;
   
   public class BrainSoundOld extends BrainSounderBaseOld
   {
      
      public var _transform:SoundTransform = new SoundTransform();
      
      private var _sound:Sound = null;
      
      private var _soundChannel:SoundChannel = null;
      
      public function BrainSoundOld(param1:String, param2:*, param3:SoundInfoOld = null)
      {
         super(param1,param3);
         if(param2 is Class)
         {
            _sound = new param2() as Sound;
         }
         else if(param2 is Sound)
         {
            _sound = param2;
         }
         if(!_sound)
         {
            throw new Error("BrainSound :: WARNING :: sound not found : " + _strID + " : " + param2);
         }
      }
      
      override public function stop(param1:Number = 0) : void
      {
         if(_soundChannel !== null)
         {
            if(param1 == 0)
            {
               TweenMax.killTweensOf(_transform);
               _soundChannel.stop();
               _soundChannel = null;
            }
            else
            {
               _transform.volume = _soundChannel.soundTransform.volume;
               TweenMax.to(_transform,param1,{
                  "volume":0,
                  "onUpdate":handleFadeUpdate,
                  "onComplete":handleFadeComplete
               });
            }
         }
      }
      
      override public function updateTransform(param1:SoundTransform) : void
      {
         _transform = param1;
         if(_soundChannel)
         {
            _soundChannel.soundTransform = _transform;
         }
      }
      
      private function removeChannelListeners(param1:SoundChannel) : void
      {
         if(param1)
         {
            param1.removeEventListener(Event.SOUND_COMPLETE,handleComplete);
         }
      }
      
      override public function onPosition() : void
      {
         if(_soundInfo.onPositionFunc !== null)
         {
            _soundInfo.onPositionFunc(_soundChannel.position);
         }
      }
      
      override public function onProgress() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(_soundInfo.onProgressFunc !== null)
         {
            _loc1_ = Math.round(Math.min(_soundChannel.position,_sound.length) / _sound.length) + 1;
            _soundInfo.onProgressFunc(_loc1_);
         }
         if(_soundInfo.controlMC)
         {
            _loc2_ = Math.min(_soundChannel.position,_sound.length) / 1000 * _soundInfo.controlMCFrameRate;
            _soundInfo.controlMC.gotoAndStop(_loc2_);
         }
      }
      
      override public function play(param1:SoundInfoOld = null) : void
      {
         if(!param1)
         {
            param1 = _soundInfo;
         }
         else
         {
            _soundInfo = param1;
         }
         var _loc2_:Number = param1.volume;
         if(_loc2_ < param1.baselineMinVol)
         {
            _loc2_ = param1.baselineMinVol;
         }
         else if(_loc2_ > param1.baselineMaxVol)
         {
            _loc2_ = param1.baselineMaxVol;
         }
         var _loc3_:SoundTransform = new SoundTransform(_loc2_,param1.pan);
         _soundChannel = _sound.play(param1.startOffset,param1.loop,_loc3_);
         addChannelListeners(_soundChannel);
      }
      
      private function handleFadeComplete() : void
      {
         if(_soundChannel)
         {
            _soundChannel.stop();
            _soundChannel = null;
         }
      }
      
      public function get soundChannel() : SoundChannel
      {
         return _soundChannel;
      }
      
      private function handleComplete(param1:Event) : void
      {
         removeChannelListeners(_soundChannel);
         _soundChannel = null;
         dispatchEvent(param1);
      }
      
      private function handleFadeUpdate() : void
      {
         if(_soundChannel)
         {
            _soundChannel.soundTransform = _transform;
         }
      }
      
      private function addChannelListeners(param1:SoundChannel) : void
      {
         if(param1)
         {
            param1.addEventListener(Event.SOUND_COMPLETE,handleComplete);
         }
      }
      
      public function get sound() : Sound
      {
         return _sound;
      }
   }
}

