package net.pluginmedia.bigandsmall.video
{
   import fl.video.FLVPlayback;
   import fl.video.VideoEvent;
   import fl.video.VideoPlayer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   
   public class VideoPlayerControl extends PlaybackControlPanel
   {
      
      private var scrubber:MovieClip;
      
      private var volumeRect:Rectangle;
      
      private var handle:MovieClip;
      
      private var track:MovieClip;
      
      private var videoPlayer:VideoPlayer;
      
      private var playbackPosition:uint = 0;
      
      private var volumeText:TextField;
      
      private var muted:Boolean = false;
      
      private var _flvPlayback:FLVPlayback;
      
      private var scrubbing:Boolean = false;
      
      public function VideoPlayerControl(param1:FLVPlayback = null)
      {
         super();
         if(param1 !== null)
         {
            _flvPlayback = param1;
            _flvPlayback.autoRewind = true;
            addPlaybackListeners();
         }
         track = volumePanel.track;
         handle = volumePanel.handle;
         volumeText = volumePanel.text;
         scrubber = progress.scrubOver;
         initUI();
         addListeners();
         progress.bar.width = 0;
         progress.scrub.x = 0;
         scrubber.x = 0;
         muteButton.visible = false;
         playProgressText.text = "00:00 / 00:00";
         AccessibilityManager.addAccessibilityProperties(playButton,"Play video","Play the video",AccessibilityDefinitions.VIDEOFRAME_UI);
         AccessibilityManager.addAccessibilityProperties(pauseButton,"Pause video","Pause the video",AccessibilityDefinitions.VIDEOFRAME_UI);
         AccessibilityManager.addAccessibilityProperties(backButton,"Restart video","Restart the video",AccessibilityDefinitions.VIDEOFRAME_UI);
         playButton.tooltip = playTip;
         pauseButton.tooltip = pauseTip;
         backButton.tooltip = restartTip;
         volumeButton.tooltip = volumeTip;
         muteButton.tooltip = volumeTip;
         playButton.mouseChildren = false;
         pauseButton.mouseChildren = false;
         backButton.mouseChildren = false;
         volumeButton.mouseChildren = false;
         muteButton.mouseChildren = false;
         volumePanel.mouseChildren = true;
         playTip.alpha = 0;
         pauseTip.alpha = 0;
         restartTip.alpha = 0;
         volumeTip.alpha = 0;
      }
      
      override public function stop() : void
      {
         _flvPlayback.seek(0);
         _flvPlayback.stop();
      }
      
      private function onPlayingState(param1:VideoEvent) : void
      {
         playButton.visible = false;
         pauseButton.visible = true;
      }
      
      private function stopVolumeDrag(param1:MouseEvent) : void
      {
         handle.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,stopVolumeDrag);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,volumePanelUpdated);
      }
      
      private function scrubRollout(param1:MouseEvent) : void
      {
         TweenMax.to(scrubber,0.4,{"alpha":0});
      }
      
      private function onPlayClick(param1:MouseEvent) : void
      {
         play();
      }
      
      private function volumeTrackPressed(param1:MouseEvent) : void
      {
         handle.y = volumePanel.mouseY;
      }
      
      private function scrubMouseDown(param1:MouseEvent) : void
      {
         scrubber.startDrag(false,new Rectangle(progress.back.x,scrubber.y,progress.back.width - scrubber.width,0));
         stage.addEventListener(MouseEvent.MOUSE_UP,stopScrubDrag);
         stage.addEventListener(Event.ENTER_FRAME,updateScrubDrag);
         scrubbing = true;
      }
      
      public function setVolume(param1:Number) : void
      {
         _flvPlayback.volume = param1;
         if(videoPlayer !== null)
         {
            videoPlayer.volume = param1;
         }
         volumePanel.handle.y = track.y + track.height - param1 * track.height;
         volumeText.text = Math.round(param1 * 11).toString();
      }
      
      private function scrubRollover(param1:MouseEvent) : void
      {
         TweenMax.to(scrubber,0.4,{"alpha":1});
      }
      
      private function stopScrubDrag(param1:MouseEvent) : void
      {
         scrubber.stopDrag();
         var _loc2_:Number = scrubber.x / (progress.back.width - scrubber.width);
         _flvPlayback.seekPercent(_loc2_ * 100);
         stage.removeEventListener(MouseEvent.MOUSE_UP,stopScrubDrag);
         stage.removeEventListener(Event.ENTER_FRAME,updateScrubDrag);
         scrubbing = false;
      }
      
      private function buttonRolledOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target["back"] as MovieClip;
         _loc2_.gotoAndStop("rolled");
         if(param1.target == volumeButton)
         {
            volumePanel.visible = true;
            TweenMax.to(volumePanel,0.5,{"alpha":1});
         }
         if(param1.target.tooltip != undefined)
         {
            TweenMax.to(param1.target.tooltip,0.5,{
               "delay":1,
               "alpha":1
            });
         }
         dispatchEvent(new MouseEvent(param1.type,true));
      }
      
      private function initUI() : void
      {
         playButton.buttonMode = true;
         pauseButton.buttonMode = true;
         volumeButton.buttonMode = true;
         muteButton.buttonMode = true;
         backButton.buttonMode = true;
         volumePanel.handle.buttonMode = true;
         progress.buttonMode = true;
         volumePanel.visible = false;
         volumePanel.alpha = 0;
         pauseButton.visible = false;
         volumeRect = volumePanel.getRect(volumePanel.hit);
      }
      
      private function addListeners() : void
      {
         playButton.addEventListener(MouseEvent.CLICK,onPlayClick);
         pauseButton.addEventListener(MouseEvent.CLICK,onPauseClick);
         backButton.addEventListener(MouseEvent.CLICK,onBackClick);
         volumeButton.addEventListener(MouseEvent.CLICK,onVolumeClick);
         muteButton.addEventListener(MouseEvent.CLICK,onVolumeClick);
         playButton.addEventListener(MouseEvent.ROLL_OVER,buttonRolledOver);
         pauseButton.addEventListener(MouseEvent.ROLL_OVER,buttonRolledOver);
         volumeButton.addEventListener(MouseEvent.ROLL_OVER,buttonRolledOver);
         backButton.addEventListener(MouseEvent.ROLL_OVER,buttonRolledOver);
         muteButton.addEventListener(MouseEvent.ROLL_OVER,buttonRolledOver);
         playButton.addEventListener(MouseEvent.ROLL_OUT,buttonRolledOut);
         pauseButton.addEventListener(MouseEvent.ROLL_OUT,buttonRolledOut);
         volumeButton.addEventListener(MouseEvent.ROLL_OUT,buttonRolledOut);
         backButton.addEventListener(MouseEvent.ROLL_OUT,buttonRolledOut);
         muteButton.addEventListener(MouseEvent.ROLL_OUT,buttonRolledOut);
         volumePanel.track.addEventListener(MouseEvent.MOUSE_DOWN,volumeTrackPressed);
         volumePanel.handle.addEventListener(MouseEvent.MOUSE_DOWN,volumeHandlePressed);
         scrubber.addEventListener(MouseEvent.MOUSE_DOWN,scrubMouseDown);
         progress.hit.addEventListener(MouseEvent.CLICK,scrubTrackClicked);
         progress.back.addEventListener(MouseEvent.CLICK,scrubTrackClicked);
         progress.bar.addEventListener(MouseEvent.CLICK,scrubTrackClicked);
         progress.hit.addEventListener(MouseEvent.ROLL_OVER,scrubRollover);
         progress.back.addEventListener(MouseEvent.ROLL_OVER,scrubRollover);
         progress.bar.addEventListener(MouseEvent.ROLL_OVER,scrubRollover);
         progress.scrubOver.addEventListener(MouseEvent.ROLL_OVER,scrubRollover);
         this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      private function onFinishedState(param1:VideoEvent) : void
      {
         _flvPlayback.seek(0);
         stop();
      }
      
      private function onPausedState(param1:VideoEvent) : void
      {
         playButton.visible = true;
         pauseButton.visible = false;
      }
      
      private function onVolumeClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(muted)
         {
            _loc2_ = (track.height - (handle.y - track.y)) / track.height;
            _loc2_ = Math.min(1,_loc2_);
            _loc2_ = Math.max(0,_loc2_);
            setVolume(_loc2_);
         }
         else
         {
            _flvPlayback.volume = 0;
         }
         muted = !muted;
         if(!muted)
         {
            muteButton.visible = false;
            volumeButton.visible = true;
         }
      }
      
      private function scrubTrackClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = Math.max(progress.mouseX / (progress.back.width - scrubber.width));
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         _loc2_ = _loc2_ > 1 ? 1 : _loc2_;
         _flvPlayback.seekPercent(_loc2_ * 100);
      }
      
      override public function play() : void
      {
         try
         {
            _flvPlayback.play();
         }
         catch(e:Error)
         {
         }
      }
      
      public function updateTime() : void
      {
         var _loc1_:uint = _flvPlayback.playheadTime;
         var _loc2_:uint = _flvPlayback.totalTime;
         var _loc3_:String = int(_loc1_ / 60).toString();
         _loc3_ = _loc3_.length == 1 ? "0" + _loc3_ : _loc3_;
         var _loc4_:String = (_loc1_ % 60).toString();
         _loc4_ = _loc4_.length == 1 ? "0" + _loc4_ : _loc4_;
         var _loc5_:String = int(_loc2_ / 60).toString();
         _loc5_ = _loc5_.length == 1 ? "0" + _loc5_ : _loc5_;
         var _loc6_:String = (_loc2_ % 60).toString();
         _loc6_ = _loc6_.length == 1 ? "0" + _loc6_ : _loc6_;
         playProgressText.text = _loc3_ + ":" + _loc4_ + " / " + _loc5_ + ":" + _loc6_;
      }
      
      private function updateScrubDrag(param1:Event) : void
      {
         var _loc2_:MovieClip = progress.scrub;
         _loc2_.x = scrubber.x;
         progress.bar.width = _loc2_.x + (_loc2_.width >> 1);
      }
      
      private function buttonRolledOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target["back"] as MovieClip;
         _loc2_.gotoAndStop("normal");
         TweenMax.to(param1.target.tooltip,0.5,{"alpha":0});
      }
      
      private function onBackClick(param1:MouseEvent) : void
      {
         stop();
         play();
      }
      
      private function addPlaybackListeners() : void
      {
         _flvPlayback.addEventListener(VideoEvent.PLAYHEAD_UPDATE,onPlayheadEvent);
         _flvPlayback.addEventListener(VideoEvent.PLAYING_STATE_ENTERED,onPlayingState);
         _flvPlayback.addEventListener(VideoEvent.PAUSED_STATE_ENTERED,onPausedState);
         _flvPlayback.addEventListener(VideoEvent.STOPPED_STATE_ENTERED,onStoppedState);
         _flvPlayback.addEventListener(VideoEvent.SCRUB_FINISH,onFinishedState);
      }
      
      private function onPlayheadEvent(param1:VideoEvent) : void
      {
         var _loc2_:MovieClip = progress.scrub;
         var _loc3_:MovieClip = progress.back;
         var _loc4_:MovieClip = progress.bar;
         updateTime();
         if(!scrubbing)
         {
            _loc2_.x = _flvPlayback.playheadPercentage / 100 * (_loc3_.width - _loc2_.width);
            scrubber.x = _loc2_.x;
         }
         else
         {
            _loc2_.x = scrubber.x;
         }
         _loc4_.width = _loc2_.x + (_loc2_.width >> 1);
      }
      
      private function onStoppedState(param1:VideoEvent) : void
      {
         playButton.visible = true;
         pauseButton.visible = false;
      }
      
      private function volumePanelUpdated(param1:MouseEvent) : void
      {
         var _loc2_:Number = (track.height - (handle.y - track.y)) / track.height;
         _loc2_ = Math.min(1,_loc2_);
         _loc2_ = Math.max(0,_loc2_);
         setVolume(_loc2_);
      }
      
      public function set flvPlayback(param1:FLVPlayback) : void
      {
         _flvPlayback = param1;
         addPlaybackListeners();
      }
      
      private function volumeHandlePressed(param1:MouseEvent) : void
      {
         handle.startDrag(true,new Rectangle(handle.x,volumePanel.track.y,0,volumePanel.track.height));
         stage.addEventListener(MouseEvent.MOUSE_UP,stopVolumeDrag);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,volumePanelUpdated);
      }
      
      public function load(param1:String) : void
      {
         _flvPlayback.activeVideoPlayerIndex = 1;
         _flvPlayback.bringVideoPlayerToFront(1);
         _flvPlayback.visibleVideoPlayerIndex = 1;
         _flvPlayback.load(param1);
         videoPlayer = _flvPlayback.getVideoPlayer(1);
      }
      
      private function volumePanelRolledOut(param1:MouseEvent) : void
      {
         volumePanel.alpha = 0;
         TweenMax.from(volumePanel,0.5,{
            "alpha":1,
            "onComplete":volumePanelFaded
         });
      }
      
      private function onPauseClick(param1:MouseEvent) : void
      {
         pause();
      }
      
      public function pause() : void
      {
         _flvPlayback.pause();
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         if(!volumeRect.contains(param1.localX,param1.localY) && volumePanel.alpha == 1)
         {
            volumePanelRolledOut(param1);
         }
      }
      
      public function close() : void
      {
         _flvPlayback.closeVideoPlayer(1);
      }
      
      private function volumePanelFaded() : void
      {
         volumePanel.visible = false;
      }
   }
}

