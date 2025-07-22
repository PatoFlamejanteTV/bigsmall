package net.pluginmedia.utils
{
   import flash.media.*;
   
   public class SoundPlayer
   {
      
      public static var sounds:Object = {};
      
      public static var muted:Boolean = false;
      
      public static var defaultPath:String = "";
      
      public function SoundPlayer()
      {
         super();
      }
      
      public static function loopSound(param1:String, param2:int, param3:Number = NaN, param4:Number = NaN, param5:Number = 0) : void
      {
         var _loc6_:ISoundPlayable = sounds[param1];
         SuperSound(_loc6_).loopSound(param2,param3,param4,param5);
      }
      
      public static function stopSound(param1:String) : void
      {
         var _loc2_:ISoundPlayable = sounds[param1];
         SuperSound(_loc2_).stopSound();
      }
      
      public static function addSound(param1:String, param2:*, param3:Number = 1) : SuperSound
      {
         var _loc4_:SuperSound = new SuperSound(param1,param2,param3);
         _loc4_.volume = param3;
         sounds[param1] = _loc4_;
         return _loc4_;
      }
      
      public static function addSoundCollection(param1:String, param2:Array, param3:Number = 1) : SoundCollection
      {
         var _loc4_:SoundCollection = new SoundCollection(param1,param2,param3);
         sounds[param1] = _loc4_;
         return _loc4_;
      }
      
      public static function getSound(param1:String) : SuperSound
      {
         return sounds[param1];
      }
      
      public static function playSound(param1:String, param2:Number = NaN, param3:Number = NaN, param4:Number = 0) : void
      {
         var _loc5_:ISoundPlayable = sounds[param1];
         if(!_loc5_)
         {
            trace("WARNING SoundPlayer - sound " + param1 + " not found");
         }
         else
         {
            _loc5_.playSound(param2,param3,param4);
         }
      }
   }
}

