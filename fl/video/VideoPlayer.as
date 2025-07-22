package fl.video
{
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.*;
   import flash.utils.*;
   
   use namespace flvplayback_internal;
   
   public class VideoPlayer extends Video
   {
      
      public static const VERSION:String = "2.1.0.14";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal static var BUFFER_EMPTY:String = "bufferEmpty";
      
      flvplayback_internal static var BUFFER_FULL:String = "bufferFull";
      
      flvplayback_internal static var BUFFER_FLUSH:String = "bufferFlush";
      
      public static var iNCManagerClass:Object = "fl.video.NCManager";
      
      public static var netStreamClientClass:Object = VideoPlayerClient;
      
      public static const DEFAULT_UPDATE_TIME_INTERVAL:Number = 250;
      
      public static const DEFAULT_UPDATE_PROGRESS_INTERVAL:Number = 250;
      
      public static const DEFAULT_IDLE_TIMEOUT_INTERVAL:Number = 300000;
      
      flvplayback_internal static const AUTO_RESIZE_INTERVAL:Number = 100;
      
      flvplayback_internal static const DEFAULT_AUTO_RESIZE_PLAYHEAD_TIMEOUT:Number = 0.5;
      
      flvplayback_internal static const DEFAULT_AUTO_RESIZE_METADATA_DELAY_MAX:Number = 5;
      
      flvplayback_internal static const FINISH_AUTO_RESIZE_INTERVAL:Number = 250;
      
      flvplayback_internal static const RTMP_DO_STOP_AT_END_INTERVAL:Number = 500;
      
      flvplayback_internal static const RTMP_DO_SEEK_INTERVAL:Number = 100;
      
      flvplayback_internal static const HTTP_DO_SEEK_INTERVAL:Number = 250;
      
      flvplayback_internal static const DEFAULT_HTTP_DO_SEEK_MAX_COUNT:Number = 4;
      
      flvplayback_internal static const HTTP_DELAYED_BUFFERING_INTERVAL:Number = 100;
      
      flvplayback_internal static const DEFAULT_LAST_UPDATE_TIME_STUCK_COUNT_MAX:int = 10;
      
      protected var _align:String;
      
      protected var _registrationWidth:Number;
      
      flvplayback_internal var _updateProgressTimer:Timer;
      
      flvplayback_internal var _atEndCheckPlayhead:Number;
      
      flvplayback_internal var _hiddenForResize:Boolean;
      
      flvplayback_internal var startProgressTime:Number;
      
      protected var _volume:Number;
      
      flvplayback_internal var _invalidSeekTime:Boolean;
      
      flvplayback_internal var _readyDispatched:Boolean;
      
      flvplayback_internal var lastUpdateTimeStuckCount:Number;
      
      protected var _ns:NetStream;
      
      protected var _isLive:Boolean;
      
      flvplayback_internal var _bufferState:String;
      
      protected var _streamLength:Number;
      
      flvplayback_internal var _rtmpDoSeekTimer:Timer;
      
      protected var _contentPath:String;
      
      flvplayback_internal var lastUpdateTimeStuckCountMax:int = flvplayback_internal::DEFAULT_LAST_UPDATE_TIME_STUCK_COUNT_MAX;
      
      protected var _metadata:Object;
      
      protected var __visible:Boolean;
      
      flvplayback_internal var autoResizeMetadataDelayMax:Number = flvplayback_internal::DEFAULT_AUTO_RESIZE_METADATA_DELAY_MAX;
      
      protected var _scaleMode:String;
      
      flvplayback_internal var _lastUpdateTime:Number;
      
      flvplayback_internal var _sawPlayStop:Boolean;
      
      flvplayback_internal var _atEnd:Boolean;
      
      flvplayback_internal var _sawSeekNotify:Boolean;
      
      flvplayback_internal var _idleTimeoutTimer:Timer;
      
      flvplayback_internal var _prevVideoWidth:int;
      
      protected var _registrationX:Number;
      
      protected var _registrationY:Number;
      
      protected var _bufferTime:Number;
      
      flvplayback_internal var _cachedState:String;
      
      flvplayback_internal var totalDownloadTime:Number;
      
      flvplayback_internal var _cachedPlayheadTime:Number;
      
      protected var _autoPlay:Boolean;
      
      protected var _autoRewind:Boolean;
      
      flvplayback_internal var _invalidSeekRecovery:Boolean;
      
      flvplayback_internal var _hiddenRewindPlayheadTime:Number;
      
      flvplayback_internal var _prevVideoHeight:int;
      
      protected var _ncMgr:INCManager;
      
      protected var _soundTransform:SoundTransform;
      
      flvplayback_internal var _httpDoSeekCount:Number;
      
      flvplayback_internal var oldRegistrationBounds:Rectangle;
      
      flvplayback_internal var _cmdQueue:Array;
      
      flvplayback_internal var _updateTimeTimer:Timer;
      
      flvplayback_internal var httpDoSeekMaxCount:Number = flvplayback_internal::DEFAULT_HTTP_DO_SEEK_MAX_COUNT;
      
      flvplayback_internal var _startingPlay:Boolean;
      
      flvplayback_internal var baselineProgressTime:Number;
      
      flvplayback_internal var _autoResizeTimer:Timer;
      
      flvplayback_internal var _autoResizeDone:Boolean;
      
      flvplayback_internal var _httpDoSeekTimer:Timer;
      
      protected var _state:String;
      
      protected var _videoWidth:int;
      
      flvplayback_internal var _finishAutoResizeTimer:Timer;
      
      flvplayback_internal var _resizeImmediatelyOnMetadata:Boolean;
      
      flvplayback_internal var _currentPos:Number;
      
      flvplayback_internal var oldBounds:Rectangle;
      
      protected var _videoHeight:int;
      
      flvplayback_internal var waitingForEnough:Boolean;
      
      flvplayback_internal var _delayedBufferingTimer:Timer;
      
      protected var _registrationHeight:Number;
      
      flvplayback_internal var _hiddenForResizeMetadataDelay:Number;
      
      flvplayback_internal var autoResizePlayheadTimeout:Number = flvplayback_internal::DEFAULT_AUTO_RESIZE_PLAYHEAD_TIMEOUT;
      
      flvplayback_internal var _rtmpDoStopAtEndTimer:Timer;
      
      flvplayback_internal var _lastSeekTime:Number;
      
      flvplayback_internal var totalProgressTime:Number;
      
      public function VideoPlayer(param1:int = 320, param2:int = 240)
      {
         super(param1,param2);
         _registrationX = x;
         _registrationY = y;
         _registrationWidth = param1;
         _registrationHeight = param2;
         _state = VideoState.DISCONNECTED;
         flvplayback_internal::_cachedState = _state;
         flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         flvplayback_internal::_sawPlayStop = false;
         flvplayback_internal::_cachedPlayheadTime = 0;
         _metadata = null;
         flvplayback_internal::_startingPlay = false;
         flvplayback_internal::_invalidSeekTime = false;
         flvplayback_internal::_invalidSeekRecovery = false;
         flvplayback_internal::_currentPos = 0;
         flvplayback_internal::_atEnd = false;
         _streamLength = 0;
         flvplayback_internal::_cmdQueue = new Array();
         flvplayback_internal::_readyDispatched = false;
         flvplayback_internal::_autoResizeDone = false;
         flvplayback_internal::_lastUpdateTime = NaN;
         flvplayback_internal::lastUpdateTimeStuckCount = 0;
         flvplayback_internal::_sawSeekNotify = false;
         flvplayback_internal::_hiddenForResize = false;
         flvplayback_internal::_hiddenForResizeMetadataDelay = 0;
         flvplayback_internal::_resizeImmediatelyOnMetadata = false;
         _videoWidth = -1;
         _videoHeight = -1;
         flvplayback_internal::_prevVideoWidth = 0;
         flvplayback_internal::_prevVideoHeight = 0;
         flvplayback_internal::_updateTimeTimer = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
         flvplayback_internal::_updateTimeTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doUpdateTime);
         flvplayback_internal::_updateProgressTimer = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
         flvplayback_internal::_updateProgressTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doUpdateProgress);
         flvplayback_internal::_idleTimeoutTimer = new Timer(DEFAULT_IDLE_TIMEOUT_INTERVAL,1);
         flvplayback_internal::_idleTimeoutTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doIdleTimeout);
         flvplayback_internal::_autoResizeTimer = new Timer(flvplayback_internal::AUTO_RESIZE_INTERVAL);
         flvplayback_internal::_autoResizeTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doAutoResize);
         flvplayback_internal::_rtmpDoStopAtEndTimer = new Timer(flvplayback_internal::RTMP_DO_STOP_AT_END_INTERVAL);
         flvplayback_internal::_rtmpDoStopAtEndTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::rtmpDoStopAtEnd);
         flvplayback_internal::_rtmpDoSeekTimer = new Timer(flvplayback_internal::RTMP_DO_SEEK_INTERVAL);
         flvplayback_internal::_rtmpDoSeekTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::rtmpDoSeek);
         flvplayback_internal::_httpDoSeekTimer = new Timer(flvplayback_internal::HTTP_DO_SEEK_INTERVAL);
         flvplayback_internal::_httpDoSeekTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::httpDoSeek);
         flvplayback_internal::_httpDoSeekCount = 0;
         flvplayback_internal::_finishAutoResizeTimer = new Timer(flvplayback_internal::FINISH_AUTO_RESIZE_INTERVAL,1);
         flvplayback_internal::_finishAutoResizeTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::finishAutoResize);
         flvplayback_internal::_delayedBufferingTimer = new Timer(flvplayback_internal::HTTP_DELAYED_BUFFERING_INTERVAL);
         flvplayback_internal::_delayedBufferingTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doDelayedBuffering);
         _isLive = false;
         _align = VideoAlign.CENTER;
         _scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
         _autoPlay = true;
         _autoRewind = false;
         _bufferTime = 0.1;
         _soundTransform = new SoundTransform();
         _volume = _soundTransform.volume;
         __visible = true;
         _contentPath = "";
         flvplayback_internal::waitingForEnough = false;
         flvplayback_internal::baselineProgressTime = NaN;
         flvplayback_internal::startProgressTime = NaN;
         flvplayback_internal::totalDownloadTime = NaN;
         flvplayback_internal::totalProgressTime = NaN;
      }
      
      public function get playheadTime() : Number
      {
         var _loc1_:Number = NaN;
         _loc1_ = _ns == null ? flvplayback_internal::_currentPos : _ns.time;
         if(_metadata != null && _metadata.audiodelay != undefined)
         {
            _loc1_ -= _metadata.audiodelay;
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
         }
         return _loc1_;
      }
      
      public function stop() : void
      {
         if(!flvplayback_internal::isXnOK())
         {
            if(_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               flvplayback_internal::queueCmd(QueuedCommand.STOP);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         if(_state == VideoState.STOPPED || _ns == null)
         {
            return;
         }
         if(_ncMgr.isRTMP)
         {
            if(_autoRewind && !_isLive)
            {
               flvplayback_internal::_currentPos = 0;
               flvplayback_internal::_play(0,0);
               _state = VideoState.STOPPED;
               flvplayback_internal::setState(VideoState.REWINDING);
            }
            else
            {
               flvplayback_internal::closeNS(true);
               flvplayback_internal::setState(VideoState.STOPPED);
            }
         }
         else
         {
            flvplayback_internal::_pause(true);
            if(_autoRewind)
            {
               flvplayback_internal::_seek(0);
               _state = VideoState.STOPPED;
               flvplayback_internal::setState(VideoState.REWINDING);
            }
            else
            {
               flvplayback_internal::setState(VideoState.STOPPED);
            }
         }
      }
      
      flvplayback_internal function execQueuedCmds() : void
      {
         var nextCmd:Object = null;
         while(flvplayback_internal::_cmdQueue.length > 0 && (stateResponsive || _state == VideoState.DISCONNECTED || _state == VideoState.CONNECTION_ERROR) && (flvplayback_internal::_cmdQueue[0].url != null || _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR))
         {
            try
            {
               nextCmd = flvplayback_internal::_cmdQueue.shift();
               flvplayback_internal::_cachedState = _state;
               _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               switch(nextCmd.type)
               {
                  case QueuedCommand.PLAY:
                     play(nextCmd.url,nextCmd.time,nextCmd.isLive);
                     break;
                  case QueuedCommand.LOAD:
                     load(nextCmd.url,nextCmd.time,nextCmd.isLive);
                     break;
                  case QueuedCommand.PAUSE:
                     pause();
                     break;
                  case QueuedCommand.STOP:
                     stop();
                     break;
                  case QueuedCommand.SEEK:
                     seek(nextCmd.time);
                     break;
                  case QueuedCommand.PLAY_WHEN_ENOUGH:
                     playWhenEnoughDownloaded();
               }
            }
            finally
            {
               if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
               {
                  _state = flvplayback_internal::_cachedState;
               }
            }
         }
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         super.scaleX = param1;
         super.scaleY = param2;
         _registrationWidth = width;
         _registrationHeight = height;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
               break;
            default:
               super.x = _registrationX;
               super.y = _registrationY;
         }
      }
      
      public function set playheadTime(param1:Number) : void
      {
         seek(param1);
      }
      
      override public function get videoWidth() : int
      {
         if(_videoWidth > 0)
         {
            return _videoWidth;
         }
         if(_metadata != null && !isNaN(_metadata.width) && !isNaN(_metadata.height))
         {
            if(_metadata.width == _metadata.height && flvplayback_internal::_readyDispatched)
            {
               return super.videoWidth;
            }
            return int(_metadata.width);
         }
         if(flvplayback_internal::_readyDispatched)
         {
            return super.videoWidth;
         }
         return -1;
      }
      
      public function get scaleMode() : String
      {
         return _scaleMode;
      }
      
      public function get progressInterval() : Number
      {
         return flvplayback_internal::_updateProgressTimer.delay;
      }
      
      public function set align(param1:String) : void
      {
         if(_align != param1)
         {
            switch(param1)
            {
               case VideoAlign.CENTER:
               case VideoAlign.TOP:
               case VideoAlign.LEFT:
               case VideoAlign.BOTTOM:
               case VideoAlign.RIGHT:
               case VideoAlign.TOP_LEFT:
               case VideoAlign.TOP_RIGHT:
               case VideoAlign.BOTTOM_LEFT:
               case VideoAlign.BOTTOM_RIGHT:
                  _align = param1;
                  switch(_scaleMode)
                  {
                     case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                     case VideoScaleMode.NO_SCALE:
                        flvplayback_internal::startAutoResize();
                  }
                  break;
               default:
                  return;
            }
         }
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(_scaleMode != param1)
         {
            switch(param1)
            {
               case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
               case VideoScaleMode.NO_SCALE:
               case VideoScaleMode.EXACT_FIT:
                  if(_scaleMode == VideoScaleMode.EXACT_FIT && flvplayback_internal::_resizeImmediatelyOnMetadata && (_videoWidth < 0 || _videoHeight < 0))
                  {
                     flvplayback_internal::_resizeImmediatelyOnMetadata = false;
                  }
                  _scaleMode = param1;
                  flvplayback_internal::startAutoResize();
                  break;
               default:
                  return;
            }
         }
      }
      
      public function get source() : String
      {
         return _contentPath;
      }
      
      flvplayback_internal function doUpdateTime(param1:TimerEvent = null) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = playheadTime;
         if(_loc2_ != flvplayback_internal::_atEndCheckPlayhead)
         {
            flvplayback_internal::_atEndCheckPlayhead = NaN;
         }
         switch(_state)
         {
            case VideoState.STOPPED:
            case VideoState.PAUSED:
            case VideoState.DISCONNECTED:
            case VideoState.CONNECTION_ERROR:
               flvplayback_internal::_updateTimeTimer.stop();
               break;
            case VideoState.PLAYING:
            case VideoState.BUFFERING:
               if(_ncMgr != null && !_ncMgr.isRTMP && flvplayback_internal::_lastUpdateTime == _loc2_ && _ns != null && _ns.bytesLoaded == _ns.bytesTotal)
               {
                  if(flvplayback_internal::lastUpdateTimeStuckCount > flvplayback_internal::lastUpdateTimeStuckCountMax)
                  {
                     flvplayback_internal::lastUpdateTimeStuckCount = 0;
                     flvplayback_internal::httpDoStopAtEnd();
                  }
                  else
                  {
                     ++flvplayback_internal::lastUpdateTimeStuckCount;
                  }
               }
         }
         if(flvplayback_internal::_lastUpdateTime != _loc2_)
         {
            dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYHEAD_UPDATE,false,false,_state,_loc2_));
            flvplayback_internal::_lastUpdateTime = _loc2_;
            flvplayback_internal::lastUpdateTimeStuckCount = 0;
         }
      }
      
      flvplayback_internal function rtmpNetStatus(param1:NetStatusEvent) : void
      {
         if(_state == VideoState.CONNECTION_ERROR)
         {
            return;
         }
         switch(param1.info.code)
         {
            case "NetStream.Play.Stop":
               if(flvplayback_internal::_startingPlay)
               {
                  return;
               }
               switch(_state)
               {
                  case VideoState.RESIZING:
                     if(flvplayback_internal::_hiddenForResize)
                     {
                        flvplayback_internal::finishAutoResize();
                     }
                     break;
                  case VideoState.LOADING:
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                     break;
                  default:
                     flvplayback_internal::_sawPlayStop = true;
                     if(!flvplayback_internal::_rtmpDoStopAtEndTimer.running && (flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || _ns.bufferTime <= 0.1 && _ns.bufferLength <= 0.1))
                     {
                        flvplayback_internal::_cachedPlayheadTime = playheadTime;
                        flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                        flvplayback_internal::_rtmpDoStopAtEndTimer.start();
                     }
               }
               break;
            case "NetStream.Buffer.Empty":
               switch(flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_FULL:
                     if(flvplayback_internal::_sawPlayStop)
                     {
                        flvplayback_internal::rtmpDoStopAtEnd();
                     }
                     else if(_state == VideoState.PLAYING)
                     {
                        flvplayback_internal::setState(VideoState.BUFFERING);
                     }
               }
               flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               flvplayback_internal::_sawPlayStop = false;
               break;
            case "NetStream.Buffer.Flush":
               if(flvplayback_internal::_sawSeekNotify && _state == VideoState.SEEKING)
               {
                  flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
                  flvplayback_internal::_sawPlayStop = false;
                  flvplayback_internal::setStateFromCachedState(false);
                  flvplayback_internal::doUpdateTime();
                  flvplayback_internal::execQueuedCmds();
               }
               if(!flvplayback_internal::_rtmpDoStopAtEndTimer.running && flvplayback_internal::_sawPlayStop && (flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY || _ns.bufferTime <= 0.1 && _ns.bufferLength <= 0.1))
               {
                  flvplayback_internal::_cachedPlayheadTime = playheadTime;
                  flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                  flvplayback_internal::_rtmpDoStopAtEndTimer.start();
               }
               switch(flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_EMPTY:
                     if(!flvplayback_internal::_hiddenForResize)
                     {
                        if(_state == VideoState.LOADING && flvplayback_internal::_cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                        {
                           flvplayback_internal::setState(VideoState.PLAYING);
                        }
                        else if(flvplayback_internal::_cachedState == VideoState.BUFFERING)
                        {
                           flvplayback_internal::_cachedState = VideoState.PLAYING;
                        }
                     }
                     flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FLUSH;
                     break;
                  default:
                     if(_state == VideoState.BUFFERING)
                     {
                        flvplayback_internal::setStateFromCachedState();
                     }
               }
               break;
            case "NetStream.Buffer.Full":
               if(flvplayback_internal::_sawSeekNotify && _state == VideoState.SEEKING)
               {
                  flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
                  flvplayback_internal::_sawPlayStop = false;
                  flvplayback_internal::setStateFromCachedState(false);
                  flvplayback_internal::doUpdateTime();
                  flvplayback_internal::execQueuedCmds();
               }
               switch(flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_EMPTY:
                     flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
                     if(!flvplayback_internal::_hiddenForResize)
                     {
                        if(_state == VideoState.LOADING && flvplayback_internal::_cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                        {
                           flvplayback_internal::setState(VideoState.PLAYING);
                        }
                        else if(flvplayback_internal::_cachedState == VideoState.BUFFERING)
                        {
                           flvplayback_internal::_cachedState = VideoState.PLAYING;
                        }
                        if(flvplayback_internal::_rtmpDoStopAtEndTimer.running)
                        {
                           flvplayback_internal::_sawPlayStop = true;
                           flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                        }
                     }
                     break;
                  case flvplayback_internal::BUFFER_FLUSH:
                     flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
                     if(flvplayback_internal::_rtmpDoStopAtEndTimer.running)
                     {
                        flvplayback_internal::_sawPlayStop = true;
                        flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                     }
               }
               if(_state == VideoState.BUFFERING)
               {
                  flvplayback_internal::setStateFromCachedState();
               }
               break;
            case "NetStream.Pause.Notify":
               if(_state == VideoState.RESIZING && flvplayback_internal::_hiddenForResize)
               {
                  flvplayback_internal::finishAutoResize();
               }
               break;
            case "NetStream.Unpause.Notify":
               if(_state == VideoState.PAUSED)
               {
                  _state = VideoState.PLAYING;
                  flvplayback_internal::setState(VideoState.BUFFERING);
               }
               else
               {
                  flvplayback_internal::_cachedState = VideoState.PLAYING;
               }
               break;
            case "NetStream.Play.Start":
               flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
               flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               flvplayback_internal::_sawPlayStop = false;
               if(flvplayback_internal::_startingPlay)
               {
                  flvplayback_internal::_startingPlay = false;
                  flvplayback_internal::_cachedPlayheadTime = playheadTime;
               }
               else if(_state == VideoState.PLAYING)
               {
                  flvplayback_internal::setState(VideoState.BUFFERING);
               }
               break;
            case "NetStream.Play.Reset":
               flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
               if(_state == VideoState.REWINDING)
               {
                  flvplayback_internal::_rtmpDoSeekTimer.reset();
                  if(playheadTime == 0 || playheadTime < flvplayback_internal::_cachedPlayheadTime)
                  {
                     flvplayback_internal::setStateFromCachedState();
                  }
                  else
                  {
                     flvplayback_internal::_cachedPlayheadTime = playheadTime;
                     flvplayback_internal::_rtmpDoSeekTimer.start();
                  }
               }
               break;
            case "NetStream.Seek.Notify":
               if(playheadTime != flvplayback_internal::_cachedPlayheadTime)
               {
                  flvplayback_internal::setStateFromCachedState(false);
                  flvplayback_internal::doUpdateTime();
                  flvplayback_internal::execQueuedCmds();
               }
               else
               {
                  flvplayback_internal::_sawSeekNotify = true;
                  flvplayback_internal::_rtmpDoSeekTimer.start();
               }
               break;
            case "Netstream.Play.UnpublishNotify":
            case "Netstream.Play.PublishNotify":
               break;
            case "NetStream.Play.StreamNotFound":
               if(!_ncMgr.connectAgain())
               {
                  flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
               }
               break;
            case "NetStream.Play.Failed":
            case "NetStream.Failed":
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
               flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
      }
      
      public function set progressInterval(param1:Number) : void
      {
         flvplayback_internal::_updateProgressTimer.delay = param1;
      }
      
      flvplayback_internal function onCuePoint(param1:Object) : void
      {
         if(!flvplayback_internal::_hiddenForResize || !isNaN(flvplayback_internal::_hiddenRewindPlayheadTime) && playheadTime < flvplayback_internal::_hiddenRewindPlayheadTime)
         {
            dispatchEvent(new MetadataEvent(MetadataEvent.CUE_POINT,false,false,param1));
         }
      }
      
      flvplayback_internal function createINCManager() : void
      {
         var theClass:Class = null;
         theClass = null;
         try
         {
            if(iNCManagerClass is String)
            {
               theClass = Class(getDefinitionByName(String(iNCManagerClass)));
            }
            else if(iNCManagerClass is Class)
            {
               theClass = Class(iNCManagerClass);
            }
         }
         catch(e:Error)
         {
            theClass = null;
         }
         if(theClass == null)
         {
            throw new VideoError(VideoError.INCMANAGER_CLASS_UNSET,iNCManagerClass == null ? "null" : iNCManagerClass.toString());
         }
         _ncMgr = new theClass();
         _ncMgr.videoPlayer = this;
      }
      
      flvplayback_internal function doAutoResize(param1:TimerEvent = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(flvplayback_internal::_autoResizeTimer.running)
         {
            switch(_state)
            {
               case VideoState.RESIZING:
               case VideoState.LOADING:
                  break;
               case VideoState.DISCONNECTED:
               case VideoState.CONNECTION_ERROR:
                  flvplayback_internal::_autoResizeTimer.reset();
                  return;
               default:
                  if(!stateResponsive)
                  {
                     return;
                  }
                  break;
            }
            if(!(super.videoWidth != flvplayback_internal::_prevVideoWidth || super.videoHeight != flvplayback_internal::_prevVideoHeight || flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FULL || flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || _ns.time > flvplayback_internal::autoResizePlayheadTimeout))
            {
               return;
            }
            if(flvplayback_internal::_hiddenForResize && !_ns.client.ready && flvplayback_internal::_hiddenForResizeMetadataDelay < flvplayback_internal::autoResizeMetadataDelayMax)
            {
               ++flvplayback_internal::_hiddenForResizeMetadataDelay;
               return;
            }
            flvplayback_internal::_autoResizeTimer.reset();
         }
         if(flvplayback_internal::_autoResizeDone)
         {
            flvplayback_internal::setState(flvplayback_internal::_cachedState);
            return;
         }
         flvplayback_internal::oldBounds = new Rectangle(x,y,width,height);
         flvplayback_internal::oldRegistrationBounds = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::_autoResizeDone = true;
         _loc2_ = flvplayback_internal::_readyDispatched;
         flvplayback_internal::_readyDispatched = true;
         _loc3_ = videoWidth;
         _loc4_ = videoHeight;
         flvplayback_internal::_readyDispatched = _loc2_;
         switch(_scaleMode)
         {
            case VideoScaleMode.NO_SCALE:
               super.width = _loc3_;
               super.height = _loc4_;
               break;
            case VideoScaleMode.EXACT_FIT:
               super.width = registrationWidth;
               super.height = registrationHeight;
               break;
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            default:
               _loc5_ = _loc3_ * _registrationHeight / _loc4_;
               _loc6_ = _loc4_ * _registrationWidth / _loc3_;
               if(_loc6_ < _registrationHeight)
               {
                  super.width = _registrationWidth;
                  super.height = _loc6_;
               }
               else if(_loc5_ < _registrationWidth)
               {
                  super.width = _loc5_;
                  super.height = _registrationHeight;
               }
               else
               {
                  super.width = _registrationWidth;
                  super.height = _registrationHeight;
               }
         }
         switch(_align)
         {
            case VideoAlign.CENTER:
            case VideoAlign.TOP:
            case VideoAlign.BOTTOM:
            default:
               super.x = _registrationX + (_registrationWidth - width) / 2;
               break;
            case VideoAlign.LEFT:
            case VideoAlign.TOP_LEFT:
            case VideoAlign.BOTTOM_LEFT:
               super.x = _registrationX;
               break;
            case VideoAlign.RIGHT:
            case VideoAlign.TOP_RIGHT:
            case VideoAlign.BOTTOM_RIGHT:
               super.x = _registrationX + (_registrationWidth - width);
         }
         switch(_align)
         {
            case VideoAlign.CENTER:
            case VideoAlign.LEFT:
            case VideoAlign.RIGHT:
            default:
               super.y = _registrationY + (_registrationHeight - height) / 2;
               break;
            case VideoAlign.TOP:
            case VideoAlign.TOP_LEFT:
            case VideoAlign.TOP_RIGHT:
               super.y = _registrationY;
               break;
            case VideoAlign.BOTTOM:
            case VideoAlign.BOTTOM_LEFT:
            case VideoAlign.BOTTOM_RIGHT:
               super.y = _registrationY + (_registrationHeight - height);
         }
         if(flvplayback_internal::_hiddenForResize)
         {
            flvplayback_internal::_hiddenRewindPlayheadTime = playheadTime;
            if(_state == VideoState.LOADING)
            {
               flvplayback_internal::_cachedState = VideoState.PLAYING;
            }
            if(!_ncMgr.isRTMP)
            {
               flvplayback_internal::_pause(true);
               flvplayback_internal::_seek(0);
               flvplayback_internal::_finishAutoResizeTimer.reset();
               flvplayback_internal::_finishAutoResizeTimer.start();
            }
            else if(!_isLive)
            {
               flvplayback_internal::_currentPos = 0;
               flvplayback_internal::_play(0,0);
               flvplayback_internal::setState(VideoState.RESIZING);
            }
            else if(_autoPlay)
            {
               flvplayback_internal::_finishAutoResizeTimer.reset();
               flvplayback_internal::_finishAutoResizeTimer.start();
            }
            else
            {
               flvplayback_internal::finishAutoResize();
            }
         }
         else
         {
            dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT,false,false,flvplayback_internal::oldBounds,flvplayback_internal::oldRegistrationBounds));
         }
      }
      
      public function get totalTime() : Number
      {
         return _streamLength;
      }
      
      public function get ncMgr() : INCManager
      {
         if(_ncMgr == null)
         {
            flvplayback_internal::createINCManager();
         }
         return _ncMgr;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         _loc2_ = soundTransform;
         _loc2_.volume = param1;
         soundTransform = _loc2_;
      }
      
      flvplayback_internal function _play(param1:int = 0, param2:int = -1) : void
      {
         flvplayback_internal::waitingForEnough = false;
         flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         flvplayback_internal::_startingPlay = true;
         _ns.play(_ncMgr.streamName,_isLive ? -1 : param1,param2);
      }
      
      flvplayback_internal function finishAutoResize(param1:TimerEvent = null) : void
      {
         if(stateResponsive)
         {
            return;
         }
         flvplayback_internal::_hiddenForResize = false;
         super.visible = __visible;
         volume = _volume;
         dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT,false,false,flvplayback_internal::oldBounds,flvplayback_internal::oldRegistrationBounds));
         if(_autoPlay)
         {
            if(_ncMgr.isRTMP)
            {
               if(!_isLive)
               {
                  flvplayback_internal::_currentPos = 0;
                  flvplayback_internal::_play(0);
               }
               if(_state == VideoState.RESIZING)
               {
                  flvplayback_internal::setState(VideoState.LOADING);
                  flvplayback_internal::_cachedState = VideoState.PLAYING;
               }
            }
            else
            {
               flvplayback_internal::waitingForEnough = true;
               flvplayback_internal::_cachedState = _state;
               _state = VideoState.PAUSED;
               flvplayback_internal::checkReadyForPlay(bytesLoaded,bytesTotal);
               if(flvplayback_internal::waitingForEnough)
               {
                  _state = flvplayback_internal::_cachedState;
                  flvplayback_internal::setState(VideoState.PAUSED);
               }
               else
               {
                  flvplayback_internal::_cachedState = VideoState.PLAYING;
               }
            }
         }
         else
         {
            flvplayback_internal::setState(VideoState.STOPPED);
         }
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(flvplayback_internal::_hiddenForResize)
         {
            _volume = param1.volume;
         }
         _soundTransform = new SoundTransform();
         _soundTransform.volume = flvplayback_internal::_hiddenForResize ? 0 : param1.volume;
         _soundTransform.leftToLeft = param1.leftToLeft;
         _soundTransform.leftToRight = param1.leftToRight;
         _soundTransform.rightToLeft = param1.rightToLeft;
         _soundTransform.rightToRight = param1.rightToRight;
         if(_ns != null)
         {
            _ns.soundTransform = _soundTransform;
         }
      }
      
      flvplayback_internal function httpDoSeek(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = _state == VideoState.REWINDING || _state == VideoState.SEEKING;
         if(_loc2_ && flvplayback_internal::_httpDoSeekCount < flvplayback_internal::httpDoSeekMaxCount && (flvplayback_internal::_cachedPlayheadTime == playheadTime || flvplayback_internal::_invalidSeekTime))
         {
            ++flvplayback_internal::_httpDoSeekCount;
            return;
         }
         flvplayback_internal::_httpDoSeekCount = 0;
         flvplayback_internal::_httpDoSeekTimer.reset();
         if(!_loc2_)
         {
            return;
         }
         flvplayback_internal::setStateFromCachedState(false);
         if(flvplayback_internal::_invalidSeekTime)
         {
            flvplayback_internal::_invalidSeekTime = false;
            flvplayback_internal::_invalidSeekRecovery = true;
            seek(playheadTime);
         }
         else
         {
            flvplayback_internal::doUpdateTime();
            flvplayback_internal::_lastSeekTime = playheadTime;
            flvplayback_internal::execQueuedCmds();
         }
      }
      
      public function get bytesLoaded() : uint
      {
         if(_ns == null || _ncMgr.isRTMP)
         {
            return uint.MIN_VALUE;
         }
         return _ns.bytesLoaded;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = _registrationHeight = param1;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
               break;
            default:
               super.height = param1;
         }
      }
      
      flvplayback_internal function httpNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Stop":
               flvplayback_internal::_delayedBufferingTimer.reset();
               if(flvplayback_internal::_invalidSeekTime)
               {
                  flvplayback_internal::_invalidSeekTime = false;
                  flvplayback_internal::_invalidSeekRecovery = true;
                  flvplayback_internal::setState(flvplayback_internal::_cachedState);
                  seek(playheadTime);
               }
               else
               {
                  switch(_state)
                  {
                     case VideoState.SEEKING:
                        flvplayback_internal::httpDoSeek(null);
                     case VideoState.PLAYING:
                     case VideoState.BUFFERING:
                        flvplayback_internal::httpDoStopAtEnd();
                  }
               }
               break;
            case "NetStream.Seek.InvalidTime":
               if(flvplayback_internal::_invalidSeekRecovery)
               {
                  flvplayback_internal::_invalidSeekTime = false;
                  flvplayback_internal::_invalidSeekRecovery = false;
                  flvplayback_internal::setState(flvplayback_internal::_cachedState);
                  seek(0);
               }
               else
               {
                  flvplayback_internal::_invalidSeekTime = true;
                  flvplayback_internal::_httpDoSeekCount = 0;
                  flvplayback_internal::_httpDoSeekTimer.start();
               }
               break;
            case "NetStream.Buffer.Empty":
               flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               if(_state == VideoState.PLAYING)
               {
                  flvplayback_internal::_delayedBufferingTimer.reset();
                  flvplayback_internal::_delayedBufferingTimer.start();
               }
               break;
            case "NetStream.Buffer.Full":
            case "NetStream.Buffer.Flush":
               flvplayback_internal::_delayedBufferingTimer.reset();
               flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
               if(!flvplayback_internal::_hiddenForResize)
               {
                  if(_state == VideoState.LOADING && flvplayback_internal::_cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                  {
                     flvplayback_internal::setState(VideoState.PLAYING);
                  }
                  else if(flvplayback_internal::_cachedState == VideoState.BUFFERING)
                  {
                     flvplayback_internal::_cachedState = VideoState.PLAYING;
                  }
               }
               break;
            case "NetStream.Seek.Notify":
               flvplayback_internal::_invalidSeekRecovery = false;
               switch(_state)
               {
                  case VideoState.SEEKING:
                  case VideoState.REWINDING:
                     flvplayback_internal::_httpDoSeekCount = 0;
                     flvplayback_internal::_httpDoSeekTimer.start();
               }
               break;
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
               flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
      }
      
      public function get netConnection() : NetConnection
      {
         if(_ncMgr != null)
         {
            return _ncMgr.netConnection;
         }
         return null;
      }
      
      public function set bufferTime(param1:Number) : void
      {
         _bufferTime = param1;
         if(_ns != null)
         {
            _ns.bufferTime = _bufferTime;
         }
      }
      
      flvplayback_internal function onMetaData(param1:Object) : void
      {
         if(_metadata != null)
         {
            return;
         }
         _metadata = param1;
         if(isNaN(_streamLength))
         {
            _streamLength = param1.duration;
         }
         if(flvplayback_internal::_resizeImmediatelyOnMetadata && Boolean(_ns.client.ready))
         {
            flvplayback_internal::_resizeImmediatelyOnMetadata = false;
            flvplayback_internal::_autoResizeTimer.reset();
            flvplayback_internal::_autoResizeDone = false;
            flvplayback_internal::doAutoResize();
         }
         dispatchEvent(new MetadataEvent(MetadataEvent.METADATA_RECEIVED,false,false,param1));
      }
      
      flvplayback_internal function queueCmd(param1:Number, param2:String = null, param3:Boolean = false, param4:Number = NaN) : void
      {
         flvplayback_internal::_cmdQueue.push(new QueuedCommand(param1,param2,param3,param4));
      }
      
      public function set registrationHeight(param1:Number) : void
      {
         height = param1;
      }
      
      override public function get visible() : Boolean
      {
         if(!flvplayback_internal::_hiddenForResize)
         {
            __visible = super.visible;
         }
         return __visible;
      }
      
      public function seek(param1:Number) : void
      {
         if(flvplayback_internal::_invalidSeekTime)
         {
            return;
         }
         if(isNaN(param1) || param1 < 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         if(!flvplayback_internal::isXnOK())
         {
            if(_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            flvplayback_internal::flushQueuedCmds();
            flvplayback_internal::queueCmd(QueuedCommand.SEEK,null,false,param1);
            flvplayback_internal::setState(VideoState.LOADING);
            flvplayback_internal::_cachedState = VideoState.LOADING;
            _ncMgr.reconnect();
            return;
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               flvplayback_internal::queueCmd(QueuedCommand.SEEK,null,false,param1);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         if(_ns == null)
         {
            flvplayback_internal::_createStream();
         }
         if(flvplayback_internal::_atEnd && param1 < playheadTime)
         {
            flvplayback_internal::_atEnd = false;
         }
         switch(_state)
         {
            case VideoState.PLAYING:
               _state = VideoState.BUFFERING;
            case VideoState.BUFFERING:
            case VideoState.PAUSED:
               flvplayback_internal::_seek(param1);
               flvplayback_internal::setState(VideoState.SEEKING);
               break;
            case VideoState.STOPPED:
               if(_ncMgr.isRTMP)
               {
                  flvplayback_internal::_play(0);
                  flvplayback_internal::_pause(true);
               }
               flvplayback_internal::_seek(param1);
               _state = VideoState.PAUSED;
               flvplayback_internal::setState(VideoState.SEEKING);
         }
      }
      
      public function get state() : String
      {
         return _state;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         _autoRewind = param1;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         _registrationWidth = width;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
         }
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         _registrationHeight = height;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
         }
      }
      
      public function get registrationWidth() : Number
      {
         return _registrationWidth;
      }
      
      flvplayback_internal function flushQueuedCmds() : void
      {
         while(flvplayback_internal::_cmdQueue.length > 0)
         {
            flvplayback_internal::_cmdQueue.pop();
         }
      }
      
      public function get registrationX() : Number
      {
         return _registrationX;
      }
      
      flvplayback_internal function _setUpStream() : void
      {
         if(!isNaN(_ncMgr.streamLength) && _ncMgr.streamLength >= 0)
         {
            _streamLength = _ncMgr.streamLength;
         }
         _videoWidth = _ncMgr.streamWidth >= 0 ? _ncMgr.streamWidth : -1;
         _videoHeight = _ncMgr.streamHeight >= 0 ? _ncMgr.streamHeight : -1;
         flvplayback_internal::_resizeImmediatelyOnMetadata = _videoWidth >= 0 && _videoHeight >= 0 || _scaleMode == VideoScaleMode.EXACT_FIT;
         if(!flvplayback_internal::_hiddenForResize)
         {
            __visible = super.visible;
            super.visible = false;
            _volume = volume;
            volume = 0;
            flvplayback_internal::_hiddenForResize = true;
         }
         flvplayback_internal::_hiddenForResizeMetadataDelay = 0;
         flvplayback_internal::_play(0);
         if(flvplayback_internal::_currentPos > 0)
         {
            flvplayback_internal::_seek(flvplayback_internal::_currentPos);
            flvplayback_internal::_currentPos = 0;
         }
         flvplayback_internal::_autoResizeTimer.reset();
         flvplayback_internal::_autoResizeTimer.start();
      }
      
      public function get registrationY() : Number
      {
         return _registrationY;
      }
      
      flvplayback_internal function httpDoStopAtEnd() : void
      {
         if(flvplayback_internal::_atEndCheckPlayhead == playheadTime && flvplayback_internal::_atEndCheckPlayhead != flvplayback_internal::_lastUpdateTime && playheadTime != 0)
         {
            flvplayback_internal::_atEnd = false;
            flvplayback_internal::_seek(0);
            return;
         }
         flvplayback_internal::_atEndCheckPlayhead = NaN;
         flvplayback_internal::_atEnd = true;
         if(isNaN(_streamLength))
         {
            _streamLength = _ns.time;
         }
         flvplayback_internal::_pause(true);
         flvplayback_internal::setState(VideoState.STOPPED);
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         flvplayback_internal::doUpdateTime();
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.COMPLETE,false,false,_state,playheadTime));
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         if(_autoRewind)
         {
            flvplayback_internal::_atEnd = false;
            flvplayback_internal::_pause(true);
            flvplayback_internal::_seek(0);
            flvplayback_internal::setState(VideoState.REWINDING);
         }
      }
      
      public function ncConnected() : void
      {
         if(_ncMgr == null || _ncMgr.netConnection == null)
         {
            flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
         else if(_ns == null)
         {
            flvplayback_internal::_createStream();
            flvplayback_internal::_setUpStream();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         __visible = param1;
         if(!flvplayback_internal::_hiddenForResize)
         {
            super.visible = __visible;
         }
      }
      
      public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            throw new VideoError(VideoError.NULL_URL_LOAD);
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive && _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR)
            {
               flvplayback_internal::queueCmd(QueuedCommand.LOAD,param1,param3,param2);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         _autoPlay = false;
         flvplayback_internal::_load(param1,param2,param3);
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.x != param1)
         {
            _loc2_ = param1 - this.x;
            super.x = param1;
            _registrationX += _loc2_;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.y != param1)
         {
            _loc2_ = param1 - this.y;
            super.y = param1;
            _registrationY += _loc2_;
         }
      }
      
      flvplayback_internal function _pause(param1:Boolean) : void
      {
         flvplayback_internal::_atEndCheckPlayhead = playheadTime;
         flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         if(param1)
         {
            _ns.pause();
         }
         else
         {
            _ns.resume();
         }
      }
      
      public function get playheadUpdateInterval() : Number
      {
         return flvplayback_internal::_updateTimeTimer.delay;
      }
      
      flvplayback_internal function doDelayedBuffering(param1:TimerEvent) : void
      {
         switch(_state)
         {
            case VideoState.LOADING:
            case VideoState.RESIZING:
               break;
            case VideoState.PLAYING:
               flvplayback_internal::_delayedBufferingTimer.reset();
               if(!isNaN(totalTime) && totalTime > 0 && bytesLoaded > 0 && bytesLoaded < uint.MAX_VALUE && bytesLoaded < bytesTotal)
               {
                  pause();
                  if(_state == VideoState.PAUSED)
                  {
                     flvplayback_internal::waitingForEnough = true;
                     playWhenEnoughDownloaded();
                  }
               }
               else
               {
                  flvplayback_internal::setState(VideoState.BUFFERING);
               }
               break;
            default:
               flvplayback_internal::_delayedBufferingTimer.reset();
         }
      }
      
      flvplayback_internal function createNetStreamClient() : Object
      {
         var theClass:Class = null;
         var theInst:Object = null;
         theClass = null;
         theInst = null;
         try
         {
            if(netStreamClientClass is String)
            {
               theClass = Class(getDefinitionByName(String(netStreamClientClass)));
            }
            else if(netStreamClientClass is Class)
            {
               theClass = Class(netStreamClientClass);
            }
            if(theClass != null)
            {
               theInst = new theClass(this);
            }
         }
         catch(e:Error)
         {
            theClass = null;
            theInst = null;
         }
         if(theInst == null)
         {
            throw new VideoError(VideoError.NETSTREAM_CLIENT_CLASS_UNSET,netStreamClientClass == null ? "null" : netStreamClientClass.toString());
         }
         return theInst;
      }
      
      public function get align() : String
      {
         return _align;
      }
      
      public function set registrationWidth(param1:Number) : void
      {
         width = param1;
      }
      
      public function get stateResponsive() : Boolean
      {
         switch(_state)
         {
            case VideoState.STOPPED:
            case VideoState.PLAYING:
            case VideoState.PAUSED:
            case VideoState.BUFFERING:
               return true;
            default:
               return false;
         }
      }
      
      public function get volume() : Number
      {
         return soundTransform.volume;
      }
      
      public function get soundTransform() : SoundTransform
      {
         var _loc1_:SoundTransform = null;
         if(_ns != null)
         {
            _soundTransform = _ns.soundTransform;
         }
         _loc1_ = new SoundTransform();
         _loc1_.volume = flvplayback_internal::_hiddenForResize ? _volume : _soundTransform.volume;
         _loc1_.leftToLeft = _soundTransform.leftToLeft;
         _loc1_.leftToRight = _soundTransform.leftToRight;
         _loc1_.rightToLeft = _soundTransform.rightToLeft;
         _loc1_.rightToRight = _soundTransform.rightToRight;
         return _loc1_;
      }
      
      public function get bufferTime() : Number
      {
         if(_ns != null)
         {
            _bufferTime = _ns.bufferTime;
         }
         return _bufferTime;
      }
      
      public function get metadata() : Object
      {
         return _metadata;
      }
      
      public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 != null)
         {
            if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
            {
               _state = flvplayback_internal::_cachedState;
            }
            else
            {
               if(!stateResponsive && _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR)
               {
                  flvplayback_internal::queueCmd(QueuedCommand.PLAY,param1,param3,param2);
                  return;
               }
               flvplayback_internal::execQueuedCmds();
            }
            _autoPlay = true;
            flvplayback_internal::_load(param1,param2,param3);
            return;
         }
         if(!flvplayback_internal::isXnOK())
         {
            if(_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            flvplayback_internal::flushQueuedCmds();
            flvplayback_internal::queueCmd(QueuedCommand.PLAY);
            flvplayback_internal::setState(VideoState.LOADING);
            flvplayback_internal::_cachedState = VideoState.LOADING;
            _ncMgr.reconnect();
            return;
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               flvplayback_internal::queueCmd(QueuedCommand.PLAY);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         if(_ns == null)
         {
            flvplayback_internal::_createStream();
         }
         switch(_state)
         {
            case VideoState.BUFFERING:
               if(_ncMgr.isRTMP)
               {
                  flvplayback_internal::_play(0);
                  if(flvplayback_internal::_atEnd)
                  {
                     flvplayback_internal::_atEnd = false;
                     flvplayback_internal::_currentPos = 0;
                     flvplayback_internal::setState(VideoState.REWINDING);
                  }
                  else if(flvplayback_internal::_currentPos > 0)
                  {
                     flvplayback_internal::_seek(flvplayback_internal::_currentPos);
                     flvplayback_internal::_currentPos = 0;
                  }
               }
            case VideoState.PLAYING:
               return;
            case VideoState.STOPPED:
               if(_ncMgr.isRTMP)
               {
                  if(_isLive)
                  {
                     flvplayback_internal::_play(-1);
                     flvplayback_internal::setState(VideoState.BUFFERING);
                  }
                  else
                  {
                     flvplayback_internal::_play(0);
                     if(flvplayback_internal::_atEnd)
                     {
                        flvplayback_internal::_atEnd = false;
                        flvplayback_internal::_currentPos = 0;
                        _state = VideoState.BUFFERING;
                        flvplayback_internal::setState(VideoState.REWINDING);
                     }
                     else if(flvplayback_internal::_currentPos > 0)
                     {
                        flvplayback_internal::_seek(flvplayback_internal::_currentPos);
                        flvplayback_internal::_currentPos = 0;
                        flvplayback_internal::setState(VideoState.BUFFERING);
                     }
                     else
                     {
                        flvplayback_internal::setState(VideoState.BUFFERING);
                     }
                  }
               }
               else
               {
                  flvplayback_internal::_pause(false);
                  if(flvplayback_internal::_atEnd)
                  {
                     flvplayback_internal::_atEnd = false;
                     flvplayback_internal::_seek(0);
                     _state = VideoState.BUFFERING;
                     flvplayback_internal::setState(VideoState.REWINDING);
                  }
                  else if(flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY)
                  {
                     flvplayback_internal::setState(VideoState.BUFFERING);
                  }
                  else
                  {
                     flvplayback_internal::setState(VideoState.PLAYING);
                  }
               }
               break;
            case VideoState.PAUSED:
               flvplayback_internal::_pause(false);
               if(!_ncMgr.isRTMP)
               {
                  if(flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY)
                  {
                     flvplayback_internal::setState(VideoState.BUFFERING);
                  }
                  else
                  {
                     flvplayback_internal::setState(VideoState.PLAYING);
                  }
               }
               else
               {
                  flvplayback_internal::setState(VideoState.BUFFERING);
               }
         }
      }
      
      public function get isLive() : Boolean
      {
         return _isLive;
      }
      
      flvplayback_internal function setStateFromCachedState(param1:Boolean = true) : void
      {
         switch(flvplayback_internal::_cachedState)
         {
            case VideoState.PLAYING:
            case VideoState.PAUSED:
            case VideoState.BUFFERING:
               flvplayback_internal::setState(flvplayback_internal::_cachedState,param1);
               break;
            default:
               flvplayback_internal::setState(VideoState.STOPPED,param1);
         }
      }
      
      public function get idleTimeout() : Number
      {
         return flvplayback_internal::_idleTimeoutTimer.delay;
      }
      
      public function get registrationHeight() : Number
      {
         return _registrationHeight;
      }
      
      public function ncReconnected() : void
      {
         if(_ncMgr == null || _ncMgr.netConnection == null)
         {
            flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
         else
         {
            _ns = null;
            _state = VideoState.STOPPED;
            flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function startAutoResize() : void
      {
         switch(_state)
         {
            case VideoState.DISCONNECTED:
            case VideoState.CONNECTION_ERROR:
               return;
            default:
               if(_ns == null)
               {
                  return;
               }
               flvplayback_internal::_autoResizeDone = false;
               if(stateResponsive && (super.videoWidth != 0 || super.videoHeight != 0 || flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FULL || flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || _ns.time > flvplayback_internal::autoResizePlayheadTimeout))
               {
                  flvplayback_internal::doAutoResize();
               }
               else
               {
                  flvplayback_internal::_autoResizeTimer.reset();
                  flvplayback_internal::_autoResizeTimer.start();
               }
               return;
         }
      }
      
      flvplayback_internal function setState(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         if(param1 == _state)
         {
            return;
         }
         flvplayback_internal::_hiddenRewindPlayheadTime = NaN;
         flvplayback_internal::_cachedState = _state;
         flvplayback_internal::_cachedPlayheadTime = playheadTime;
         _state = param1;
         _loc3_ = _state;
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,_loc3_,playheadTime));
         if(!flvplayback_internal::_readyDispatched)
         {
            switch(_loc3_)
            {
               case VideoState.STOPPED:
               case VideoState.PLAYING:
               case VideoState.PAUSED:
               case VideoState.BUFFERING:
                  flvplayback_internal::_readyDispatched = true;
                  dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.READY,false,false,_loc3_,playheadTime));
            }
         }
         switch(flvplayback_internal::_cachedState)
         {
            case VideoState.REWINDING:
               dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.AUTO_REWOUND,false,false,_loc3_,playheadTime));
               if(_ncMgr.isRTMP && _loc3_ == VideoState.STOPPED)
               {
                  flvplayback_internal::closeNS();
               }
         }
         switch(_loc3_)
         {
            case VideoState.STOPPED:
            case VideoState.PAUSED:
               if(_ncMgr.isRTMP)
               {
                  flvplayback_internal::_idleTimeoutTimer.reset();
                  flvplayback_internal::_idleTimeoutTimer.start();
               }
               break;
            case VideoState.SEEKING:
            case VideoState.REWINDING:
               flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               flvplayback_internal::_sawPlayStop = false;
               flvplayback_internal::_idleTimeoutTimer.reset();
               break;
            case VideoState.PLAYING:
            case VideoState.BUFFERING:
               flvplayback_internal::_updateTimeTimer.start();
               flvplayback_internal::_idleTimeoutTimer.reset();
               break;
            case VideoState.LOADING:
            case VideoState.RESIZING:
               flvplayback_internal::_idleTimeoutTimer.reset();
         }
         if(param2)
         {
            flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function _seek(param1:Number) : void
      {
         flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         if(_metadata != null && _metadata.audiodelay != undefined && (isNaN(_streamLength) || param1 + _metadata.audiodelay < _streamLength))
         {
            param1 += _metadata.audiodelay;
         }
         _ns.seek(param1);
         flvplayback_internal::_lastSeekTime = param1;
         flvplayback_internal::_invalidSeekTime = false;
         flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         flvplayback_internal::_sawPlayStop = false;
         flvplayback_internal::_sawSeekNotify = false;
      }
      
      public function get autoRewind() : Boolean
      {
         return _autoRewind;
      }
      
      flvplayback_internal function doIdleTimeout(param1:TimerEvent) : void
      {
         close();
      }
      
      public function playWhenEnoughDownloaded() : void
      {
         if(_ncMgr != null && _ncMgr.isRTMP)
         {
            play();
            return;
         }
         if(!flvplayback_internal::isXnOK())
         {
            throw new VideoError(VideoError.NO_CONNECTION);
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               flvplayback_internal::queueCmd(QueuedCommand.PLAY_WHEN_ENOUGH);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         flvplayback_internal::waitingForEnough = true;
         flvplayback_internal::checkReadyForPlay(bytesLoaded,bytesTotal);
      }
      
      flvplayback_internal function rtmpDoSeek(param1:TimerEvent) : void
      {
         if(_state != VideoState.REWINDING && _state != VideoState.SEEKING)
         {
            flvplayback_internal::_rtmpDoSeekTimer.reset();
            flvplayback_internal::_sawSeekNotify = false;
         }
         else if(playheadTime != flvplayback_internal::_cachedPlayheadTime)
         {
            flvplayback_internal::_rtmpDoSeekTimer.reset();
            flvplayback_internal::_sawSeekNotify = false;
            flvplayback_internal::setStateFromCachedState(false);
            flvplayback_internal::doUpdateTime();
            flvplayback_internal::_lastSeekTime = playheadTime;
            flvplayback_internal::execQueuedCmds();
         }
      }
      
      public function get netStream() : NetStream
      {
         return _ns;
      }
      
      override public function get videoHeight() : int
      {
         if(_videoHeight > 0)
         {
            return _videoHeight;
         }
         if(_metadata != null && !isNaN(_metadata.width) && !isNaN(_metadata.height))
         {
            if(_metadata.width == _metadata.height && flvplayback_internal::_readyDispatched)
            {
               return super.videoHeight;
            }
            return int(_metadata.height);
         }
         if(flvplayback_internal::_readyDispatched)
         {
            return super.videoHeight;
         }
         return -1;
      }
      
      public function set registrationX(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(_registrationX != param1)
         {
            _loc2_ = param1 - _registrationX;
            _registrationX = param1;
            this.x += _loc2_;
         }
      }
      
      public function set registrationY(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(_registrationY != param1)
         {
            _loc2_ = param1 - _registrationY;
            _registrationY = param1;
            this.y += _loc2_;
         }
      }
      
      flvplayback_internal function doUpdateProgress(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(_ns == null)
         {
            return;
         }
         _loc2_ = _ns.bytesLoaded;
         _loc3_ = _ns.bytesTotal;
         if(_loc3_ < uint.MAX_VALUE)
         {
            dispatchEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS,false,false,_loc2_,_loc3_));
         }
         if(_state == VideoState.DISCONNECTED || _state == VideoState.CONNECTION_ERROR || _loc2_ >= _loc3_)
         {
            flvplayback_internal::_updateProgressTimer.stop();
         }
         flvplayback_internal::checkEnoughDownloaded(_loc2_,_loc3_);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = _registrationWidth = param1;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
               break;
            default:
               super.width = param1;
         }
      }
      
      public function get isRTMP() : Boolean
      {
         if(_ncMgr == null)
         {
            return false;
         }
         return _ncMgr.isRTMP;
      }
      
      public function get bytesTotal() : uint
      {
         if(_ns == null || _ncMgr.isRTMP)
         {
            return uint.MAX_VALUE;
         }
         return _ns.bytesTotal;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         super.width = _registrationWidth = param1;
         super.height = _registrationHeight = param2;
         switch(_scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               flvplayback_internal::startAutoResize();
               break;
            default:
               super.x = _registrationX;
               super.y = _registrationY;
         }
      }
      
      flvplayback_internal function isXnOK() : Boolean
      {
         if(_state == VideoState.LOADING)
         {
            return true;
         }
         if(_state == VideoState.CONNECTION_ERROR)
         {
            return false;
         }
         if(_state != VideoState.DISCONNECTED)
         {
            if(_ncMgr == null || _ncMgr.netConnection == null || _ncMgr.isRTMP && !_ncMgr.netConnection.connected)
            {
               flvplayback_internal::setState(VideoState.DISCONNECTED);
               return false;
            }
            return true;
         }
         return false;
      }
      
      flvplayback_internal function _createStream() : void
      {
         var _loc1_:NetStream = null;
         _ns = null;
         _loc1_ = new NetStream(_ncMgr.netConnection);
         if(_ncMgr.isRTMP)
         {
            _loc1_.addEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::rtmpNetStatus);
         }
         else
         {
            _loc1_.addEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::httpNetStatus);
         }
         _loc1_.client = flvplayback_internal::createNetStreamClient();
         _loc1_.bufferTime = _bufferTime;
         _loc1_.soundTransform = soundTransform;
         _ns = _loc1_;
         attachNetStream(_ns);
      }
      
      flvplayback_internal function checkReadyForPlay(param1:uint, param2:uint) : void
      {
         var _loc3_:Number = NaN;
         if(param1 >= param2)
         {
            flvplayback_internal::waitingForEnough = false;
            flvplayback_internal::_cachedState = _state;
            _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
            play();
            flvplayback_internal::execQueuedCmds();
            return;
         }
         if(isNaN(flvplayback_internal::baselineProgressTime))
         {
            return;
         }
         if(isNaN(totalTime) || totalTime < 0)
         {
            flvplayback_internal::waitingForEnough = false;
            flvplayback_internal::_cachedState = _state;
            _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
            play();
            flvplayback_internal::execQueuedCmds();
         }
         else if(flvplayback_internal::totalDownloadTime > 1.5)
         {
            _loc3_ = (flvplayback_internal::totalProgressTime - flvplayback_internal::baselineProgressTime) / flvplayback_internal::totalDownloadTime;
            if(totalTime - playheadTime > (totalTime - flvplayback_internal::totalProgressTime) / _loc3_)
            {
               flvplayback_internal::waitingForEnough = false;
               flvplayback_internal::_cachedState = _state;
               _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               play();
               flvplayback_internal::execQueuedCmds();
            }
         }
      }
      
      flvplayback_internal function closeNS(param1:Boolean = false) : void
      {
         if(_ns != null)
         {
            if(param1)
            {
               flvplayback_internal::doUpdateTime();
               flvplayback_internal::_currentPos = _ns.time;
            }
            flvplayback_internal::_updateTimeTimer.reset();
            flvplayback_internal::_updateProgressTimer.reset();
            flvplayback_internal::_idleTimeoutTimer.reset();
            flvplayback_internal::_autoResizeTimer.reset();
            flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
            flvplayback_internal::_rtmpDoSeekTimer.reset();
            flvplayback_internal::_httpDoSeekTimer.reset();
            flvplayback_internal::_finishAutoResizeTimer.reset();
            flvplayback_internal::_delayedBufferingTimer.reset();
            _ns.removeEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::rtmpNetStatus);
            _ns.removeEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::httpNetStatus);
            _ns.close();
            _ns = null;
         }
      }
      
      flvplayback_internal function _load(param1:String, param2:Number, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         flvplayback_internal::_prevVideoWidth = super.videoWidth;
         flvplayback_internal::_prevVideoHeight = super.videoHeight;
         flvplayback_internal::_autoResizeDone = false;
         flvplayback_internal::_cachedPlayheadTime = 0;
         flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         flvplayback_internal::_sawPlayStop = false;
         _metadata = null;
         flvplayback_internal::_startingPlay = false;
         flvplayback_internal::_invalidSeekTime = false;
         flvplayback_internal::_invalidSeekRecovery = false;
         _isLive = param3;
         _contentPath = param1;
         flvplayback_internal::_currentPos = 0;
         _streamLength = isNaN(param2) || param2 <= 0 ? NaN : param2;
         flvplayback_internal::_atEnd = false;
         flvplayback_internal::_readyDispatched = false;
         flvplayback_internal::_lastUpdateTime = NaN;
         flvplayback_internal::lastUpdateTimeStuckCount = 0;
         flvplayback_internal::_sawSeekNotify = false;
         flvplayback_internal::waitingForEnough = false;
         flvplayback_internal::baselineProgressTime = NaN;
         flvplayback_internal::startProgressTime = NaN;
         flvplayback_internal::totalDownloadTime = NaN;
         flvplayback_internal::totalProgressTime = NaN;
         flvplayback_internal::_httpDoSeekCount = 0;
         flvplayback_internal::_updateTimeTimer.reset();
         flvplayback_internal::_updateProgressTimer.reset();
         flvplayback_internal::_idleTimeoutTimer.reset();
         flvplayback_internal::_autoResizeTimer.reset();
         flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         flvplayback_internal::_rtmpDoSeekTimer.reset();
         flvplayback_internal::_httpDoSeekTimer.reset();
         flvplayback_internal::_finishAutoResizeTimer.reset();
         flvplayback_internal::_delayedBufferingTimer.reset();
         flvplayback_internal::closeNS(false);
         if(_ncMgr == null)
         {
            flvplayback_internal::createINCManager();
         }
         _loc4_ = _ncMgr.connectToURL(_contentPath);
         flvplayback_internal::setState(VideoState.LOADING);
         flvplayback_internal::_cachedState = VideoState.LOADING;
         if(_loc4_)
         {
            flvplayback_internal::_createStream();
            flvplayback_internal::_setUpStream();
         }
         if(!_ncMgr.isRTMP)
         {
            flvplayback_internal::_updateProgressTimer.start();
         }
      }
      
      flvplayback_internal function rtmpDoStopAtEnd(param1:TimerEvent = null) : void
      {
         if(flvplayback_internal::_rtmpDoStopAtEndTimer.running)
         {
            switch(_state)
            {
               case VideoState.DISCONNECTED:
               case VideoState.CONNECTION_ERROR:
                  flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                  return;
               default:
                  if(!(param1 == null || flvplayback_internal::_cachedPlayheadTime == playheadTime))
                  {
                     flvplayback_internal::_cachedPlayheadTime = playheadTime;
                     return;
                  }
                  flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
            }
         }
         if(flvplayback_internal::_atEndCheckPlayhead == playheadTime && flvplayback_internal::_atEndCheckPlayhead != flvplayback_internal::_lastSeekTime && !_isLive && playheadTime != 0)
         {
            flvplayback_internal::_atEnd = false;
            flvplayback_internal::_currentPos = 0;
            flvplayback_internal::_play(0);
            return;
         }
         flvplayback_internal::_atEndCheckPlayhead = NaN;
         flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         flvplayback_internal::_sawPlayStop = false;
         flvplayback_internal::_atEnd = true;
         flvplayback_internal::setState(VideoState.STOPPED);
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         flvplayback_internal::doUpdateTime();
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.COMPLETE,false,false,_state,playheadTime));
         if(_state != VideoState.STOPPED)
         {
            return;
         }
         if(_autoRewind && !_isLive && playheadTime != 0)
         {
            flvplayback_internal::_atEnd = false;
            flvplayback_internal::_currentPos = 0;
            flvplayback_internal::_play(0,0);
            flvplayback_internal::setState(VideoState.REWINDING);
         }
         else
         {
            flvplayback_internal::closeNS();
         }
      }
      
      public function set idleTimeout(param1:Number) : void
      {
         flvplayback_internal::_idleTimeoutTimer.delay = param1;
      }
      
      public function set playheadUpdateInterval(param1:Number) : void
      {
         flvplayback_internal::_updateTimeTimer.delay = param1;
      }
      
      flvplayback_internal function checkEnoughDownloaded(param1:uint, param2:uint) : void
      {
         if(param1 == 0 || param2 == uint.MAX_VALUE)
         {
            return;
         }
         if(isNaN(totalTime) || totalTime <= 0)
         {
            if(flvplayback_internal::waitingForEnough && stateResponsive)
            {
               flvplayback_internal::waitingForEnough = false;
               flvplayback_internal::_cachedState = _state;
               _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               play();
               flvplayback_internal::execQueuedCmds();
            }
            return;
         }
         if(param1 >= param2)
         {
            if(flvplayback_internal::waitingForEnough)
            {
               flvplayback_internal::waitingForEnough = false;
               flvplayback_internal::_cachedState = _state;
               _state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               play();
               flvplayback_internal::execQueuedCmds();
            }
            return;
         }
         if(isNaN(flvplayback_internal::baselineProgressTime))
         {
            flvplayback_internal::baselineProgressTime = param1 / param2 * totalTime;
         }
         if(isNaN(flvplayback_internal::startProgressTime))
         {
            flvplayback_internal::startProgressTime = getTimer();
         }
         else
         {
            flvplayback_internal::totalDownloadTime = (getTimer() - flvplayback_internal::startProgressTime) / 1000;
            flvplayback_internal::totalProgressTime = param1 / param2 * totalTime;
            if(flvplayback_internal::waitingForEnough)
            {
               flvplayback_internal::checkReadyForPlay(param1,param2);
            }
         }
      }
      
      public function close() : void
      {
         flvplayback_internal::closeNS(true);
         if(_ncMgr != null && _ncMgr.isRTMP)
         {
            _ncMgr.close();
         }
         flvplayback_internal::setState(VideoState.DISCONNECTED);
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.CLOSE,false,false,_state,playheadTime));
      }
      
      public function pause() : void
      {
         if(!flvplayback_internal::isXnOK())
         {
            if(_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(_state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            _state = flvplayback_internal::_cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               flvplayback_internal::queueCmd(QueuedCommand.PAUSE);
               return;
            }
            flvplayback_internal::execQueuedCmds();
         }
         if(_state == VideoState.PAUSED || _state == VideoState.STOPPED || _ns == null)
         {
            return;
         }
         flvplayback_internal::_pause(true);
         flvplayback_internal::setState(VideoState.PAUSED);
      }
   }
}

