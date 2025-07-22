package net.pluginmedia.bigandsmall.pages.bedroom.managers
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.pages.bedroom.Blind;
   import net.pluginmedia.bigandsmall.pages.bedroom.ThrowableBedroomObject;
   import net.pluginmedia.bigandsmall.pages.bedroom.characters.BigInBed;
   import net.pluginmedia.bigandsmall.pages.bedroom.mobile.MobileDragEvent;
   import net.pluginmedia.bigandsmall.pages.bedroom.mobile.MobileStruct3D;
   import net.pluginmedia.bigandsmall.pages.bedroom.teddy.ThrowableFreakyAssTeddy;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.brain.core.interfaces.IBrainSounderOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.view.BasicView;
   
   public class BigWakeUpGameManager extends BedroomGameManager
   {
      
      public static const THRASH_STARTED:String = "bigThrashStarted";
      
      public static const THRASH_ENDED:String = "bigThrashEnded";
      
      public static const WOKEN_UP:String = "bigWokenUp";
      
      public static const FALLEN_ASLEEP:String = "bigFallenAsleep";
      
      public static const BLUEPILLOW_HITBIG:String = "bluePillowHitBig";
      
      public static const GREENPILLOW_HITBIG:String = "greenPillowHitBig";
      
      public static const TEDDY_HITBIG:String = "teddyHitBig";
      
      private var rolloverVoxPlaying:Boolean;
      
      private var bigThrashingRotY:Number = -187;
      
      private var smallCamDist:Number;
      
      private var bigThrashingY:Number = 485;
      
      private var smallCamY:Number;
      
      private var greenPillowButton:VPortLayerButton;
      
      public var rolloverVoxTimeout:uint = 45000;
      
      private var occupiedAnimChannel:Boolean = false;
      
      private var teddyButton:VPortLayerButton;
      
      private var smallCam:OrbitCamera3D;
      
      private var bigThrashingDist:Number = 350;
      
      public var isIntro:Boolean = false;
      
      private var gameOn:Boolean;
      
      private var inGameVoxTimer:Timer;
      
      private var started:Boolean;
      
      private var bigThrashingrotXVariance:Number = 1;
      
      private var rolloverVoxTimes:Array;
      
      private var bigThrashingRotYVariance:Number = 1;
      
      private var smallCamMinX:Number;
      
      private var smallCamMinY:Number;
      
      private var mobileHitArea:Sprite;
      
      private var greenPillow:ThrowableBedroomObject;
      
      private var bluePillow:ThrowableBedroomObject;
      
      private var smallCamMaxX:Number;
      
      private var smallCamMaxY:Number;
      
      private var teddy:ThrowableFreakyAssTeddy;
      
      private var bigThrashingrotX:Number = -1;
      
      private var bluePillowButton:VPortLayerButton;
      
      private var preGameVoxTimer:Timer;
      
      private var bigInBed:BigInBed;
      
      public function BigWakeUpGameManager(param1:BigAndSmallPage3D, param2:BasicView)
      {
         super(param1,param2);
         gameOn = false;
         started = false;
         initVoxTimers();
      }
      
      override public function enableMobile() : void
      {
         super.enableMobile();
         mobileLayerButton.addEventListener(MouseEvent.CLICK,handleSmallMobileClick);
         mobile.enableDrag();
         mobileHitArea.buttonMode = true;
         mobileHitArea.mouseEnabled = true;
      }
      
      private function handleRolloverVox(param1:Event) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:IBrainSounderOld = null;
         if(!_active || this.isIntro || SoundManagerOld.channelOccupied(1))
         {
            return;
         }
         var _loc2_:uint = uint(getTimer());
         var _loc3_:* = param1.target;
         switch(_loc3_)
         {
            case bluePillowButton:
            case greenPillowButton:
               _loc5_ = "bed_small_OKlookatthose";
               _loc4_ = 0;
               break;
            case blindButton:
               _loc5_ = "bed_small_maybenotbright";
               _loc4_ = 1;
               break;
            case teddyButton:
               _loc5_ = "bed_small_thatsleeptoythingy";
               _loc4_ = 2;
               break;
            case mobileLayerButton:
               _loc5_ = "bed_small_whataboutrocket";
               _loc4_ = 3;
         }
         if(_loc2_ - rolloverVoxTimes[_loc4_] > rolloverVoxTimeout && !rolloverVoxPlaying)
         {
            stopPreGameVox();
            rolloverVoxPlaying = true;
            _loc6_ = SoundManagerOld.getSoundByID(_loc5_);
            _loc6_.soundInfo.onCompleteFunc = handleRolloverVoxComplete;
            _loc6_.soundInfo.channel = 1;
            SoundManagerOld.playSound(_loc5_);
            rolloverVoxTimes[_loc4_] = _loc2_;
         }
      }
      
      private function handleGreenPillowHitBig(param1:Event) : void
      {
         dispatchEvent(new Event(GREENPILLOW_HITBIG));
         greenPillow.removeEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleGreenPillowHitBig);
         bigThrash();
      }
      
      private function handleGreenPillowClicked(param1:MouseEvent) : void
      {
         if(greenPillow.onBed)
         {
            greenPillow.flyOffBed();
         }
         else
         {
            stopInteractive();
            greenPillow.addEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleGreenPillowHitBig);
            greenPillow.flyToBed();
            SoundManagerOld.playSound("bed_cushion");
         }
      }
      
      public function init(param1:BigInBed) : void
      {
         bigInBed = param1;
         bigInBed.addEventListener(BigInBed.FALLEN_ASLEEP,handleBigFallenAsleep);
         bigInBed.addEventListener(BigInBed.WOKEN_UP,handleBigWokenUp);
      }
      
      override public function setBlind(param1:Blind, param2:VPortLayerButton) : void
      {
         super.setBlind(param1,param2);
         blindButton.addEventListener(MouseEvent.MOUSE_OVER,handleRolloverVox);
      }
      
      private function handleHitAreaRollout(param1:MouseEvent) : void
      {
         mobileLayerButton.forceHighlight(false);
      }
      
      private function stopPreGameVox() : void
      {
         preGameVoxTimer.reset();
         preGameVoxTimer.stop();
      }
      
      private function handleThrowablePillowFlightProgress(param1:Event) : void
      {
         if(param1.target == greenPillow)
         {
            page.flagDirtyLayer(greenPillowButton.viewportLayer);
         }
         else if(param1.target == bluePillow)
         {
            page.flagDirtyLayer(bluePillowButton.viewportLayer);
         }
         else if(param1.target == teddy)
         {
            page.flagDirtyLayer(teddyButton.viewportLayer);
         }
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(bigInBed)
         {
            bigInBed.activate();
         }
         setPillowsVisible(true);
      }
      
      override public function startInteractive() : void
      {
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_OFF)
         {
            setLightsEnabled(true);
         }
         setPillowsEnabled(true);
         enableMobile();
      }
      
      public function setPillowsEnabled(param1:Boolean) : void
      {
         bluePillowButton.setEnabledState(param1);
         greenPillowButton.setEnabledState(param1);
         teddyButton.setEnabledState(param1);
      }
      
      public function startInteractiveMobileDrag() : void
      {
         mobileLayerButton.setEnabledState(true);
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_OFF)
         {
            setLightsEnabled(true);
         }
         setPillowsEnabled(true);
      }
      
      private function handleThrowableTeddyClicked(param1:MouseEvent) : void
      {
         if(teddy.onBed)
         {
            teddy.flyOffBed();
         }
         else
         {
            stopInteractive();
            teddy.addEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleThrowableTeddyHitBig);
            teddy.flyToBed();
            SoundManagerOld.playSound("bed_toy_smallthrow");
         }
      }
      
      public function setThrowableObjects(param1:ThrowableBedroomObject, param2:VPortLayerButton, param3:ThrowableBedroomObject, param4:VPortLayerButton, param5:ThrowableFreakyAssTeddy, param6:VPortLayerButton) : void
      {
         this.bluePillow = param1;
         this.bluePillowButton = param2;
         this.greenPillow = param3;
         this.greenPillowButton = param4;
         this.teddy = param5;
         this.teddyButton = param6;
         bluePillowButton.addEventListener(MouseEvent.CLICK,handleBluePillowClicked);
         bluePillow.addEventListener(ThrowableBedroomObject.FLIGHT_PROGRESS,handleThrowablePillowFlightProgress);
         greenPillowButton.addEventListener(MouseEvent.CLICK,handleGreenPillowClicked);
         greenPillow.addEventListener(ThrowableBedroomObject.FLIGHT_PROGRESS,handleThrowablePillowFlightProgress);
         teddyButton.addEventListener(MouseEvent.CLICK,handleThrowableTeddyClicked);
         param5.addEventListener(ThrowableFreakyAssTeddy.FLIGHT_PROGRESS,handleThrowablePillowFlightProgress);
         bluePillowButton.addEventListener(MouseEvent.MOUSE_OVER,handleRolloverVox);
         greenPillowButton.addEventListener(MouseEvent.MOUSE_OVER,handleRolloverVox);
         teddyButton.addEventListener(MouseEvent.MOUSE_OVER,handleRolloverVox);
      }
      
      private function unBindVoxChannel() : void
      {
         if(occupiedAnimChannel)
         {
            SoundManagerOld.unSelectChannel(1);
         }
         occupiedAnimChannel = false;
      }
      
      override public function reset() : void
      {
         super.reset();
         bigInBed.resetStimuli();
         rolloverVoxPlaying = false;
         bluePillow.reset();
         greenPillow.reset();
         teddy.reset();
         unBindVoxChannel();
      }
      
      public function bigThrash() : void
      {
         bigInBed.addStimulus();
         bigInBed.addEventListener(BigInBed.THRASH_COMPLETE,handleThrashComplete);
         smallCam.rotationXMax = bigThrashingrotX - bigThrashingrotXVariance;
         smallCam.rotationXMax = bigThrashingrotX + bigThrashingrotXVariance;
         smallCam.rotationYMin = bigThrashingRotY - bigThrashingRotYVariance;
         smallCam.rotationYMin = bigThrashingRotY + bigThrashingRotYVariance;
         TweenMax.to(smallCam,0.6,{"radius":bigThrashingDist});
         TweenMax.to(smallCam.target,0.6,{"y":bigThrashingY});
         if(!gameOn)
         {
            SoundManagerOld.stopSound("bed_small_bigsfastasleepthats");
            gameOn = true;
            stopPreGameVox();
         }
         else
         {
            SoundManagerOld.stopSoundChannel(1);
            stopInGameVox();
         }
         stopInteractive();
         bindVoxChannel();
      }
      
      private function bindVoxChannel() : void
      {
         if(!occupiedAnimChannel)
         {
            SoundManagerOld.selectChannel(1);
         }
         occupiedAnimChannel = true;
      }
      
      override protected function handleBlindClicked(param1:MouseEvent) : void
      {
         super.handleBlindClicked(param1);
         if(blindButton.isEnabled)
         {
            SoundManagerOld.playSound("bed_blinds_smallflap");
         }
      }
      
      private function handleThrowableTeddyHitBig(param1:Event) : void
      {
         dispatchEvent(new Event(TEDDY_HITBIG));
         teddy.removeEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleThrowableTeddyHitBig);
         bigThrash();
      }
      
      private function handleBigWokenUp(param1:Event) : void
      {
         SoundManagerOld.stopSoundChannel(1,1);
         dispatchEvent(new Event(WOKEN_UP));
         gameOn = false;
         bigInBed.resetStimuli();
         setPillowsEnabled(true);
         bluePillow.flyOffBed();
         greenPillow.flyOffBed();
         teddy.flyOffBed();
      }
      
      private function handleMobileStopDrag(param1:Event) : void
      {
         SoundManagerOld.stopSound("bed_mobile_smallstretchloop");
         SoundManagerOld.playSound("bed_mobile_smallrelease");
         SoundManagerOld.playSound("bed_mobile_jangling");
         unBindVoxChannel();
         startInteractiveMobileDrag();
         if(!doneMobileResponse)
         {
            doneMobileResponse = true;
            bigThrash();
         }
      }
      
      public function setPillowsVisible(param1:Boolean = true) : void
      {
         bluePillow.setVisible(param1);
         greenPillow.setVisible(param1);
         teddy.setVisible(param1);
      }
      
      private function initVoxTimers() : void
      {
         inGameVoxTimer = new Timer(12000,0);
         inGameVoxTimer.addEventListener(TimerEvent.TIMER,handleInGameVoxTimer);
         preGameVoxTimer = new Timer(12000,0);
         preGameVoxTimer.addEventListener(TimerEvent.TIMER,handlePreGameVoxTimer);
         rolloverVoxTimes = [0,0,0,0];
      }
      
      private function startPreGameVox() : void
      {
         isIntro = false;
         preGameVoxTimer.start();
      }
      
      override protected function lightChange() : void
      {
         super.lightChange();
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_OFF)
         {
            lightDarkManager.toggleLights();
            bigThrash();
            SoundManagerOld.playSound("bed_blinds_smallflapping");
         }
      }
      
      private function handleRolloverVoxComplete() : void
      {
         rolloverVoxPlaying = false;
         if(!gameOn)
         {
            startPreGameVox();
         }
      }
      
      private function handleBluePillowHitBig(param1:Event) : void
      {
         dispatchEvent(new Event(BLUEPILLOW_HITBIG));
         bluePillow.removeEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleBluePillowHitBig);
         bigThrash();
      }
      
      private function handleBigFallenAsleep(param1:Event) : void
      {
         dispatchEvent(new Event(FALLEN_ASLEEP));
         if(lightDarkManager.lightState == LightDarkManager.LIGHTSTATE_ON)
         {
            lightDarkManager.toggleLights();
         }
         super.reset();
         unBindVoxChannel();
         SoundManagerOld.playSound("bed_small_try_being_big");
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         rolloverVoxPlaying = false;
         stopInGameVox();
         stopPreGameVox();
         smallCam.rotationXMax = smallCamMaxX;
         smallCam.rotationYMax = smallCamMaxY;
         smallCam.rotationXMin = smallCamMinX;
         smallCam.rotationYMin = smallCamMinY;
         smallCam.radius = smallCamDist;
         smallCam.target.y = smallCamY;
         SoundManagerOld.stopSound("small_pregame_vox");
      }
      
      private function startInGameVox() : void
      {
         rolloverVoxPlaying = false;
         inGameVoxTimer.start();
      }
      
      private function handleHitAreaRollover(param1:MouseEvent) : void
      {
         mobileLayerButton.forceHighlight(true);
      }
      
      override public function stopInteractive() : void
      {
         super.stopInteractive();
         disableMobile();
         setPillowsEnabled(false);
      }
      
      private function handleBluePillowClicked(param1:MouseEvent) : void
      {
         if(bluePillow.onBed)
         {
            bluePillow.flyOffBed();
         }
         else
         {
            stopInteractive();
            bluePillow.addEventListener(ThrowableBedroomObject.FLIGHT_COMPLETE,handleBluePillowHitBig);
            bluePillow.flyToBed();
            SoundManagerOld.playSound("bed_cushion");
         }
      }
      
      public function setMobileHitArea(param1:Sprite) : void
      {
         mobileHitArea = param1;
         mobileHitArea.buttonMode = true;
         mobileHitArea.addEventListener(MouseEvent.CLICK,handleSmallMobileClick);
         mobileHitArea.addEventListener(MouseEvent.ROLL_OVER,handleHitAreaRollover);
         mobileHitArea.addEventListener(MouseEvent.ROLL_OUT,handleHitAreaRollout);
      }
      
      private function handleMobileDragProgress(param1:MobileDragEvent) : void
      {
         var _loc2_:Number = -(param1.intersectX / basicView.viewport.containerSprite.width) * 4;
         var _loc3_:Number = param1.stringLength / 400;
         if(_loc3_ > 2)
         {
            _loc3_ = 2;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ < -1)
         {
            _loc2_ = -1;
         }
         SoundManagerOld.updateTransform("bed_mobile_smallstretchloop",_loc3_,_loc2_);
      }
      
      public function stopInteractiveMobileDrag() : void
      {
         mobileLayerButton.setEnabledState(false);
         setLightsEnabled(false);
         setPillowsEnabled(false);
      }
      
      override public function setMobile(param1:MobileStruct3D, param2:VPortLayerButton) : void
      {
         super.setMobile(param1,param2);
         param1.addEventListener("StartDrag",handleMobileStartDrag);
         param1.addEventListener("StopDrag",handleMobileStopDrag);
         param1.addEventListener(MobileDragEvent.PROGRESS,handleMobileDragProgress);
         param2.addEventListener(MouseEvent.ROLL_OVER,handleRolloverVox);
         mobileLayerButton.addEventListener(MouseEvent.CLICK,handleSmallMobileClick);
      }
      
      override public function disableMobile() : void
      {
         super.disableMobile();
         mobileLayerButton.removeEventListener(MouseEvent.CLICK,handleSmallMobileClick);
         mobile.disableDrag();
         mobileHitArea.buttonMode = false;
         mobileHitArea.mouseEnabled = false;
      }
      
      private function handlePreGameVoxTimer(param1:TimerEvent) : void
      {
         SoundManagerOld.playSound("small_pregame_vox");
      }
      
      private function handleInGameVoxTimer(param1:TimerEvent) : void
      {
      }
      
      private function stopInGameVox() : void
      {
         inGameVoxTimer.reset();
         inGameVoxTimer.stop();
      }
      
      private function handleSmallMobileClick(param1:MouseEvent) : void
      {
         mobile.pickUpRandomDecal();
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:Number = NaN;
         if(mobileHitArea)
         {
            mobileHitArea.x = mobile.screen.x + (basicView.viewport.viewportWidth >> 1);
            mobileHitArea.y = mobile.screen.y + (basicView.viewport.viewportHeight >> 1);
            _loc2_ = Point.distance(new Point(mobileHitArea.x,mobileHitArea.y),new Point(param1.stageMouseX,param1.stageMouseY));
            if(_loc2_ < 200)
            {
               mobileHitArea.visible = true;
            }
            else
            {
               mobileHitArea.visible = false;
            }
         }
      }
      
      public function setSmallCam(param1:OrbitCamera3D) : void
      {
         this.smallCam = param1;
         smallCamMaxX = param1.rotationXMax;
         smallCamMinX = param1.rotationXMin;
         smallCamMaxY = param1.rotationYMax;
         smallCamMinY = param1.rotationYMin;
         smallCamY = param1.target.y;
         smallCamDist = param1.radius;
      }
      
      private function handleThrashComplete(param1:Event) : void
      {
         unBindVoxChannel();
         bigInBed.removeEventListener(BigInBed.THRASH_COMPLETE,handleThrashComplete);
         if(gameOn)
         {
            startInGameVox();
         }
         else
         {
            startPreGameVox();
            reset();
         }
         smallCam.rotationXMax = smallCamMaxX;
         smallCam.rotationYMax = smallCamMaxY;
         smallCam.rotationXMin = smallCamMinX;
         smallCam.rotationYMin = smallCamMinY;
         TweenMax.to(smallCam,0.6,{"radius":smallCamDist});
         TweenMax.to(smallCam.target,0.6,{"y":smallCamY});
         startInteractive();
         if(bluePillow.onBed)
         {
            bluePillowButton.setEnabledState(false);
         }
         if(greenPillow.onBed)
         {
            greenPillowButton.setEnabledState(false);
         }
         if(teddy.onBed)
         {
            teddyButton.setEnabledState(false);
         }
         rolloverVoxPlaying = false;
      }
      
      override public function park() : void
      {
         super.park();
         deactivate();
         reset();
         if(bigInBed)
         {
            bigInBed.deactivate();
         }
         setPillowsVisible(false);
      }
      
      private function handleMobileStartDrag(param1:Event) : void
      {
         if(!mobile.isDragging)
         {
            SoundManagerOld.playSoundSimple("bed_mobile_smallstretchloop",0,0,int.MAX_VALUE);
         }
         bindVoxChannel();
         stopInteractiveMobileDrag();
      }
      
      override public function activate() : void
      {
         super.activate();
         var _loc1_:IBrainSounderOld = SoundManagerOld.getSoundByID("bed_small_bigsfastasleepthats");
         _loc1_.soundInfo.onCompleteFunc = startPreGameVox;
         SoundManagerOld.playSound("bed_small_bigsfastasleepthats");
         isIntro = true;
         rolloverVoxPlaying = false;
      }
   }
}

