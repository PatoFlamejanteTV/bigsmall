package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BrainSoundFadeManager
   {
      
      private var timer:Timer;
      
      private var batches:Array = [];
      
      public function BrainSoundFadeManager(param1:int = 30)
      {
         super();
         timer = new Timer(param1);
         timer.addEventListener(TimerEvent.TIMER,handleTimer);
      }
      
      public function pushBatch(param1:Array, param2:Number, param3:Function) : void
      {
         var _loc4_:BrainSoundFadeBatch = new BrainSoundFadeBatch(timer.delay,param1,param2,param3);
         _loc4_.addEventListener(Event.COMPLETE,handleBatchFadeComplete);
         batches.push(_loc4_);
         startTimer();
      }
      
      private function startTimer() : void
      {
         if(!timer.running)
         {
            timer.start();
         }
      }
      
      private function stopTimer() : void
      {
         if(timer.running)
         {
            timer.reset();
            timer.stop();
         }
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         var _loc2_:BrainSoundFadeBatch = null;
         for each(_loc2_ in batches)
         {
            _loc2_.update();
         }
      }
      
      private function handleBatchFadeComplete(param1:Event) : void
      {
         var _loc2_:BrainSoundFadeBatch = param1.target as BrainSoundFadeBatch;
         _loc2_.removeEventListener(Event.COMPLETE,handleBatchFadeComplete);
         var _loc3_:int = int(batches.indexOf(_loc2_));
         batches.splice(_loc3_,1);
         if(batches.length == 0)
         {
            stopTimer();
         }
      }
   }
}

