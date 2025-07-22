package net.pluginmedia.utils
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   public class SuperSound implements ISoundPlayable
   {
      
      public var soundChannel:SoundChannel = null;
      
      public var name:String;
      
      public var sound:Sound;
      
      public var maxVolume:Number = 1;
      
      public var setupFailed:Boolean = false;
      
      public var pan:Number;
      
      private var muted:Boolean;
      
      private var _volume:Number;
      
      public function SuperSound(param1:String, param2:*, param3:Number = 1, param4:Number = 0)
      {
         var sname:String = param1;
         var soundref:* = param2;
         var maxvolume:Number = param3;
         var defaultpan:Number = param4;
         super();
         if(soundref is String)
         {
            try
            {
               sound = new Sound(new URLRequest(SoundPlayer.defaultPath + soundref));
            }
            finally
            {
               trace("WARNING - SuperSound sound not found : " + sname);
               return;
            }
         }
         else
         {
            if(soundref is Class)
            {
               sound = new soundref();
            }
            else if(soundref is Sound)
            {
               sound = soundref;
            }
            if(!sound)
            {
               trace("WARNING - SuperSound sound not found : " + sname);
               return;
            }
            maxVolume = maxvolume;
            _volume = maxVolume;
            pan = defaultpan;
            trace("new SuperSound",sound,soundref,soundref is Sound,typeof soundref);
            name = sname;
            return;
         }
      }
      
      public function loopSound(param1:int, param2:Number = NaN, param3:Number = NaN, param4:Number = 0) : void
      {
         soundChannel = sound.play(param4,param1);
         if(!isNaN(param2))
         {
            _volume = param2;
         }
         if(!isNaN(param3))
         {
            this.pan = param3;
         }
         soundChannel.soundTransform = new SoundTransform(_volume * maxVolume,this.pan);
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function get length() : Number
      {
         return sound.length;
      }
      
      public function get position() : Number
      {
         if(soundChannel)
         {
            return soundChannel.position;
         }
         return 0;
      }
      
      public function stopSound() : void
      {
         if(soundChannel !== null)
         {
            soundChannel.stop();
         }
      }
      
      public function set volume(param1:Number) : void
      {
         if(soundChannel !== null)
         {
            soundChannel.soundTransform = new SoundTransform(param1 * maxVolume,pan);
            _volume = param1;
         }
      }
      
      public function playSound(param1:Number = NaN, param2:Number = NaN, param3:uint = 0) : void
      {
         soundChannel = sound.play(param3);
         if(!isNaN(param1))
         {
            _volume = param1;
         }
         if(!isNaN(param2))
         {
            this.pan = param2;
         }
         soundChannel.soundTransform = new SoundTransform(_volume * maxVolume,this.pan);
      }
   }
}

