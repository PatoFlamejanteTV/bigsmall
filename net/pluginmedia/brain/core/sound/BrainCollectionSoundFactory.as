package net.pluginmedia.brain.core.sound
{
   public class BrainCollectionSoundFactory extends BrainSoundFactory
   {
      
      public static const RANDOM:uint = 0;
      
      public static const PSUEDO_RANDOM:uint = 1;
      
      public static const SEQUENCE:uint = 2;
      
      protected var minMult:Number;
      
      protected var collection:Array;
      
      protected var maxMult:Number;
      
      protected var lastindex:int = -1;
      
      protected var selectMode:int;
      
      public function BrainCollectionSoundFactory(param1:String, param2:Array, param3:Number = 1, param4:Number = 1, param5:uint = 0)
      {
         maxMult = param4;
         minMult = param3;
         selectMode = param5;
         super(param1,param2[0],maxMult);
         collection = param2;
      }
      
      public function setSelectMode(param1:uint) : void
      {
         if(param1 > 2)
         {
            param1 = 0;
         }
         selectMode = param1;
      }
      
      protected function getSeed() : uint
      {
         var _loc1_:uint = 0;
         if(collection.length > 1)
         {
            switch(selectMode)
            {
               case RANDOM:
                  _loc1_ = Math.random() * collection.length;
                  break;
               case PSUEDO_RANDOM:
                  _loc1_ = Math.random() * collection.length;
                  while(_loc1_ == lastindex)
                  {
                     _loc1_ = Math.random() * collection.length;
                  }
                  break;
               case SEQUENCE:
                  _loc1_ = (lastindex + 1) % collection.length;
            }
         }
         lastindex = _loc1_;
         return _loc1_;
      }
      
      override public function factorySoundInstance(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Function = null, param6:Function = null, param7:Function = null) : BaseSoundInstance
      {
         var _loc8_:uint = getSeed();
         _soundObj = collection[_loc8_];
         _volumeMult = minMult + Math.random() * (maxMult - minMult);
         return super.factorySoundInstance(param1,param2,param3,param4,param5,param6,param7);
      }
   }
}

