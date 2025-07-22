package net.pluginmedia.bigandsmall.pages.bedroom.characters
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.pages.livingroom.characters.CompanionCharacter;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSpriteMovieUpdater;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class BigInBed extends CompanionCharacter
   {
      
      public static const BIG_REACT:String = "BigInBed.BIG_REACT";
      
      public static const THRASH_COMPLETE:String = "thrashComplete";
      
      public static const WOKEN_UP:String = "wokenUp";
      
      public static const FALLEN_ASLEEP:String = "fallenAsleep";
      
      private var breatheOutStrRef:String;
      
      private var bigMouthBreatheOutOffs:Number;
      
      private var bigTummy:MovieClip;
      
      private var bigTumBreatheOutOffs:Number;
      
      private var sleepUpdaterAnim:MovieClip;
      
      private var bigMouth:MovieClip;
      
      private var bigsLeftHand:MovieClip;
      
      private var currentAnim:MovieClip = null;
      
      private var snoreCollectionIn:BrainSoundCollectionOld;
      
      public var stimulusTotal:uint = 5;
      
      private var bigMouthSnore:MovieClip;
      
      private var bigTumBreatheOutFr:Number;
      
      private var greenPillow:MovieClip;
      
      private var bigPointSpriteMat:SpriteParticleMaterial;
      
      private var breatheInStrRef:String;
      
      private var bigMouthBreatheInFr:Number;
      
      protected var _stimCount:uint = 0;
      
      private var bigPointSprite:PointSpriteMovieUpdater;
      
      private var bluePillow:MovieClip;
      
      private var _greenVisible:Boolean = false;
      
      private var animDict:Dictionary = new Dictionary();
      
      private var snoreCollectionOut:BrainSoundCollectionOld;
      
      private var bigTumBreatheInFr:Number;
      
      private var animSequence:Array;
      
      private var _blueVisible:Boolean = false;
      
      private var bigMouthBreatheOutFr:Number;
      
      public function BigInBed(param1:MovieClip = null)
      {
         super();
         if(param1 === null)
         {
            sleepUpdaterAnim = new MovieClip();
            BrainLogger.warning("BigInBed :: [constructor] - default animation is null reference");
         }
         else
         {
            sleepUpdaterAnim = param1;
         }
         currentAnim = sleepUpdaterAnim;
         bigPointSpriteMat = new SpriteParticleMaterial(currentAnim);
         bigPointSprite = new PointSpriteMovieUpdater(bigPointSpriteMat,-32.835,-0.084);
         bigPointSprite.size = 0.87;
         addChild(bigPointSprite,"BigSleeping");
         bigMouth = sleepUpdaterAnim.bigMouthAnim;
         bigMouth.stop();
         bigMouthSnore = sleepUpdaterAnim.bigMouthAnim.bigMouth;
         var _loc2_:AnimationOld = new AnimationOld(bigMouthSnore,false);
         bigMouthBreatheInFr = _loc2_.getLengthOfLabel("breatheIn");
         bigMouthBreatheOutFr = _loc2_.getLengthOfLabel("breatheOut");
         _loc2_.gotoAndStop("breatheOut");
         bigMouthBreatheOutOffs = _loc2_.currentFrame;
         _loc2_.gotoAndStop(1);
         bigTummy = sleepUpdaterAnim.bigSnoringTummy;
         var _loc3_:AnimationOld = new AnimationOld(bigTummy,false);
         _loc3_.gotoAndStop("breatheOut");
         bigTumBreatheInFr = _loc3_.getLengthOfLabel("breatheIn");
         bigTumBreatheOutFr = _loc3_.getLengthOfLabel("breatheOut");
         bigTumBreatheOutOffs = _loc3_.currentFrame;
         _loc3_.gotoAndStop(1);
         bigsLeftHand = bigTummy.bigLeftHand;
         bigsLeftHand.stop();
         greenPillow = sleepUpdaterAnim.GreenPillow;
         bluePillow = sleepUpdaterAnim.BluePillow;
         setBluePillowVisible(false);
         setGreenPillowVisible(false);
         animDict["NULL"] = sleepUpdaterAnim;
      }
      
      public function registerReaction(param1:String, param2:MovieClip, param3:Sound) : void
      {
         SoundManager.quickRegisterSound(BIG_REACT + param1,param3);
         animDict[param1] = param2;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         sleepUpdaterAnim.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
      
      public function addStimulus() : void
      {
         ++_stimCount;
         stopSnores();
         setAnimState("BigReaction" + _stimCount.toString());
         if(_stimCount >= stimulusTotal)
         {
            dispatchEvent(new Event(WOKEN_UP));
         }
      }
      
      private function killCurrentAnim() : void
      {
         if(currentAnim !== sleepUpdaterAnim && currentAnim !== null)
         {
            currentAnim.gotoAndStop(1);
         }
      }
      
      public function setGreenPillowVisible(param1:Boolean) : void
      {
      }
      
      private function removeAnimListeners(param1:AnimationOld) : void
      {
         if(param1.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            param1.removeEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete,false);
         }
         if(param1.hasEventListener("bigFallenAsleep"))
         {
            param1.removeEventListener("bigFallenAsleep",handleBigFallenAsleep);
         }
      }
      
      public function stopSnores() : void
      {
         SoundManagerOld.stopSound("big_snore_in");
         SoundManagerOld.stopSound("big_snore_out");
      }
      
      private function handleBigFallenAsleep(param1:Event = null) : void
      {
         dispatchEvent(new Event(FALLEN_ASLEEP));
      }
      
      private function attachAnimListeners(param1:AnimationOld) : void
      {
         if(!param1.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            param1.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete,false,0,true);
         }
         if(!param1.subjectClip.hasEventListener("bigFallenAsleep"))
         {
            param1.subjectClip.addEventListener("bigFallenAsleep",handleBigFallenAsleep);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(currentAnim === sleepUpdaterAnim)
         {
            updateChildParts();
         }
      }
      
      private function handleSnoreInProgress(param1:Number) : void
      {
         var _loc2_:int = Math.round(param1 * bigTumBreatheInFr);
         bigTummy.gotoAndStop(_loc2_);
         bigMouthSnore.gotoAndStop(bigTummy.currentFrame);
      }
      
      private function handleSnoreOutProgress(param1:Number) : void
      {
         var _loc2_:int = Math.round(param1 * bigTumBreatheOutFr);
         bigTummy.gotoAndStop(bigTumBreatheOutOffs + _loc2_);
         bigMouthSnore.gotoAndStop(bigTummy.currentFrame);
      }
      
      private function handleSnoreInComplete() : void
      {
         SoundManagerOld.playSound("big_snore_out");
      }
      
      public function setAnimState(param1:String) : void
      {
         killCurrentAnim();
         currentAnim = animDict[param1] as MovieClip;
         if(currentAnim === null)
         {
            BrainLogger.warning("BigInBed :: setAnimState :: Warning - no movie asset for label:",param1);
            return;
         }
         bigPointSpriteMat.movie = currentAnim;
         if(currentAnim != sleepUpdaterAnim)
         {
            bigPointSprite.doUpdateClip = false;
            if(currentAnim)
            {
               SoundManager.playSyncAnimSound(currentAnim,BIG_REACT + param1,SoundChannelDefinitions.VOX,25,1,0,0,0,handleAnimComplete);
            }
         }
         else
         {
            bigPointSprite.doUpdateClip = true;
         }
      }
      
      public function defaultAnimState() : void
      {
         setAnimState("NULL");
         if(this.isActive)
         {
            SoundManagerOld.playSound("big_snore_in");
         }
      }
      
      private function handleSnoreOutComplete() : void
      {
         SoundManagerOld.playSound("big_snore_in");
      }
      
      public function get stimCount() : int
      {
         return _stimCount;
      }
      
      private function updateChildParts() : void
      {
         if(bigsLeftHand !== null)
         {
            bigsLeftHand.gotoAndStop(sleepUpdaterAnim.currentFrame);
         }
         if(bigMouth !== null)
         {
            bigMouth.gotoAndStop(sleepUpdaterAnim.currentFrame);
         }
         if(bigMouthSnore !== null)
         {
         }
         if(bigTummy !== null)
         {
         }
         if(greenPillow !== null)
         {
            greenPillow.gotoAndStop(sleepUpdaterAnim.currentFrame);
         }
         if(bluePillow !== null)
         {
            bluePillow.gotoAndStop(sleepUpdaterAnim.currentFrame);
         }
      }
      
      public function setBluePillowVisible(param1:Boolean) : void
      {
      }
      
      private function handleAnimComplete(param1:AnimationOldEvent = null) : void
      {
         defaultAnimState();
         dispatchEvent(new Event(THRASH_COMPLETE));
         if(_stimCount == 0)
         {
            dispatchEvent(new Event(FALLEN_ASLEEP));
         }
      }
      
      public function setSnoreCollections(param1:BrainSoundCollectionOld, param2:BrainSoundCollectionOld) : void
      {
         snoreCollectionIn = param1;
         snoreCollectionIn.soundInfo.onProgressFunc = handleSnoreInProgress;
         snoreCollectionIn.soundInfo.onCompleteFunc = handleSnoreInComplete;
         snoreCollectionOut = param2;
         snoreCollectionOut.soundInfo.onProgressFunc = handleSnoreOutProgress;
         snoreCollectionOut.soundInfo.onCompleteFunc = handleSnoreOutComplete;
         breatheInStrRef = snoreCollectionIn.strID;
         breatheOutStrRef = snoreCollectionOut.strID;
      }
      
      override public function activate() : void
      {
         super.activate();
         visible = true;
         bigPointSprite.visible = true;
         defaultAnimState();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         sleepUpdaterAnim.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         defaultAnimState();
         visible = false;
         bigPointSprite.visible = false;
         bigPointSpriteMat.removeSprite();
         SoundManagerOld.stopSound("big_snore_in");
         SoundManagerOld.stopSound("big_snore_out");
      }
      
      public function resetStimuli() : void
      {
         _stimCount = 0;
      }
   }
}

