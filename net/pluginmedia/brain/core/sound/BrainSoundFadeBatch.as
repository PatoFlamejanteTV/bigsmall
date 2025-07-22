package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   
   public class BrainSoundFadeBatch extends EventDispatcher
   {
      
      private var fadeMsec:int;
      
      private var callback:Function;
      
      private var soundBatch:Array;
      
      private var currentIncs:int = 0;
      
      private var clock:int;
      
      private var volIncrements:Array;
      
      private var totalIncs:int;
      
      public function BrainSoundFadeBatch(param1:int, param2:Array, param3:Number, param4:Function)
      {
         super();
         this.clock = param1;
         soundBatch = param2;
         fadeMsec = param3 * 1000;
         this.callback = param4;
         totalIncs = fadeMsec / param1;
         calculateIncrements();
      }
      
      public function update() : void
      {
         ++currentIncs;
         var _loc1_:int = 0;
         while(_loc1_ < soundBatch.length)
         {
            IBrainSoundInstance(soundBatch[_loc1_]).volume = IBrainSoundInstance(soundBatch[_loc1_]).volume - volIncrements[_loc1_];
            _loc1_++;
         }
         if(currentIncs == totalIncs)
         {
            endBatchFade();
         }
      }
      
      private function calculateIncrements() : void
      {
         volIncrements = new Array(soundBatch.length);
         var _loc1_:int = 0;
         while(_loc1_ < soundBatch.length)
         {
            volIncrements[_loc1_] = IBrainSoundInstance(soundBatch[_loc1_]).volume / totalIncs;
            _loc1_++;
         }
      }
      
      private function endBatchFade() : void
      {
         var _loc1_:BrainSoundInstance = null;
         for each(_loc1_ in soundBatch)
         {
            _loc1_.stop();
         }
         if(callback is Function)
         {
            callback();
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

