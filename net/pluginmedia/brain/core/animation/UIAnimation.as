package net.pluginmedia.brain.core.animation
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   
   public class UIAnimation extends SuperMovieClip
   {
      
      public static var STATE_LABEL_STEP:String = "CharacterAnimation.STATE_LABEL_STEP";
      
      protected var fpStep:int = 1;
      
      public function UIAnimation(param1:MovieClip, param2:Boolean = true)
      {
         super(param1,param2);
      }
      
      public function stepLabel(param1:String = null, param2:int = 0, param3:Boolean = false, param4:int = 1) : void
      {
         var _loc5_:int = 0;
         stop();
         this.fpStep = param4;
         setStartEndFramesToLabel(param1);
         if(param3)
         {
            _loc5_ = int(startFrame);
            startFrame = endFrame;
            endFrame = _loc5_;
         }
         _subjectClip.gotoAndStop(startFrame);
         setState(STATE_LABEL_STEP);
      }
      
      protected function updateStepLabelState() : void
      {
         var _loc1_:Number = _subjectClip.currentFrame;
         var _loc2_:Number = _loc1_;
         if(_loc1_ != endFrame)
         {
            if(_loc1_ > endFrame)
            {
               _loc2_ -= fpStep;
               if(_loc2_ < endFrame)
               {
                  _loc2_ = endFrame;
               }
            }
            else if(_loc1_ < endFrame)
            {
               _loc2_ += fpStep;
               if(_loc2_ > endFrame)
               {
                  _loc2_ = endFrame;
               }
            }
            _loc2_ = validateFrameStep(_loc2_);
            _subjectClip.gotoAndStop(_loc2_);
         }
         else
         {
            if(loopCounter > 1)
            {
               --loopCounter;
               _subjectClip.gotoAndStop(startFrame);
               dispatchEvent(new AnimationEvent(AnimationEvent.LOOP_COMPLETE));
               return;
            }
            _subjectClip.gotoAndStop(endFrame);
            padAnimation();
         }
      }
      
      override protected function handleEnterFrame(param1:Event) : void
      {
         super.handleEnterFrame(param1);
         switch(_currentState)
         {
            case STATE_LABEL_STEP:
               updateStepLabelState();
         }
      }
   }
}

