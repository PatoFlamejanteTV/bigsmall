package net.pluginmedia.brain.core.animation
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   
   public class BaseAnimation extends MovieClip
   {
      
      public static var STATE_IDLE:String = "BaseAnimation.STATE_IDLE";
      
      public static var STATE_PLAYBACK:String = "BaseAnimation.STATE_PLAYBACK";
      
      public static var STATE_LOOPING_PLAYBACK:String = "BaseAnimation.STATE_LOOPING_PLAYBACK";
      
      public static var STATE_PADDING:String = "BaseAnimation.STATE_PADDING";
      
      protected var _animLabels:Array;
      
      public var frameStep:Number = 1;
      
      protected var _isPlaying:Boolean = false;
      
      protected var paddingCounter:uint = 0;
      
      protected var _subjectClip:MovieClip;
      
      protected var _currentState:String = STATE_IDLE;
      
      protected var loopCounter:uint = 0;
      
      public function BaseAnimation(param1:MovieClip, param2:Boolean = true)
      {
         super();
         registerMovieClip(param1,param2);
         addEventListener(Event.ENTER_FRAME,handleEnterFrame);
         this.mouseChildren = false;
         this.stop();
      }
      
      override public function stop() : void
      {
         _subjectClip.stop();
         _isPlaying = false;
         loopCounter = 0;
         paddingCounter = 0;
         setState(STATE_IDLE);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         switch(_currentState)
         {
            case STATE_IDLE:
               updateIdleState();
               break;
            case STATE_PLAYBACK:
               updatePlaybackState();
               break;
            case STATE_LOOPING_PLAYBACK:
               updateLoopingPlaybackState();
               break;
            case STATE_PADDING:
               updatePaddingState();
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         stop();
         _subjectClip.gotoAndPlay(param1,param2);
         _isPlaying = true;
         setState(STATE_PLAYBACK);
      }
      
      protected function endAnimation() : void
      {
         stop();
         dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
      }
      
      protected function updateLoopingPlaybackState() : void
      {
         updatePlaybackState();
         if(_subjectClip.currentFrame == _subjectClip.totalFrames)
         {
            --loopCounter;
         }
         if(loopCounter < 1)
         {
            padAnimation();
         }
      }
      
      override public function get totalFrames() : int
      {
         return _subjectClip.totalFrames;
      }
      
      override public function get currentLabel() : String
      {
         return _subjectClip.currentLabel;
      }
      
      protected function updateIdleState() : void
      {
      }
      
      override public function get currentLabels() : Array
      {
         return _subjectClip.currentLabels;
      }
      
      public function get subjectClip() : MovieClip
      {
         return _subjectClip;
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         stop();
         _subjectClip.gotoAndStop(param1,param2);
      }
      
      public function get currentState() : String
      {
         return _currentState;
      }
      
      public function getLabelObj(param1:String) : FrameLabel
      {
         var _loc2_:FrameLabel = null;
         var _loc3_:int = 0;
         while(_loc3_ < _animLabels.length)
         {
            _loc2_ = _animLabels[_loc3_] as FrameLabel;
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getLengthOfLabel(param1:String) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:FrameLabel = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _animLabels.length)
         {
            _loc3_ = _animLabels[_loc6_] as FrameLabel;
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
         if(_loc7_ > _animLabels.length - 1)
         {
            _loc5_ = _subjectClip.totalFrames;
         }
         else
         {
            _loc3_ = _animLabels[_loc7_] as FrameLabel;
            _loc5_ = _loc3_.frame;
         }
         return uint(_loc5_ - _loc4_);
      }
      
      public function loop(param1:Number = 0, param2:int = 0) : void
      {
         stop();
         paddingCounter = param2;
         loopCounter = param1;
         _subjectClip.gotoAndPlay(1);
         setState(STATE_LOOPING_PLAYBACK);
      }
      
      protected function setState(param1:String) : void
      {
         _currentState = param1;
      }
      
      protected function updatePaddingState() : void
      {
         if(paddingCounter > 0)
         {
            --paddingCounter;
         }
         else
         {
            endAnimation();
         }
      }
      
      protected function updatePlaybackState() : void
      {
         dispatchEvent(new AnimationEvent(AnimationEvent.PROGRESS));
      }
      
      protected function padAnimation() : void
      {
         if(paddingCounter > 0)
         {
            _subjectClip.stop();
            setState(STATE_PADDING);
         }
         else
         {
            endAnimation();
         }
      }
      
      override public function play() : void
      {
         stop();
         _subjectClip.play();
         _isPlaying = true;
         setState(STATE_PLAYBACK);
      }
      
      public function destroy() : void
      {
         removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      override public function get currentFrame() : int
      {
         return _subjectClip.currentFrame;
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      protected function registerMovieClip(param1:MovieClip, param2:Boolean) : void
      {
         _subjectClip = param1;
         _subjectClip.gotoAndStop(1);
         _animLabels = currentLabels;
         if(param2)
         {
            addChild(param1);
         }
      }
   }
}

