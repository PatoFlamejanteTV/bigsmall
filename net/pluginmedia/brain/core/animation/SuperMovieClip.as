package net.pluginmedia.brain.core.animation
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   
   public class SuperMovieClip extends BaseAnimation
   {
      
      public static var STATE_LABEL_PLAYBACK:String = "CharacterAnimation.STATE_LABEL_PLAYBACK";
      
      protected var startFrame:uint;
      
      protected var endFrame:uint;
      
      protected var callbackOnComplete:Function = null;
      
      public function SuperMovieClip(param1:MovieClip, param2:Boolean = true)
      {
         super(param1,param2);
      }
      
      public function playLabel(param1:String = null, param2:uint = 0, param3:uint = 0, param4:Function = null) : void
      {
         stop();
         callbackOnComplete = param4;
         loopCounter = param2;
         paddingCounter = param3;
         setStartEndFramesToLabel(param1);
         _subjectClip.gotoAndPlay(startFrame);
         setState(STATE_LABEL_PLAYBACK);
      }
      
      protected function updatePlaybackLabelState() : void
      {
         if(_subjectClip.currentFrame >= endFrame)
         {
            if(loopCounter > 1)
            {
               --loopCounter;
               _subjectClip.gotoAndPlay(startFrame);
               dispatchEvent(new AnimationEvent(AnimationEvent.LOOP_COMPLETE));
               return;
            }
            _subjectClip.gotoAndStop(endFrame);
            padAnimation();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         callbackOnComplete = null;
      }
      
      protected function validateFrameStep(param1:uint) : uint
      {
         if(param1 < 1)
         {
            param1 = uint(_subjectClip.totalFrames);
         }
         else if(param1 > _subjectClip.totalFrames)
         {
            param1 = 1;
         }
         return param1;
      }
      
      override protected function endAnimation() : void
      {
         var _loc1_:Function = callbackOnComplete;
         super.endAnimation();
         if(_loc1_ is Function)
         {
            _loc1_.apply(this);
         }
      }
      
      override protected function handleEnterFrame(param1:Event) : void
      {
         super.handleEnterFrame(param1);
         switch(_currentState)
         {
            case STATE_LABEL_PLAYBACK:
               updatePlaybackLabelState();
         }
      }
      
      protected function setStartEndFramesToLabel(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:FrameLabel = null;
         startFrame = 1;
         endFrame = 1;
         if(_animLabels.length > 1 && param1 !== null)
         {
            _loc3_ = 0;
            while(_loc3_ < _animLabels.length)
            {
               _loc2_ = _animLabels[_loc3_] as FrameLabel;
               if(_loc2_.name == param1)
               {
                  startFrame = _loc2_.frame;
                  break;
               }
               _loc3_++;
            }
            _loc4_ = _loc3_ + 1;
            if(_loc4_ > _animLabels.length - 1)
            {
               _loc4_ = 0;
            }
            _loc2_ = _animLabels[_loc4_] as FrameLabel;
            endFrame = _loc2_.frame - 1;
            endFrame = validateFrameStep(endFrame);
         }
         else
         {
            startFrame = 1;
            endFrame = _subjectClip.totalFrames;
         }
      }
   }
}

