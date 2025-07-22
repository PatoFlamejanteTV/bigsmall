package net.pluginmedia.bigandsmall.core.animation
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   
   public class AnimationOld extends MovieClip
   {
      
      public static var PBSTATE_PLAYOUTLABEL:String = "PBSTATE_PLAYOUTLABEL";
      
      public static var PBSTATE_STEPOUTLABEL:String = "PBSTATE_STEPOUTLABEL";
      
      public static var PBSTATE_TOTARGETFRAME:String = "PBSTATE_TOFRAME";
      
      public static var PBSTATE_TONEXTLABEL:String = "PBSTATE_TONEXTLABEL";
      
      public static var PBSTATE_PREFINISH:String = "PBSTATE_PREFINISH";
      
      public static var PBSTATE_STOPPED:String = "PBSTATE_STOPPED";
      
      public static var PBSTATE_LOOPING:String = "PBSTATE_LOOPING";
      
      private var prevLabel:String = "_";
      
      private var playBackState:String = PBSTATE_STOPPED;
      
      private var _isPlaying:Boolean = false;
      
      private var startFrame:int = 0;
      
      private var forceStartTime:int = 0;
      
      private var loopCounter:int = 0;
      
      private var forceFrameRate:int = 0;
      
      private var paddingCounter:int = 0;
      
      private var endFrame:int = 0;
      
      public var frameStep:Number = 1;
      
      private var targetFrame:Number = -1;
      
      private var _subjectClip:MovieClip = null;
      
      private var forceStartFrame:int = 0;
      
      private var animLabels:Array = [];
      
      public function AnimationOld(param1:MovieClip, param2:Boolean = true, param3:int = 0)
      {
         super();
         forceFrameRate = param3;
         registerMovieClip(param1,param2);
         this.mouseChildren = false;
      }
      
      override public function stop() : void
      {
         doStop();
      }
      
      override public function get totalFrames() : int
      {
         return _subjectClip.totalFrames;
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         doStop();
         _subjectClip.gotoAndStop(param1,param2);
      }
      
      public function playOutLabel(param1:String = null, param2:int = 0, param3:Boolean = false, param4:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         doStop();
         loopCounter = param4;
         var _loc5_:FrameLabel = null;
         startFrame = 0;
         endFrame = 0;
         if(animLabels.length > 1 && param1 !== null)
         {
            _loc6_ = 0;
            while(_loc6_ < animLabels.length)
            {
               _loc5_ = animLabels[_loc6_] as FrameLabel;
               if(_loc5_.name == param1)
               {
                  startFrame = _loc5_.frame;
                  break;
               }
               _loc6_++;
            }
            _loc7_ = _loc6_ + 1;
            if(_loc7_ > animLabels.length - 1)
            {
               _loc7_ = 0;
            }
            _loc5_ = animLabels[_loc7_] as FrameLabel;
            endFrame = _loc5_.frame - 1;
            endFrame = validateFrameStep(endFrame);
         }
         else
         {
            startFrame = 1;
            endFrame = subjectClip.totalFrames;
         }
         if(!param3)
         {
            _subjectClip.gotoAndPlay(startFrame);
            targetFrame = endFrame;
            setState(PBSTATE_PLAYOUTLABEL);
         }
         else
         {
            _subjectClip.gotoAndStop(endFrame);
            targetFrame = startFrame;
            setState(PBSTATE_TOTARGETFRAME);
         }
         doPlay();
      }
      
      public function get subjectClip() : MovieClip
      {
         return _subjectClip;
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      public function doStop() : void
      {
         startFrame = 0;
         endFrame = 0;
         loopCounter = 0;
         paddingCounter = 0;
         removeEnterFrameListener();
         _isPlaying = false;
         _subjectClip.stop();
      }
      
      private function stepTowardsNextLabel() : void
      {
         var _loc1_:Number = _subjectClip.currentFrame;
         var _loc2_:String = _subjectClip.currentLabel;
         var _loc3_:Number = 0;
         if(_loc2_ == prevLabel)
         {
            _loc3_ = _loc1_ + frameStep;
            _loc3_ = validateFrameStep(_loc3_);
            _subjectClip.gotoAndStop(_loc3_);
         }
         else
         {
            setState(PBSTATE_PREFINISH);
         }
         prevLabel = _loc2_;
      }
      
      public function stepOutLabel(param1:String = null, param2:int = 0, param3:Boolean = false, param4:Number = 1) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.frameStep = param4;
         doStop();
         var _loc5_:FrameLabel = null;
         startFrame = 0;
         endFrame = 0;
         if(animLabels.length > 1 && param1 !== null)
         {
            _loc6_ = 0;
            while(_loc6_ < animLabels.length)
            {
               _loc5_ = animLabels[_loc6_] as FrameLabel;
               if(_loc5_.name == param1)
               {
                  startFrame = _loc5_.frame;
                  break;
               }
               _loc6_++;
            }
            _loc7_ = _loc6_ + 1;
            if(_loc7_ > animLabels.length - 1)
            {
               _loc7_ = 0;
            }
            _loc5_ = animLabels[_loc7_] as FrameLabel;
            endFrame = _loc5_.frame - 1;
            endFrame = validateFrameStep(endFrame);
         }
         else
         {
            startFrame = 1;
            endFrame = subjectClip.totalFrames;
         }
         if(!param3)
         {
            _subjectClip.gotoAndStop(startFrame);
            targetFrame = endFrame;
            setState(PBSTATE_STEPOUTLABEL);
         }
         else
         {
            _subjectClip.gotoAndStop(endFrame);
            targetFrame = startFrame;
            setState(PBSTATE_TOTARGETFRAME);
         }
         doPlay();
      }
      
      override public function play() : void
      {
         doStop();
         _subjectClip.play();
         doPlay();
      }
      
      public function playToNextLabel(param1:int = 0) : void
      {
         doStop();
         setState(PBSTATE_TONEXTLABEL);
         paddingCounter = param1;
         prevLabel = _subjectClip.currentLabel;
         doPlay();
      }
      
      public function registerMovieClip(param1:MovieClip, param2:Boolean) : void
      {
         _subjectClip = param1;
         _subjectClip.gotoAndStop(1);
         animLabels = _subjectClip.currentLabels;
         if(param2)
         {
            addChild(param1);
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         switch(playBackState)
         {
            case PBSTATE_PLAYOUTLABEL:
               stepTowardsTargetFrame(false);
               break;
            case PBSTATE_STEPOUTLABEL:
               stepTowardsTargetFrame(true);
               break;
            case PBSTATE_TOTARGETFRAME:
               stepTowardsTargetFrame(true);
               break;
            case PBSTATE_TONEXTLABEL:
               stepTowardsNextLabel();
               break;
            case PBSTATE_LOOPING:
               stepLoopingPhase();
               break;
            case PBSTATE_PREFINISH:
               stepPreFinishPhase();
         }
         if(this.hasEventListener(AnimationOldEvent.PROGRESS))
         {
            dispatchEvent(new AnimationOldEvent(AnimationOldEvent.PROGRESS));
         }
      }
      
      public function loop(param1:Number = 0, param2:int = 0) : void
      {
         doStop();
         paddingCounter = param2;
         loopCounter = param1;
         setState(PBSTATE_LOOPING);
         doPlay();
         _subjectClip.gotoAndPlay(1);
      }
      
      private function stepTowardsTargetFrame(param1:Boolean = true) : void
      {
         var _loc4_:int = 0;
         if(forceFrameRate != 0 && !param1)
         {
            _loc4_ = forceStartFrame + (getTimer() - forceStartTime) / (1000 / forceFrameRate);
            if(_loc4_ > targetFrame)
            {
               _loc4_ = targetFrame;
            }
            subjectClip.gotoAndPlay(_loc4_);
         }
         var _loc2_:Number = _subjectClip.currentFrame;
         var _loc3_:Number = _loc2_;
         if(_loc2_ != targetFrame)
         {
            if(!param1)
            {
               return;
            }
            if(_loc2_ > targetFrame)
            {
               _loc3_ -= frameStep;
               if(_loc3_ < targetFrame)
               {
                  _loc3_ = targetFrame;
               }
            }
            else if(_loc2_ < targetFrame)
            {
               _loc3_ += frameStep;
               if(_loc3_ > targetFrame)
               {
                  _loc3_ = targetFrame;
                  if(forceFrameRate)
                  {
                     setState(PBSTATE_PREFINISH);
                  }
               }
            }
            _loc3_ = validateFrameStep(_loc3_);
            _subjectClip.gotoAndStop(_loc3_);
         }
         else
         {
            if(!param1)
            {
               if(loopCounter > 0)
               {
                  --loopCounter;
                  _subjectClip.gotoAndPlay(startFrame);
                  dispatchEvent(new AnimationOldEvent(AnimationOldEvent.LOOP_COMPLETE));
                  return;
               }
               _subjectClip.stop();
            }
            setState(PBSTATE_PREFINISH);
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         doStop();
         _subjectClip.gotoAndPlay(param1,param2);
         doPlay();
      }
      
      private function stepLoopingPhase() : void
      {
         var _loc1_:Number = _subjectClip.currentFrame;
         var _loc2_:Number = _subjectClip.totalFrames;
         if(_loc1_ == _loc2_)
         {
            --loopCounter;
         }
         if(loopCounter < 1)
         {
            _subjectClip.gotoAndStop(1);
            setState(PBSTATE_PREFINISH);
         }
      }
      
      private function addEnterFrameListener() : void
      {
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,handleEnterFrame);
         }
      }
      
      override public function get currentLabels() : Array
      {
         return _subjectClip.currentLabels;
      }
      
      public function playToFrame(param1:Number, param2:int = 0) : void
      {
         doStop();
         setState(PBSTATE_TOTARGETFRAME);
         paddingCounter = param2;
         if(param1 != _subjectClip.currentFrame)
         {
            targetFrame = param1;
            doPlay();
         }
      }
      
      public function doPlay() : void
      {
         addEnterFrameListener();
         if(forceFrameRate != 0)
         {
            forceStartFrame = _subjectClip.currentFrame;
            forceStartTime = getTimer();
         }
         _isPlaying = true;
      }
      
      public function getLengthOfLabel(param1:String) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:FrameLabel = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < animLabels.length)
         {
            _loc3_ = animLabels[_loc6_] as FrameLabel;
            if(_loc3_.name == param1)
            {
               _loc4_ = uint(_loc3_.frame);
               break;
            }
            _loc6_++;
         }
         if(!_loc3_)
         {
            return 0;
         }
         var _loc7_:int = _loc6_ + 1;
         if(_loc7_ > animLabels.length - 1)
         {
            _loc5_ = _subjectClip.totalFrames;
         }
         else
         {
            _loc3_ = animLabels[_loc7_] as FrameLabel;
            _loc5_ = _loc3_.frame;
         }
         return uint(_loc5_ - _loc4_);
      }
      
      private function validateFrameStep(param1:Number) : Number
      {
         if(param1 < 1)
         {
            param1 = _subjectClip.totalFrames;
         }
         else if(param1 > _subjectClip.totalFrames)
         {
            param1 = 1;
         }
         return param1;
      }
      
      private function setState(param1:String) : void
      {
         playBackState = param1;
      }
      
      private function removeEnterFrameListener() : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
         }
      }
      
      private function stepPreFinishPhase() : void
      {
         if(paddingCounter > 0)
         {
            --paddingCounter;
         }
         else
         {
            doStop();
            dispatchEvent(new AnimationOldEvent(AnimationOldEvent.COMPLETE));
         }
      }
      
      override public function get currentFrame() : int
      {
         return _subjectClip.currentFrame;
      }
      
      override public function get currentLabel() : String
      {
         return _subjectClip.currentLabel;
      }
   }
}

