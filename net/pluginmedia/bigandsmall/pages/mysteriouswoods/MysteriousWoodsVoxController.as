package net.pluginmedia.bigandsmall.pages.mysteriouswoods
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   
   public class MysteriousWoodsVoxController extends EventDispatcher
   {
      
      public static var END_DANCE:String = "MysteriousWoods.END_DANCE";
      
      public static var BIG_ACTIVATE:String = "MysteriousWoods.BIG_ACTIVATE";
      
      public static var BIG_ROLLOVER_ARROW:String = "MysteriousWoods.BIG_ROLLOVER_ARROW";
      
      public static var BIG_CLICK_ARROW:String = "MysteriousWoods.BIG_CLICK_ARROW";
      
      public static var BIG_JUNCTION_I:String = "MysteriousWoods.BIG_JUNCTION_I";
      
      public static var BIG_JUNCTION_II:String = "MysteriousWoods.BIG_JUNCTION_II";
      
      public static var BIG_JUNCTION_III:String = "MysteriousWoods.BIG_JUNCTION_III";
      
      public static var BIG_JUNCTION_IV:String = "MysteriousWoods.BIG_JUNCTION_IV";
      
      public static var BIG_JUNCTIONS:Array = [BIG_JUNCTION_I,BIG_JUNCTION_II,BIG_JUNCTION_III,BIG_JUNCTION_IV];
      
      public static var BIG_PROMPT_I:String = "MysteriousWoods.BIG_PROMPT_I";
      
      public static var BIG_PROMPT_II:String = "MysteriousWoods.BIG_PROMPT_II";
      
      public static var BIG_PROMPT_III:String = "MysteriousWoods.BIG_PROMPT_III";
      
      public static var BIG_PROMPT_IV:String = "MysteriousWoods.BIG_PROMPT_IV";
      
      public static var BIG_PROMPT_V:String = "MysteriousWoods.BIG_PROMPT_V";
      
      public static var BIG_PROMPT_VI:String = "MysteriousWoods.BIG_PROMPT_VI";
      
      public static var BIG_PROMPT_VII:String = "MysteriousWoods.BIG_PROMPT_VII";
      
      public static var BIG_PROMPTS:Array = [BIG_PROMPT_I,BIG_PROMPT_II,BIG_PROMPT_III,BIG_PROMPT_IV,BIG_PROMPT_V,BIG_PROMPT_VI,BIG_PROMPT_VII];
      
      public static var BIG_DEADEND_I:String = "MysteriousWoods.BIG_DEADEND_I";
      
      public static var BIG_DEADEND_II:String = "MysteriousWoods.BIG_DEADEND_II";
      
      public static var BIG_DEADEND_III:String = "MysteriousWoods.BIG_DEADEND_III";
      
      public static var BIG_DEADEND_IV:String = "MysteriousWoods.BIG_DEADEND_IV";
      
      public static var BIG_DEADENDS:Array = [BIG_DEADEND_I,BIG_DEADEND_II,BIG_DEADEND_III,BIG_DEADEND_IV];
      
      public static var BIG_COMPLETION_I:String = "MysteriousWoods.BIG_COMPLETION_I";
      
      public static var BIG_COMPLETION_II:String = "MysteriousWoods.BIG_COMPLETION_II";
      
      public static var SMALL_ACTIVATE:String = "MysteriousWoods.SMALL_ACTIVATE";
      
      public static var SMALL_ROLLOVER_ARROW:String = "MysteriousWoods.SMALL_ROLLOVER_ARROW";
      
      public static var SMALL_CLICK_ARROW:String = "MysteriousWoods.SMALL_CLICK_ARROW";
      
      public static var SMALL_JUNCTION_I:String = "MysteriousWoods.SMALL_JUNCTION_I";
      
      public static var SMALL_JUNCTION_II:String = "MysteriousWoods.SMALL_JUNCTION_II";
      
      public static var SMALL_JUNCTION_III:String = "MysteriousWoods.SMALL_JUNCTION_III";
      
      public static var SMALL_JUNCTION_IV:String = "MysteriousWoods.SMALL_JUNCTION_IV";
      
      public static var SMALL_JUNCTIONS:Array = [SMALL_JUNCTION_I,SMALL_JUNCTION_II,SMALL_JUNCTION_III,SMALL_JUNCTION_IV];
      
      public static var SMALL_PROMPT_I:String = "MysteriousWoods.SMALL_PROMPT_I";
      
      public static var SMALL_PROMPT_II:String = "MysteriousWoods.SMALL_PROMPT_II";
      
      public static var SMALL_PROMPT_III:String = "MysteriousWoods.SMALL_PROMPT_III";
      
      public static var SMALL_PROMPT_IV:String = "MysteriousWoods.SMALL_PROMPT_IV";
      
      public static var SMALL_PROMPT_V:String = "MysteriousWoods.SMALL_PROMPT_V";
      
      public static var SMALL_PROMPT_VI:String = "MysteriousWoods.SMALL_PROMPT_VI";
      
      public static var SMALL_PROMPT_VII:String = "MysteriousWoods.SMALL_PROMPT_VII";
      
      public static var SMALL_PROMPT_VIII:String = "MysteriousWoods.SMALL_PROMPT_VIII";
      
      public static var SMALL_PROMPTS:Array = [SMALL_PROMPT_I,SMALL_PROMPT_II,SMALL_PROMPT_III,SMALL_PROMPT_IV,SMALL_PROMPT_V,SMALL_PROMPT_VI,SMALL_PROMPT_VII,SMALL_PROMPT_VIII];
      
      public static var SMALL_DEADEND_I:String = "MysteriousWoods.SMALL_DEADEND_I";
      
      public static var SMALL_DEADEND_II:String = "MysteriousWoods.SMALL_DEADEND_II";
      
      public static var SMALL_DEADEND_III:String = "MysteriousWoods.SMALL_DEADEND_III";
      
      public static var SMALL_DEADEND_IV:String = "MysteriousWoods.SMALL_DEADEND_IV";
      
      public static var SMALL_DEADENDS:Array = [SMALL_DEADEND_I,SMALL_DEADEND_III,SMALL_DEADEND_II,SMALL_DEADEND_IV];
      
      public static var SMALL_COMPLETION_I:String = "MysteriousWoods.SMALL_COMPLETION_I";
      
      public static var SMALL_COMPLETION_II:String = "MysteriousWoods.SMALL_COMPLETION_II";
      
      public static var GAME_FINISHED:String = "MysteriousWoods.GAME_FINISHED";
      
      private var rolloverPlayed:Boolean;
      
      private var voxPromptAtStraightSeg:int = 3;
      
      private var timeoutTimer:Timer;
      
      private var currentPOV:String;
      
      private var straightSegsVisited:int = 0;
      
      private var clickPlayed:Boolean;
      
      public function MysteriousWoodsVoxController()
      {
         super();
         timeoutTimer = new Timer(18000);
         timeoutTimer.addEventListener(TimerEvent.TIMER,handleTimeOut);
         reset();
      }
      
      private function handleTimeOut(param1:TimerEvent) : void
      {
         doVoxPrompt();
      }
      
      private function playSound(param1:String, param2:Boolean = false, param3:Function = null) : void
      {
         if(SoundManagerOld.channelOccupied(1))
         {
            return;
         }
         if(SoundManager.isChannelBusy(SoundChannelDefinitions.VOX) && !param2)
         {
            return;
         }
         if(SoundManager.isChannelBusy(SoundChannelDefinitions.VOX) && param2)
         {
            SoundManager.stopChannel(SoundChannelDefinitions.VOX,0.45);
         }
         SoundManager.playSoundOnChannel(param1,SoundChannelDefinitions.VOX,1,0,0,0,param3);
      }
      
      public function reset() : void
      {
         rolloverPlayed = false;
         clickPlayed = false;
         straightSegsVisited = 0;
      }
      
      public function resetTimeoutTimer(param1:Boolean = false) : void
      {
         timeoutTimer.reset();
         if(param1)
         {
            timeoutTimer.start();
         }
         else
         {
            timeoutTimer.stop();
         }
      }
      
      private function endVoxFinished() : void
      {
         dispatchEvent(new Event(GAME_FINISHED));
      }
      
      private function doVoxPrompt() : void
      {
         var _loc1_:Array = null;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            _loc1_ = BIG_PROMPTS;
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            _loc1_ = SMALL_PROMPTS;
         }
         playSound(_loc1_[0]);
         _loc1_.push(_loc1_.shift());
      }
      
      public function arrowClicked() : void
      {
         if(clickPlayed)
         {
            return;
         }
         clickPlayed = true;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            playSound(BIG_CLICK_ARROW);
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            playSound(SMALL_CLICK_ARROW);
         }
      }
      
      public function atStraightSegment() : void
      {
         ++straightSegsVisited;
         if(straightSegsVisited % voxPromptAtStraightSeg == 0)
         {
            doVoxPrompt();
         }
      }
      
      public function transitionFinished() : void
      {
         resetTimeoutTimer(true);
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
      }
      
      public function atFinalSegment() : void
      {
         resetTimeoutTimer();
      }
      
      public function activate() : void
      {
         if(currentPOV == CharacterDefinitions.BIG)
         {
            playSound(BIG_ACTIVATE);
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            playSound(SMALL_ACTIVATE);
         }
         resetTimeoutTimer(true);
      }
      
      public function deactivate() : void
      {
         resetTimeoutTimer();
      }
      
      public function arrowRolledOver() : void
      {
         if(rolloverPlayed)
         {
            return;
         }
         rolloverPlayed = true;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            playSound(BIG_ROLLOVER_ARROW);
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            playSound(SMALL_ROLLOVER_ARROW);
         }
      }
      
      public function atDeadEnd(param1:int) : void
      {
         var _loc2_:Array = null;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            _loc2_ = BIG_DEADENDS;
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            _loc2_ = SMALL_DEADENDS;
         }
         playSound(_loc2_[param1],true);
      }
      
      public function atJunction(param1:int) : void
      {
         var _loc2_:Array = null;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            _loc2_ = BIG_JUNCTIONS;
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            _loc2_ = SMALL_JUNCTIONS;
         }
         playSound(_loc2_[param1],true);
      }
   }
}

