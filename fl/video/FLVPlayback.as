package fl.video
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.*;
   import flash.utils.*;
   
   use namespace flvplayback_internal;
   
   public class FLVPlayback extends Sprite
   {
      
      public static const VERSION:String = "2.1.0.14";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal static const DEFAULT_SKIN_SHOW_TIMER_INTERVAL:Number = 2000;
      
      flvplayback_internal static const skinShowTimerInterval:Number = flvplayback_internal::DEFAULT_SKIN_SHOW_TIMER_INTERVAL;
      
      public static const SEEK_TO_PREV_OFFSET_DEFAULT:Number = 1;
      
      private var _playheadUpdateInterval:Number;
      
      private var _align:String;
      
      flvplayback_internal var videoPlayerStateDict:Dictionary;
      
      flvplayback_internal var cuePointMgrs:Array;
      
      private var _volume:Number;
      
      private var _origHeight:Number;
      
      flvplayback_internal var videoPlayerStates:Array;
      
      private var _progressInterval:Number;
      
      private var _seekToPrevOffset:Number;
      
      private var _origWidth:Number;
      
      private var _scaleMode:String;
      
      flvplayback_internal var resizingNow:Boolean;
      
      flvplayback_internal var videoPlayers:Array;
      
      private var _bufferTime:Number;
      
      private var _aspectRatio:Boolean;
      
      private var _autoRewind:Boolean;
      
      flvplayback_internal var uiMgr:UIManager;
      
      private var previewImage_mc:Loader;
      
      private var _componentInspectorSetting:Boolean;
      
      flvplayback_internal var _firstStreamShown:Boolean;
      
      private var _visibleVP:uint;
      
      private var _idleTimeout:Number;
      
      private var _soundTransform:SoundTransform;
      
      public var boundingBox_mc:DisplayObject;
      
      flvplayback_internal var skinShowTimer:Timer;
      
      private var preview_mc:MovieClip;
      
      private var livePreviewHeight:Number;
      
      flvplayback_internal var _firstStreamReady:Boolean;
      
      private var _activeVP:uint;
      
      private var isLivePreview:Boolean;
      
      private var _topVP:uint;
      
      private var livePreviewWidth:Number;
      
      private var __forceNCMgr:NCManager;
      
      private var previewImageUrl:String;
      
      public function FLVPlayback()
      {
         var _loc1_:VideoPlayer = null;
         super();
         mouseEnabled = false;
         isLivePreview = parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent";
         _componentInspectorSetting = false;
         _origWidth = super.width;
         _origHeight = super.height;
         super.scaleX = 1;
         super.scaleY = 1;
         _loc1_ = new VideoPlayer(0,0);
         _loc1_.setSize(_origWidth,_origHeight);
         flvplayback_internal::videoPlayers = new Array();
         flvplayback_internal::videoPlayers[0] = _loc1_;
         _align = _loc1_.align;
         _autoRewind = _loc1_.autoRewind;
         _scaleMode = _loc1_.scaleMode;
         _bufferTime = _loc1_.bufferTime;
         _idleTimeout = _loc1_.idleTimeout;
         _playheadUpdateInterval = _loc1_.playheadUpdateInterval;
         _progressInterval = _loc1_.progressInterval;
         _soundTransform = _loc1_.soundTransform;
         _volume = _loc1_.volume;
         _seekToPrevOffset = SEEK_TO_PREV_OFFSET_DEFAULT;
         flvplayback_internal::_firstStreamReady = false;
         flvplayback_internal::_firstStreamShown = false;
         flvplayback_internal::resizingNow = false;
         flvplayback_internal::uiMgr = new UIManager(this);
         if(isLivePreview)
         {
            flvplayback_internal::uiMgr.visible = true;
         }
         _activeVP = 0;
         _visibleVP = 0;
         _topVP = 0;
         flvplayback_internal::videoPlayerStates = new Array();
         flvplayback_internal::videoPlayerStateDict = new Dictionary(true);
         flvplayback_internal::cuePointMgrs = new Array();
         flvplayback_internal::createVideoPlayer(0);
         boundingBox_mc.visible = false;
         removeChild(boundingBox_mc);
         boundingBox_mc = null;
         if(isLivePreview)
         {
            previewImageUrl = "";
            createLivePreviewMovieClip();
            setSize(_origWidth,_origHeight);
         }
      }
      
      public function set fullScreenTakeOver(param1:Boolean) : void
      {
         flvplayback_internal::uiMgr.fullScreenTakeOver = param1;
      }
      
      public function pause() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
            flvplayback_internal::queueCmd(_loc1_,QueuedCommand.PAUSE);
         }
         else
         {
            _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
            _loc2_.pause();
         }
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:int = 0;
         var _loc6_:VideoPlayer = null;
         _loc3_ = new Rectangle(x,y,width,height);
         _loc4_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::resizingNow = true;
         _loc5_ = 0;
         while(_loc5_ < flvplayback_internal::videoPlayers.length)
         {
            _loc6_ = flvplayback_internal::videoPlayers[_loc5_];
            if(_loc6_ !== null)
            {
               _loc6_.setSize(_origWidth * param1,_origWidth * param2);
            }
            _loc5_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
      }
      
      public function stop() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
            flvplayback_internal::queueCmd(_loc1_,QueuedCommand.STOP);
         }
         else
         {
            _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
            _loc2_.stop();
         }
      }
      
      public function set align(param1:String) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _align = param1;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.align = param1;
      }
      
      public function getVideoPlayer(param1:Number) : VideoPlayer
      {
         return flvplayback_internal::videoPlayers[param1];
      }
      
      public function get playheadTime() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.playheadTime;
      }
      
      public function get progressInterval() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.progressInterval;
      }
      
      public function set skinFadeTime(param1:int) : void
      {
         flvplayback_internal::uiMgr.skinFadeTime = param1;
      }
      
      public function get seekToPrevOffset() : Number
      {
         return _seekToPrevOffset;
      }
      
      public function set playheadTime(param1:Number) : void
      {
         seek(param1);
      }
      
      public function get source() : String
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
         if(_loc1_.isWaiting)
         {
            return _loc1_.url;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc2_.source;
      }
      
      public function get activeVideoPlayerIndex() : uint
      {
         return _activeVP;
      }
      
      public function get skinFadeTime() : int
      {
         return flvplayback_internal::uiMgr.skinFadeTime;
      }
      
      public function set scaleMode(param1:String) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _scaleMode = param1;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.scaleMode = param1;
      }
      
      public function set bufferingBar(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.BUFFERING_BAR,param1);
      }
      
      public function get metadataLoaded() : Boolean
      {
         var _loc1_:CuePointManager = null;
         _loc1_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc1_.metadataLoaded;
      }
      
      public function closeVideoPlayer(param1:uint) : void
      {
         var _loc2_:VideoPlayer = null;
         if(param1 == 0)
         {
            throw new VideoError(VideoError.DELETE_DEFAULT_PLAYER);
         }
         if(flvplayback_internal::videoPlayers[param1] == undefined)
         {
            return;
         }
         _loc2_ = flvplayback_internal::videoPlayers[param1];
         if(_visibleVP == param1)
         {
            visibleVideoPlayerIndex = 0;
         }
         if(_activeVP == param1)
         {
            activeVideoPlayerIndex = 0;
         }
         removeChild(_loc2_);
         _loc2_.close();
         delete flvplayback_internal::videoPlayers[param1];
         delete flvplayback_internal::videoPlayerStates[param1];
         delete flvplayback_internal::videoPlayerStateDict[_loc2_];
      }
      
      public function get scaleMode() : String
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.scaleMode;
      }
      
      public function set progressInterval(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _progressInterval = param1;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.progressInterval = param1;
      }
      
      public function get playing() : Boolean
      {
         return state == VideoState.PLAYING;
      }
      
      public function get totalTime() : Number
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(isLivePreview)
         {
            return 1;
         }
         _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
         if(_loc1_.totalTimeSet)
         {
            return _loc1_.totalTime;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc2_.totalTime;
      }
      
      public function get ncMgr() : INCManager
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.ncMgr;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_volume == param1)
         {
            return;
         }
         _volume = param1;
         if(!scrubbing)
         {
            _loc2_ = flvplayback_internal::videoPlayers[_visibleVP];
            _loc2_.volume = _volume;
         }
         dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE,false,false,_loc2_.soundTransform));
      }
      
      public function get skinAutoHide() : Boolean
      {
         return flvplayback_internal::uiMgr.skinAutoHide;
      }
      
      public function set source(param1:String) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:CuePointManager = null;
         if(isLivePreview)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = "";
         }
         if(_componentInspectorSetting)
         {
            _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
            _loc2_.url = param1;
            if(param1.length > 0)
            {
               _loc2_.isWaiting = true;
               addEventListener(Event.ENTER_FRAME,doContentPathConnect);
            }
         }
         else
         {
            if(source == param1)
            {
               return;
            }
            _loc3_ = flvplayback_internal::cuePointMgrs[_activeVP];
            _loc3_.reset();
            _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
            _loc2_.url = param1;
            _loc2_.isWaiting = true;
            doContentPathConnect(_activeVP);
         }
      }
      
      public function set activeVideoPlayerIndex(param1:uint) : void
      {
         if(_activeVP == param1)
         {
            return;
         }
         _activeVP = param1;
         if(flvplayback_internal::videoPlayers[_activeVP] == undefined)
         {
            flvplayback_internal::createVideoPlayer(_activeVP);
         }
      }
      
      override public function set soundTransform(param1:SoundTransform) : void
      {
         var _loc2_:VideoPlayer = null;
         if(param1 == null)
         {
            return;
         }
         _volume = param1.volume;
         _soundTransform.volume = scrubbing ? 0 : param1.volume;
         _soundTransform.leftToLeft = param1.leftToLeft;
         _soundTransform.leftToRight = param1.leftToRight;
         _soundTransform.rightToLeft = param1.rightToLeft;
         _soundTransform.rightToRight = param1.rightToRight;
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.soundTransform = _soundTransform;
         dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE,false,false,_loc2_.soundTransform));
      }
      
      public function set seekToPrevOffset(param1:Number) : void
      {
         _seekToPrevOffset = param1;
      }
      
      public function set seekBarScrubTolerance(param1:Number) : void
      {
         flvplayback_internal::uiMgr.seekBarScrubTolerance = param1;
      }
      
      override public function get scaleX() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.width / _origWidth;
      }
      
      override public function get scaleY() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.height / _origHeight;
      }
      
      public function get bytesLoaded() : uint
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.bytesLoaded;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:VideoPlayer = null;
         if(isLivePreview)
         {
            setSize(this.width,param1);
            return;
         }
         _loc2_ = new Rectangle(x,y,width,height);
         _loc3_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::resizingNow = true;
         _loc4_ = 0;
         while(_loc4_ < flvplayback_internal::videoPlayers.length)
         {
            _loc5_ = flvplayback_internal::videoPlayers[_loc4_];
            if(_loc5_ != null)
            {
               _loc5_.height = param1;
            }
            _loc4_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      public function get forwardButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.FORWARD_BUTTON);
      }
      
      public function get seekBarInterval() : Number
      {
         return flvplayback_internal::uiMgr.seekBarInterval;
      }
      
      public function set totalTime(param1:Number) : void
      {
         var _loc2_:VideoPlayerState = null;
         _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
         _loc2_.totalTime = param1;
         _loc2_.totalTimeSet = true;
      }
      
      public function set skinAutoHide(param1:Boolean) : void
      {
         if(isLivePreview)
         {
            return;
         }
         flvplayback_internal::uiMgr.skinAutoHide = param1;
      }
      
      public function set bufferTime(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.bufferTime = param1;
      }
      
      public function get fullScreenSkinDelay() : int
      {
         return flvplayback_internal::uiMgr.fullScreenSkinDelay;
      }
      
      public function seekToNavCuePoint(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 is String)
         {
            _loc2_ = {"name":String(param1)};
         }
         else if(param1 is Number)
         {
            _loc2_ = {"time":Number(param1)};
         }
         else
         {
            _loc2_ = param1;
         }
         if(_loc2_.name == undefined)
         {
            seekToNextNavCuePoint(_loc2_.time);
            return;
         }
         if(isNaN(_loc2_.time))
         {
            _loc2_.time = 0;
         }
         _loc3_ = findNearestCuePoint(param1,CuePointType.NAVIGATION);
         while(_loc3_ != null && (_loc3_.time < _loc2_.time || !isFLVCuePointEnabled(_loc3_)))
         {
            _loc3_ = findNextCuePointWithName(_loc3_);
         }
         if(_loc3_ == null)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         seek(_loc3_.time);
      }
      
      private function onCompletePreview(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            previewImage_mc.width = livePreviewWidth;
            previewImage_mc.height = livePreviewHeight;
         }
         catch(e:Error)
         {
         }
      }
      
      public function set isLive(param1:Boolean) : void
      {
         var _loc2_:VideoPlayerState = null;
         _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
         _loc2_.isLive = param1;
         _loc2_.isLiveSet = true;
      }
      
      flvplayback_internal function showSkinNow(param1:TimerEvent) : void
      {
         flvplayback_internal::skinShowTimer = null;
         flvplayback_internal::uiMgr.visible = true;
      }
      
      override public function get x() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return super.x + _loc1_.x;
      }
      
      override public function get y() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return super.y + _loc1_.y;
      }
      
      public function get seekBar() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.SEEK_BAR);
      }
      
      public function get volumeBarInterval() : Number
      {
         return flvplayback_internal::uiMgr.volumeBarInterval;
      }
      
      public function set registrationHeight(param1:Number) : void
      {
         height = param1;
      }
      
      public function get bufferingBarHidesAndDisablesOthers() : Boolean
      {
         return flvplayback_internal::uiMgr.bufferingBarHidesAndDisablesOthers;
      }
      
      public function seek(param1:Number) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:VideoPlayer = null;
         _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
         if(!flvplayback_internal::_firstStreamShown)
         {
            _loc2_.preSeekTime = 0;
            flvplayback_internal::queueCmd(_loc2_,QueuedCommand.SEEK,param1);
         }
         else
         {
            _loc2_.preSeekTime = playheadTime;
            _loc3_ = flvplayback_internal::videoPlayers[_activeVP];
            _loc3_.seek(param1);
         }
      }
      
      public function get state() : String
      {
         var _loc1_:VideoPlayer = null;
         var _loc2_:String = null;
         var _loc3_:VideoPlayerState = null;
         if(isLivePreview)
         {
            return VideoState.STOPPED;
         }
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         if(_activeVP == _visibleVP && scrubbing)
         {
            return VideoState.SEEKING;
         }
         _loc2_ = _loc1_.state;
         if(_loc2_ == VideoState.RESIZING)
         {
            return VideoState.LOADING;
         }
         _loc3_ = flvplayback_internal::videoPlayerStates[_activeVP];
         if(_loc3_.prevState == VideoState.LOADING && _loc3_.autoPlay && _loc2_ == VideoState.STOPPED)
         {
            return VideoState.LOADING;
         }
         return _loc2_;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _autoRewind = param1;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.autoRewind = param1;
      }
      
      public function get volumeBar() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.VOLUME_BAR);
      }
      
      flvplayback_internal function skinError(param1:String) : void
      {
         if(isLivePreview)
         {
            return;
         }
         if(flvplayback_internal::_firstStreamReady && !flvplayback_internal::_firstStreamShown)
         {
            flvplayback_internal::showFirstStream();
         }
         dispatchEvent(new SkinErrorEvent(SkinErrorEvent.SKIN_ERROR,false,false,param1));
      }
      
      override public function set scaleX(param1:Number) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:VideoPlayer = null;
         _loc2_ = new Rectangle(x,y,width,height);
         _loc3_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::resizingNow = true;
         _loc4_ = 0;
         while(_loc4_ < flvplayback_internal::videoPlayers.length)
         {
            _loc5_ = flvplayback_internal::videoPlayers[_loc4_];
            if(_loc5_ !== null)
            {
               _loc5_.width = _origWidth * param1;
            }
            _loc4_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      override public function set scaleY(param1:Number) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:VideoPlayer = null;
         _loc2_ = new Rectangle(x,y,width,height);
         _loc3_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::resizingNow = true;
         _loc4_ = 0;
         while(_loc4_ < flvplayback_internal::videoPlayers.length)
         {
            _loc5_ = flvplayback_internal::videoPlayers[_loc4_];
            if(_loc5_ !== null)
            {
               _loc5_.height = _origHeight * param1;
            }
            _loc4_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      flvplayback_internal function createVideoPlayer(param1:Number) : void
      {
         var vp:VideoPlayer = null;
         var added:Boolean = false;
         var vpState:VideoPlayerState = null;
         var cpMgr:CuePointManager = null;
         var skinDepth:int = 0;
         var index:Number = param1;
         if(isLivePreview)
         {
            return;
         }
         vp = flvplayback_internal::videoPlayers[index];
         if(vp == null)
         {
            flvplayback_internal::videoPlayers[index] = vp = new VideoPlayer(0,0);
            vp.setSize(registrationWidth,registrationHeight);
         }
         vp.visible = false;
         vp.volume = 0;
         vp.name = String(index);
         added = false;
         if(flvplayback_internal::uiMgr.flvplayback_internal::skin_mc != null)
         {
            try
            {
               skinDepth = getChildIndex(flvplayback_internal::uiMgr.flvplayback_internal::skin_mc);
               if(skinDepth > 0)
               {
                  addChildAt(vp,skinDepth);
                  added = true;
               }
            }
            catch(err:Error)
            {
            }
         }
         if(!added)
         {
            addChild(vp);
         }
         _topVP = index;
         vp.autoRewind = _autoRewind;
         vp.scaleMode = _scaleMode;
         vp.bufferTime = _bufferTime;
         vp.idleTimeout = _idleTimeout;
         vp.playheadUpdateInterval = _playheadUpdateInterval;
         vp.progressInterval = _progressInterval;
         vp.soundTransform = _soundTransform;
         vpState = new VideoPlayerState(vp,index);
         flvplayback_internal::videoPlayerStates[index] = vpState;
         flvplayback_internal::videoPlayerStateDict[vp] = vpState;
         vp.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,flvplayback_internal::handleAutoLayoutEvent);
         vp.addEventListener(MetadataEvent.CUE_POINT,flvplayback_internal::handleMetadataEvent);
         vp.addEventListener(MetadataEvent.METADATA_RECEIVED,flvplayback_internal::handleMetadataEvent);
         vp.addEventListener(VideoProgressEvent.PROGRESS,flvplayback_internal::handleVideoProgressEvent);
         vp.addEventListener(fl.video.VideoEvent.AUTO_REWOUND,flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.CLOSE,flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.COMPLETE,flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.STATE_CHANGE,flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.READY,flvplayback_internal::handleVideoEvent);
         cpMgr = new CuePointManager(this,index);
         flvplayback_internal::cuePointMgrs[index] = cpMgr;
         cpMgr.playheadUpdateInterval = _playheadUpdateInterval;
      }
      
      public function findNearestCuePoint(param1:*, param2:String = "all") : Object
      {
         var _loc3_:CuePointManager = null;
         _loc3_ = flvplayback_internal::cuePointMgrs[_activeVP];
         switch(param2)
         {
            case "event":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::eventCuePoints,true,param1);
            case "navigation":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::navCuePoints,true,param1);
            case "flv":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::flvCuePoints,true,param1);
            case "actionscript":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::asCuePoints,true,param1);
            case "all":
         }
         return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::allCuePoints,true,param1);
      }
      
      public function get muteButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.MUTE_BUTTON);
      }
      
      public function seekPercent(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         if(isNaN(param1) || param1 < 0 || param1 > 100 || isNaN(_loc2_.totalTime) || _loc2_.totalTime <= 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         seek(_loc2_.totalTime * param1 / 100);
      }
      
      public function set forwardButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.FORWARD_BUTTON,param1);
      }
      
      public function get registrationWidth() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.registrationWidth;
      }
      
      flvplayback_internal function queueCmd(param1:VideoPlayerState, param2:Number, param3:Number = NaN) : void
      {
         if(param1.cmdQueue == null)
         {
            param1.cmdQueue = new Array();
         }
         param1.cmdQueue.push(new QueuedCommand(param2,null,false,param3));
      }
      
      private function doContentPathConnect(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:VideoPlayer = null;
         var _loc4_:VideoPlayerState = null;
         if(isLivePreview)
         {
            return;
         }
         _loc2_ = 0;
         if(param1 is int)
         {
            _loc2_ = int(param1);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,doContentPathConnect);
         }
         _loc3_ = flvplayback_internal::videoPlayers[_loc2_];
         _loc4_ = flvplayback_internal::videoPlayerStates[_loc2_];
         if(!_loc4_.isWaiting)
         {
            return;
         }
         if(_loc4_.autoPlay && flvplayback_internal::_firstStreamShown)
         {
            _loc3_.play(_loc4_.url,_loc4_.totalTime,_loc4_.isLive);
         }
         else
         {
            _loc3_.load(_loc4_.url,_loc4_.totalTime,_loc4_.isLive);
         }
         _loc4_.isLiveSet = false;
         _loc4_.totalTimeSet = false;
         _loc4_.isWaiting = false;
      }
      
      public function get registrationX() : Number
      {
         return super.x;
      }
      
      public function bringVideoPlayerToFront(param1:uint) : void
      {
         var vp:VideoPlayer = null;
         var moved:Boolean = false;
         var skinDepth:int = 0;
         var index:uint = param1;
         if(index == _topVP)
         {
            return;
         }
         vp = flvplayback_internal::videoPlayers[index];
         if(vp == null)
         {
            flvplayback_internal::createVideoPlayer(index);
            vp = flvplayback_internal::videoPlayers[index];
         }
         moved = false;
         if(flvplayback_internal::uiMgr.flvplayback_internal::skin_mc != null)
         {
            try
            {
               skinDepth = getChildIndex(flvplayback_internal::uiMgr.flvplayback_internal::skin_mc);
               if(skinDepth > 0)
               {
                  setChildIndex(vp,skinDepth - 1);
                  moved = true;
               }
            }
            catch(err:Error)
            {
            }
         }
         if(!moved)
         {
            setChildIndex(vp,numChildren - 1);
         }
         _topVP = index;
      }
      
      public function get registrationY() : Number
      {
         return super.y;
      }
      
      public function get pauseButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.PAUSE_BUTTON);
      }
      
      public function set seekBarInterval(param1:Number) : void
      {
         flvplayback_internal::uiMgr.seekBarInterval = param1;
      }
      
      public function addASCuePoint(param1:*, param2:String = null, param3:Object = null) : Object
      {
         var _loc4_:CuePointManager = null;
         _loc4_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc4_.addASCuePoint(param1,param2,param3);
      }
      
      public function get playheadPercentage() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         if(isNaN(_loc1_.totalTime))
         {
            return NaN;
         }
         return _loc1_.playheadTime / _loc1_.totalTime * 100;
      }
      
      public function setFLVCuePointEnabled(param1:Boolean, param2:*) : Number
      {
         var _loc3_:CuePointManager = null;
         _loc3_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc3_.setFLVCuePointEnabled(param1,param2);
      }
      
      public function set fullScreenSkinDelay(param1:int) : void
      {
         flvplayback_internal::uiMgr.fullScreenSkinDelay = param1;
      }
      
      public function seekToNextNavCuePoint(param1:Number = NaN) : void
      {
         var _loc2_:VideoPlayer = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         if(isNaN(param1) || param1 < 0)
         {
            param1 = _loc2_.playheadTime + 0.001;
         }
         _loc3_ = findNearestCuePoint(param1,CuePointType.NAVIGATION);
         if(_loc3_ == null)
         {
            seek(_loc2_.totalTime);
            return;
         }
         _loc4_ = Number(_loc3_.index);
         if(_loc3_.time < param1)
         {
            _loc4_++;
         }
         while(_loc4_ < _loc3_.array.length && !isFLVCuePointEnabled(_loc3_.array[_loc4_]))
         {
            _loc4_++;
         }
         if(_loc4_ >= _loc3_.array.length)
         {
            param1 = _loc2_.totalTime;
            if(_loc3_.array[_loc3_.array.length - 1].time > param1)
            {
               param1 = Number(_loc3_.array[_loc3_.array.length - 1]);
            }
            seek(param1);
         }
         else
         {
            seek(_loc3_.array[_loc4_].time);
         }
      }
      
      public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         if(param1 == this.source)
         {
            return;
         }
         this.autoPlay = false;
         this.totalTime = param2;
         this.isLive = param3;
         this.source = param1;
      }
      
      public function seekSeconds(param1:Number) : void
      {
         seek(param1);
      }
      
      public function get fullScreenButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.FULL_SCREEN_BUTTON);
      }
      
      public function get scrubbing() : Boolean
      {
         var _loc1_:Sprite = null;
         var _loc2_:ControlData = null;
         _loc1_ = seekBar;
         if(_loc1_ != null)
         {
            _loc2_ = flvplayback_internal::uiMgr.ctrlDataDict[_loc1_];
            return _loc2_.isDragging;
         }
         return false;
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         _loc2_ = flvplayback_internal::videoPlayers[_visibleVP];
         super.y = param1 - _loc2_.y;
      }
      
      public function removeASCuePoint(param1:*) : Object
      {
         var _loc2_:CuePointManager = null;
         _loc2_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc2_.removeASCuePoint(param1);
      }
      
      public function get fullScreenTakeOver() : Boolean
      {
         return flvplayback_internal::uiMgr.fullScreenTakeOver;
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         _loc2_ = flvplayback_internal::videoPlayers[_visibleVP];
         super.x = param1 - _loc2_.x;
      }
      
      public function get backButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.BACK_BUTTON);
      }
      
      public function set seekBar(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.SEEK_BAR,param1);
      }
      
      public function set skin(param1:String) : void
      {
         flvplayback_internal::uiMgr.skin = param1;
      }
      
      public function set componentInspectorSetting(param1:Boolean) : void
      {
         _componentInspectorSetting = param1;
      }
      
      public function get preferredHeight() : int
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.videoHeight;
      }
      
      public function set volumeBarInterval(param1:Number) : void
      {
         flvplayback_internal::uiMgr.volumeBarInterval = param1;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         var _loc2_:VideoPlayerState = null;
         _loc2_ = flvplayback_internal::videoPlayerStates[_activeVP];
         _loc2_.autoPlay = param1;
      }
      
      public function set visibleVideoPlayerIndex(param1:uint) : void
      {
         var _loc2_:VideoPlayer = null;
         var _loc3_:VideoPlayer = null;
         var _loc4_:uint = 0;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         if(_visibleVP == param1)
         {
            return;
         }
         if(flvplayback_internal::videoPlayers[param1] == undefined)
         {
            flvplayback_internal::createVideoPlayer(param1);
         }
         _loc2_ = flvplayback_internal::videoPlayers[param1];
         _loc3_ = flvplayback_internal::videoPlayers[_visibleVP];
         _loc3_.visible = false;
         _loc3_.volume = 0;
         _visibleVP = param1;
         if(flvplayback_internal::_firstStreamShown)
         {
            flvplayback_internal::uiMgr.flvplayback_internal::setupSkinAutoHide(false);
            _loc2_.visible = true;
            _soundTransform.volume = !scrubbing ? 0 : _volume;
            _loc2_.soundTransform = _soundTransform;
         }
         else if((_loc2_.stateResponsive || _loc2_.state == VideoState.CONNECTION_ERROR || _loc2_.state == VideoState.DISCONNECTED) && flvplayback_internal::uiMgr.skinReady)
         {
            flvplayback_internal::uiMgr.visible = true;
            flvplayback_internal::uiMgr.flvplayback_internal::setupSkinAutoHide(false);
            flvplayback_internal::_firstStreamReady = true;
            if(flvplayback_internal::uiMgr.skin == "")
            {
               flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
            }
            flvplayback_internal::showFirstStream();
         }
         if(_loc2_.height != _loc3_.height || _loc2_.width != _loc3_.width)
         {
            _loc5_ = new Rectangle(_loc3_.x + super.x,_loc3_.y + super.y,_loc3_.width,_loc3_.height);
            _loc6_ = new Rectangle(_loc3_.registrationX + super.x,_loc3_.registrationY + super.y,_loc3_.registrationWidth,_loc3_.registrationHeight);
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc5_,_loc6_));
         }
         _loc4_ = _activeVP;
         _activeVP = _visibleVP;
         flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,state,playheadTime,_visibleVP));
         flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYHEAD_UPDATE,false,false,state,playheadTime,_visibleVP));
         if(_loc2_.isRTMP)
         {
            flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.READY,false,false,state,playheadTime,_visibleVP));
         }
         else
         {
            flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal,_visibleVP));
         }
         _activeVP = _loc4_;
      }
      
      public function get bufferingBar() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.BUFFERING_BAR);
      }
      
      flvplayback_internal function _scrubStart() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:VideoPlayer = null;
         _loc1_ = playheadTime;
         _loc2_ = flvplayback_internal::videoPlayers[_visibleVP];
         _volume = _loc2_.volume;
         _loc2_.volume = 0;
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,VideoState.SEEKING,_loc1_,_visibleVP));
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SCRUB_START,false,false,VideoState.SEEKING,_loc1_,_visibleVP));
      }
      
      public function get align() : String
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.align;
      }
      
      flvplayback_internal function handleAutoLayoutEvent(param1:AutoLayoutEvent) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:AutoLayoutEvent = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         _loc2_ = flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         _loc3_ = AutoLayoutEvent(param1.clone());
         _loc3_.oldBounds.x += super.x;
         _loc3_.oldBounds.y += super.y;
         _loc3_.oldRegistrationBounds.x += super.y;
         _loc3_.oldRegistrationBounds.y += super.y;
         _loc3_.vp = _loc2_.index;
         dispatchEvent(_loc3_);
         if(!flvplayback_internal::resizingNow && _loc2_.index == _visibleVP)
         {
            _loc4_ = Rectangle(param1.oldBounds.clone());
            _loc5_ = Rectangle(param1.oldRegistrationBounds.clone());
            _loc4_.x += super.x;
            _loc4_.y += super.y;
            _loc5_.x += super.y;
            _loc5_.y += super.y;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc4_,_loc5_));
         }
      }
      
      public function findNextCuePointWithName(param1:Object) : Object
      {
         var _loc2_:CuePointManager = null;
         _loc2_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc2_.flvplayback_internal::getNextCuePointWithName(param1);
      }
      
      public function set playButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.PLAY_BUTTON,param1);
      }
      
      public function set bitrate(param1:Number) : void
      {
         ncMgr.bitrate = param1;
      }
      
      public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
      {
         flvplayback_internal::uiMgr.bufferingBarHidesAndDisablesOthers = param1;
      }
      
      override public function get soundTransform() : SoundTransform
      {
         var _loc1_:VideoPlayer = null;
         var _loc2_:SoundTransform = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         _loc2_ = _loc1_.soundTransform;
         if(scrubbing)
         {
            _loc2_.volume = _volume;
         }
         return _loc2_;
      }
      
      public function get stateResponsive() : Boolean
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.stateResponsive;
      }
      
      public function get idleTimeout() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.idleTimeout;
      }
      
      override public function get height() : Number
      {
         var _loc1_:VideoPlayer = null;
         if(isLivePreview)
         {
            return livePreviewHeight;
         }
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.height;
      }
      
      public function set registrationWidth(param1:Number) : void
      {
         width = param1;
      }
      
      public function get metadata() : Object
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.metadata;
      }
      
      public function set skinBackgroundColor(param1:uint) : void
      {
         flvplayback_internal::uiMgr.skinBackgroundColor = param1;
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
      {
         var _loc4_:VideoPlayerState = null;
         var _loc5_:VideoPlayer = null;
         if(param1 == null)
         {
            if(!flvplayback_internal::_firstStreamShown)
            {
               _loc4_ = flvplayback_internal::videoPlayerStates[_activeVP];
               flvplayback_internal::queueCmd(_loc4_,QueuedCommand.PLAY);
            }
            else
            {
               _loc5_ = flvplayback_internal::videoPlayers[_activeVP];
               _loc5_.play();
            }
         }
         else
         {
            if(param1 == this.source)
            {
               return;
            }
            this.autoPlay = true;
            this.totalTime = param2;
            this.isLive = param3;
            this.source = param1;
         }
      }
      
      public function get paused() : Boolean
      {
         return state == VideoState.PAUSED;
      }
      
      flvplayback_internal function handleVideoEvent(param1:fl.video.VideoEvent) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:CuePointManager = null;
         var _loc4_:fl.video.VideoEvent = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         _loc2_ = flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         _loc3_ = flvplayback_internal::cuePointMgrs[_loc2_.index];
         _loc4_ = VideoEvent(param1.clone());
         _loc4_.vp = _loc2_.index;
         _loc5_ = _loc2_.index == _visibleVP && scrubbing ? VideoState.SEEKING : param1.state;
         switch(param1.type)
         {
            case fl.video.VideoEvent.AUTO_REWOUND:
               dispatchEvent(_loc4_);
               dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.REWIND,false,false,_loc5_,param1.playheadTime,_loc2_.index));
               _loc3_.resetASCuePointIndex(param1.playheadTime);
               break;
            case fl.video.VideoEvent.PLAYHEAD_UPDATE:
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               if(!isNaN(_loc2_.preSeekTime) && param1.state != VideoState.SEEKING)
               {
                  _loc6_ = _loc2_.preSeekTime;
                  _loc2_.preSeekTime = NaN;
                  _loc3_.resetASCuePointIndex(param1.playheadTime);
                  dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SEEKED,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  if(_loc6_ < param1.playheadTime)
                  {
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.FAST_FORWARD,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  }
                  else if(_loc6_ > param1.playheadTime)
                  {
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.REWIND,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  }
               }
               _loc3_.dispatchASCuePoints();
               break;
            case fl.video.VideoEvent.STATE_CHANGE:
               if(_loc2_.index == _visibleVP && scrubbing)
               {
                  break;
               }
               if(param1.state == VideoState.RESIZING)
               {
                  break;
               }
               if(_loc2_.prevState == VideoState.LOADING && _loc2_.autoPlay && param1.state == VideoState.STOPPED)
               {
                  return;
               }
               if(param1.state == VideoState.CONNECTION_ERROR && param1.vp == _visibleVP && !flvplayback_internal::_firstStreamShown && flvplayback_internal::uiMgr.skinReady)
               {
                  flvplayback_internal::showFirstStream();
                  flvplayback_internal::uiMgr.visible = true;
                  if(flvplayback_internal::uiMgr.skin == "")
                  {
                     flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
                  }
                  if(flvplayback_internal::skinShowTimer != null)
                  {
                     flvplayback_internal::skinShowTimer.reset();
                     flvplayback_internal::skinShowTimer = null;
                  }
               }
               _loc2_.prevState = param1.state;
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               if(_loc2_.owner.state != param1.state)
               {
                  return;
               }
               switch(param1.state)
               {
                  case VideoState.BUFFERING:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.BUFFERING_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break;
                  case VideoState.PAUSED:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PAUSED_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break;
                  case VideoState.PLAYING:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYING_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break;
                  case VideoState.STOPPED:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STOPPED_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
               }
               break;
            case fl.video.VideoEvent.READY:
               if(!flvplayback_internal::_firstStreamReady)
               {
                  if(_loc2_.index == _visibleVP)
                  {
                     flvplayback_internal::_firstStreamReady = true;
                     if(flvplayback_internal::uiMgr.skinReady && !flvplayback_internal::_firstStreamShown)
                     {
                        flvplayback_internal::uiMgr.visible = true;
                        if(flvplayback_internal::uiMgr.skin == "")
                        {
                           flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
                        }
                        flvplayback_internal::showFirstStream();
                     }
                  }
               }
               else if(flvplayback_internal::_firstStreamShown && param1.state == VideoState.STOPPED && _loc2_.autoPlay)
               {
                  if(_loc2_.owner.isRTMP)
                  {
                     _loc2_.owner.play();
                  }
                  else
                  {
                     _loc2_.prevState = VideoState.STOPPED;
                     _loc2_.owner.playWhenEnoughDownloaded();
                  }
               }
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               break;
            case fl.video.VideoEvent.CLOSE:
            case fl.video.VideoEvent.COMPLETE:
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
         }
      }
      
      public function set volumeBar(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.VOLUME_BAR,param1);
      }
      
      public function set fullScreenBackgroundColor(param1:uint) : void
      {
         flvplayback_internal::uiMgr.fullScreenBackgroundColor = param1;
      }
      
      public function get isLive() : Boolean
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
         if(_loc1_.isLiveSet)
         {
            return _loc1_.isLive;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc2_.isLive;
      }
      
      public function get bufferTime() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.bufferTime;
      }
      
      public function get registrationHeight() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.registrationHeight;
      }
      
      public function get playPauseButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.PLAY_PAUSE_BUTTON);
      }
      
      flvplayback_internal function showFirstStream() : void
      {
         var _loc1_:VideoPlayer = null;
         var _loc2_:int = 0;
         var _loc3_:VideoPlayerState = null;
         var _loc4_:int = 0;
         flvplayback_internal::_firstStreamShown = true;
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         _loc1_.visible = true;
         if(!scrubbing)
         {
            _soundTransform.volume = _volume;
            _loc1_.soundTransform = _soundTransform;
         }
         _loc2_ = 0;
         while(_loc2_ < flvplayback_internal::videoPlayers.length)
         {
            _loc1_ = flvplayback_internal::videoPlayers[_loc2_];
            if(_loc1_ != null)
            {
               _loc3_ = flvplayback_internal::videoPlayerStates[_loc2_];
               if(_loc1_.state == VideoState.STOPPED && _loc3_.autoPlay)
               {
                  if(_loc1_.isRTMP)
                  {
                     _loc1_.play();
                  }
                  else
                  {
                     _loc3_.prevState = VideoState.STOPPED;
                     _loc1_.playWhenEnoughDownloaded();
                  }
               }
               if(_loc3_.cmdQueue != null)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.cmdQueue.length)
                  {
                     switch(_loc3_.cmdQueue[_loc4_].type)
                     {
                        case QueuedCommand.PLAY:
                           _loc1_.play();
                           break;
                        case QueuedCommand.PAUSE:
                           _loc1_.pause();
                           break;
                        case QueuedCommand.STOP:
                           _loc1_.stop();
                           break;
                        case QueuedCommand.SEEK:
                           _loc1_.seek(_loc3_.cmdQueue[_loc4_].time);
                           break;
                        case QueuedCommand.PLAY_WHEN_ENOUGH:
                           _loc1_.playWhenEnoughDownloaded();
                           break;
                     }
                     _loc4_++;
                  }
                  _loc3_.cmdQueue = null;
               }
            }
            _loc2_++;
         }
      }
      
      public function set volumeBarScrubTolerance(param1:Number) : void
      {
         flvplayback_internal::uiMgr.volumeBarScrubTolerance = param1;
      }
      
      public function set skinBackgroundAlpha(param1:Number) : void
      {
         flvplayback_internal::uiMgr.skinBackgroundAlpha = param1;
      }
      
      public function get playheadUpdateInterval() : Number
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.playheadUpdateInterval;
      }
      
      public function set muteButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.MUTE_BUTTON,param1);
      }
      
      public function set skinScaleMaximum(param1:Number) : *
      {
         flvplayback_internal::uiMgr.skinScaleMaximum = param1;
      }
      
      public function enterFullScreenDisplayState() : void
      {
         flvplayback_internal::uiMgr.enterFullScreenDisplayState();
      }
      
      flvplayback_internal function handleMetadataEvent(param1:MetadataEvent) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:CuePointManager = null;
         var _loc4_:MetadataEvent = null;
         _loc2_ = flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         _loc3_ = flvplayback_internal::cuePointMgrs[_loc2_.index];
         switch(param1.type)
         {
            case MetadataEvent.METADATA_RECEIVED:
               _loc3_.processFLVCuePoints(param1.info.cuePoints);
               break;
            case MetadataEvent.CUE_POINT:
               if(!_loc3_.isFLVCuePointEnabled(param1.info))
               {
                  return;
               }
               break;
         }
         _loc4_ = MetadataEvent(param1.clone());
         _loc4_.vp = _loc2_.index;
         dispatchEvent(_loc4_);
      }
      
      public function playWhenEnoughDownloaded() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
            flvplayback_internal::queueCmd(_loc1_,QueuedCommand.PLAY_WHEN_ENOUGH);
         }
         else
         {
            _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
            _loc2_.playWhenEnoughDownloaded();
         }
      }
      
      public function get bitrate() : Number
      {
         return ncMgr.bitrate;
      }
      
      public function get autoRewind() : Boolean
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.autoRewind;
      }
      
      public function get fullScreenBackgroundColor() : uint
      {
         return flvplayback_internal::uiMgr.fullScreenBackgroundColor;
      }
      
      public function get skin() : String
      {
         return flvplayback_internal::uiMgr.skin;
      }
      
      public function set registrationX(param1:Number) : void
      {
         super.x = param1;
      }
      
      public function set registrationY(param1:Number) : void
      {
         super.y = param1;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:int = 0;
         var _loc6_:VideoPlayer = null;
         _loc3_ = new Rectangle(x,y,this.width,this.height);
         _loc4_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         if(isLivePreview)
         {
            livePreviewWidth = param1;
            livePreviewHeight = param2;
            if(previewImage_mc != null)
            {
               previewImage_mc.width = param1;
               previewImage_mc.height = param2;
            }
            preview_mc.box_mc.width = param1;
            preview_mc.box_mc.height = param2;
            if(preview_mc.box_mc.width < preview_mc.icon_mc.width || preview_mc.box_mc.height < preview_mc.icon_mc.height)
            {
               preview_mc.icon_mc.visible = false;
            }
            else
            {
               preview_mc.icon_mc.visible = true;
               preview_mc.icon_mc.x = (preview_mc.box_mc.width - preview_mc.icon_mc.width) / 2;
               preview_mc.icon_mc.y = (preview_mc.box_mc.height - preview_mc.icon_mc.height) / 2;
            }
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
            return;
         }
         flvplayback_internal::resizingNow = true;
         _loc5_ = 0;
         while(_loc5_ < flvplayback_internal::videoPlayers.length)
         {
            _loc6_ = flvplayback_internal::videoPlayers[_loc5_];
            if(_loc6_ != null)
            {
               _loc6_.setSize(param1,param2);
            }
            _loc5_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
      }
      
      public function get isRTMP() : Boolean
      {
         var _loc1_:VideoPlayer = null;
         if(isLivePreview)
         {
            return true;
         }
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.isRTMP;
      }
      
      public function set preview(param1:String) : void
      {
         var filename:String = param1;
         if(!isLivePreview)
         {
            return;
         }
         previewImageUrl = filename;
         if(previewImage_mc != null)
         {
            removeChild(previewImage_mc);
         }
         previewImage_mc = new Loader();
         previewImage_mc.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompletePreview);
         previewImage_mc.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
         });
         previewImage_mc.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:SecurityErrorEvent):void
         {
         });
         addChildAt(previewImage_mc,1);
         previewImage_mc.load(new URLRequest(previewImageUrl));
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:VideoPlayer = null;
         if(isLivePreview)
         {
            setSize(param1,this.height);
            return;
         }
         _loc2_ = new Rectangle(x,y,width,height);
         _loc3_ = new Rectangle(registrationX,registrationY,registrationWidth,registrationHeight);
         flvplayback_internal::resizingNow = true;
         _loc4_ = 0;
         while(_loc4_ < flvplayback_internal::videoPlayers.length)
         {
            _loc5_ = flvplayback_internal::videoPlayers[_loc4_];
            if(_loc5_ != null)
            {
               _loc5_.width = param1;
            }
            _loc4_++;
         }
         flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      public function get playButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.PLAY_BUTTON);
      }
      
      public function set pauseButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.PAUSE_BUTTON,param1);
      }
      
      public function get bytesTotal() : uint
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.bytesTotal;
      }
      
      public function seekToPrevNavCuePoint(param1:Number = NaN) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:VideoPlayer = null;
         if(isNaN(param1) || param1 < 0)
         {
            _loc4_ = flvplayback_internal::videoPlayers[_activeVP];
            param1 = _loc4_.playheadTime;
         }
         _loc2_ = findNearestCuePoint(param1,CuePointType.NAVIGATION);
         if(_loc2_ == null)
         {
            seek(0);
            return;
         }
         _loc3_ = Number(_loc2_.index);
         while(_loc3_ >= 0 && (!isFLVCuePointEnabled(_loc2_.array[_loc3_]) || _loc2_.array[_loc3_].time >= param1 - _seekToPrevOffset))
         {
            _loc3_--;
         }
         if(_loc3_ < 0)
         {
            seek(0);
         }
         else
         {
            seek(_loc2_.array[_loc3_].time);
         }
      }
      
      public function get autoPlay() : Boolean
      {
         var _loc1_:VideoPlayerState = null;
         _loc1_ = flvplayback_internal::videoPlayerStates[_activeVP];
         return _loc1_.autoPlay;
      }
      
      public function set playheadPercentage(param1:Number) : void
      {
         seekPercent(param1);
      }
      
      public function isFLVCuePointEnabled(param1:*) : Boolean
      {
         var _loc2_:CuePointManager = null;
         _loc2_ = flvplayback_internal::cuePointMgrs[_activeVP];
         return _loc2_.isFLVCuePointEnabled(param1);
      }
      
      public function get buffering() : Boolean
      {
         return state == VideoState.BUFFERING;
      }
      
      public function get volumeBarScrubTolerance() : Number
      {
         return flvplayback_internal::uiMgr.volumeBarScrubTolerance;
      }
      
      public function get skinBackgroundColor() : uint
      {
         return flvplayback_internal::uiMgr.skinBackgroundColor;
      }
      
      public function get visibleVideoPlayerIndex() : uint
      {
         return _visibleVP;
      }
      
      public function set stopButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.STOP_BUTTON,param1);
      }
      
      public function get skinBackgroundAlpha() : Number
      {
         return flvplayback_internal::uiMgr.skinBackgroundAlpha;
      }
      
      public function get skinScaleMaximum() : Number
      {
         return flvplayback_internal::uiMgr.skinScaleMaximum;
      }
      
      public function get preferredWidth() : int
      {
         var _loc1_:VideoPlayer = null;
         _loc1_ = flvplayback_internal::videoPlayers[_activeVP];
         return _loc1_.videoWidth;
      }
      
      override public function get width() : Number
      {
         var _loc1_:VideoPlayer = null;
         if(isLivePreview)
         {
            return livePreviewWidth;
         }
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         return _loc1_.width;
      }
      
      public function get stopped() : Boolean
      {
         return state == VideoState.STOPPED;
      }
      
      public function set fullScreenButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.FULL_SCREEN_BUTTON,param1);
      }
      
      public function get stopButton() : Sprite
      {
         return flvplayback_internal::uiMgr.getControl(UIManager.STOP_BUTTON);
      }
      
      public function set playheadUpdateInterval(param1:Number) : void
      {
         var _loc2_:CuePointManager = null;
         var _loc3_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _playheadUpdateInterval = param1;
         }
         _loc2_ = flvplayback_internal::cuePointMgrs[_activeVP];
         _loc2_.playheadUpdateInterval = param1;
         _loc3_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc3_.playheadUpdateInterval = param1;
      }
      
      private function createLivePreviewMovieClip() : void
      {
         preview_mc = new MovieClip();
         preview_mc.name = "preview_mc";
         preview_mc.box_mc = new MovieClip();
         preview_mc.box_mc.name = "box_mc";
         preview_mc.box_mc.graphics.beginFill(0);
         preview_mc.box_mc.graphics.moveTo(0,0);
         preview_mc.box_mc.graphics.lineTo(0,100);
         preview_mc.box_mc.graphics.lineTo(100,100);
         preview_mc.box_mc.graphics.lineTo(100,0);
         preview_mc.box_mc.graphics.lineTo(0,0);
         preview_mc.box_mc.graphics.endFill();
         preview_mc.addChild(preview_mc.box_mc);
         preview_mc.icon_mc = new Icon();
         preview_mc.icon_mc.name = "icon_mc";
         preview_mc.addChild(preview_mc.icon_mc);
         addChild(preview_mc);
      }
      
      public function set idleTimeout(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         if(_activeVP == 0)
         {
            _idleTimeout = param1;
         }
         _loc2_ = flvplayback_internal::videoPlayers[_activeVP];
         _loc2_.idleTimeout = param1;
      }
      
      flvplayback_internal function skinLoaded() : void
      {
         var _loc1_:VideoPlayer = null;
         if(isLivePreview)
         {
            return;
         }
         _loc1_ = flvplayback_internal::videoPlayers[_visibleVP];
         if(flvplayback_internal::_firstStreamReady || _loc1_.state == VideoState.CONNECTION_ERROR || _loc1_.state == VideoState.DISCONNECTED)
         {
            flvplayback_internal::uiMgr.visible = true;
            if(!flvplayback_internal::_firstStreamShown)
            {
               flvplayback_internal::showFirstStream();
            }
         }
         else
         {
            if(flvplayback_internal::skinShowTimer != null)
            {
               flvplayback_internal::skinShowTimer.reset();
               flvplayback_internal::skinShowTimer = null;
            }
            flvplayback_internal::skinShowTimer = new Timer(flvplayback_internal::DEFAULT_SKIN_SHOW_TIMER_INTERVAL,1);
            flvplayback_internal::skinShowTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::showSkinNow);
            flvplayback_internal::skinShowTimer.start();
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SKIN_LOADED,false,false,state,playheadTime,_visibleVP));
      }
      
      flvplayback_internal function _scrubFinish() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:String = null;
         var _loc3_:VideoPlayer = null;
         _loc1_ = playheadTime;
         _loc2_ = state;
         _loc3_ = flvplayback_internal::videoPlayers[_visibleVP];
         _soundTransform.volume = _volume;
         _loc3_.soundTransform = _soundTransform;
         if(_loc2_ != VideoState.SEEKING)
         {
            dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,_loc2_,_loc1_,_visibleVP));
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SCRUB_FINISH,false,false,_loc2_,_loc1_,_visibleVP));
      }
      
      public function set playPauseButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.PLAY_PAUSE_BUTTON,param1);
      }
      
      public function set backButton(param1:Sprite) : void
      {
         flvplayback_internal::uiMgr.setControl(UIManager.BACK_BUTTON,param1);
      }
      
      public function set cuePoints(param1:Array) : void
      {
         if(!_componentInspectorSetting)
         {
            return;
         }
         flvplayback_internal::cuePointMgrs[0].processCuePointsProperty(param1);
      }
      
      public function findCuePoint(param1:*, param2:String = "all") : Object
      {
         var _loc3_:CuePointManager = null;
         _loc3_ = flvplayback_internal::cuePointMgrs[_activeVP];
         switch(param2)
         {
            case "event":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::eventCuePoints,false,param1);
            case "navigation":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::navCuePoints,false,param1);
            case "flv":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::flvCuePoints,false,param1);
            case "actionscript":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::asCuePoints,false,param1);
            case "all":
         }
         return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::allCuePoints,false,param1);
      }
      
      public function get seekBarScrubTolerance() : Number
      {
         return flvplayback_internal::uiMgr.seekBarScrubTolerance;
      }
      
      flvplayback_internal function handleVideoProgressEvent(param1:VideoProgressEvent) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:VideoProgressEvent = null;
         _loc2_ = flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         _loc3_ = VideoProgressEvent(param1.clone());
         _loc3_.vp = _loc2_.index;
         dispatchEvent(_loc3_);
      }
   }
}

