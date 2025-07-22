package net.pluginmedia.utils
{
   public class SoundCollection implements ISoundPlayable
   {
      
      public var soundCount:Number;
      
      public var sounds:Array;
      
      public var name:String;
      
      public var setupFailed:Boolean;
      
      public var counter:Number = 0;
      
      public function SoundCollection(param1:String, param2:Array, param3:Number = 1)
      {
         var _loc4_:SuperSound = null;
         super();
         counter = 0;
         sounds = new Array();
         var _loc5_:Number = 0;
         while(_loc5_ < param2.length)
         {
            _loc4_ = SoundPlayer.addSound(param1 + _loc5_.toString(),param2[_loc5_],param3);
            if(_loc4_)
            {
               sounds.push(_loc4_);
            }
            _loc5_++;
         }
         soundCount = sounds.length;
         if(soundCount == 0)
         {
            setupFailed = true;
         }
         this.name = param1;
      }
      
      public function playSound(param1:Number = 1, param2:Number = 0, param3:uint = 0) : void
      {
         ++counter;
         if(counter >= soundCount)
         {
            counter = 0;
         }
         var _loc4_:SuperSound = sounds[counter];
         SoundPlayer.playSound(_loc4_.name,param1,param2);
      }
      
      public function playRandomSound(param1:Number = 1, param2:Number = 0, param3:uint = 0) : void
      {
         var _loc4_:int = Math.random() * sounds.length;
         var _loc5_:SuperSound = sounds[_loc4_];
         SoundPlayer.playSound(_loc5_.name,param1,param2);
      }
   }
}

