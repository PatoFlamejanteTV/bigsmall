package net.pluginmedia.brain.core.sound
{
   import flash.media.Sound;
   
   public class BrainSoundFactory
   {
      
      protected var _soundObj:Sound;
      
      protected var _volumeMult:Number = 1;
      
      protected var _id:String;
      
      public function BrainSoundFactory(param1:String, param2:Sound, param3:Number = 1)
      {
         super();
         _id = param1;
         _soundObj = param2;
         _volumeMult = param3;
      }
      
      public function factorySoundInstance(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Function = null, param6:Function = null, param7:Function = null) : BaseSoundInstance
      {
         return new BrainSoundInstance(_id,_soundObj,param1,_volumeMult,param2,param3,param4,param5,param6);
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get volumeMult() : Number
      {
         return _volumeMult;
      }
      
      public function get sound() : Sound
      {
         return _soundObj;
      }
   }
}

