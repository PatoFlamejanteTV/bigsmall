package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   
   public class BigGameSmallSpriteTBTackle extends PointSprite
   {
      
      public static var STATE_NULL:String = "ANIMSTATE_NULL";
      
      public static var STATE_MCLOCKWISE:String = "ANIMSTATE_CLOCKWISE";
      
      public static var STATE_MANTICLOCKWISE:String = "ANIMSTATE_ANTICLOCKWISE";
      
      public static var STATE_BRUSHED:String = "ANIMSTATE_BRUSH";
      
      public static var STATE_BRUSHED_RAPID:String = "ANIMSTATE_BRUSH_RAPID";
      
      public static var STATE_EXITSEQ:String = "ANIMSTATE_EXITSEQ";
      
      public static var STATE_RAPIDEXIT:String = "ANIMSTATE_RAPIDEXIT";
      
      public static var STATE_ENTRYSEQ:String = "ANIMSTATE_ENTRYSEQ";
      
      public static var STATE_BOUNCEVOXABLE:String = "ANIMSTATE_BOUNCEVOXABLE";
      
      private var sinTicker:Number = 0;
      
      public var splutterVoxableLabels:Array = [];
      
      private var possibleMiss:Boolean = false;
      
      private var bounceVoxable:MovieClip;
      
      public var isBackDepth:Boolean = false;
      
      private var frontDepth:Number;
      
      private var backDepth:Number;
      
      private var voxCallbackFunc:Function = null;
      
      private var currentAnim:AnimationOld;
      
      private var _isActive:Boolean = false;
      
      private var voxControllerDict:Dictionary = new Dictionary();
      
      private var immunityCtr:int = 0;
      
      private var _feetLocalX:Number;
      
      private var _feetLocalY:Number;
      
      public var missedVoxableLabels:Array = [];
      
      private var _footTarget:MovieClip = new MovieClip();
      
      private var smallExitAnimation:AnimationOld;
      
      private var preBrushFrame:int;
      
      private var brushCtrMax:int = 30;
      
      private var _animLocalY:Number;
      
      private var _animLocalX:Number;
      
      private var sinFreq:Number = 1;
      
      private var mouthToLabel:String;
      
      private var partMat:SpriteParticleMaterial;
      
      private var missedMeVoxLocked:Boolean = true;
      
      private var nullClip:MovieClip = new MovieClip();
      
      private var missedMeTimer:Timer = new Timer(4000);
      
      private var vPlane:Plane3D = new Plane3D();
      
      private var brushCtr:int = 0;
      
      private var preBrushState:String;
      
      private var missedVIndex:int = -1;
      
      private var _gameOn:Boolean = false;
      
      private var baseZ:Number;
      
      private var splutterVIndex:int = -1;
      
      private var _isVoxable:Boolean = true;
      
      private var _smallTarget:MovieClip = new MovieClip();
      
      private var _hasContact:Boolean = false;
      
      private var brushFollowMag:Number = 20;
      
      public var worldOffset:Number3D = new Number3D();
      
      private var sinAmp:Number = 25;
      
      public var globalPlaneNorm:Number3D = new Number3D();
      
      private var contactRad:Number = 80;
      
      private var stateStr:String;
      
      private var currentVoxCtrlAnim:AnimationOld;
      
      private var allowMiss:Boolean = true;
      
      private var voxCallbackParams:Array = null;
      
      private var talkerMouth:MovieClip;
      
      private var immunityCtrMax:int = 45;
      
      private var movDict:Dictionary = new Dictionary();
      
      private var talkerBrainSound:BrainSoundOld;
      
      public function BigGameSmallSpriteTBTackle(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:MovieClip, param6:MovieClip, param7:MovieClip, param8:MovieClip, param9:Number3D, param10:Number3D, param11:Number, param12:Number, param13:Number = 0.7)
      {
         globalPlaneNorm = param9;
         worldOffset = param10;
         movDict[STATE_NULL] = new AnimationOld(nullClip);
         movDict[STATE_MCLOCKWISE] = new AnimationOld(param1);
         movDict[STATE_MANTICLOCKWISE] = new AnimationOld(param3);
         rigTimelineListeners(AnimationOld(movDict[STATE_MCLOCKWISE]).subjectClip);
         rigTimelineListeners(AnimationOld(movDict[STATE_MANTICLOCKWISE]).subjectClip);
         movDict[STATE_BRUSHED] = new AnimationOld(param4);
         movDict[STATE_BRUSHED_RAPID] = new AnimationOld(param5);
         movDict[STATE_ENTRYSEQ] = new AnimationOld(param2);
         param2.addEventListener("INTRO_COMPLETE",handleIntroSeqComplete);
         movDict[STATE_EXITSEQ] = new AnimationOld(param7);
         if(param7["smallexit"])
         {
            param7["smallexit"].gotoAndStop(1);
            smallExitAnimation = new AnimationOld(param7["smallexit"],false,25);
            smallExitAnimation.addEventListener(AnimationOldEvent.COMPLETE,handleExitSeqComplete);
         }
         else
         {
            trace("smallGameSprite error :: cannot source exit sequence internal");
         }
         movDict[STATE_RAPIDEXIT] = new AnimationOld(param8);
         if(param8["smallexit"])
         {
            param8["smallexit"].gotoAndStop(1);
            param8["smallexit"].addEventListener("RAPIDEXIT_COMPLETE",handleRapidExitComplete);
         }
         else
         {
            trace("smallGameSprite error :: cannot source rapid exit sequence internal");
         }
         var _loc14_:AnimationOld = new AnimationOld(param6);
         if(_loc14_)
         {
            movDict[STATE_BOUNCEVOXABLE] = _loc14_;
            bounceVoxable = param6["voxable"];
            bounceVoxable.gotoAndStop(1);
            rigTimelineListeners(bounceVoxable);
         }
         partMat = new SpriteParticleMaterial(movDict[STATE_NULL]);
         frontDepth = param11;
         backDepth = param12;
         missedMeTimer.addEventListener(TimerEvent.TIMER,handleMissedMeTimer);
         super(partMat,param13);
      }
      
      public function doPreOutro() : void
      {
         setState(STATE_EXITSEQ,1,false);
         AnimationOld(movDict[STATE_EXITSEQ]).subjectClip["smallexit"].gotoAndStop(1);
      }
      
      private function rigVoxControllerListeners(param1:AnimationOld) : void
      {
         param1.addEventListener(AnimationOldEvent.COMPLETE,handleVoxControllerComplete);
         param1.addEventListener(Event.ADDED,handleVoxControllerChildAdded);
      }
      
      private function handleCheckTurnEv(param1:Event) : void
      {
         if(_isActive && Boolean(currentAnim))
         {
            checkTurn(currentAnim.currentLabel);
         }
         immunityCtr = 0;
         synchroniseAnimLocs();
         dispatchEvent(new Event("TURN_EVENT"));
      }
      
      public function prepare() : void
      {
      }
      
      public function brushAt(param1:Number, param2:Number, param3:Boolean, param4:Boolean = false) : Boolean
      {
         if(!brushTarget)
         {
            return false;
         }
         if(hasBrushContact(param1,param2) || param4)
         {
            updateBrushState(true,param3);
            return true;
         }
         updateBrushState(false,param3);
         return false;
      }
      
      public function stopCharacterVox() : void
      {
         if(talkerBrainSound)
         {
            SoundManagerOld.stopSound(talkerBrainSound.strID);
         }
         if(currentVoxCtrlAnim)
         {
            currentVoxCtrlAnim.gotoAndStop(1);
         }
      }
      
      private function handleVoxControllerComplete(param1:AnimationOldEvent) : void
      {
         param1.target.gotoAndStop(1);
         currentVoxCtrlAnim = null;
         if(voxCallbackFunc is Function)
         {
            voxCallbackFunc.apply(null,voxCallbackParams);
         }
         dispatchEvent(new Event("VOX_END"));
      }
      
      public function get hasContact() : Boolean
      {
         return _hasContact;
      }
      
      public function doMissedMeJibe() : void
      {
         missedVIndex = (missedVIndex + 1) % missedVoxableLabels.length;
         doVox(missedVoxableLabels[missedVIndex]);
         dispatchEvent(new Event("MISSED_JIBE"));
      }
      
      public function initGame() : void
      {
         setState(STATE_MCLOCKWISE,1);
         synchroniseAnimLocs();
         setState(STATE_BOUNCEVOXABLE,1);
         setVoxable(true);
      }
      
      public function getLocalMouseCoords() : Number2D
      {
         var _loc1_:Number2D = new Number2D();
         if(currentAnim)
         {
            _loc1_.x = currentAnim.mouseX;
            _loc1_.y = currentAnim.mouseY;
         }
         return _loc1_;
      }
      
      public function setBaseDepth(param1:Number) : void
      {
         z = param1;
         baseZ = this.z;
      }
      
      public function get isVoxable() : Boolean
      {
         return _isVoxable;
      }
      
      private function handleVoxControllerChildAdded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = "MouthShape_";
         if(_loc2_.name.substr(0,11) == _loc3_)
         {
            mouthToLabel = _loc2_.name.substr(_loc3_.length);
            if(talkerMouth)
            {
               talkerMouth.gotoAndStop(mouthToLabel);
            }
         }
      }
      
      private function handleMissedMeTimer(param1:TimerEvent) : void
      {
         missedMeVoxLocked = false;
      }
      
      public function doOutro() : void
      {
         setState(STATE_EXITSEQ,1,false);
         smallExitAnimation.gotoAndStop(1);
         smallExitAnimation.playOutLabel("talking");
         SoundManagerOld.playSound("Bath_Small_woohoosohappyteethareclean");
      }
      
      public function beginGame() : void
      {
         _gameOn = true;
         enableMissedMeVox();
         setState(STATE_MCLOCKWISE,1);
      }
      
      public function disableMissedMeVox() : void
      {
         missedMeVoxLocked = true;
         missedMeTimer.stop();
         missedMeTimer.reset();
      }
      
      private function hasBrushContact(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number2D = getMouthPosition();
         if(!_loc3_)
         {
            return false;
         }
         _loc3_.x = currentAnim.mouseX - _loc3_.x;
         _loc3_.y = currentAnim.mouseY - _loc3_.y;
         return _loc3_.isModuloLessThan(contactRad);
      }
      
      private function handleBounceContact(param1:Event) : void
      {
      }
      
      private function handleRapidExitComplete(param1:Event) : void
      {
         setState(STATE_NULL);
         stopAllAnims();
      }
      
      private function updateBrushState(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:Number2D = null;
         if(param1 && param2)
         {
            if(stateStr == STATE_BRUSHED || stateStr == STATE_BRUSHED_RAPID)
            {
               ++brushCtr;
               if(immunityCtr < immunityCtrMax)
               {
                  ++immunityCtr;
               }
               if(brushCtr > brushCtrMax)
               {
                  breakBrushedState(preBrushState,preBrushFrame);
                  return;
               }
               if(param2)
               {
                  if(stateStr !== STATE_BRUSHED_RAPID)
                  {
                     setState(STATE_BRUSHED_RAPID);
                  }
                  dispatchEvent(new Event("EV_BRUSH_HEAVY"));
               }
               else
               {
                  if(stateStr == STATE_BRUSHED_RAPID)
                  {
                     breakBrushedState(preBrushState,preBrushFrame);
                     return;
                  }
                  dispatchEvent(new Event("EV_BRUSH_LITE"));
               }
               _loc3_ = new Number2D(currentAnim.mouseX - _animLocalX,currentAnim.mouseY - _animLocalY);
               _loc3_.normalise();
               _loc3_.multiplyEq(brushFollowMag);
               synchroniseAnimLocs(_loc3_.x,_loc3_.y);
               return;
            }
            if(immunityCtr > 0)
            {
               --immunityCtr;
            }
            if(immunityCtr > 0)
            {
               return;
            }
            preBrushFrame = currentAnim.currentFrame;
            preBrushState = stateStr;
            setState(STATE_BRUSHED);
            stopCharacterVox();
            dispatchEvent(new Event("BRUSHING_BEGIN"));
         }
         else
         {
            if(immunityCtr > 0)
            {
               --immunityCtr;
            }
            if(stateStr == STATE_BRUSHED || stateStr == STATE_BRUSHED_RAPID)
            {
               breakBrushedState(preBrushState,preBrushFrame);
            }
         }
      }
      
      private function handleBrainSoundProgress(param1:Number) : void
      {
         var _loc2_:Number = 0;
         if(talkerBrainSound.soundChannel)
         {
            _loc2_ = (talkerBrainSound.soundChannel.leftPeak + talkerBrainSound.soundChannel.rightPeak) / 2;
         }
         else
         {
            _loc2_ = 0;
         }
      }
      
      public function setState(param1:String, param2:int = 0, param3:Boolean = true) : void
      {
         var nmouth:MovieClip = null;
         var newstatestr:String = param1;
         var frame:int = param2;
         var play:Boolean = param3;
         var newstate:AnimationOld = movDict[newstatestr];
         if(!newstate)
         {
            BrainLogger.warning("BathroomGameBigPOVSmall.setAnimState",newstatestr,"is not a valid animation state setting");
            return;
         }
         if(currentAnim)
         {
            currentAnim.stop();
         }
         if(stateStr == STATE_EXITSEQ)
         {
            AnimationOld(movDict[STATE_EXITSEQ]).subjectClip["smallexit"].gotoAndStop(1);
         }
         else if(stateStr == STATE_RAPIDEXIT)
         {
            AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["smallexit"].gotoAndStop(1);
         }
         if(newstatestr == STATE_NULL)
         {
            currentAnim = newstate;
            partMat.movie = newstate;
            stateStr = newstatestr;
            return;
         }
         nmouth = null;
         try
         {
            if(newstatestr == STATE_BOUNCEVOXABLE)
            {
               nmouth = newstate.subjectClip["voxable"]["mouth"];
            }
            else
            {
               nmouth = newstate.subjectClip["mouth"];
            }
         }
         catch(e:Error)
         {
         }
         if(nmouth)
         {
            talkerMouth = nmouth;
            talkerMouth.gotoAndStop(mouthToLabel);
         }
         if(newstatestr == STATE_BOUNCEVOXABLE)
         {
            bounceVoxable.gotoAndPlay(1);
         }
         else
         {
            bounceVoxable.gotoAndStop(1);
         }
         currentAnim = newstate;
         partMat.movie = newstate;
         stateStr = newstatestr;
         if(frame > 0)
         {
            if(play)
            {
               currentAnim.gotoAndPlay(frame);
            }
            else
            {
               currentAnim.gotoAndStop(frame);
            }
         }
         else if(play)
         {
            currentAnim.play();
         }
         else
         {
            currentAnim.stop();
         }
      }
      
      public function endIntro() : void
      {
         setState(STATE_NULL);
         dispatchEvent(new Event("INTRO_COMPLETE"));
      }
      
      private function breakBrushedState(param1:String, param2:int) : void
      {
         setState(param1,param2);
         brushCtr = 0;
         sinTicker = 0;
         doSplutterJibe();
         dispatchEvent(new Event("BRUSHING_END"));
      }
      
      public function getMouthPosition() : Number2D
      {
         var _loc1_:MovieClip = brushTarget;
         if(!_loc1_ || !currentAnim)
         {
            return null;
         }
         return new Number2D(_loc1_.x,_loc1_.y);
      }
      
      public function doVox(param1:String, param2:Function = null, param3:Array = null) : void
      {
         var _loc5_:SoundInfoOld = null;
         if(!_isVoxable)
         {
            return;
         }
         var _loc4_:AnimationOld = voxControllerDict[param1];
         stopCharacterVox();
         if(!_loc4_)
         {
            talkerBrainSound = BrainSoundOld(SoundManagerOld.getSoundByID(param1));
            if(!talkerBrainSound)
            {
               BrainLogger.warning("small sprite : doVox :: could not source vox asset for label",param1);
               return;
            }
            _loc5_ = new SoundInfoOld();
            _loc5_.onProgressFunc = handleBrainSoundProgress;
            _loc5_.onCompleteFunc = handleBrainSoundComplete;
            SoundManagerOld.playSound(param1,_loc5_);
         }
         else
         {
            currentVoxCtrlAnim = _loc4_;
            currentVoxCtrlAnim.loop(1);
         }
         voxCallbackFunc = param2;
         voxCallbackParams = param3;
         dispatchEvent(new Event("VOX_BEGIN"));
      }
      
      private function handleBrainSoundComplete() : void
      {
         talkerBrainSound = null;
         if(voxCallbackFunc is Function)
         {
            voxCallbackFunc.apply(null,voxCallbackParams);
         }
         dispatchEvent(new Event("VOX_END"));
      }
      
      public function doSplutterJibe() : void
      {
         splutterVIndex = (splutterVIndex + 1) % splutterVoxableLabels.length;
         doVox(splutterVoxableLabels[splutterVIndex]);
      }
      
      public function get brushTarget() : MovieClip
      {
         var _loc1_:MovieClip = smallTarget;
         if(!_loc1_)
         {
            if(!currentAnim)
            {
               return null;
            }
            return currentAnim.subjectClip["btarget"];
         }
         return _loc1_;
      }
      
      private function handleDepthToBack(param1:Event) : void
      {
         toBackDepth();
      }
      
      private function resetAnims() : void
      {
         var _loc1_:AnimationOld = null;
         for each(_loc1_ in movDict)
         {
            if(_loc1_)
            {
               _loc1_.gotoAndStop(1);
            }
         }
      }
      
      public function get smallTarget() : MovieClip
      {
         if(!currentAnim)
         {
            return null;
         }
         _smallTarget = currentAnim.subjectClip["target"];
         return _smallTarget;
      }
      
      private function synchroniseAnimLocs(param1:Number = 0, param2:Number = 0) : void
      {
         var tx:Number;
         var ty:Number;
         var btarg:MovieClip = null;
         var ftarg:MovieClip = null;
         var brushmov:MovieClip = null;
         var brushmovtarget:MovieClip = null;
         var brushrapidmov:MovieClip = null;
         var brushrapidmovtarget:MovieClip = null;
         var completionanim:MovieClip = null;
         var completionanimtarget:MovieClip = null;
         var exitseq:MovieClip = null;
         var exitseqtarget:MovieClip = null;
         var rexitseq:MovieClip = null;
         var rexitseqtarget:MovieClip = null;
         var lx:Number = param1;
         var ly:Number = param2;
         if(stateStr == STATE_MANTICLOCKWISE || stateStr == STATE_MCLOCKWISE)
         {
            btarg = brushTarget;
            if(!btarg)
            {
               BrainLogger.warning("BigGameSmallSpriteTBTackle warning - cannot source brush target clip");
               return;
            }
            _animLocalX = btarg.x;
            _animLocalY = btarg.y;
            ftarg = footTarget;
            if(!ftarg)
            {
               BrainLogger.warning("BigGameSmallSpriteTBTackle warning - cannot source foot target clip");
               return;
            }
            _feetLocalX = ftarg.x;
            _feetLocalY = ftarg.y;
         }
         else if(stateStr == STATE_BRUSHED || stateStr == STATE_BRUSHED_RAPID)
         {
            sinTicker = (sinTicker + sinFreq) % 360;
            ly += Math.sin(sinTicker) * sinAmp;
         }
         tx = _animLocalX + lx;
         ty = _animLocalY + ly;
         try
         {
            brushmov = AnimationOld(movDict[STATE_BRUSHED]).subjectClip["smallbrushed"];
            brushmovtarget = AnimationOld(movDict[STATE_BRUSHED]).subjectClip["btarget"];
            brushmov.x = tx;
            brushmov.y = ty;
            brushmovtarget.x = _animLocalX;
            brushmovtarget.y = _animLocalY;
         }
         catch(e:Error)
         {
            trace("synchroniseAnimLocs error :: brush sequence ",e);
         }
         try
         {
            brushrapidmov = AnimationOld(movDict[STATE_BRUSHED_RAPID]).subjectClip["smallbrushed"];
            brushrapidmovtarget = AnimationOld(movDict[STATE_BRUSHED_RAPID]).subjectClip["btarget"];
            brushrapidmov.x = tx;
            brushrapidmov.y = ty;
            brushrapidmovtarget.x = _animLocalX;
            brushrapidmovtarget.y = _animLocalY;
         }
         catch(e:Error)
         {
            trace("synchroniseAnimLocs error :: brush rapid sequence ",e);
         }
         try
         {
            completionanim = AnimationOld(movDict[STATE_BOUNCEVOXABLE]).subjectClip["voxable"];
            completionanimtarget = AnimationOld(movDict[STATE_BOUNCEVOXABLE]).subjectClip["target"];
            completionanim.x = _feetLocalX;
            completionanim.y = _feetLocalY;
            completionanimtarget.x = _animLocalX;
            completionanimtarget.y = _animLocalY;
         }
         catch(e:Error)
         {
            trace("synchroniseAnimLocs error :: bounce voxable sequence",e);
         }
         try
         {
            exitseq = AnimationOld(movDict[STATE_EXITSEQ]).subjectClip["smallexit"];
            exitseqtarget = AnimationOld(movDict[STATE_EXITSEQ]).subjectClip["target"];
            exitseq.x = _feetLocalX;
            exitseq.y = _feetLocalY;
            exitseqtarget.x = _animLocalX;
            exitseqtarget.y = _animLocalY;
         }
         catch(e:Error)
         {
            trace("synchroniseAnimLocs error :: exit sequence",e);
         }
         try
         {
            rexitseq = AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["smallexit"];
            rexitseqtarget = AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["target"];
            rexitseq.x = _feetLocalX;
            rexitseq.y = _feetLocalY;
            rexitseqtarget.x = _animLocalX;
            rexitseqtarget.y = _animLocalY;
         }
         catch(e:Error)
         {
            trace("synchroniseAnimLocs error :: rapid exit sequence",e);
         }
      }
      
      public function deactivate() : void
      {
         _isActive = false;
         doRapidExit();
         disableMissedMeVox();
         setVoxable(false);
      }
      
      public function endGame() : void
      {
         _gameOn = false;
         disableMissedMeVox();
         setState(STATE_RAPIDEXIT,1,false);
         AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["smallexit"].gotoAndPlay(1);
      }
      
      private function handleAnimationContainerAdded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.name == "mouth")
         {
            talkerMouth = _loc2_;
            talkerMouth.gotoAndStop(mouthToLabel);
         }
      }
      
      private function handleDepthToFront(param1:Event) : void
      {
         toFrontDepth();
      }
      
      public function getVirtualPlane() : Plane3D
      {
         var _loc1_:Number3D = new Number3D(-this.position.x - worldOffset.x,-this.position.y - worldOffset.y,-this.position.z - worldOffset.z);
         vPlane.setNormalAndPoint(globalPlaneNorm,_loc1_);
         return vPlane;
      }
      
      private function stopAllAnims() : void
      {
         var _loc1_:AnimationOld = null;
         for each(_loc1_ in movDict)
         {
            _loc1_.gotoAndStop(1);
         }
         AnimationOld(movDict[STATE_EXITSEQ]).subjectClip["smallexit"].gotoAndStop(1);
         AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["smallexit"].gotoAndStop(1);
      }
      
      private function handleExitSeqComplete(param1:Event) : void
      {
         endOutro();
      }
      
      public function get footTarget() : MovieClip
      {
         if(!currentAnim)
         {
            return null;
         }
         _footTarget = currentAnim.subjectClip["ftarget"];
         return _footTarget;
      }
      
      public function doIntro() : void
      {
         setState(STATE_ENTRYSEQ,1);
      }
      
      private function checkTurn(param1:String) : void
      {
         if(Math.random() > 0.5)
         {
            doTurn(param1);
         }
      }
      
      private function doTurn(param1:String) : void
      {
         var _loc7_:FrameLabel = null;
         var _loc2_:String = null;
         if(stateStr == STATE_MCLOCKWISE)
         {
            _loc2_ = STATE_MANTICLOCKWISE;
         }
         else
         {
            if(stateStr != STATE_MANTICLOCKWISE)
            {
               return;
            }
            _loc2_ = STATE_MCLOCKWISE;
         }
         var _loc3_:AnimationOld = movDict[_loc2_] as AnimationOld;
         var _loc4_:int = 1;
         var _loc5_:Array = _loc3_.currentLabels;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_] as FrameLabel;
            if(_loc7_.name == param1)
            {
               _loc4_ = _loc7_.frame + 1;
               break;
            }
            _loc6_++;
         }
         setState(_loc2_,_loc4_);
      }
      
      public function get animLocalX() : Number
      {
         return _animLocalX;
      }
      
      public function get animLocalY() : Number
      {
         return _animLocalY;
      }
      
      public function update(param1:Number, param2:Number, param3:Boolean, param4:Boolean = false) : void
      {
         synchroniseAnimLocs();
         if(_gameOn)
         {
            if(param4)
            {
               _hasContact = brushAt(param1,param2,param3,true);
            }
            else
            {
               _hasContact = brushAt(param1,param2,param3);
            }
            if(!param3)
            {
               if(!_hasContact && possibleMiss && allowMiss)
               {
                  possibleMiss = false;
                  if(!missedMeVoxLocked && !currentVoxCtrlAnim)
                  {
                     doMissedMeJibe();
                     missedMeVoxLocked = true;
                     missedMeTimer.reset();
                     missedMeTimer.start();
                  }
                  dispatchEvent(new Event("MISSED"));
               }
               else if(!allowMiss)
               {
                  allowMiss = true;
                  possibleMiss = false;
               }
            }
            else if(_hasContact)
            {
               allowMiss = false;
               dispatchEvent(new Event("POSITIVE_INPUT"));
            }
            else
            {
               possibleMiss = true;
               dispatchEvent(new Event("NEGATIVE_INPUT"));
            }
         }
      }
      
      private function rigTimelineListeners(param1:MovieClip) : void
      {
         if(!param1)
         {
            trace("rigTimelineListeners error :: null reference");
            return;
         }
         param1.addEventListener("CHECK_TURN",handleCheckTurnEv);
         param1.addEventListener("DEPTH_TO_FRONT",handleDepthToFront);
         param1.addEventListener("DEPTH_TO_BACK",handleDepthToBack);
         param1.addEventListener("BOUNCE_CONTACT",handleBounceContact);
         param1.addEventListener(Event.ADDED,handleAnimationContainerAdded);
      }
      
      public function enableMissedMeVox() : void
      {
         missedMeVoxLocked = false;
         missedMeTimer.start();
      }
      
      public function get isActive() : Boolean
      {
         return _isActive;
      }
      
      private function toBackDepth(param1:Boolean = false) : void
      {
         if(!param1)
         {
            TweenMax.to(this,0.3,{"z":this.baseZ + this.backDepth});
         }
         else
         {
            this.z = this.baseZ + this.backDepth;
         }
         isBackDepth = true;
      }
      
      public function endOutro() : void
      {
         setState(STATE_NULL);
         dispatchEvent(new Event("EXIT_COMPLETE"));
      }
      
      public function doRapidExit() : void
      {
         setState(STATE_RAPIDEXIT,1,false);
         AnimationOld(movDict[STATE_RAPIDEXIT]).subjectClip["smallexit"].gotoAndPlay(1);
      }
      
      public function setVoxable(param1:Boolean = true) : void
      {
         if(!param1)
         {
            stopCharacterVox();
         }
         _isVoxable = param1;
      }
      
      public function registerVoxController(param1:String, param2:MovieClip) : void
      {
         var _loc3_:AnimationOld = new AnimationOld(param2);
         voxControllerDict[param1] = _loc3_;
         rigVoxControllerListeners(_loc3_);
      }
      
      public function park() : void
      {
      }
      
      public function activate() : void
      {
         _isActive = true;
         resetAnims();
         toFrontDepth(true);
         initGame();
      }
      
      private function handleIntroSeqComplete(param1:Event) : void
      {
         endIntro();
      }
      
      private function toFrontDepth(param1:Boolean = false) : void
      {
         if(!param1)
         {
            TweenMax.to(this,0.3,{"z":this.baseZ + this.frontDepth});
         }
         else
         {
            this.z = this.baseZ + this.frontDepth;
         }
         isBackDepth = false;
      }
   }
}

