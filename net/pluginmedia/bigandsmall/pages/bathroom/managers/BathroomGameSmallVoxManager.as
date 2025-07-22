package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   
   public class BathroomGameSmallVoxManager extends EventDispatcher
   {
      
      private var smallLipSyncAnims:Dictionary;
      
      private var controllerMouth:MovieClip;
      
      private var controllerClip:MovieClip;
      
      private var bigLipSyncClips:Dictionary;
      
      private var timeoutLast:Number = -1;
      
      private var smallLipSyncClips:Dictionary;
      
      private var bigIntroAnims:Array;
      
      private var bigBrushedAnimLast:Number = -1;
      
      private var bigMouthToLabel:String;
      
      private var timeoutAnims:Array;
      
      private var bigControllerClip:MovieClip;
      
      private var bigIntroAnimLast:Number = -1;
      
      private var smallFailAnimLast:Number = -1;
      
      private var smallFailAnims:Array;
      
      private var talkInProgress:Boolean = false;
      
      private var _smallLipSyncNames:Array;
      
      private var talkerClip:MovieClip;
      
      private var smallLeapAnims:Array;
      
      private var controllerAnim:AnimationOld;
      
      private var bigTalkerMouth:MovieClip;
      
      private var bigBrushedAnims:Array;
      
      private var activeMouth:MovieClip;
      
      private var smallSuccessAnimLast:Number = -1;
      
      private var talkerBig:Boolean = false;
      
      private var bigTalkerClip:MovieClip;
      
      private var bigControllerMouth:MovieClip;
      
      private var smallSuccessAnims:Array;
      
      private var mouthToLabel:String;
      
      private var bigLipSyncAnims:Dictionary;
      
      private var smallLeapAnimLast:Number = -1;
      
      private var _bigLipSyncNames:Array;
      
      private var bigControllerAnim:AnimationOld;
      
      public function BathroomGameSmallVoxManager()
      {
         super();
         _smallLipSyncNames = [];
         _smallLipSyncNames.push("bath_small_aaghsoclose");
         _smallLipSyncNames.push("bath_small_BIG");
         _smallLipSyncNames.push("bath_small_bigyoumoved");
         _smallLipSyncNames.push("bath_small_cmonletsgetbouncing");
         _smallLipSyncNames.push("bath_small_dontworrybig");
         _smallLipSyncNames.push("bath_small_letsgetbigsteethbrushed");
         _smallLipSyncNames.push("bath_small_oobutimnotgivingup");
         _smallLipSyncNames.push("bath_small_thisismorefunthat");
         _smallLipSyncNames.push("bath_small_bigyourteethareso");
         _smallLipSyncNames.push("bath_small_yayimthebest");
         _smallLipSyncNames.push("bath_small_bounceBrush");
         _smallLipSyncNames.push("bath_small_ImTheBest");
         _smallLipSyncNames.push("bath_small_missed");
         _smallLipSyncNames.push("bath_small_shinyClean");
         _smallLipSyncNames.push("bath_small_smallToTheRescue");
         _smallLipSyncNames.push("bath_small_upupAndAway");
         _smallLipSyncNames.push("bath_small_weehee");
         _smallLipSyncNames.push("bath_small_yippee");
         _smallLipSyncNames.push("bath_small_getbrushing");
         _smallLipSyncNames.push("bath_small_blastoff");
         _bigLipSyncNames = [];
         _bigLipSyncNames.push("BigHeadCantStopDancing");
         _bigLipSyncNames.push("BigHeadHeySmallThanks");
         _bigLipSyncNames.push("BigHeadTellYouWhat");
         _bigLipSyncNames.push("BigHeadYayILoveHavingMyTeethClean");
      }
      
      public function setActiveTalker(param1:MovieClip) : void
      {
         talkerClip = param1;
         var _loc2_:MovieClip = param1.mouth;
         if(_loc2_ !== null)
         {
            _loc2_.gotoAndStop(1);
            activeMouth = _loc2_;
         }
         talkerClip.addEventListener(Event.ADDED,handleMouthContainerChildAdded);
      }
      
      public function setSmallLipSyncClips(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:AnimationOld = null;
         smallLipSyncClips = param1;
         smallLipSyncAnims = new Dictionary();
         for(_loc2_ in param1)
         {
            _loc3_ = new AnimationOld(param1[_loc2_],true);
            smallLipSyncAnims[_loc2_] = _loc3_;
         }
         smallLeapAnims = [];
         smallLeapAnims.push("bath_small_BIG");
         smallLeapAnims.push("bath_small_blastoff");
         smallLeapAnims.push("bath_small_yippee");
         smallLeapAnims.push("bath_small_upupAndAway");
         smallLeapAnims.push("bath_small_smallToTheRescue");
         smallLeapAnims.push("bath_small_ImTheBest");
         smallLeapAnims.push("bath_small_bounceBrush");
         smallLeapAnims.push("bath_small_shinyClean");
         smallLeapAnims.push("bath_small_weehee");
         smallFailAnims = [];
         smallFailAnims.push("bath_small_aaghsoclose");
         smallFailAnims.push("bath_small_bigyoumoved");
         smallFailAnims.push("bath_small_missed");
         smallFailAnims.push("bath_small_oobutimnotgivingup");
         smallSuccessAnims = [];
         smallSuccessAnims.push("bath_small_yayimthebest");
         smallSuccessAnims.push("bath_small_thisismorefunthat");
         smallSuccessAnims.push("bath_small_bigyourteethareso");
         if(timeoutAnims == null)
         {
            timeoutAnims = [];
         }
         timeoutAnims.push("bath_small_getbrushing");
         timeoutAnims.push("bath_small_letsgetbigsteethbrushed");
         timeoutAnims.push("bath_small_cmonletsgetbouncing");
         timeoutAnims.push("bath_small_dontworrybig");
         if(bigBrushedAnims == null)
         {
            bigBrushedAnims = [];
         }
         bigBrushedAnims.push("bath_small_yayimthebest");
         bigBrushedAnims.push("bath_small_bigyourteethareso");
      }
      
      public function playLipSync(param1:String) : void
      {
         stopLipSync();
         if(param1.slice(0,3) == "Big")
         {
            bigControllerAnim = bigLipSyncAnims[param1];
            bigControllerClip = bigControllerAnim.subjectClip;
            addBigLipSyncListeners();
            bigControllerAnim.loop(1);
            talkerBig = true;
         }
         else
         {
            controllerAnim = smallLipSyncAnims[param1];
            controllerClip = controllerAnim.subjectClip;
            addSmallLipSyncListeners();
            controllerAnim.loop(1);
            talkerBig = false;
         }
         talkInProgress = true;
         bindVoxChannel();
      }
      
      private function getSudoRandIndex(param1:int, param2:Array) : int
      {
         var _loc3_:int = param1;
         if(param2.length == 1)
         {
            _loc3_ = 0;
         }
         else
         {
            while(_loc3_ == param1)
            {
               _loc3_ = Math.random() * param2.length;
            }
         }
         return _loc3_;
      }
      
      public function playTimeout() : void
      {
         timeoutLast = getSudoRandIndex(timeoutLast,timeoutAnims);
         playLipSync(timeoutAnims[timeoutLast]);
      }
      
      private function handleBigMouthControllerChildAdded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = "MouthShape_";
         if(_loc2_.name.substr(0,11) == _loc3_)
         {
            bigMouthToLabel = _loc2_.name.substr(_loc3_.length);
            if(bigTalkerMouth)
            {
               bigTalkerMouth.gotoAndStop(bigMouthToLabel);
            }
         }
      }
      
      private function handleBigIntroVoxComplete(param1:AnimationOldEvent) : void
      {
         var _loc2_:AnimationOld = bigLipSyncAnims["BigHeadCantStopDancing"];
         _loc2_.removeEventListener(AnimationOldEvent.COMPLETE,handleBigIntroVoxComplete);
         playLipSync("bath_small_dontworrybig");
      }
      
      private function removeBigLipSyncListeners() : void
      {
         bigControllerAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleBigControllerAnimComplete);
         bigControllerClip.removeEventListener(Event.ADDED,handleBigMouthControllerChildAdded);
      }
      
      private function removeSmallLipSyncListeners() : void
      {
         controllerClip.removeEventListener(Event.ADDED,handleMouthControllerChildAdded);
         controllerAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleControllerComplete);
      }
      
      private function addSmallLipSyncListeners() : void
      {
         controllerClip.addEventListener(Event.ADDED,handleMouthControllerChildAdded);
         controllerAnim.addEventListener(AnimationOldEvent.COMPLETE,handleControllerComplete);
      }
      
      private function handleMouthControllerChildAdded(param1:Event) : void
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
            if(activeMouth)
            {
               activeMouth.gotoAndStop(mouthToLabel);
            }
         }
      }
      
      private function handleMouthContainerChildAdded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ !== null)
         {
            if(_loc2_.name == "mouth")
            {
               activeMouth = _loc2_;
               if(mouthToLabel)
               {
                  activeMouth.gotoAndStop(mouthToLabel);
               }
               else
               {
                  activeMouth.stop();
               }
            }
         }
      }
      
      public function playBigIntro() : void
      {
         playLipSync("BigHeadCantStopDancing");
         var _loc1_:AnimationOld = bigLipSyncAnims["BigHeadCantStopDancing"];
         _loc1_.addEventListener(AnimationOldEvent.COMPLETE,handleBigIntroVoxComplete);
      }
      
      private function unbindVoxChannel() : void
      {
         SoundManagerOld.unSelectChannel(1);
      }
      
      public function setBigLipSyncAnims(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:AnimationOld = null;
         bigLipSyncAnims = new Dictionary();
         bigLipSyncClips = param1;
         for(_loc2_ in param1)
         {
            _loc3_ = new AnimationOld(param1[_loc2_],true);
            bigLipSyncAnims[_loc2_] = _loc3_;
         }
         if(bigBrushedAnims == null)
         {
            bigBrushedAnims = [];
         }
         bigBrushedAnims.push("BigHeadHeySmallThanks");
         bigBrushedAnims.push("BigHeadYayILoveHavingMyTeethClean");
         if(timeoutAnims == null)
         {
            timeoutAnims = [];
         }
         timeoutAnims.push("BigHeadTellYouWhat");
      }
      
      private function handleBigMouthContainerChildAdded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ !== null)
         {
            if(_loc2_.name == "mouth")
            {
               bigTalkerMouth = _loc2_;
               if(talkInProgress && talkerBig)
               {
                  if(bigMouthToLabel)
                  {
                     bigTalkerMouth.gotoAndStop(bigMouthToLabel);
                  }
                  else
                  {
                     bigTalkerMouth.gotoAndStop(1);
                  }
               }
               else
               {
                  bigTalkerMouth.gotoAndStop("aa");
               }
            }
         }
      }
      
      public function setBigTalker(param1:MovieClip) : void
      {
         bigTalkerClip = param1;
         var _loc2_:MovieClip = param1.mouth;
         if(_loc2_ !== null)
         {
            _loc2_.gotoAndStop(1);
            bigTalkerMouth = _loc2_;
         }
         bigTalkerClip.addEventListener(Event.ADDED,handleBigMouthContainerChildAdded);
      }
      
      public function get smallLipSyncNames() : Array
      {
         return _smallLipSyncNames;
      }
      
      private function addBigLipSyncListeners() : void
      {
         bigControllerAnim.addEventListener(AnimationOldEvent.COMPLETE,handleBigControllerAnimComplete);
         bigControllerClip.addEventListener(Event.ADDED,handleBigMouthControllerChildAdded);
      }
      
      private function handleControllerComplete(param1:AnimationOldEvent) : void
      {
         removeSmallLipSyncListeners();
         controllerAnim.stop();
         if(!activeMouth)
         {
         }
         talkInProgress = false;
         unbindVoxChannel();
      }
      
      private function bindVoxChannel() : void
      {
         if(SoundManagerOld.channelOccupied(1))
         {
            SoundManagerOld.stopSoundChannel(1,0.5);
         }
         SoundManagerOld.selectChannel(1);
      }
      
      public function playSmallLeap() : void
      {
         smallLeapAnimLast = getSudoRandIndex(smallLeapAnimLast,smallLeapAnims);
         playLipSync(smallLeapAnims[smallLeapAnimLast]);
      }
      
      public function playSmallSuccess() : void
      {
         smallSuccessAnimLast = getSudoRandIndex(smallSuccessAnimLast,smallSuccessAnims);
         playLipSync(smallSuccessAnims[smallSuccessAnimLast]);
      }
      
      public function get bigLipSyncNames() : Array
      {
         return _bigLipSyncNames;
      }
      
      public function playBigBrushedReaction() : void
      {
         bigBrushedAnimLast = getSudoRandIndex(bigBrushedAnimLast,bigBrushedAnims);
         playLipSync(bigBrushedAnims[bigBrushedAnimLast]);
      }
      
      public function playSmallFail() : void
      {
         smallFailAnimLast = getSudoRandIndex(smallFailAnimLast,smallFailAnims);
         playLipSync(smallFailAnims[smallFailAnimLast]);
      }
      
      public function stopLipSync() : void
      {
         if(talkInProgress)
         {
            if(talkerBig)
            {
               removeBigLipSyncListeners();
               bigControllerAnim.stop();
               bigTalkerMouth.gotoAndStop("aa");
            }
            else
            {
               removeSmallLipSyncListeners();
               controllerAnim.stop();
               activeMouth.gotoAndStop("a");
            }
         }
      }
      
      private function handleBigControllerAnimComplete(param1:AnimationOldEvent) : void
      {
         if(bigTalkerMouth)
         {
            bigTalkerMouth.gotoAndStop("aa");
         }
         removeBigLipSyncListeners();
         bigControllerAnim.stop();
         talkInProgress = false;
         unbindVoxChannel();
      }
   }
}

