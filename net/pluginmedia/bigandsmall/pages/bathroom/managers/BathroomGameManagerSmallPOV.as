package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import gs.TweenMax;
   import gs.easing.Expo;
   import gs.easing.Quad;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.pages.bathroom.BathroomGameProgress;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.geom.BezierSegment3D;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   
   public class BathroomGameManagerSmallPOV extends BathroomGameManager
   {
      
      private var bigHighLowRight:MovieClip;
      
      private var currentSwitch:AnimationOld;
      
      private var bigHighLowLeftAnim:AnimationOld;
      
      private var currentMouthPosition:Point = new Point();
      
      private var smallDoneClip:MovieClip;
      
      private var crosshair:MovieClip;
      
      private var bigSpritePosition:Number3D;
      
      private var bigBrushed:MovieClip;
      
      private const FAILED:uint = 5;
      
      private var bigExit:MovieClip;
      
      private var bigMat:SpriteParticleMaterial;
      
      private var prevAimingTarget:Number3D;
      
      private var smallBrushingSprite:PointSprite;
      
      private const EXITED:uint = 9;
      
      private var smallAimingSprite:PointSprite;
      
      private var crosshair1:MovieClip;
      
      private var closestFlightProximity:Number;
      
      private var bigHighLowLeft:MovieClip;
      
      private var timeoutTimer:Timer;
      
      private const BRUSHING:uint = 3;
      
      private var smallSuccessClip:MovieClip;
      
      private const CHANGING:uint = 2;
      
      private var failFlightPath:BezierSegment3D;
      
      private const FINISHED:uint = 7;
      
      private const AIMING:uint = 0;
      
      private var smallBrushingClip:MovieClip;
      
      private var bigLowBrushed:MovieClip;
      
      private var bigLowJive:MovieClip;
      
      private const FLYING:uint = 2;
      
      private const RETURNING:uint = 6;
      
      private var smallAimingAnim:AnimationOld;
      
      private var currentFlightProgress:uint = 0;
      
      private var smallFailAnim:AnimationOld;
      
      public var toBigFlightLength:uint = 12;
      
      private var bigJiveToExitFrames:Array = [7,26,87,118];
      
      private var room:BigAndSmallPage3D;
      
      private var smallDoneAnim:AnimationOld;
      
      private var smallSuccessSprite:PointSprite;
      
      private var smallFlyingSprite:PointSprite;
      
      private var smallFlyingClip:MovieClip;
      
      private var toothPastePosition:Number3D;
      
      private var brushLoop:String;
      
      private var successFlightPath:BezierSegment3D;
      
      public var successFlightLength:uint = 12;
      
      private var toBigFlightPath:BezierSegment3D;
      
      private const PREPPING:uint = 1;
      
      private var mouseUnprojected:Number3D = new Number3D();
      
      private var smallSuccessAnim:AnimationOld;
      
      private const BRUSHED:uint = 1;
      
      private var bigHighLowRightAnim:AnimationOld;
      
      private var smallBrushingAnim:AnimationOld;
      
      private var currentJive:MovieClip;
      
      private var bigJive:MovieClip;
      
      private var smallDoneSprite:PointSprite;
      
      public var flightSuccesProximity:Number = 110;
      
      private var aimingTargetModifier:Number = 0;
      
      private const JIVING:uint = 0;
      
      private var bigExitAnim:AnimationOld;
      
      private var bigState:uint = 0;
      
      private var currentSmallSprite:PointSprite;
      
      private var currentBrushPosition:Point = new Point();
      
      private var bigJiveChangeReady:Boolean = true;
      
      private var smallFlyingAnim:AnimationOld;
      
      public var failFlightLength:uint = 12;
      
      private var smallFailClip:MovieClip;
      
      private var smallState:uint;
      
      private var smallAimingMoving:Boolean = false;
      
      private var smallAimingClip:MovieClip;
      
      private var mouseUnprojectPlane:Plane3D = new Plane3D();
      
      private const SUCCESS:uint = 4;
      
      private const EXITING:uint = 8;
      
      private var bigSprite:PointSprite;
      
      private var smallFailSprite:PointSprite;
      
      public var lipSyncManager:BathroomGameSmallVoxManager;
      
      public function BathroomGameManagerSmallPOV(param1:BigAndSmallPage3D, param2:Sprite, param3:BasicView, param4:BathroomGameProgress, param5:ToothpasteManager, param6:String)
      {
         super(param1,param2,param3,param4,param5);
         brushLoop = param6;
         lipSyncManager = new BathroomGameSmallVoxManager();
         timeoutTimer = new Timer(17000);
      }
      
      private function handleSmallDoneSpeech(param1:AnimationOldEvent) : void
      {
         bigExitAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBigExitTalkDone);
         smallDoneAnim.playOutLabel("leave");
         setSmallState(EXITING);
      }
      
      private function getSmallFlyingToothpastePos() : Point
      {
         var _loc1_:Number = smallFlyingClip.container.toothpaste.x * smallFlyingSprite.size * smallFlyingSprite.renderScale * smallFlyingClip.container.scaleX;
         var _loc2_:Number = smallFlyingClip.container.toothpaste.y * smallFlyingSprite.size * smallFlyingSprite.renderScale * smallFlyingClip.container.scaleY;
         return new Point(_loc1_,_loc2_);
      }
      
      public function setBigBrushed(param1:MovieClip) : void
      {
         bigBrushed = param1;
         param1.stop();
      }
      
      public function setRoom(param1:BigAndSmallPage3D) : void
      {
         this.room = param1;
      }
      
      private function handleBigExitComplete(param1:AnimationOldEvent) : void
      {
         bigExitAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleBigExitComplete);
         dispatchEvent(new Event(GAME_COMPLETE));
      }
      
      public function setSmallLipSyncClips(param1:Dictionary) : void
      {
         lipSyncManager.setSmallLipSyncClips(param1);
      }
      
      private function handleBigSwitchComplete(param1:AnimationOldEvent) : void
      {
         bigMat.movie = currentJive;
         currentJive.play();
         bigState = JIVING;
      }
      
      private function updateMouseUnproject() : void
      {
         var _loc1_:Number = basicView.viewport.containerSprite.mouseX;
         var _loc2_:Number = basicView.viewport.containerSprite.mouseY;
         var _loc3_:Number3D = new Number3D(basicView.camera.x - room.x,basicView.camera.y - room.y,basicView.camera.z - room.z);
         var _loc4_:Number3D = basicView.camera.unproject(_loc1_,_loc2_);
         _loc4_.plusEq(_loc3_);
         mouseUnprojectPlane.setNormalAndPoint(new Number3D(0,0,-1),new Number3D(0,0,100));
         mouseUnprojected = mouseUnprojectPlane.getIntersectionLineNumbers(_loc3_,_loc4_);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         basicView.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handlePageClicked);
         basicView.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
         if(managerPageContainer2D.contains(crosshair1))
         {
            managerPageContainer2D.removeChild(crosshair1);
         }
         lipSyncManager.stopLipSync();
         SoundManagerOld.stopSound("BACKING",2);
         SoundManagerOld.stopSound(brushLoop);
         if(bigState == CHANGING)
         {
            currentSwitch.stop();
         }
         if(!_gameOver)
         {
            if(bigSprite)
            {
               TweenMax.to(bigSprite,0.8,{
                  "x":800,
                  "ease":Quad.easeInOut
               });
            }
            if(currentSmallSprite)
            {
               TweenMax.to(currentSmallSprite,0.8,{
                  "x":-700,
                  "ease":Quad.easeInOut
               });
            }
         }
         setScore(0,true);
         if(_gameOver)
         {
            bigExitAnim.gotoAndStop(1);
            bigMat.movie = currentJive;
            bigSprite.visible = false;
            bigMat.removeSprite();
         }
         timeoutTimer.reset();
         timeoutTimer.stop();
      }
      
      public function setSmallSuccess(param1:MovieClip, param2:PointSprite) : void
      {
         smallSuccessClip = param1;
         smallSuccessSprite = param2;
         smallSuccessAnim = new AnimationOld(smallSuccessClip.container,false);
         successFlightLength = smallSuccessAnim.getLengthOfLabel("fall");
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLSUCCESS,smallSuccessSprite);
         smallSuccessSprite.visible = false;
      }
      
      public function setSmallFail(param1:MovieClip, param2:PointSprite) : void
      {
         smallFailClip = param1;
         smallFailSprite = param2;
         smallFailAnim = new AnimationOld(smallFailClip["container"],false);
         failFlightLength = smallFailAnim.getLengthOfLabel("fall");
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLFAIL,smallFailSprite);
         smallFailSprite.visible = false;
      }
      
      public function setBigLowJive(param1:MovieClip) : void
      {
         bigLowJive = param1;
         bigLowJive.stop();
      }
      
      public function setBigJive(param1:MovieClip, param2:PointSprite) : void
      {
         bigJive = param1;
         bigSprite = param2;
         bigMat = param2.material as SpriteParticleMaterial;
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_BIG,bigSprite);
         bigSpritePosition = bigSprite.position;
         bigJive.stop();
         lipSyncManager.setBigTalker(bigJive);
         currentJive = bigJive;
      }
      
      private function createToBigFlightPath() : void
      {
         var _loc1_:Number3D = new Number3D(smallAimingSprite.x,smallAimingSprite.y,smallAimingSprite.z);
         var _loc2_:Number3D = new Number3D(mouseUnprojected.x,Math.max(mouseUnprojected.y,smallAimingSprite.y + 100),bigSprite.z + 10);
         var _loc3_:Number = (_loc2_.x - _loc1_.x) / 2.3;
         var _loc4_:Number = (_loc2_.y - _loc1_.y) / 2.3;
         var _loc5_:Number3D = new Number3D(_loc1_.x + _loc3_,_loc1_.y + _loc4_,_loc1_.z);
         var _loc6_:Number3D = new Number3D(_loc2_.x - _loc3_,_loc2_.y - _loc4_,_loc2_.z);
         toBigFlightPath = new BezierSegment3D(_loc1_,_loc5_,_loc2_,_loc6_);
      }
      
      private function handleAimingAnimationComplete(param1:AnimationOldEvent) : void
      {
         if(smallAimingMoving)
         {
            smallAimingAnim.playOutLabel("running");
         }
         else
         {
            smallAimingAnim.gotoAndStop("still");
         }
      }
      
      private function tendDO3DTo(param1:DisplayObject3D, param2:Number3D, param3:Number = 7) : Number3D
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param2.z - param1.z;
         var _loc7_:Number = _loc4_ / param3;
         var _loc8_:Number = _loc5_ / param3;
         var _loc9_:Number = _loc6_ / param3;
         param1.x += _loc7_;
         param1.y += _loc8_;
         param1.z += _loc9_;
         return new Number3D(_loc7_,_loc8_,_loc9_);
      }
      
      public function setSmallAiming(param1:MovieClip, param2:PointSprite) : void
      {
         smallAimingClip = param1;
         smallAimingSprite = param2;
         smallAimingAnim = new AnimationOld(smallAimingClip.container,false);
         smallAimingAnim.addEventListener(AnimationOldEvent.COMPLETE,handleAimingAnimationComplete);
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLAIMING,smallAimingSprite);
      }
      
      private function createFailFlightPath() : void
      {
         var _loc1_:Number3D = smallFlyingSprite.position.clone();
         var _loc2_:Number3D = new Number3D(toBigFlightPath.pointB.x + (toBigFlightPath.pointB.x - toBigFlightPath.pointA.x),smallAimingSprite.y + 121,_loc1_.z);
         var _loc3_:Number = (_loc2_.x - _loc1_.x) / 3;
         var _loc4_:Number = (_loc2_.y - _loc1_.y) / 3;
         var _loc5_:Number3D = new Number3D(_loc1_.x + _loc3_,_loc1_.y + _loc4_,_loc1_.z);
         var _loc6_:Number3D = new Number3D(_loc2_.x - _loc3_,_loc2_.y - _loc4_,_loc2_.z);
         failFlightPath = new BezierSegment3D(_loc1_,_loc5_,_loc2_,_loc6_);
      }
      
      private function handleTimeoutTimer(param1:TimerEvent) : void
      {
         lipSyncManager.playTimeout();
      }
      
      public function setSmallFlying(param1:MovieClip, param2:PointSprite) : void
      {
         smallFlyingClip = param1;
         smallFlyingSprite = param2;
         smallFlyingAnim = new AnimationOld(smallFlyingClip.container,false);
         toBigFlightLength = smallFlyingAnim.getLengthOfLabel("flying");
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLFLYING,smallFlyingSprite);
         smallFlyingSprite.visible = false;
      }
      
      private function updateSmallToBigFlight() : void
      {
         ++currentFlightProgress;
         if(currentFlightProgress > toBigFlightLength)
         {
            if(closestFlightProximity < flightSuccesProximity)
            {
               if(bigState == JIVING)
               {
                  startSmallBrushing();
               }
               return;
            }
            setSmallState(FAILED);
            createFailFlightPath();
            smallFailSprite.position = failFlightPath.getNumber3DAtT(0);
            smallFailClip.container.scaleX = smallFlyingClip.container.scaleX;
            smallFailAnim.playOutLabel("fall");
            currentFlightProgress = 0;
            return;
         }
         var _loc1_:Number = currentFlightProgress / toBigFlightLength;
         _loc1_ = Math.pow(_loc1_,0.6);
         var _loc2_:Number3D = toBigFlightPath.getNumber3DAtT(_loc1_);
         smallFlyingSprite.position = _loc2_;
         updatePoints();
         var _loc3_:Number = Point.distance(currentMouthPosition,currentBrushPosition);
         if(bigState == JIVING)
         {
            if(_loc3_ < flightSuccesProximity && smallFlyingSprite.y > 30)
            {
               if(_loc3_ < closestFlightProximity)
               {
                  closestFlightProximity = _loc3_;
                  if(currentMouthPosition.y < currentBrushPosition.y)
                  {
                     startSmallBrushing();
                     return;
                  }
               }
            }
            else if(_loc3_ > closestFlightProximity && smallFlyingSprite.y > 30)
            {
               startSmallBrushing();
            }
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         return _loc1_.concat(DO3DDefinitions.BATHROOM_SHOWERCURTAIN,DO3DDefinitions.BATHROOM_SINKTAPS);
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         super.update(param1);
         if(_active)
         {
            room.flagDirtyLayer(bigSprite.container);
            updatePoints();
            updateMouseUnproject();
            updateSmall();
            updateBig();
            fireToothpaste();
            flagLayers();
         }
      }
      
      private function handleMouseMove(param1:MouseEvent) : void
      {
         crosshair1.x = param1.stageX;
         crosshair1.y = param1.stageY;
         param1.updateAfterEvent();
      }
      
      private function handlePrepComplete(param1:AnimationOldEvent) : void
      {
         smallFlyingAnim.removeEventListener(AnimationOldEvent.COMPLETE,handlePrepComplete);
         smallFlyingAnim.playOutLabel("flying");
         setSmallState(FLYING);
      }
      
      override public function setAccessClip(param1:Sprite) : void
      {
         super.setAccessClip(param1);
      }
      
      public function setSmallDone(param1:MovieClip, param2:PointSprite) : void
      {
         smallDoneClip = param1;
         smallDoneSprite = param2;
         smallDoneAnim = new AnimationOld(smallDoneClip.container,false,25);
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLDONE,smallDoneSprite);
         smallDoneSprite.visible = false;
      }
      
      private function handleFailAnimComplete(param1:AnimationOldEvent) : void
      {
         if(smallState == RETURNING)
         {
            setSmallState(AIMING);
            lipSyncManager.playSmallFail();
         }
      }
      
      override public function activate() : void
      {
         currentJive.addEventListener("JiveComplete",handleBigJiveComplete);
         currentJive.play();
         bigMat.removeSprite();
         bigSprite.visible = false;
         smallAimingSprite.visible = false;
         SpriteParticleMaterial(smallAimingSprite.material).removeSprite();
         super.activate();
         _gameOver = false;
         updateMouseUnproject();
         updateSmallAiming(true);
         bigState = JIVING;
         setSmallState(AIMING);
         lipSyncManager.setActiveTalker(smallAimingClip.container);
         basicView.stage.addEventListener(MouseEvent.MOUSE_DOWN,handlePageClicked);
         basicView.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
         managerPageContainer2D.addChild(crosshair1);
         crosshair = crosshair1;
         crosshair1.visible = true;
         lipSyncManager.playBigIntro();
         updateSmallAiming(true);
         SoundManagerOld.playSoundSimple("BACKING",1,0,int.MAX_VALUE);
         timeoutTimer.addEventListener(TimerEvent.TIMER,handleTimeoutTimer);
         timeoutTimer.start();
         bigSprite.position = bigSpritePosition;
         TweenMax.from(bigSprite,0.5,{
            "x":bigSprite.x + 500,
            "ease":Expo.easeOut
         });
         smallAimingSprite.x = 500;
         bigSprite.visible = true;
         smallAimingSprite.visible = true;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         bigMat.removeSprite();
         bigSprite.visible = false;
         smallAimingSprite.visible = false;
         SpriteParticleMaterial(smallAimingSprite.material).removeSprite();
      }
      
      private function updatePoints() : void
      {
         currentMouthPosition.x = bigSprite.screen.x + currentJive.mouthPosition.x * bigSprite.size * bigSprite.renderScale + basicView.viewport.viewportWidth / 2;
         currentMouthPosition.y = bigSprite.screen.y + currentJive.mouthPosition.y * bigSprite.size * bigSprite.renderScale + basicView.viewport.viewportHeight / 2;
         if(smallState == FLYING)
         {
            currentBrushPosition.x = smallFlyingSprite.screen.x + smallFlyingClip.container.toothbrush.x * smallFlyingSprite.size * smallFlyingSprite.renderScale * smallFlyingClip.container.scaleX + basicView.viewport.viewportWidth / 2;
            currentBrushPosition.y = smallFlyingSprite.screen.y + smallFlyingClip.container.toothbrush.y * smallFlyingSprite.size * smallFlyingSprite.renderScale * smallFlyingClip.container.scaleY + basicView.viewport.viewportHeight / 2;
         }
      }
      
      private function updateSmallSuccessFlight() : void
      {
         ++currentFlightProgress;
         if(currentFlightProgress > successFlightLength)
         {
            if(!_gameOver)
            {
               smallAimingSprite.position = smallSuccessSprite.position.clone();
               setSmallState(AIMING);
            }
            else
            {
               setSmallState(FINISHED);
               smallDoneClip.container.scaleX = smallSuccessClip.container.scaleX;
               smallDoneSprite.x = smallSuccessSprite.x;
               smallDoneSprite.x += smallDoneClip.container.scaleX > 0 ? -50 : 50;
               smallDoneSprite.y = -8;
               smallDoneSprite.z = -160;
               lipSyncManager.stopLipSync();
               smallDoneAnim.playOutLabel("lipsync");
               SoundManagerOld.stopSoundChannel(1);
               SoundManagerOld.playSound("Bath_Small_yaythatswhaticallclean");
            }
         }
         var _loc1_:Number = currentFlightProgress / successFlightLength;
         _loc1_ = Math.pow(_loc1_,2.97);
         var _loc2_:Number3D = successFlightPath.getNumber3DAtT(_loc1_);
         smallSuccessSprite.position = _loc2_;
      }
      
      private function handleBrushingAnimComplete(param1:AnimationOldEvent) : void
      {
         if(!_gameOver)
         {
            lipSyncManager.playBigBrushedReaction();
         }
         SoundManagerOld.stopSound(brushLoop);
         setSmallState(SUCCESS);
         createSuccessFlightPath();
         currentFlightProgress = 0;
         bigMat.movie = currentJive;
         currentJive.play();
         smallSuccessSprite.position = successFlightPath.getNumber3DAtT(0);
         smallSuccessAnim.playOutLabel("fall");
      }
      
      public function setBigLowBrushed(param1:MovieClip) : void
      {
         bigLowBrushed = param1;
         param1.stop();
      }
      
      public function setBigHighLowRight(param1:MovieClip) : void
      {
         bigHighLowRight = param1;
         bigHighLowRightAnim = new AnimationOld(bigHighLowRight);
         bigHighLowRightAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBigSwitchComplete);
      }
      
      public function setSmallBrushing(param1:MovieClip, param2:PointSprite) : void
      {
         smallBrushingClip = param1;
         smallBrushingAnim = new AnimationOld(smallBrushingClip.container,false);
         smallBrushingSprite = param2;
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_SMALLPOV_SMALLBRUSHING,smallBrushingSprite);
         smallBrushingSprite.visible = false;
      }
      
      private function handlePageClicked(param1:MouseEvent = null) : void
      {
         if(smallState == AIMING || smallState == RETURNING)
         {
            setSmallState(PREPPING);
            updatePoints();
            createToBigFlightPath();
            currentFlightProgress = 0;
            smallFlyingSprite.position = toBigFlightPath.getNumber3DAtT(0);
            smallFlyingAnim.playOutLabel("prepping");
            smallFlyingAnim.addEventListener(AnimationOldEvent.COMPLETE,handlePrepComplete);
            smallFlyingClip.container.scaleX = smallAimingClip.container.scaleX;
            lipSyncManager.playSmallLeap();
         }
      }
      
      private function startSmallBrushing() : void
      {
         setSmallState(BRUSHING);
         smallBrushingAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBrushingAnimComplete);
         smallBrushingAnim.playOutLabel("brushing");
         SoundManagerOld.playSound(brushLoop,new SoundInfoOld(1,0,int.MAX_VALUE));
         currentJive.stop();
         if(currentJive == bigJive)
         {
            bigBrushed.gotoAndStop(currentJive.currentFrame);
            bigMat.movie = bigBrushed;
         }
         else
         {
            bigLowBrushed.gotoAndStop(currentJive.currentFrame);
            bigMat.movie = bigLowBrushed;
         }
         smallBrushingSprite.position = getProjectedMouthPosition();
         smallBrushingSprite.y -= 82;
         if(smallFlyingSprite.screen.x > 0)
         {
            smallBrushingClip.container.scaleX = -1;
            smallBrushingSprite.x -= 25;
         }
         else
         {
            smallBrushingClip.container.scaleX = 1;
            smallBrushingSprite.x += 25;
         }
         TweenMax.from(smallBrushingSprite,0.5,{
            "x":smallFlyingSprite.x,
            "y":smallFlyingSprite.y,
            "z":smallFlyingSprite.z,
            "ease":Expo.easeOut
         });
         setScore(score + 0.2);
      }
      
      public function setBigHighLowLeft(param1:MovieClip) : void
      {
         bigHighLowLeft = param1;
         bigHighLowLeftAnim = new AnimationOld(bigHighLowLeft);
         bigHighLowLeftAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBigSwitchComplete);
      }
      
      private function doLandingSound() : void
      {
         SoundManagerOld.playSound("bath_tooth_smallbouncedown");
      }
      
      private function handleBigExitTalkDone(param1:AnimationOldEvent) : void
      {
         bigExitAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleBigExitTalkDone);
         bigExitAnim.playOutLabel("walking");
         bigExitAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBigExitComplete);
      }
      
      private function handleBigJiveComplete(param1:Event) : void
      {
         if(!bigJiveChangeReady)
         {
            bigJiveChangeReady = true;
            return;
         }
         if(param1.target != currentJive)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Math.round(Math.random()));
         if(_gameOver)
         {
            if(currentJive == bigLowJive)
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
         }
         if(_loc2_)
         {
            currentJive.stop();
            currentJive.removeEventListener("JiveComplete",handleBigJiveComplete);
            if(currentJive.currentFrame == currentJive.totalFrames)
            {
               currentSwitch = bigHighLowLeftAnim;
            }
            else
            {
               currentSwitch = bigHighLowRightAnim;
            }
            if(currentJive == bigJive)
            {
               bigLowJive.gotoAndStop(currentJive.currentFrame);
               currentJive = bigLowJive;
               currentSwitch.gotoAndStop(1);
               currentSwitch.playOutLabel("change");
            }
            else
            {
               bigJive.gotoAndStop(currentJive.currentFrame);
               currentJive = bigJive;
               currentSwitch.gotoAndStop(currentSwitch.subjectClip.totalFrames);
               currentSwitch.playOutLabel("change",0,true);
            }
            bigMat.movie = currentSwitch.subjectClip;
            lipSyncManager.setBigTalker(currentJive);
            currentJive.addEventListener("JiveComplete",handleBigJiveComplete);
            bigState = CHANGING;
            bigJiveChangeReady = false;
         }
      }
      
      private function getProjectedMouthPosition() : Number3D
      {
         var _loc1_:Number3D = new Number3D();
         var _loc2_:Number = currentMouthPosition.x - (basicView.viewport.viewportWidth >> 1);
         var _loc3_:Number = currentMouthPosition.y - (basicView.viewport.viewportHeight >> 1);
         var _loc4_:Number3D = new Number3D(basicView.camera.x - room.x,basicView.camera.y - room.y,basicView.camera.z - room.z);
         var _loc5_:Number3D = basicView.camera.unproject(_loc2_,_loc3_);
         _loc5_.plusEq(_loc4_);
         var _loc6_:Plane3D = new Plane3D();
         _loc6_.setNormalAndPoint(new Number3D(0,0,-1),new Number3D(0,0,90));
         return _loc6_.getIntersectionLineNumbers(_loc4_,_loc5_);
      }
      
      private function updateBig() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         if(_gameOver && (smallState == EXITING || smallState == EXITED))
         {
            if(bigMat.movie != bigExit)
            {
               _loc1_ = false;
               if(smallState == EXITED)
               {
                  _loc1_ = true;
               }
               else
               {
                  for each(_loc2_ in bigJiveToExitFrames)
                  {
                     if(_loc2_ == bigJive.currentFrame)
                     {
                        _loc1_ = true;
                     }
                  }
               }
               trace("onFrame",_loc1_);
               if(bigMat.movie == bigJive && _loc1_)
               {
                  bigMat.movie = bigExit;
                  bigExitAnim.playOutLabel("talking");
                  SoundManagerOld.playSound("Bath_Big_thankssmall");
               }
            }
         }
      }
      
      public function setBigExit(param1:MovieClip) : void
      {
         bigExit = param1;
         bigExitAnim = new AnimationOld(bigExit,false,25);
      }
      
      private function createSuccessFlightPath() : void
      {
         var _loc1_:Number3D = smallBrushingSprite.position.clone();
         var _loc2_:Number3D = new Number3D(smallBrushingSprite.x + 70,smallAimingSprite.y,smallAimingSprite.z);
         if(smallBrushingSprite.screen.x < 0)
         {
            _loc2_.x -= 140;
            smallSuccessClip.container.scaleX = 1;
         }
         else
         {
            smallSuccessClip.container.scaleX = -1;
         }
         if(_gameOver)
         {
            _loc2_.x = (234 - 115) / 2;
         }
         var _loc3_:Number = (_loc2_.x - _loc1_.x) / 4.5;
         var _loc4_:Number = (_loc2_.y - _loc1_.y) / 1.2;
         var _loc5_:Number3D = new Number3D(_loc1_.x + _loc3_,_loc1_.y + 90,_loc1_.z);
         var _loc6_:Number3D = new Number3D(_loc2_.x - _loc3_,_loc2_.y + 154,_loc2_.z);
         successFlightPath = new BezierSegment3D(_loc1_,_loc5_,_loc2_,_loc6_);
      }
      
      private function updateSmallFailFlight() : void
      {
         ++currentFlightProgress;
         if(currentFlightProgress > failFlightLength)
         {
            smallFailAnim.playOutLabel("back up");
            setSmallState(RETURNING);
            setSmallState(AIMING);
            lipSyncManager.playSmallFail();
            smallAimingSprite.y -= 75;
            smallAimingSprite.x = smallFailSprite.x;
            smallAimingSprite.x += smallAimingClip.container.scaleX > 0 ? 45 : -45;
            return;
         }
         var _loc1_:Number = currentFlightProgress / successFlightLength;
         _loc1_ = Math.pow(_loc1_,3.37);
         var _loc2_:Number3D = failFlightPath.getNumber3DAtT(_loc1_);
         smallFailSprite.position = _loc2_;
      }
      
      private function fireToothpaste() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number3D = null;
         if(smallState == BRUSHING)
         {
            _loc2_ = new Number3D(Math.random() * 20 - 10,Math.random() * 20 - 10,Math.random() * 20 - 10);
            toothpasteManager.fireToothPaste(toothPastePosition.x + _loc2_.x,toothPastePosition.y + _loc2_.y,toothPastePosition.z + _loc2_.z,3,null,3.5);
         }
         else if(smallState == FLYING)
         {
            if(smallFlyingClip.container.toothpaste)
            {
               _loc1_ = getSmallFlyingToothpastePos();
               toothpasteManager.fireToothPaste(smallFlyingSprite.x - _loc1_.x / 1.7,smallFlyingSprite.y,smallFlyingSprite.z,3,null,3);
            }
         }
         else if(smallState == FAILED)
         {
            if(smallFailClip.container.toothpaste)
            {
               _loc1_ = getSmallFailToothpastePos();
               toothpasteManager.fireToothPaste(smallFlyingSprite.x - _loc1_.x,smallFlyingSprite.y - _loc1_.y,smallFlyingSprite.z,2,null,3.5);
            }
         }
      }
      
      private function getSmallFailToothpastePos() : Point
      {
         var _loc1_:Number = smallFailClip.container.toothpaste.x * smallFailSprite.size * smallFailSprite.renderScale * smallFailClip.container.scaleX;
         var _loc2_:Number = smallFailClip.container.toothpaste.y * smallFailSprite.size * smallFailSprite.renderScale * smallFailClip.container.scaleY;
         return new Point(_loc1_,_loc2_);
      }
      
      private function updateSmall() : void
      {
         if(smallState == AIMING)
         {
            updateSmallAiming();
         }
         else if(smallState != PREPPING)
         {
            if(smallState == FLYING)
            {
               updateSmallToBigFlight();
            }
            else if(smallState != BRUSHING)
            {
               if(smallState == SUCCESS)
               {
                  updateSmallSuccessFlight();
               }
               else if(smallState == FAILED)
               {
                  updateSmallFailFlight();
               }
               else if(smallState != RETURNING)
               {
                  if(smallState != FINISHED)
                  {
                     if(smallState == EXITING)
                     {
                     }
                  }
               }
            }
         }
      }
      
      private function flagLayers() : void
      {
         if(smallState == AIMING)
         {
            room.flagDirtyLayer(smallAimingSprite.container);
         }
         else if(smallState == PREPPING)
         {
            room.flagDirtyLayer(smallFlyingSprite.container);
         }
         else if(smallState == FLYING)
         {
            room.flagDirtyLayer(smallFlyingSprite.container);
         }
         else if(smallState == BRUSHING)
         {
            room.flagDirtyLayer(smallBrushingSprite.container);
         }
         else if(smallState == SUCCESS)
         {
            room.flagDirtyLayer(smallSuccessSprite.container);
         }
         else if(smallState == FAILED)
         {
            room.flagDirtyLayer(smallFailSprite.container);
         }
         else if(smallState == RETURNING)
         {
            room.flagDirtyLayer(smallFailSprite.container);
         }
         else if(smallState == FINISHED)
         {
            room.flagDirtyLayer(smallDoneSprite.container);
         }
         else if(smallState == EXITING)
         {
            room.flagDirtyLayer(smallDoneSprite.container);
         }
      }
      
      private function setSmallState(param1:uint) : void
      {
         if(param1 == smallState)
         {
            return;
         }
         if(smallState == AIMING)
         {
            if(timeoutTimer)
            {
               timeoutTimer.stop();
               timeoutTimer.removeEventListener(TimerEvent.TIMER,handleTimeoutTimer);
            }
            smallAimingSprite.visible = false;
            SpriteParticleMaterial(smallAimingSprite.material).removeSprite();
            SoundManagerOld.playSound("bath_tooth_smallbounceup");
         }
         else if(smallState != PREPPING)
         {
            if(smallState == FLYING)
            {
               smallFlyingSprite.visible = false;
               SpriteParticleMaterial(smallFlyingSprite.material).removeSprite();
            }
            else if(smallState == BRUSHING)
            {
               smallBrushingSprite.visible = false;
               SpriteParticleMaterial(smallBrushingSprite.material).removeSprite();
            }
            else if(smallState == SUCCESS)
            {
               smallSuccessSprite.visible = false;
               SpriteParticleMaterial(smallSuccessSprite.material).removeSprite();
               lipSyncManager.setActiveTalker(smallSuccessClip.container);
               doLandingSound();
            }
            else if(smallState == FAILED)
            {
               smallFailSprite.visible = false;
               SpriteParticleMaterial(smallFailSprite.material).removeSprite();
               doLandingSound();
            }
            else if(smallState == RETURNING)
            {
               smallFailSprite.visible = false;
               SpriteParticleMaterial(smallFailSprite.material).removeSprite();
               smallFailAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleFailAnimComplete);
            }
            else if(smallState == FINISHED)
            {
               smallDoneSprite.visible = false;
               SpriteParticleMaterial(smallDoneSprite.material).removeSprite();
               smallDoneAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleSmallDoneSpeech);
            }
            else if(smallState == EXITING)
            {
               smallDoneSprite.visible = false;
               SpriteParticleMaterial(smallDoneSprite.material).removeSprite();
               smallDoneAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleSmallExitComplete);
            }
         }
         if(param1 == AIMING)
         {
            currentSmallSprite = smallAimingSprite;
            smallAimingSprite.visible = true;
            lipSyncManager.setActiveTalker(smallAimingClip.container);
            timeoutTimer.addEventListener(TimerEvent.TIMER,handleTimeoutTimer);
            timeoutTimer.start();
         }
         else if(param1 == PREPPING)
         {
            currentSmallSprite = smallFlyingSprite;
            smallFlyingSprite.visible = true;
            lipSyncManager.setActiveTalker(smallFlyingClip.container);
         }
         else if(param1 == FLYING)
         {
            currentSmallSprite = smallFlyingSprite;
            smallFlyingSprite.visible = true;
            closestFlightProximity = 1000;
            updatePoints();
            lipSyncManager.setActiveTalker(smallFlyingClip.container);
         }
         else if(param1 == BRUSHING)
         {
            currentSmallSprite = smallBrushingSprite;
            toothPastePosition = getProjectedMouthPosition();
            smallBrushingSprite.visible = true;
            smallBrushingAnim.gotoAndStop("brushing");
         }
         else if(param1 == SUCCESS)
         {
            currentSmallSprite = smallSuccessSprite;
            smallSuccessAnim.gotoAndStop("fall");
            smallSuccessSprite.visible = true;
            lipSyncManager.setActiveTalker(smallSuccessClip.container);
         }
         else if(param1 == FAILED)
         {
            currentSmallSprite = smallFailSprite;
            smallFailSprite.visible = true;
         }
         else if(param1 == RETURNING)
         {
            currentSmallSprite = smallFailSprite;
            smallFailSprite.position = smallAimingSprite.position.clone();
            smallFailSprite.visible = true;
            smallFailAnim.addEventListener(AnimationOldEvent.COMPLETE,handleFailAnimComplete);
         }
         else if(param1 == FINISHED)
         {
            crosshair1.visible = false;
            currentSmallSprite = smallDoneSprite;
            smallDoneSprite.visible = true;
            smallDoneAnim.addEventListener(AnimationOldEvent.COMPLETE,handleSmallDoneSpeech);
         }
         else if(param1 == EXITING)
         {
            currentSmallSprite = smallDoneSprite;
            smallDoneSprite.visible = true;
            smallDoneAnim.addEventListener(AnimationOldEvent.COMPLETE,handleSmallExitComplete);
         }
         smallState = param1;
      }
      
      private function handleSmallExitComplete(param1:AnimationOldEvent) : void
      {
         setSmallState(EXITED);
         trace("EXITED");
      }
      
      public function setCrosshair(param1:MovieClip) : void
      {
         crosshair1 = param1;
         crosshair = param1;
      }
      
      private function updateSmallAiming(param1:Boolean = false) : void
      {
         var _loc2_:Number3D = new Number3D(mouseUnprojected.x,smallAimingSprite.y,mouseUnprojected.z);
         _loc2_.y = 32 + _loc2_.z / 2.75;
         var _loc3_:Number3D = _loc2_.clone();
         if(prevAimingTarget)
         {
            if(prevAimingTarget.x < _loc2_.x && Math.abs(prevAimingTarget.x - _loc2_.x) > 0.5)
            {
               aimingTargetModifier = -50;
            }
            else if(Math.abs(prevAimingTarget.x - _loc2_.x) > 0.5)
            {
               aimingTargetModifier = 50;
            }
         }
         _loc3_.x += aimingTargetModifier;
         prevAimingTarget = _loc2_;
         var _loc4_:Number3D = tendDO3DTo(smallAimingSprite,_loc3_,5);
         if(Math.abs(_loc4_.modulo) > 0.28)
         {
            smallAimingMoving = true;
            if(!smallAimingAnim.isPlaying)
            {
               smallAimingAnim.playOutLabel("running");
            }
         }
         else
         {
            smallAimingMoving = false;
         }
         if(smallAimingSprite.x < _loc2_.x)
         {
            smallAimingClip.container.scaleX = 1;
         }
         else
         {
            smallAimingClip.container.scaleX = -1;
         }
         if(param1)
         {
            smallAimingSprite.position = _loc3_;
         }
      }
      
      override protected function gameOver() : void
      {
         _gameOver = true;
      }
      
      override protected function handleAccessClipClick(param1:MouseEvent) : void
      {
         if(smallState == AIMING || smallState == RETURNING)
         {
            setSmallState(PREPPING);
            updatePoints();
            mouseUnprojected.x = 35;
            mouseUnprojected.y = 210;
            createToBigFlightPath();
            currentFlightProgress = 0;
            smallFlyingSprite.position = toBigFlightPath.getNumber3DAtT(0);
            smallFlyingAnim.playOutLabel("prepping");
            smallFlyingAnim.addEventListener(AnimationOldEvent.COMPLETE,handlePrepComplete);
            smallFlyingClip.container.scaleX = smallAimingClip.container.scaleX;
            lipSyncManager.playSmallLeap();
         }
      }
      
      override public function park() : void
      {
         super.park();
      }
   }
}

