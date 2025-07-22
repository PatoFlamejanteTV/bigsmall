package net.pluginmedia.bigandsmall.pages.bedroom.managers
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.pages.bedroom.BigDraggablePillows;
   import net.pluginmedia.bigandsmall.pages.bedroom.ModifiableDuvet;
   import net.pluginmedia.bigandsmall.pages.bedroom.characters.SmallBounceBed;
   import net.pluginmedia.bigandsmall.pages.bedroom.mobile.MobileStruct3D;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.brain.core.interfaces.IBrainSounderOld;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.view.BasicView;
   
   public class SmallToSleepGameManager extends BedroomGameManager
   {
      
      private var started:Boolean;
      
      private var smallBounceBed:SmallBounceBed;
      
      private var playedFirstCalmVOX:Boolean = false;
      
      private var occupiedAnimChannel:Boolean = false;
      
      private var prevPreGameTimeOut:int = 0;
      
      private var oCam:OrbitCamera3D;
      
      private var draggablePillows:BigDraggablePillows;
      
      private var duvetMod:ModifiableDuvet;
      
      private var gameOn:Boolean;
      
      private var preGameVoxTimer:Timer;
      
      private var inGameVoxTimer:Timer;
      
      public function SmallToSleepGameManager(param1:BigAndSmallPage3D, param2:BasicView)
      {
         super(param1,param2);
         gameOn = false;
         started = false;
         initVoxTimers();
      }
      
      override public function stopInteractive() : void
      {
         super.stopInteractive();
         disableMobile();
      }
      
      override public function enableMobile() : void
      {
         super.enableMobile();
         mobileLayerButton.addEventListener(MouseEvent.CLICK,handleBigMobileClick);
      }
      
      override public function prepare() : void
      {
         draggablePillows.reset(true);
         if(smallBounceBed)
         {
            smallBounceBed.activate();
         }
      }
      
      private function handleSmallFallenAsleep(param1:Event) : void
      {
         unBindVoxChannel();
      }
      
      private function stopPreGameVox() : void
      {
         preGameVoxTimer.reset();
      }
      
      private function handleTeddyPillowOnSmall(param1:Event) : void
      {
         smallBounceBed.setTeddyVisible(true);
         makeSmallSleepier();
      }
      
      public function init(param1:SmallBounceBed) : void
      {
         smallBounceBed = param1;
         smallBounceBed.addEventListener("BounceUp",handleSmallBounceUp);
         smallBounceBed.addEventListener("BounceDown",handleSmallBounceDown);
         smallBounceBed.addEventListener(SmallBounceBed.QUEUED_ANIM_STARTING,handleSmallQueuedAnimStarting);
         smallBounceBed.addEventListener(SmallBounceBed.FALLING_ASLEEP,handleSmallFallingAsleep);
         smallBounceBed.addEventListener(SmallBounceBed.PUT_TO_SLEEP,handleSmallFallenAsleep);
         smallBounceBed.addEventListener(SmallBounceBed.WOKEN_UP,handleSmallWokenUp);
         smallBounceBed.addEventListener("VOX_COMPLETE",handleSmallVoxComplete);
         smallBounceBed.addEventListener("CALMINGINFLUENCE_COMPLETE",handleCalmInf);
      }
      
      private function handleSmallVoxComplete(param1:Event) : void
      {
         var _loc2_:IBrainSounderOld = null;
         unBindVoxChannel();
         if(gameOn)
         {
            if(!playedFirstCalmVOX && !smallBounceBed.hasQueue && smallBounceBed.calmingCount > 0)
            {
               SoundManagerOld.playSound("small_sleep_reinforce");
               playedFirstCalmVOX = true;
            }
            startInGameVox();
         }
         else if(!started)
         {
            started = true;
            _loc2_ = SoundManagerOld.getSoundByID("bed_big_theremustbeawaytocalm");
            _loc2_.soundInfo.onCompleteFunc = handleInitBigVoxComplete;
            SoundManagerOld.playSound("bed_big_theremustbeawaytocalm");
         }
         else if(started)
         {
            startPreGameVox();
         }
      }
      
      private function releaseCamera() : void
      {
         if(oCam)
         {
            oCam.release();
         }
      }
      
      private function handleInitBigVoxComplete() : void
      {
         startPreGameVox();
         unBindVoxChannel();
      }
      
      override public function startInteractive() : void
      {
         draggablePillows.activate();
         draggablePillows.setVisible(true);
         enableMobile();
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_ON)
         {
            setLightsEnabled(true);
         }
      }
      
      private function handleSmallBounceUp(param1:Event) : void
      {
         duvetMod.setTarg(0);
      }
      
      public function setCamera(param1:OrbitCamera3D) : void
      {
         oCam = param1;
      }
      
      override public function disableMobile() : void
      {
         super.disableMobile();
         mobileLayerButton.removeEventListener(MouseEvent.CLICK,handleBigMobileClick);
      }
      
      override public function setMobile(param1:MobileStruct3D, param2:VPortLayerButton) : void
      {
         super.setMobile(param1,param2);
      }
      
      private function handleBigMobileClick(param1:MouseEvent) : void
      {
         mobile.doJingleSpin(2);
         SoundManagerOld.playSound("bed_mobile_bigplays");
         if(!doneMobileResponse)
         {
            doneMobileResponse = true;
            makeSmallSleepier();
         }
         disableMobile();
      }
      
      private function lockCamera() : void
      {
         if(oCam)
         {
            oCam.lock();
         }
      }
      
      public function setDuvet(param1:ModifiableDuvet) : void
      {
         duvetMod = param1;
      }
      
      private function unBindVoxChannel() : void
      {
         if(occupiedAnimChannel)
         {
            SoundManagerOld.unSelectChannel(1);
         }
         occupiedAnimChannel = false;
      }
      
      private function handleSmallQueuedAnimStarting(param1:Event) : void
      {
         stopInGameVox();
         stopPreGameVox();
      }
      
      private function bindVoxChannel() : void
      {
         if(!occupiedAnimChannel)
         {
            SoundManagerOld.selectChannel(1);
         }
         occupiedAnimChannel = true;
      }
      
      private function handlePreGameVoxTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:IBrainSounderOld = null;
         while(_loc2_ == prevPreGameTimeOut)
         {
            _loc2_ = int(Math.random() * 2);
         }
         switch(_loc2_)
         {
            case 0:
               _loc3_ = SoundManagerOld.getSoundByID("bed_big_theremustbeawaytocalm");
               _loc3_.soundInfo.onCompleteFunc = handleInitBigVoxComplete;
               SoundManagerOld.playSound("bed_big_theremustbeawaytocalm");
               break;
            case 1:
               _loc3_ = SoundManagerOld.getSoundByID("bed_big_letsseeifwecan");
               _loc3_.soundInfo.onCompleteFunc = handleInitBigVoxComplete;
               SoundManagerOld.playSound("bed_big_letsseeifwecan");
               break;
            case 2:
         }
         prevPreGameTimeOut = _loc2_;
      }
      
      private function handleBluePillowOnSmall(param1:Event) : void
      {
         smallBounceBed.setBluePillowVisible(true);
         if(smallBounceBed.greenPillowVisible)
         {
            makeSmallSleepier();
         }
      }
      
      private function handleCalmInf(param1:Event) : void
      {
         if(!playedFirstCalmVOX)
         {
            SoundManagerOld.playSound("small_sleep_reinforce");
            playedFirstCalmVOX = true;
         }
      }
      
      private function handleGreenPillowOnSmall(param1:Event) : void
      {
         smallBounceBed.setGreenPillowVisible(true);
         if(smallBounceBed.bluePillowVisible)
         {
            makeSmallSleepier();
         }
      }
      
      private function stopInGameVox() : void
      {
         inGameVoxTimer.reset();
      }
      
      override public function reset() : void
      {
         super.reset();
         unBindVoxChannel();
         draggablePillows.reset(true);
         playedFirstCalmVOX = false;
         smallBounceBed.reset();
      }
      
      private function handleBluePillowMoving(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleInGameVoxTimer(param1:TimerEvent) : void
      {
         SoundManagerOld.playSound("big_ingame_vox");
      }
      
      private function handleTeddyPillowMoving(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function initVoxTimers() : void
      {
         inGameVoxTimer = new Timer(12000,0);
         inGameVoxTimer.addEventListener(TimerEvent.TIMER,handleInGameVoxTimer);
         preGameVoxTimer = new Timer(12000,0);
         preGameVoxTimer.addEventListener(TimerEvent.TIMER,handlePreGameVoxTimer);
      }
      
      override protected function lightChange() : void
      {
         super.lightChange();
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_ON)
         {
            makeSmallSleepier();
            lightDarkManager.toggleLights();
            SoundManagerOld.playSound("bed_blinds_bigclose");
         }
      }
      
      public function setDraggablePillows(param1:BigDraggablePillows) : void
      {
         draggablePillows = param1;
         draggablePillows.addEventListener(BigDraggablePillows.BLUEPILLOW_ONSMALL,handleBluePillowOnSmall);
         draggablePillows.addEventListener(BigDraggablePillows.GREENPILLOW_ONSMALL,handleGreenPillowOnSmall);
         draggablePillows.addEventListener(BigDraggablePillows.TEDDY_ONSMALL,handleTeddyPillowOnSmall);
         draggablePillows.addEventListener(BigDraggablePillows.BLUEPILLOW_MOVING,handleBluePillowMoving);
         draggablePillows.addEventListener(BigDraggablePillows.GREENPILLOW_MOVING,handleGreenPillowMoving);
         draggablePillows.addEventListener(BigDraggablePillows.TEDDY_MOVING,handleTeddyPillowMoving);
      }
      
      private function handleSmallBounceDown(param1:Event) : void
      {
         var _loc2_:Number = -1 * (1 / (smallBounceBed.bounceMag + 1.5));
         SoundManagerOld.playSound("bed_small_bounce");
         SoundManagerOld.updateTransform("bed_small_bounce",_loc2_);
         duvetMod.setTarg(_loc2_);
      }
      
      override public function park() : void
      {
         reset();
         deactivate();
      }
      
      private function startPreGameVox() : void
      {
         preGameVoxTimer.start();
      }
      
      private function startInGameVox() : void
      {
         inGameVoxTimer.start();
      }
      
      private function handleSmallWakeupFinished(param1:AnimationOldEvent) : void
      {
         releaseCamera();
         smallBounceBed.removeEventListener(AnimationOldEvent.COMPLETE,handleSmallWakeupFinished);
         reset();
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_OFF)
         {
            lightDarkManager.toggleLights();
            SoundManagerOld.playSound("bed_blinds_bigclose");
         }
         draggablePillows.setVisible(true);
         setLightsEnabled(true);
         enableMobile();
         startPreGameVox();
         SoundManagerOld.playSound("bed_big_trybeingsmall");
      }
      
      override public function activate() : void
      {
         super.activate();
         bindVoxChannel();
         smallBounceBed.doVox();
         started = false;
      }
      
      override public function deactivate() : void
      {
         var _loc1_:IBrainSounderOld = null;
         super.deactivate();
         if(smallBounceBed)
         {
            smallBounceBed.deactivate();
         }
         if(duvetMod)
         {
            duvetMod.setTarg(0,true);
         }
         stopInGameVox();
         stopPreGameVox();
         _loc1_ = SoundManagerOld.getSoundByID("bed_big_theremustbeawaytocalm");
         _loc1_.soundInfo.onCompleteFunc = null;
         _loc1_.stop();
         _loc1_ = SoundManagerOld.getSoundByID("bed_big_letsseeifwecan");
         _loc1_.soundInfo.onCompleteFunc = null;
         _loc1_.stop();
         unBindVoxChannel();
         draggablePillows.deactivate();
      }
      
      public function makeSmallSleepier() : void
      {
         if(!gameOn)
         {
            gameOn = true;
            started = true;
         }
         else
         {
            stopInGameVox();
         }
         stopPreGameVox();
         smallBounceBed.addCalmingInfluence();
         bindVoxChannel();
      }
      
      private function handleGreenPillowMoving(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleSmallFallingAsleep(param1:Event) : void
      {
         smallBounceBed.addEventListener(SmallBounceBed.WOKEN_UP,handleSmallWokenUp);
         gameOn = false;
      }
      
      private function handleSmallWokenUp(param1:Event) : void
      {
         lockCamera();
         smallBounceBed.setBluePillowVisible(false);
         smallBounceBed.setGreenPillowVisible(false);
         smallBounceBed.setTeddyVisible(false);
         draggablePillows.reset(false);
         draggablePillows.activate();
         draggablePillows.setVisible(false);
         mobileLayerButton.setEnabledState(false);
         smallBounceBed.removeEventListener(SmallBounceBed.WOKEN_UP,handleSmallWokenUp);
         smallBounceBed.addEventListener(AnimationOldEvent.COMPLETE,handleSmallWakeupFinished);
      }
   }
}

