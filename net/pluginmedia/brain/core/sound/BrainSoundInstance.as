package net.pluginmedia.brain.core.sound
{
   import flash.media.Sound;
   import net.pluginmedia.maths.SuperMath;
   
   public class BrainSoundInstance extends BaseSoundInstance
   {
      
      protected var _soundObj:Sound;
      
      protected var _playbackprogress:uint;
      
      public function BrainSoundInstance(param1:String, param2:Sound, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Function = null, param9:Function = null)
      {
         super(param1,param3,param4,param5,param6,param7,param8,param9);
         _soundObj = param2;
      }
      
      override public function stop() : void
      {
         _progress = 0;
         if(_soundChannel)
         {
            _soundChannel.stop();
         }
         removeChannelListeners(_soundChannel);
         super.stop();
      }
      
      override public function updateTransform() : void
      {
         super.updateTransform();
         if(_soundChannel !== null)
         {
            _soundChannel.soundTransform = _soundTransform;
         }
      }
      
      override public function pause() : void
      {
         if(_soundChannel)
         {
            _playbackprogress = _soundChannel.position;
            _soundChannel.stop();
         }
         super.pause();
      }
      
      override public function get length() : Number
      {
         var _loc1_:Number = 0;
         if(_soundChannel !== null)
         {
            _loc1_ = _soundObj.length;
         }
         return _loc1_;
      }
      
      override public function resume() : void
      {
         if(_soundChannel)
         {
            _soundChannel = _soundObj.play(_playbackprogress,loop,_soundTransform);
            addChannelListeners(_soundChannel);
         }
         super.resume();
      }
      
      override public function get progress() : Number
      {
         var _loc1_:Number = NaN;
         if(_soundChannel !== null)
         {
            _loc1_ = this.position;
            _progress = _loc1_ / _soundObj.length;
            _progress = SuperMath.clamp(_progress,0,1);
         }
         return super.progress;
      }
      
      override public function get position() : Number
      {
         var _loc1_:Number = 0;
         if(_soundChannel !== null)
         {
            _loc1_ = _soundChannel.position % (_soundObj.length - offset);
         }
         return _loc1_;
      }
      
      override public function play() : void
      {
         super.play();
         _soundChannel = _soundObj.play(offset,loop,_soundTransform);
         addChannelListeners(_soundChannel);
      }
   }
}

