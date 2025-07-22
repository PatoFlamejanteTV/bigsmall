package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.pages.bathroom.BathroomGameProgress;
   import net.pluginmedia.bigandsmall.pages.bathroom.BigGameArmTBTackle;
   import net.pluginmedia.bigandsmall.pages.bathroom.BigGameSmallSpriteTBTackle;
   import net.pluginmedia.bigandsmall.pages.bathroom.Mirror;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BathroomGameManagerBigPOV extends BathroomGameManager
   {
      
      private static var STATE_IDLE:int = 0;
      
      private static var STATE_GAMEPLAY:int = 1;
      
      private static var STATE_BEGINANIM:int = 2;
      
      private static var STATE_COMPLETEANIM:int = 3;
      
      private static var STATE_INTROANIM:int = 4;
      
      private static var STATE_PRECOMPLETEANIM:int = 5;
      
      private var states:Dictionary = new Dictionary();
      
      private var smallSpriteLayer:ViewportLayer;
      
      private var bigTimeoutVoxTimer:Timer = new Timer(10000);
      
      private var bigRewardVox:Array = [];
      
      private var gameOverTriggered:Boolean = false;
      
      private var smallScaleOffs:Number = 0;
      
      private var accessMode:Boolean = false;
      
      private var bigMissedVox:Array = [];
      
      private var _doGameOver:Boolean = false;
      
      private var brushTimer:Timer = new Timer(3000);
      
      private var occupiedAnimChannel:Boolean = false;
      
      private var bigArm:BigGameArmTBTackle;
      
      private var brushScoreInc:Number = 0.0065;
      
      private var camOrbitCentreVel:Number3D = new Number3D();
      
      private var bigsTadaFinished:Boolean = false;
      
      private var flipFlopEntryVox:int = -1;
      
      private var bigGameCam:OrbitCamera3D;
      
      private var smallReflMat:Matrix = new Matrix();
      
      private var filterDestPoint:Point = new Point();
      
      private var pageWidth:Number;
      
      private var smallReflXOffs:Number = 166;
      
      private var smallGamePlaySprite:BigGameSmallSpriteTBTackle;
      
      private var pageHeight:Number;
      
      private var currentState:TBGameBigPOVState = null;
      
      private var customReflScalefact:Number = 2;
      
      private var holdBrushActive:Boolean = false;
      
      private var completionTurnEventReceived:Boolean = false;
      
      private var mousePosLast:Point = new Point(0,0);
      
      private var camOrbitCentreTarget:Number3D = new Number3D();
      
      private var intersect2D:Point = new Point();
      
      private var brushLoopRef:String;
      
      private var mirror:Mirror;
      
      private var responseOnSmVoxFin:String;
      
      private var smallReflBMPData:BitmapData;
      
      private var bigTimeoutVox:Array = [];
      
      private var mouseDown:Boolean = false;
      
      private var smallReflYOffs:Number = 252;
      
      private var smallPos3D:Number3D = new Number3D();
      
      public function BathroomGameManagerBigPOV(param1:BigAndSmallPage3D, param2:Sprite, param3:BasicView, param4:BathroomGameProgress, param5:OrbitCamera3D, param6:Number, param7:Number, param8:ToothpasteManager, param9:String)
      {
         super(param1,param2,param3,param4,param8);
         brushLoopRef = param9;
         pageWidth = param6;
         pageHeight = param7;
         bigGameCam = param5;
         registerState(STATE_IDLE,selectIdleState,unselectIdleState);
         registerState(STATE_INTROANIM,selectIntroAnimState,unselectIntroAnimState,updateIntroAnimState);
         registerState(STATE_BEGINANIM,selectBeginPhaseState,unselectBeginPhaseState);
         registerState(STATE_COMPLETEANIM,selectCompletionPhaseState,unselectCompletionPhaseState,updateCompletionPhaseState);
         registerState(STATE_PRECOMPLETEANIM,selectPreCompletionPhaseState,null,updatePreCompletionPhaseState);
         registerState(STATE_GAMEPLAY,selectGamePlayState,unselectGamePlayState,updateGamePlayState,mouseDownGamePlayState,mouseUpGamePlayState);
         bigTimeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleBigTimeoutVoxTimer);
         brushTimer.addEventListener(TimerEvent.TIMER,handleBrushTimer);
         resetSmallReflBMPData();
      }
      
      private function handlePositiveInput(param1:Event) : void
      {
         bigTimeoutVoxTimer.reset();
         bigTimeoutVoxTimer.start();
      }
      
      private function updatePreCompletionPhaseState(param1:UpdateInfo) : void
      {
         if(mirror)
         {
            updateSmallRefl();
         }
      }
      
      private function selectState(param1:int) : void
      {
         BrainLogger.out("selectState",param1);
         if(currentState)
         {
            currentState.deselect();
         }
         var _loc2_:TBGameBigPOVState = states[param1] as TBGameBigPOVState;
         if(!_loc2_)
         {
            trace("selectState error :: could not source state object");
            return;
         }
         currentState = _loc2_;
         currentState.select();
      }
      
      private function updateSmallRefl() : void
      {
         var _loc1_:Rectangle = null;
         smallReflBMPData.lock();
         smallReflBMPData.fillRect(smallReflBMPData.rect,0);
         if(smallGamePlaySprite.isBackDepth)
         {
            smallReflBMPData.draw(smallGamePlaySprite.container,smallReflMat);
            _loc1_ = smallReflBMPData.getColorBoundsRect(4278190080,0,false);
            filterDestPoint.x = _loc1_.x;
            filterDestPoint.y = _loc1_.y;
            smallReflBMPData.colorTransform(_loc1_,mirror.lighterTransform);
            smallReflBMPData.applyFilter(smallReflBMPData,_loc1_,filterDestPoint,mirror.blurFilter);
         }
         smallReflBMPData.unlock();
      }
      
      private function updateIntroAnimState(param1:UpdateInfo = null) : void
      {
      }
      
      private function selectIntroAnimState() : void
      {
         smallGamePlaySprite.addEventListener("INTRO_COMPLETE",handleSmallIntroComplete);
         smallGamePlaySprite.doIntro();
      }
      
      private function unselectGamePlayState() : void
      {
         deactivateBrushArm();
         smallGamePlaySprite.endGame();
         stopTimer(bigTimeoutVoxTimer);
      }
      
      private function updateSmallPosition() : void
      {
         var _loc1_:MovieClip = smallGamePlaySprite.brushTarget;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Number = 0.6;
         smallPos3D.x = smallGamePlaySprite.x + -_loc1_.x * _loc2_;
         smallPos3D.y = smallGamePlaySprite.y + -_loc1_.y * _loc2_;
         smallPos3D.z = smallGamePlaySprite.z;
         smallPos3D.rotateY(-10);
         _loc2_ = 0.3;
         camOrbitCentreTarget.x = smallGamePlaySprite.x + -_loc1_.x * _loc2_;
         camOrbitCentreTarget.y = smallGamePlaySprite.y + -_loc1_.y * _loc2_;
         camOrbitCentreTarget.z = smallGamePlaySprite.z;
         camOrbitCentreTarget.rotateY(-10);
         camOrbitCentreTarget.plusEq(parentPage3D.position);
      }
      
      private function unselectIntroAnimState() : void
      {
         smallGamePlaySprite.removeEventListener("INTRO_COMPLETE",handleSmallIntroComplete);
      }
      
      private function unBindVoxChannel() : void
      {
         if(occupiedAnimChannel)
         {
            SoundManagerOld.unSelectChannel(1);
            occupiedAnimChannel = false;
         }
      }
      
      private function updateCompletionPhaseState(param1:UpdateInfo = null) : void
      {
         if(mirror)
         {
            updateSmallRefl();
         }
      }
      
      public function setBigArm(param1:BigGameArmTBTackle) : Boolean
      {
         if(!BigGameArmTBTackle)
         {
            return false;
         }
         bigArm = param1;
         return true;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         smallGamePlaySprite.prepare();
      }
      
      protected function doGameOverProper(param1:Event) : void
      {
         smallGamePlaySprite.removeEventListener("TURN_EVENT",doGameOverProper);
         completionTurnEventReceived = true;
         if(bigsTadaFinished)
         {
            selectState(STATE_COMPLETEANIM);
         }
         else
         {
            selectState(STATE_PRECOMPLETEANIM);
         }
      }
      
      private function resetSmallReflBMPData() : void
      {
         smallReflBMPData = new BitmapData(pageWidth / customReflScalefact,pageHeight / customReflScalefact,true,0);
         smallReflMat.identity();
         smallReflMat.scale(-1 / customReflScalefact,1 / customReflScalefact);
         smallReflMat.translate(smallReflXOffs / customReflScalefact,smallReflYOffs / customReflScalefact);
      }
      
      private function mouseDownGamePlayState() : void
      {
         if(smallGamePlaySprite.hasContact)
         {
            holdBrush();
         }
      }
      
      private function handleMissedJibe(param1:Event) : void
      {
         responseOnSmVoxFin = "MISS";
         bigTimeoutVoxTimer.reset();
         bigTimeoutVoxTimer.start();
      }
      
      private function handleSmallIntroComplete(param1:Event) : void
      {
         selectState(STATE_BEGINANIM);
      }
      
      private function bindVoxChannel() : void
      {
         if(!occupiedAnimChannel)
         {
            SoundManagerOld.selectChannel(1);
            occupiedAnimChannel = true;
         }
      }
      
      private function handleVoxBegin(param1:Event) : void
      {
         bindVoxChannel();
      }
      
      private function handleNegativeInput(param1:Event) : void
      {
      }
      
      protected function deactivateBrushArm() : void
      {
         if(managerPageContainer2D.contains(bigArm))
         {
            managerPageContainer2D.removeChild(bigArm);
         }
         bigArm.deactivate();
         bigArm.park();
      }
      
      private function handleSpriteBrushedLite(param1:Event) : void
      {
         incrementScore(brushScoreInc / 2);
      }
      
      private function selectGamePlayState() : void
      {
         activateBrushArm();
         smallGamePlaySprite.beginGame();
         bigTimeoutVoxTimer.start();
      }
      
      private function unselectCompletionPhaseState() : void
      {
         smallGamePlaySprite.removeEventListener("EXIT_COMPLETE",handleSmallOutroComplete);
         unBindVoxChannel();
      }
      
      private function updateGameCamera() : void
      {
         var _loc1_:Number = basicView.viewport.containerSprite.mouseX / (pageWidth / 2);
         var _loc2_:Number = basicView.viewport.containerSprite.mouseY / (pageHeight / 2);
         var _loc3_:DisplayObject3D = bigGameCam.orbitCentre;
         var _loc4_:Number = camOrbitCentreTarget.x - _loc3_.x;
         var _loc5_:Number = camOrbitCentreTarget.y - _loc3_.y;
         var _loc6_:Number = camOrbitCentreTarget.z - _loc3_.z;
         camOrbitCentreVel.x += _loc4_ * 0.05;
         camOrbitCentreVel.y += _loc5_ * 0.05;
         camOrbitCentreVel.z += _loc6_ * 0.05;
         _loc3_.x += camOrbitCentreVel.x;
         _loc3_.y += camOrbitCentreVel.y;
         _loc3_.z += camOrbitCentreVel.z;
         camOrbitCentreVel.multiplyEq(0.75);
      }
      
      private function stopTimer(param1:Timer) : void
      {
         param1.reset();
         param1.stop();
      }
      
      private function handleTadaComplete() : void
      {
         bigsTadaFinished = true;
         if(completionTurnEventReceived)
         {
            selectState(STATE_COMPLETEANIM);
         }
      }
      
      private function handleBigTimeoutVoxTimer(param1:TimerEvent) : void
      {
         var _loc2_:String = bigTimeoutVox.shift();
         SoundManagerOld.playSound(_loc2_);
         bigTimeoutVox.push(_loc2_);
      }
      
      private function handleBrushTimer(param1:TimerEvent) : void
      {
         ceaseBrush();
      }
      
      override public function deactivate() : void
      {
         var _loc1_:BrainSoundOld = null;
         super.deactivate();
         setScore(0,true);
         basicView.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageDown);
         basicView.stage.removeEventListener(MouseEvent.MOUSE_UP,handleStageUp);
         if(gameOverTriggered && !completionTurnEventReceived)
         {
            smallGamePlaySprite.removeEventListener("TURN_EVENT",doGameOverProper);
            _loc1_ = SoundManagerOld.getSoundByID("bath_big_tadaididit") as BrainSoundOld;
            _loc1_.soundInfo.onCompleteFunc = null;
         }
         smallGamePlaySprite.deactivate();
         SoundManagerOld.stopSoundChannel(1);
         if(occupiedAnimChannel)
         {
            unBindVoxChannel();
         }
         SoundManagerOld.stopSound(brushLoopRef);
         selectState(STATE_IDLE);
         if(mirror)
         {
            mirror.releaseCustomReflection();
            resetSmallReflBMPData();
         }
         gameOverTriggered = false;
         bigsTadaFinished = false;
         completionTurnEventReceived = false;
         responseOnSmVoxFin = null;
         unBindVoxChannel();
      }
      
      private function selectPreCompletionPhaseState() : void
      {
         smallGamePlaySprite.doPreOutro();
      }
      
      private function handleStageDown(param1:MouseEvent) : void
      {
         mouseDown = true;
         if(currentState)
         {
            currentState.stageMouseDown();
         }
      }
      
      private function selectIdleState() : void
      {
      }
      
      private function handleBrushEnd(param1:Event) : void
      {
         SoundManagerOld.stopSound(brushLoopRef);
      }
      
      private function callbackIntroVoxComplete() : void
      {
         SoundManagerOld.playSound("bath_big_haveagoattoothbrush");
         selectState(STATE_GAMEPLAY);
      }
      
      public function setBigRewardVox(param1:Array) : void
      {
         bigRewardVox = param1;
      }
      
      public function setBigTimeoutVox(param1:Array) : void
      {
         bigTimeoutVox = param1;
      }
      
      public function setBigMissedVox(param1:Array) : void
      {
         bigMissedVox = param1;
      }
      
      private function updateGamePlayState(param1:UpdateInfo = null) : void
      {
         if(!accessMode && (!smallGamePlaySprite.hasContact && holdBrushActive))
         {
            ceaseBrush();
         }
         if(accessMode && (param1.stageMouseX != mousePosLast.x || param1.stageMouseY != mousePosLast.y))
         {
            accessMode = false;
         }
         if(mirror)
         {
            updateSmallRefl();
         }
         if(gameOverTriggered)
         {
            return;
         }
         if(!holdBrushActive)
         {
            if(mouseDown && !bigArm.isBrushing)
            {
               bigArm.startBrush();
            }
            if(!mouseDown && bigArm.isBrushing)
            {
               bigArm.stopBrush();
            }
         }
         mousePosLast.x = param1.stageMouseX;
         mousePosLast.y = param1.stageMouseY;
         if(!accessMode)
         {
            bigArm.update(param1);
         }
      }
      
      private function handleSpriteBrushedHeavy(param1:Event) : void
      {
         incrementScore(brushScoreInc);
      }
      
      private function mouseUpGamePlayState() : void
      {
      }
      
      private function registerState(param1:int, param2:Function = null, param3:Function = null, param4:Function = null, param5:Function = null, param6:Function = null) : void
      {
         states[param1] = new TBGameBigPOVState(param1,param2,param3,param4,param5,param6);
      }
      
      private function holdBrush() : void
      {
         holdBrushActive = true;
         bigArm.startBrush();
         brushTimer.reset();
         brushTimer.start();
      }
      
      public function setMirror(param1:Mirror) : void
      {
         this.mirror = param1;
      }
      
      private function selectBeginPhaseState() : void
      {
         smallGamePlaySprite.initGame();
         if((flipFlopEntryVox + 1) % 2 == 0)
         {
            smallGamePlaySprite.doVox("VoxCtrl_Small_UhOhFoundToothpaste",callbackIntroVoxComplete);
            flipFlopEntryVox = 0;
         }
         else
         {
            smallGamePlaySprite.doVox("VoxCtrl_Small_AreYouReallyGoing",callbackIntroVoxComplete);
         }
      }
      
      private function handleVoxEnd(param1:Event) : void
      {
         var _loc2_:String = null;
         unBindVoxChannel();
         if(responseOnSmVoxFin == "HIT")
         {
            _loc2_ = bigRewardVox.shift();
            SoundManagerOld.playSound(_loc2_);
            bigRewardVox.push(_loc2_);
         }
         else if(responseOnSmVoxFin == "MISS")
         {
            _loc2_ = bigMissedVox.shift();
            SoundManagerOld.playSound(_loc2_);
            bigMissedVox.push(_loc2_);
         }
      }
      
      private function unselectIdleState() : void
      {
         this.currentState = null;
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:Number3D = null;
         var _loc3_:Number3D = null;
         super.update(param1);
         updateSmallPosition();
         updateGameCamera();
         smallGamePlaySprite.update(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY,bigArm.isBrushing,accessMode);
         if(currentState == states[STATE_GAMEPLAY])
         {
            if(bigArm.isBrushing)
            {
               if(!accessMode)
               {
                  _loc2_ = getBrushCoords(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY,smallGamePlaySprite.getVirtualPlane());
               }
               else
               {
                  _loc2_ = getBrushCoords(bigArm.armClipAnim.x - pageWidth / 2,bigArm.armClipAnim.y - pageHeight / 2,smallGamePlaySprite.getVirtualPlane());
               }
               if(!accessMode)
               {
                  _loc3_ = new Number3D(-bigArm.velocity.x / 3 + SuperMath.random(-3,3),bigArm.velocity.y / 3 + SuperMath.random(-3,3),SuperMath.random(-8,8));
               }
               else
               {
                  _loc3_ = new Number3D(SuperMath.random(-8,8),SuperMath.random(-8,8),SuperMath.random(-8,8));
               }
               toothpasteManager.fireToothPaste(_loc2_.x,_loc2_.y,_loc2_.z,3,_loc3_,2);
            }
            else if(Math.random() < 0.1)
            {
               _loc2_ = getBrushCoords(bigArm.armClipAnim.x - pageWidth / 2,bigArm.armClipAnim.y - pageHeight / 2,smallGamePlaySprite.getVirtualPlane());
               toothpasteManager.fireToothPaste(_loc2_.x,_loc2_.y,_loc2_.z,1,null,2);
            }
         }
         if(currentState)
         {
            currentState.update(param1);
         }
      }
      
      private function unselectBeginPhaseState() : void
      {
      }
      
      override protected function handleAccessClipClick(param1:MouseEvent) : void
      {
         if(gameOverTriggered)
         {
            return;
         }
         accessMode = true;
         var _loc2_:Number2D = smallGamePlaySprite.getMouthPosition();
         smallGamePlaySprite.calculateScreenCoords(basicView.camera);
         var _loc3_:Number3D = smallGamePlaySprite.screen;
         bigArm.updateArmPos(_loc3_.x + pageWidth / 2 + _loc2_.x,_loc3_.y + pageHeight / 2 + _loc2_.y);
         holdBrush();
      }
      
      private function getBrushCoords(param1:Number, param2:Number, param3:Plane3D) : Number3D
      {
         var _loc4_:Number3D = null;
         _loc4_ = basicView.camera.unproject(param1,param2);
         _loc4_ = Number3D.add(_loc4_,basicView.camera.position);
         var _loc5_:Number3D = param3.getIntersectionLineNumbers(basicView.camera.position,_loc4_);
         _loc5_.minusEq(this.parentPage3D.position);
         return _loc5_;
      }
      
      protected function activateBrushArm() : void
      {
         bigArm.updateArmPos(basicView.stage.mouseX,basicView.stage.mouseY);
         managerPageContainer2D.addChild(bigArm);
         bigArm.prepare();
         bigArm.activate();
      }
      
      override public function setAccessClip(param1:Sprite) : void
      {
         super.setAccessClip(param1);
      }
      
      private function handleBrushBegin(param1:Event) : void
      {
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.playSound(brushLoopRef,new SoundInfoOld(1,0,int.MAX_VALUE));
         responseOnSmVoxFin = "HIT";
      }
      
      private function handleMissed(param1:Event) : void
      {
      }
      
      private function handleSmallOutroComplete(param1:Event) : void
      {
         dispatchEvent(new Event(GAME_COMPLETE));
      }
      
      override protected function gameOver() : void
      {
         gameOverTriggered = true;
         ceaseBrush();
         deactivateBrushArm();
         var _loc1_:BrainSoundOld = SoundManagerOld.getSoundByID("bath_big_tadaididit") as BrainSoundOld;
         _loc1_.soundInfo.onCompleteFunc = handleTadaComplete;
         SoundManagerOld.playSound("bath_big_tadaididit");
         smallGamePlaySprite.addEventListener("TURN_EVENT",doGameOverProper);
         smallGamePlaySprite.setVoxable(false);
      }
      
      private function ceaseBrush() : void
      {
         holdBrushActive = false;
         stopTimer(brushTimer);
         bigArm.stopBrush();
      }
      
      override public function park() : void
      {
         super.park();
         smallGamePlaySprite.park();
      }
      
      private function handleStageUp(param1:MouseEvent) : void
      {
         mouseDown = false;
         if(currentState)
         {
            currentState.stageMouseUp();
         }
      }
      
      override public function activate() : void
      {
         super.activate();
         basicView.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageDown);
         basicView.stage.addEventListener(MouseEvent.MOUSE_UP,handleStageUp);
         smallGamePlaySprite.activate();
         selectState(STATE_INTROANIM);
         dispatchEvent(new Event("RENDERSTATE_ON"));
         if(mirror)
         {
            mirror.bindCustomReflection(smallReflBMPData,customReflScalefact);
         }
      }
      
      private function selectCompletionPhaseState() : void
      {
         dispatchEvent(new Event("RENDERSTATE_OFF"));
         smallGamePlaySprite.addEventListener("EXIT_COMPLETE",handleSmallOutroComplete);
         smallGamePlaySprite.doOutro();
         bindVoxChannel();
      }
      
      public function setSmallGameSprite(param1:BigGameSmallSpriteTBTackle, param2:ViewportLayer) : Boolean
      {
         smallSpriteLayer = param2;
         smallGamePlaySprite = param1;
         if(!smallGamePlaySprite)
         {
            return false;
         }
         smallGamePlaySprite.addEventListener("EV_BRUSH_LITE",handleSpriteBrushedLite);
         smallGamePlaySprite.addEventListener("EV_BRUSH_HEAVY",handleSpriteBrushedHeavy);
         smallGamePlaySprite.addEventListener("POSITIVE_INPUT",handlePositiveInput);
         smallGamePlaySprite.addEventListener("NEGATIVE_INPUT",handleNegativeInput);
         smallGamePlaySprite.addEventListener("MISSED",handleMissed);
         smallGamePlaySprite.addEventListener("MISSED_JIBE",handleMissedJibe);
         smallGamePlaySprite.addEventListener("BRUSHING_BEGIN",handleBrushBegin);
         smallGamePlaySprite.addEventListener("BRUSHING_END",handleBrushEnd);
         smallGamePlaySprite.addEventListener("VOX_BEGIN",handleVoxBegin);
         smallGamePlaySprite.addEventListener("VOX_END",handleVoxEnd);
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_BIGPOV_SMALL,smallGamePlaySprite);
         return true;
      }
   }
}

