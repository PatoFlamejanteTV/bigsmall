package net.pluginmedia.bigandsmall.pages.livingroom.bandgame
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class LipSyncTimerManager
   {
      
      public var timer:Timer;
      
      public var lipSyncList:Array = new Array();
      
      public var defaultTime:int;
      
      public var currentLipSync:int = 0;
      
      public function LipSyncTimerManager(param1:int)
      {
         super();
         defaultTime = param1;
         timer = new Timer(defaultTime);
      }
      
      public function start() : void
      {
         BrainLogger.out("LipSyncTimer.START");
         timer.addEventListener(TimerEvent.TIMER,handleTimer);
         timer.start();
      }
      
      public function stop() : void
      {
         BrainLogger.out("LipSyncTimer.RESET");
         timer.reset();
         timer.removeEventListener(TimerEvent.TIMER,handleTimer);
      }
      
      public function reset() : void
      {
         BrainLogger.out("LipSyncTimer.RESET");
         timer.reset();
         BrainLogger.out("LipSyncTimer.START");
         timer.start();
      }
      
      public function addLipSyncData(param1:PlayerPointSprite, param2:String) : void
      {
         lipSyncList.push(new BandLipSyncData(param1,param2));
      }
      
      public function incCurrentLipSync() : void
      {
         ++currentLipSync;
         if(currentLipSync >= lipSyncList.length)
         {
            currentLipSync = 0;
         }
      }
      
      public function handleTimer(param1:TimerEvent) : void
      {
         var _loc2_:BandLipSyncData = null;
         var _loc3_:PlayerPointSprite = null;
         BrainLogger.out("LipSyncTimer.HANDLETIMER");
         var _loc4_:int = 0;
         while(_loc4_ == 0 || !_loc3_.isPlayingNullAnim && _loc4_ < lipSyncList.length)
         {
            _loc2_ = lipSyncList[currentLipSync] as BandLipSyncData;
            _loc3_ = _loc2_.player;
            BrainLogger.out("attempt",_loc4_,"char",_loc3_,_loc3_.isPlayingNullAnim,"currentLipSync",currentLipSync);
            _loc4_++;
            incCurrentLipSync();
         }
         if(_loc4_ <= lipSyncList.length)
         {
            _loc3_.playLipSyncAnim(_loc2_.label);
         }
      }
   }
}

