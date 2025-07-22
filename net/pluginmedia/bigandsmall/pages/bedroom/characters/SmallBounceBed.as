package net.pluginmedia.bigandsmall.pages.bedroom.characters
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.pages.livingroom.characters.CompanionCharacter;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.interfaces.IBrainSounderOld;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class SmallBounceBed extends CompanionCharacter
   {
      
      public static const QUEUED_ANIM_STARTING:String = "queuedAnimStarting";
      
      public static const FALLING_ASLEEP:String = "fallingAsleep";
      
      public static const PUT_TO_SLEEP:String = "putToSleep";
      
      public static const WOKEN_UP:String = "wokenUp";
      
      private var _isPlayingVox:Boolean = false;
      
      private var animCount:uint;
      
      public var sleepSequenceStart:uint = 2;
      
      private var doVoxWhenReady:Boolean = false;
      
      public var hasQueue:Boolean = false;
      
      private var animYOffset:Number = 0;
      
      public var calmingCount:uint = 0;
      
      private var _asleep:Boolean = false;
      
      public var nullAnim:MovieClip = new MovieClip();
      
      private var currentAnim:AnimationOld = null;
      
      private var _wakingUp:Boolean = false;
      
      private var _showGreenPillow:Boolean = false;
      
      private var smallJumpMat:SpriteParticleMaterial;
      
      private var smallJump:PointSprite;
      
      private var _showBluePillow:Boolean = false;
      
      private var _hasToyArm:Boolean = false;
      
      public var calmingTotal:uint = 4;
      
      private var animDict:Dictionary;
      
      private var _yawning:Boolean = false;
      
      private var animSequence:Array;
      
      private var _fallingAsleep:Boolean = false;
      
      public function SmallBounceBed(param1:MovieClip = null)
      {
         super();
         if(!param1)
         {
            nullAnim = new MovieClip();
         }
         else
         {
            nullAnim = param1;
         }
         smallJumpMat = new SpriteParticleMaterial(nullAnim);
         smallJump = new PointSprite(smallJumpMat);
         smallJump.size = 0.85;
         setContent(new Dictionary(true));
         addChild(smallJump,"SmallJumpingPointSprite");
         var _loc2_:IBrainSounderOld = SoundManagerOld.getSoundByID("bed_big_tadaididit");
         _loc2_.soundInfo.onCompleteFunc = onTadaaComplete;
      }
      
      public function voxEnd() : void
      {
         _isPlayingVox = false;
         if(currentAnim is AnimationOld && !_fallingAsleep && !_yawning && !_asleep && !_wakingUp)
         {
            if(checkAnimCount())
            {
               dispatchEvent(new Event(QUEUED_ANIM_STARTING));
               if(animCount >= calmingTotal)
               {
                  _fallingAsleep = true;
                  dispatchEvent(new Event(FALLING_ASLEEP));
                  calmingCount = 0;
                  animCount = 0;
               }
            }
            else if(this._isActive)
            {
               currentAnim.playOutLabel("bounce",0,false,int.MAX_VALUE);
            }
         }
      }
      
      private function killCurrentAnim() : void
      {
         if(currentAnim)
         {
            currentAnim.gotoAndStop(1);
            if(isPlayingVox)
            {
               currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleVoxComplete);
            }
         }
      }
      
      public function goHyper() : void
      {
         setAnimState(animSequence[0]);
         doVox();
      }
      
      private function triggerVox() : void
      {
         currentAnim.playOutLabel("voxStart");
         _isPlayingVox = true;
         currentAnim.addEventListener(AnimationOldEvent.COMPLETE,handleVoxComplete);
      }
      
      public function get greenPillowVisible() : Boolean
      {
         return _showGreenPillow;
      }
      
      private function removeAnimListeners(param1:AnimationOld) : void
      {
         if(param1.subjectClip.hasEventListener("BounceDown"))
         {
            param1.subjectClip.removeEventListener("BounceDown",handleBounceDown);
         }
         if(param1.subjectClip.hasEventListener("BounceUp"))
         {
            param1.subjectClip.removeEventListener("BounceUp",handleBounceUp);
         }
         if(param1.hasEventListener(AnimationOldEvent.PROGRESS))
         {
            param1.removeEventListener(AnimationOldEvent.PROGRESS,handleAnimProgress,false);
         }
         if(param1.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            param1.removeEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete,false);
         }
         if(param1.hasEventListener(AnimationOldEvent.LOOP_COMPLETE))
         {
            param1.removeEventListener(AnimationOldEvent.LOOP_COMPLETE,handleAnimLoopComplete,false);
         }
      }
      
      private function handleBounceUp(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleAnimLoopComplete(param1:AnimationOldEvent) : void
      {
         if(_asleep)
         {
            currentAnim.playOutLabel("asleep");
            return;
         }
         if(doVoxWhenReady)
         {
            triggerVox();
            doVoxWhenReady = false;
         }
         if(checkAnimCount())
         {
            return;
         }
      }
      
      private function handleBounceDown(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function get bluePillowVisible() : Boolean
      {
         return _showBluePillow;
      }
      
      public function setGreenPillowVisible(param1:Boolean) : void
      {
         _showGreenPillow = param1;
         updateGreenPillowVis();
      }
      
      public function get isPlayingVox() : Boolean
      {
         return _isPlayingVox;
      }
      
      private function handleAnimProgress(param1:AnimationOldEvent) : void
      {
         if(currentAnim !== null)
         {
            if(currentAnim.subjectClip["arm"] != null)
            {
               currentAnim.subjectClip["arm"].gotoAndStop(currentAnim.currentFrame);
            }
            if(currentAnim.subjectClip["arm_ted"] != null)
            {
               currentAnim.subjectClip["arm_ted"].gotoAndStop(currentAnim.currentFrame);
            }
         }
         dispatchEvent(new AnimationOldEvent(AnimationOldEvent.PROGRESS));
      }
      
      private function updateBluePillowVis() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in animDict)
         {
            if(_loc1_ is AnimationOld)
            {
               if(_loc1_.subjectClip.hasOwnProperty("BluePillow"))
               {
                  MovieClip(_loc1_.subjectClip["BluePillow"]).visible = _showBluePillow;
               }
            }
         }
      }
      
      public function get bounceMag() : uint
      {
         if(_fallingAsleep)
         {
            return calmingTotal + 1;
         }
         if(_asleep)
         {
            return calmingTotal + 1;
         }
         return animCount;
      }
      
      public function setContent(param1:Dictionary, param2:Array = null) : void
      {
         var _loc3_:MovieClip = null;
         animDict = param1;
         animDict["NULL"] = nullAnim;
         smallJumpMat.movie = nullAnim;
         for each(_loc3_ in animDict)
         {
            if(_loc3_ is AnimationOld)
            {
               attachAnimListeners(AnimationOld(_loc3_));
            }
         }
         animSequence = param2;
         updateArmVis();
      }
      
      public function setAnimState(param1:String) : void
      {
         killCurrentAnim();
         currentAnim = animDict[param1] as AnimationOld;
         if(!currentAnim)
         {
            BrainLogger.warning("SmallBounceBed :: setAnimState :: Warning - no movie asset for label:",param1);
            return;
         }
         smallJumpMat.movie = currentAnim;
         currentAnim.gotoAndStop(1);
         _isPlayingVox = false;
         if(currentAnim is AnimationOld && this._isActive)
         {
            currentAnim.playOutLabel("bounce",0,false,int.MAX_VALUE);
         }
      }
      
      public function defaultAnimState() : void
      {
         setAnimState("NULL");
      }
      
      private function onTadaaComplete() : void
      {
      }
      
      private function handleAnimComplete(param1:AnimationOldEvent) : void
      {
         if(!_fallingAsleep && !_yawning && !_asleep && !_wakingUp && animCount >= calmingCount)
         {
            dispatchEvent(new AnimationOldEvent(AnimationOldEvent.COMPLETE));
         }
         else if(_fallingAsleep)
         {
            currentAnim.playOutLabel("yawn");
            _fallingAsleep = false;
            _yawning = true;
         }
         else if(_yawning)
         {
            _yawning = false;
            _asleep = true;
            currentAnim.playOutLabel("asleep",0,false,2);
            currentAnim.subjectClip.addEventListener("playTadaa",handlePlayTadaa,false,0,true);
            dispatchEvent(new Event(PUT_TO_SLEEP));
         }
         else if(_asleep)
         {
            currentAnim.playOutLabel("get up");
            _asleep = false;
            _wakingUp = true;
            dispatchEvent(new Event(WOKEN_UP));
         }
         else if(_wakingUp)
         {
            defaultAnimState();
            setAnimState(animSequence[sleepSequenceStart - 1]);
            reset();
            _wakingUp = false;
            dispatchEvent(new AnimationOldEvent(AnimationOldEvent.COMPLETE));
         }
      }
      
      private function updateArmVis() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in animDict)
         {
            if(_loc1_ is AnimationOld)
            {
               if(_loc1_.subjectClip["arm"] != null)
               {
                  MovieClip(_loc1_.subjectClip["arm"]).visible = !_hasToyArm;
               }
               if(_loc1_.subjectClip["arm_ted"] != null)
               {
                  MovieClip(_loc1_.subjectClip["arm_ted"]).visible = _hasToyArm;
               }
            }
         }
      }
      
      public function addCalmingInfluence() : void
      {
         ++calmingCount;
         if(calmingCount >= calmingTotal)
         {
            if(!_isPlayingVox)
            {
               calmingCount = 0;
               animCount = 0;
               _fallingAsleep = true;
               dispatchEvent(new Event(FALLING_ASLEEP));
               setAnimState(animSequence[animSequence.length - 1]);
               doVox();
            }
         }
      }
      
      public function doVox() : void
      {
         if(currentAnim is AnimationOld)
         {
            doVoxWhenReady = true;
         }
         else
         {
            BrainLogger.warning("SmallBounceBed :: doLabelAnim :: Warning - currentAnim is not an Animation");
         }
      }
      
      public function reset() : void
      {
         _fallingAsleep = false;
         _yawning = false;
         _asleep = false;
         _wakingUp = false;
         hasQueue = false;
         calmingCount = 0;
         animCount = 0;
      }
      
      public function setBluePillowVisible(param1:Boolean) : void
      {
         _showBluePillow = param1;
         updateBluePillowVis();
      }
      
      private function checkAnimCount() : Boolean
      {
         var _loc1_:Boolean = false;
         if(calmingCount > animCount)
         {
            hasQueue = true;
            ++animCount;
            setAnimState(animSequence[animCount + sleepSequenceStart - 1]);
            triggerVox();
            _loc1_ = true;
         }
         else
         {
            hasQueue = false;
         }
         return _loc1_;
      }
      
      public function get hasToyArm() : Boolean
      {
         return _hasToyArm;
      }
      
      private function handlePlayTadaa(param1:Event) : void
      {
         SoundManagerOld.playSound("bed_big_tadaididit");
         currentAnim.subjectClip.removeEventListener("playTadaa",handlePlayTadaa);
      }
      
      public function get animationSequence() : Array
      {
         return animSequence;
      }
      
      private function attachAnimListeners(param1:AnimationOld) : void
      {
         if(!param1.subjectClip.hasEventListener("BounceDown"))
         {
            param1.subjectClip.addEventListener("BounceDown",handleBounceDown,false,0,true);
         }
         if(!param1.subjectClip.hasEventListener("BounceUp"))
         {
            param1.subjectClip.addEventListener("BounceUp",handleBounceUp,false,0,true);
         }
         if(!param1.hasEventListener(AnimationOldEvent.PROGRESS))
         {
            param1.addEventListener(AnimationOldEvent.PROGRESS,handleAnimProgress,false,0,true);
         }
         if(!param1.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            param1.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete,false,0,true);
         }
         if(!param1.hasEventListener(AnimationOldEvent.LOOP_COMPLETE))
         {
            param1.addEventListener(AnimationOldEvent.LOOP_COMPLETE,handleAnimLoopComplete,false,0,true);
         }
      }
      
      public function setTeddyVisible(param1:Boolean) : void
      {
         _hasToyArm = param1;
         updateArmVis();
      }
      
      private function handleVoxComplete(param1:AnimationOldEvent) : void
      {
         currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleVoxComplete);
         voxEnd();
         if(!_asleep && !_yawning && !_fallingAsleep && !_wakingUp)
         {
            dispatchEvent(new Event("VOX_COMPLETE"));
         }
      }
      
      override public function activate() : void
      {
         super.activate();
         visible = true;
         smallJump.visible = true;
         _hasToyArm = false;
         _showBluePillow = false;
         _showGreenPillow = false;
         updateArmVis();
         updateBluePillowVis();
         updateGreenPillowVis();
         defaultAnimState();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         defaultAnimState();
         visible = false;
         smallJump.visible = false;
         smallJumpMat.removeSprite();
      }
      
      private function updateGreenPillowVis() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in animDict)
         {
            if(_loc1_ is AnimationOld)
            {
               if(_loc1_.subjectClip.hasOwnProperty("GreenPillow"))
               {
                  MovieClip(_loc1_.subjectClip["GreenPillow"]).visible = _showGreenPillow;
               }
            }
         }
      }
   }
}

