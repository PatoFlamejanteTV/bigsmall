package net.pluginmedia.bigandsmall.pages.livingroom.characters
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import net.pluginmedia.bigandsmall.pages.livingroom.LipSyncData;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSpriteMovieUpdater;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class BigWateringPlant extends CompanionCharacter
   {
      
      private var bigsHead:MovieClip;
      
      private var bigTurnMat:SpriteParticleMaterial;
      
      private var isWatering:Boolean = false;
      
      private var dripCounter:int = 0;
      
      public var wateringInterval:uint = 10000;
      
      private var bigsRightArmPouring:MovieClip;
      
      private var wateringTimer:Timer;
      
      private var bigTurn:PointSpriteMovieUpdater;
      
      private var drips:Array = new Array();
      
      public var wateringDuration:uint = 3000;
      
      private var currentTalker:MovieClip = null;
      
      private var bigsRightArm:MovieClip;
      
      public var bigTurnMov:MovieClip;
      
      private var talkingHeads:Dictionary = new Dictionary();
      
      public function BigWateringPlant()
      {
         super();
         wateringTimer = new Timer(wateringInterval,1);
         wateringTimer.addEventListener(TimerEvent.TIMER,onWateringTimer);
         visible = false;
      }
      
      private function onEnterFrame(param1:Event = null) : void
      {
         bigsHead.gotoAndStop(bigTurnMov.currentFrame);
         bigsRightArm.gotoAndStop(bigTurnMov.currentFrame);
         bigsRightArmPouring.gotoAndStop(bigTurnMov.currentFrame);
         updateDrips();
      }
      
      private function onWateringTimer(param1:TimerEvent) : void
      {
         if(!isWatering)
         {
            doWatering(true);
         }
         else
         {
            doWatering(false);
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         stopSyncedMovie();
         doWatering(false);
         wateringTimer.reset();
      }
      
      public function setContent(param1:MovieClip) : void
      {
         bigTurnMov = param1;
         bigsHead = MovieClip(param1["big_head_normal"]);
         bigsRightArm = MovieClip(param1["big_r_arm_normal"]);
         bigsRightArmPouring = MovieClip(param1["big_r_arm_pouring"]);
         initDrips(bigsRightArmPouring);
         bigTurnMat = new SpriteParticleMaterial(bigTurnMov);
         bigTurn = new PointSpriteMovieUpdater(bigTurnMat,40.493,-28.5539);
         bigsRightArmPouring.visible = false;
         addChild(bigTurn);
      }
      
      override public function activate() : void
      {
         super.activate();
         wateringTimer.start();
         visible = true;
      }
      
      public function removeTalkerHeads() : void
      {
         var _loc1_:LipSyncData = null;
         for each(_loc1_ in voiceOverData)
         {
            if(bigTurnMov.contains(_loc1_.movie))
            {
               bigTurnMov.removeChild(_loc1_.movie);
            }
         }
      }
      
      override public function showSyncedMovie(param1:MovieClip) : void
      {
         if(param1)
         {
            bigsHead.visible = false;
            currentTalker = param1;
            bigTurnMov.addChild(currentTalker);
            currentTalker.x = bigsHead.x;
            currentTalker.y = bigsHead.y;
         }
         else
         {
            BrainLogger.warning("BigWateringPlant :: registerTalkerHead :: WARNING :: could not source head");
         }
      }
      
      private function initDrips(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(getQualifiedClassName(param1.getChildAt(_loc2_)) == "WaterRunning")
            {
               drips.push(param1.getChildAt(_loc2_));
            }
            _loc2_++;
         }
      }
      
      private function updateDrips() : void
      {
         var _loc1_:int = 0;
         if(drips.length == 0)
         {
            initDrips(bigsRightArmPouring);
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < drips.length)
            {
               drips[_loc1_].gotoAndStop(dripCounter);
               _loc1_++;
            }
            ++dripCounter;
            if(dripCounter >= drips[0].totalFrames)
            {
               dripCounter = 0;
            }
         }
      }
      
      public function doWatering(param1:Boolean) : void
      {
         if(param1)
         {
            wateringTimer.delay = wateringDuration;
            bigsRightArm.visible = false;
            bigsRightArmPouring.visible = true;
            wateringTimer.reset();
            wateringTimer.start();
            SoundManagerOld.playSoundSimple("lr_plant_watering",0.7,0.6,100);
         }
         else
         {
            wateringTimer.delay = wateringInterval;
            bigsRightArmPouring.visible = false;
            bigsRightArm.visible = true;
            wateringTimer.reset();
            wateringTimer.start();
            SoundManagerOld.stopSound("lr_plant_watering",0.5);
         }
         isWatering = param1;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         bigTurnMov.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         visible = true;
      }
      
      override public function setVoiceOver(param1:String, param2:String, param3:String = null, param4:int = 1, param5:Boolean = false) : LipSyncData
      {
         if(!param3)
         {
            param3 = "big_head_" + param2;
         }
         return super.setVoiceOver(param1,param2,param3,param4,param5);
      }
      
      override public function park() : void
      {
         super.park();
         bigTurnMov.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         bigTurnMat.removeSprite();
         stopSyncedMovie();
         visible = false;
         bigTurnMat.removeSprite();
      }
      
      override public function stopSyncedMovie() : void
      {
         if(currentTalker !== null)
         {
            bigsHead.visible = true;
            removeTalkerHeads();
            currentTalker = null;
         }
      }
   }
}

