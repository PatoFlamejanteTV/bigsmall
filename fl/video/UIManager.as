package fl.video
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.*;
   
   use namespace flvplayback_internal;
   
   public class UIManager
   {
      
      public static const VERSION:String = "2.1.0.14";
      
      public static const SHORT_VERSION:String = "2.1";
      
      public static const PAUSE_BUTTON:int = 0;
      
      public static const PLAY_BUTTON:int = 1;
      
      public static const STOP_BUTTON:int = 2;
      
      public static const SEEK_BAR_HANDLE:int = 3;
      
      public static const SEEK_BAR_HIT:int = 4;
      
      public static const BACK_BUTTON:int = 5;
      
      public static const FORWARD_BUTTON:int = 6;
      
      public static const FULL_SCREEN_ON_BUTTON:int = 7;
      
      public static const FULL_SCREEN_OFF_BUTTON:int = 8;
      
      public static const MUTE_ON_BUTTON:int = 9;
      
      public static const MUTE_OFF_BUTTON:int = 10;
      
      public static const VOLUME_BAR_HANDLE:int = 11;
      
      public static const VOLUME_BAR_HIT:int = 12;
      
      public static const NUM_BUTTONS:int = 13;
      
      public static const PLAY_PAUSE_BUTTON:int = 13;
      
      public static const FULL_SCREEN_BUTTON:int = 14;
      
      public static const MUTE_BUTTON:int = 15;
      
      public static const BUFFERING_BAR:int = 16;
      
      public static const SEEK_BAR:int = 17;
      
      public static const VOLUME_BAR:int = 18;
      
      public static const NUM_CONTROLS:int = 19;
      
      public static const NORMAL_STATE:uint = 0;
      
      public static const OVER_STATE:uint = 1;
      
      public static const DOWN_STATE:uint = 2;
      
      public static const FULL_SCREEN_SOURCE_RECT_MIN_WIDTH:uint = 320;
      
      public static const FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT:uint = 240;
      
      flvplayback_internal static const SKIN_AUTO_HIDE_INTERVAL:Number = 200;
      
      flvplayback_internal static const SKIN_FADING_INTERVAL:Number = 100;
      
      flvplayback_internal static const SKIN_FADING_MAX_TIME_DEFAULT:Number = 500;
      
      flvplayback_internal static const SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT:Number = 3000;
      
      public static const VOLUME_BAR_INTERVAL_DEFAULT:Number = 250;
      
      public static const VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 0;
      
      public static const SEEK_BAR_INTERVAL_DEFAULT:Number = 250;
      
      public static const SEEK_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 5;
      
      public static const BUFFERING_DELAY_INTERVAL_DEFAULT:Number = 1000;
      
      flvplayback_internal static var layoutNameToIndexMappings:Object = null;
      
      flvplayback_internal static var layoutNameArray:Array = ["pause_mc","play_mc","stop_mc",null,null,"back_mc","forward_mc",null,null,null,null,null,null,"playpause_mc","fullScreenToggle_mc","volumeMute_mc","bufferingBar_mc","seekBar_mc","volumeBar_mc","seekBarHandle_mc","seekBarHit_mc","seekBarProgress_mc","seekBarFullness_mc","volumeBarHandle_mc","volumeBarHit_mc","volumeBarProgress_mc","volumeBarFullness_mc","progressFill_mc"];
      
      flvplayback_internal static var skinClassPrefixes:Array = ["pauseButton","playButton","stopButton",null,null,"backButton","forwardButton","fullScreenButtonOn","fullScreenButtonOff","muteButtonOn","muteButtonOff",null,null,null,null,null,"bufferingBar","seekBar","volumeBar"];
      
      flvplayback_internal static var customComponentClassNames:Array = ["PauseButton","PlayButton","StopButton",null,null,"BackButton","ForwardButton",null,null,null,null,null,null,"PlayPauseButton","FullScreenButton","MuteButton","BufferingBar","SeekBar","VolumeBar"];
      
      flvplayback_internal static var buttonSkinLinkageIDs:Array = ["upLinkageID","overLinkageID","downLinkageID"];
      
      flvplayback_internal var cacheStageBGColor:uint;
      
      flvplayback_internal var _bufferingDelayTimer:Timer;
      
      public var ctrlDataDict:Dictionary;
      
      flvplayback_internal var _skinAutoHide:Boolean;
      
      flvplayback_internal var placeholderLeft:Number;
      
      flvplayback_internal var _playAfterScrub:Boolean;
      
      public var customClips:Array;
      
      flvplayback_internal var _skinFadeStartTime:int;
      
      flvplayback_internal var delayedControls:Array;
      
      flvplayback_internal var _lastScrubPos:Number;
      
      flvplayback_internal var _skinAutoHideLastMotionTime:int;
      
      flvplayback_internal var _volumeBarTimer:Timer;
      
      flvplayback_internal var cacheFLVPlaybackScaleMode:Array;
      
      flvplayback_internal var borderScale9Rects:Array;
      
      flvplayback_internal var _volumeBarScrubTolerance:Number;
      
      flvplayback_internal var fullScreenSourceRectMinAspectRatio:Number;
      
      flvplayback_internal var _skin:String;
      
      flvplayback_internal var fullScreenSourceRectMinHeight:uint;
      
      flvplayback_internal var videoRight:Number;
      
      flvplayback_internal var _bufferingBarHides:Boolean;
      
      flvplayback_internal var placeholderRight:Number;
      
      flvplayback_internal var cachedSoundLevel:Number;
      
      flvplayback_internal var videoBottom:Number;
      
      flvplayback_internal var border_mc:DisplayObject;
      
      flvplayback_internal var borderAlpha:Number;
      
      flvplayback_internal var borderColorTransform:ColorTransform;
      
      flvplayback_internal var _skinFadingTimer:Timer;
      
      flvplayback_internal var __visible:Boolean;
      
      flvplayback_internal var borderColor:uint;
      
      flvplayback_internal var cacheFLVPlaybackIndex:int;
      
      flvplayback_internal var cacheFLVPlaybackLocation:Rectangle;
      
      flvplayback_internal var _skinReady:Boolean;
      
      flvplayback_internal var controls:Array;
      
      flvplayback_internal var cacheFLVPlaybackAlign:Array;
      
      flvplayback_internal var _skinAutoHideMouseX:Number;
      
      flvplayback_internal var _skinAutoHideMouseY:Number;
      
      flvplayback_internal var layout_mc:Sprite;
      
      flvplayback_internal var cacheSkinAutoHide:Boolean;
      
      flvplayback_internal var cacheStageScaleMode:String;
      
      flvplayback_internal var videoTop:Number;
      
      flvplayback_internal var _skinFadingMaxTime:int;
      
      flvplayback_internal var placeholderTop:Number;
      
      flvplayback_internal var _lastVolumePos:Number;
      
      flvplayback_internal var mouseCaptureCtrl:int;
      
      flvplayback_internal var _seekBarScrubTolerance:Number;
      
      flvplayback_internal var borderPrevRect:Rectangle;
      
      flvplayback_internal var skinTemplate:Sprite;
      
      flvplayback_internal var _progressPercent:Number;
      
      flvplayback_internal var videoLeft:Number;
      
      flvplayback_internal var _fullScreenVideoWidth:Number;
      
      flvplayback_internal var _isMuted:Boolean;
      
      flvplayback_internal var _skinAutoHideTimer:Timer;
      
      flvplayback_internal var _fullScreenBgColor:uint;
      
      flvplayback_internal var _vc:FLVPlayback;
      
      flvplayback_internal var _bufferingOn:Boolean;
      
      flvplayback_internal var _seekBarTimer:Timer;
      
      flvplayback_internal var _controlsEnabled:Boolean;
      
      flvplayback_internal var _fullScreen:Boolean;
      
      flvplayback_internal var placeholderBottom:Number;
      
      flvplayback_internal var fullScreenSourceRectMinWidth:uint;
      
      flvplayback_internal var _fullScreenTakeOver:Boolean;
      
      flvplayback_internal var skin_mc:Sprite;
      
      flvplayback_internal var _fullScreenAccel:Boolean;
      
      flvplayback_internal var _fullScreenVideoHeight:Number;
      
      flvplayback_internal var skinLoadDelayCount:uint;
      
      flvplayback_internal var _skinFadingIn:Boolean;
      
      flvplayback_internal var _skinAutoHideMotionTimeout:int;
      
      flvplayback_internal var borderCopy:Sprite;
      
      flvplayback_internal var cacheStageAlign:String;
      
      flvplayback_internal var cacheFLVPlaybackParent:DisplayObjectContainer;
      
      flvplayback_internal var skinLoader:Loader;
      
      flvplayback_internal var _skinScaleMaximum:Number;
      
      public function UIManager(param1:FLVPlayback)
      {
         var vc:FLVPlayback = param1;
         super();
         flvplayback_internal::_vc = vc;
         flvplayback_internal::_skin = null;
         flvplayback_internal::_skinAutoHide = false;
         flvplayback_internal::cacheSkinAutoHide = flvplayback_internal::_skinAutoHide;
         flvplayback_internal::_skinFadingMaxTime = flvplayback_internal::SKIN_FADING_MAX_TIME_DEFAULT;
         flvplayback_internal::_skinAutoHideMotionTimeout = flvplayback_internal::SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT;
         flvplayback_internal::_skinReady = true;
         flvplayback_internal::__visible = false;
         flvplayback_internal::_bufferingBarHides = false;
         flvplayback_internal::_controlsEnabled = true;
         flvplayback_internal::_lastScrubPos = 0;
         flvplayback_internal::_lastVolumePos = 0;
         flvplayback_internal::cachedSoundLevel = flvplayback_internal::_vc.volume;
         flvplayback_internal::_isMuted = false;
         flvplayback_internal::controls = new Array();
         customClips = null;
         ctrlDataDict = new Dictionary(true);
         flvplayback_internal::skin_mc = null;
         flvplayback_internal::skinLoader = null;
         flvplayback_internal::skinTemplate = null;
         flvplayback_internal::layout_mc = null;
         flvplayback_internal::border_mc = null;
         flvplayback_internal::borderCopy = null;
         flvplayback_internal::borderPrevRect = null;
         flvplayback_internal::borderScale9Rects = null;
         flvplayback_internal::borderAlpha = 0.85;
         flvplayback_internal::borderColor = 4697035;
         flvplayback_internal::borderColorTransform = new ColorTransform(0,0,0,0,71,171,203,255 * flvplayback_internal::borderAlpha);
         flvplayback_internal::_seekBarScrubTolerance = SEEK_BAR_SCRUB_TOLERANCE_DEFAULT;
         flvplayback_internal::_volumeBarScrubTolerance = VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT;
         flvplayback_internal::_bufferingOn = false;
         flvplayback_internal::mouseCaptureCtrl = -1;
         flvplayback_internal::_seekBarTimer = new Timer(SEEK_BAR_INTERVAL_DEFAULT);
         flvplayback_internal::_seekBarTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::seekBarListener);
         flvplayback_internal::_volumeBarTimer = new Timer(VOLUME_BAR_INTERVAL_DEFAULT);
         flvplayback_internal::_volumeBarTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::volumeBarListener);
         flvplayback_internal::_bufferingDelayTimer = new Timer(BUFFERING_DELAY_INTERVAL_DEFAULT,1);
         flvplayback_internal::_bufferingDelayTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::doBufferingDelay);
         flvplayback_internal::_skinAutoHideTimer = new Timer(flvplayback_internal::SKIN_AUTO_HIDE_INTERVAL);
         flvplayback_internal::_skinAutoHideTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::skinAutoHideHitTest);
         flvplayback_internal::_skinFadingTimer = new Timer(flvplayback_internal::SKIN_FADING_INTERVAL);
         flvplayback_internal::_skinFadingTimer.addEventListener(TimerEvent.TIMER,flvplayback_internal::skinFadeMore);
         flvplayback_internal::_vc.addEventListener(MetadataEvent.METADATA_RECEIVED,flvplayback_internal::handleIVPEvent);
         flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,flvplayback_internal::handleIVPEvent);
         flvplayback_internal::_vc.addEventListener(VideoProgressEvent.PROGRESS,flvplayback_internal::handleIVPEvent);
         flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.STATE_CHANGE,flvplayback_internal::handleIVPEvent);
         flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.READY,flvplayback_internal::handleIVPEvent);
         flvplayback_internal::_vc.addEventListener(LayoutEvent.LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.addEventListener(SoundEvent.SOUND_UPDATE,flvplayback_internal::handleSoundEvent);
         flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::_vc.addEventListener(Event.REMOVED_FROM_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::fullScreenSourceRectMinWidth = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH;
         flvplayback_internal::fullScreenSourceRectMinHeight = FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
         flvplayback_internal::fullScreenSourceRectMinAspectRatio = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH / FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
         flvplayback_internal::_fullScreen = false;
         flvplayback_internal::_fullScreenTakeOver = true;
         flvplayback_internal::_fullScreenBgColor = 0;
         flvplayback_internal::_fullScreenAccel = false;
         if(flvplayback_internal::_vc.stage != null)
         {
            try
            {
               flvplayback_internal::_fullScreen = flvplayback_internal::_vc.stage.displayState == StageDisplayState.FULL_SCREEN;
               flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
            }
            catch(se:SecurityError)
            {
            }
         }
         if(flvplayback_internal::layoutNameToIndexMappings == null)
         {
            flvplayback_internal::initLayoutNameToIndexMappings();
         }
      }
      
      flvplayback_internal static function getNumberPropSafe(param1:Object, param2:String) : Number
      {
         var numProp:* = undefined;
         var obj:Object = param1;
         var propName:String = param2;
         try
         {
            numProp = obj[propName];
            return Number(numProp);
         }
         catch(re:ReferenceError)
         {
         }
         return NaN;
      }
      
      flvplayback_internal static function getBooleanPropSafe(param1:Object, param2:String) : Boolean
      {
         var boolProp:* = undefined;
         var obj:Object = param1;
         var propName:String = param2;
         try
         {
            boolProp = obj[propName];
            return Boolean(boolProp);
         }
         catch(re:ReferenceError)
         {
         }
         return false;
      }
      
      flvplayback_internal static function initLayoutNameToIndexMappings() : void
      {
         var _loc1_:int = 0;
         flvplayback_internal::layoutNameToIndexMappings = new Object();
         _loc1_ = 0;
         while(_loc1_ < flvplayback_internal::layoutNameArray.length)
         {
            if(flvplayback_internal::layoutNameArray[_loc1_] != null)
            {
               flvplayback_internal::layoutNameToIndexMappings[flvplayback_internal::layoutNameArray[_loc1_]] = _loc1_;
            }
            _loc1_++;
         }
      }
      
      public function get seekBarScrubTolerance() : Number
      {
         return flvplayback_internal::_seekBarScrubTolerance;
      }
      
      flvplayback_internal function removeButtonListeners(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.removeEventListener(MouseEvent.ROLL_OVER,flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.ROLL_OUT,flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.CLICK,flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::skinButtonControl);
      }
      
      public function set skinFadeTime(param1:int) : void
      {
         flvplayback_internal::_skinFadingMaxTime = param1;
      }
      
      public function get skinFadeTime() : int
      {
         return flvplayback_internal::_skinFadingMaxTime;
      }
      
      flvplayback_internal function finishLoad(param1:Event) : void
      {
         var i:int = 0;
         var cachedActivePlayerIndex:int = 0;
         var state:String = null;
         var j:int = 0;
         var e:Event = param1;
         try
         {
            ++flvplayback_internal::skinLoadDelayCount;
            if(flvplayback_internal::skinLoadDelayCount < 2)
            {
               return;
            }
            flvplayback_internal::_vc.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::finishLoad);
            i = 0;
            while(i < NUM_CONTROLS)
            {
               if(flvplayback_internal::delayedControls[i] != undefined)
               {
                  setControl(i,flvplayback_internal::delayedControls[i]);
               }
               i++;
            }
            if(flvplayback_internal::_fullScreenTakeOver)
            {
               flvplayback_internal::enterFullScreenTakeOver();
            }
            else
            {
               flvplayback_internal::exitFullScreenTakeOver();
            }
            flvplayback_internal::layoutSkin();
            flvplayback_internal::setupSkinAutoHide(false);
            flvplayback_internal::skin_mc.visible = flvplayback_internal::__visible;
            flvplayback_internal::_vc.addChild(flvplayback_internal::skin_mc);
            flvplayback_internal::_skinReady = true;
            flvplayback_internal::_vc.flvplayback_internal::skinLoaded();
            cachedActivePlayerIndex = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
            flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
            state = flvplayback_internal::_vc.state;
            j = 0;
            while(j < NUM_CONTROLS)
            {
               if(flvplayback_internal::controls[j] != undefined)
               {
                  flvplayback_internal::setEnabledAndVisibleForState(j,state);
                  if(j < NUM_BUTTONS)
                  {
                     flvplayback_internal::skinButtonControl(flvplayback_internal::controls[j]);
                  }
               }
               j++;
            }
            flvplayback_internal::_vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
         }
         catch(err:Error)
         {
            flvplayback_internal::_vc.flvplayback_internal::skinError(err.message);
            flvplayback_internal::removeSkin();
         }
      }
      
      flvplayback_internal function downloadSkin() : void
      {
         if(flvplayback_internal::skinLoader == null)
         {
            flvplayback_internal::skinLoader = new Loader();
            flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,flvplayback_internal::handleLoad);
            flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,flvplayback_internal::handleLoadErrorEvent);
            flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,flvplayback_internal::handleLoadErrorEvent);
         }
         flvplayback_internal::skinLoader.load(new URLRequest(flvplayback_internal::_skin));
      }
      
      flvplayback_internal function removeSkin() : void
      {
         var i:int = 0;
         if(flvplayback_internal::skinLoader != null)
         {
            try
            {
               flvplayback_internal::skinLoader.close();
            }
            catch(e1:Error)
            {
            }
            flvplayback_internal::skinLoader = null;
         }
         if(flvplayback_internal::skin_mc != null)
         {
            i = 0;
            while(i < NUM_CONTROLS)
            {
               if(flvplayback_internal::controls[i] != undefined)
               {
                  if(i < NUM_BUTTONS)
                  {
                     flvplayback_internal::removeButtonListeners(flvplayback_internal::controls[i]);
                  }
                  delete ctrlDataDict[flvplayback_internal::controls[i]];
                  delete flvplayback_internal::controls[i];
               }
               i++;
            }
            try
            {
               flvplayback_internal::skin_mc.parent.removeChild(flvplayback_internal::skin_mc);
            }
            catch(e2:Error)
            {
            }
            flvplayback_internal::skin_mc = null;
         }
         flvplayback_internal::skinTemplate = null;
         flvplayback_internal::layout_mc = null;
         flvplayback_internal::border_mc = null;
         flvplayback_internal::borderCopy = null;
         flvplayback_internal::borderPrevRect = null;
         flvplayback_internal::borderScale9Rects = null;
      }
      
      flvplayback_internal function positionBar(param1:Sprite, param2:String, param3:Number) : void
      {
         var ctrlData:ControlData = null;
         var bar:DisplayObject = null;
         var barData:ControlData = null;
         var ctrl:Sprite = param1;
         var type:String = param2;
         var percent:Number = param3;
         try
         {
            if(ctrl["positionBar"] is Function && Boolean(ctrl["positionBar"](type,percent)))
            {
               return;
            }
         }
         catch(re2:ReferenceError)
         {
         }
         ctrlData = ctrlDataDict[ctrl];
         bar = ctrlData[type + "_mc"];
         if(bar == null)
         {
            return;
         }
         barData = ctrlDataDict[bar];
         if(bar.parent == ctrl)
         {
            if(barData.fill_mc == null)
            {
               bar.scaleX = barData.origScaleX * percent / 100;
            }
            else
            {
               flvplayback_internal::positionMaskedFill(bar,percent);
            }
         }
         else
         {
            bar.x = ctrl.x + barData.leftMargin;
            bar.y = ctrl.y + barData.origY;
            if(barData.fill_mc == null)
            {
               bar.width = (ctrl.width - barData.leftMargin - barData.rightMargin) * percent / 100;
            }
            else
            {
               flvplayback_internal::positionMaskedFill(bar,percent);
            }
         }
      }
      
      flvplayback_internal function setupButtonSkin(param1:int) : Sprite
      {
         var _loc2_:String = null;
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         _loc2_ = flvplayback_internal::skinClassPrefixes[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         _loc3_ = new Sprite();
         _loc4_ = new ControlData(this,_loc3_,null,param1);
         ctrlDataDict[_loc3_] = _loc4_;
         _loc4_.state_mc = new Array();
         _loc4_.state_mc[NORMAL_STATE] = flvplayback_internal::setupButtonSkinState(_loc3_,flvplayback_internal::skinTemplate,_loc2_ + "NormalState");
         _loc4_.state_mc[NORMAL_STATE].visible = true;
         _loc4_.state_mc[OVER_STATE] = flvplayback_internal::setupButtonSkinState(_loc3_,flvplayback_internal::skinTemplate,_loc2_ + "OverState",_loc4_.state_mc[NORMAL_STATE]);
         _loc4_.state_mc[DOWN_STATE] = flvplayback_internal::setupButtonSkinState(_loc3_,flvplayback_internal::skinTemplate,_loc2_ + "DownState",_loc4_.state_mc[NORMAL_STATE]);
         _loc4_.disabled_mc = flvplayback_internal::setupButtonSkinState(_loc3_,flvplayback_internal::skinTemplate,_loc2_ + "DisabledState",_loc4_.state_mc[NORMAL_STATE]);
         return _loc3_;
      }
      
      public function get skinReady() : Boolean
      {
         return flvplayback_internal::_skinReady;
      }
      
      public function get skinAutoHide() : Boolean
      {
         return flvplayback_internal::_skinAutoHide;
      }
      
      flvplayback_internal function dispatchMessage(param1:int) : void
      {
         var cachedActivePlayerIndex:int = 0;
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var handle:Sprite = null;
         var index:int = param1;
         if(index == SEEK_BAR_HANDLE || index == SEEK_BAR_HIT)
         {
            flvplayback_internal::_vc.flvplayback_internal::_scrubStart();
         }
         cachedActivePlayerIndex = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         switch(index)
         {
            case PAUSE_BUTTON:
               flvplayback_internal::_vc.pause();
               break;
            case PLAY_BUTTON:
               flvplayback_internal::_vc.play();
               break;
            case STOP_BUTTON:
               flvplayback_internal::_vc.stop();
               break;
            case SEEK_BAR_HIT:
            case SEEK_BAR_HANDLE:
               ctrl = flvplayback_internal::controls[SEEK_BAR];
               ctrlData = ctrlDataDict[ctrl];
               flvplayback_internal::calcPercentageFromHandle(ctrl);
               flvplayback_internal::_lastScrubPos = ctrlData.percentage;
               if(index == SEEK_BAR_HIT)
               {
                  handle = flvplayback_internal::controls[SEEK_BAR_HANDLE];
                  handle.x = handle.parent.mouseX;
                  handle.y = handle.parent.mouseY;
               }
               flvplayback_internal::_vc.removeEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,flvplayback_internal::handleIVPEvent);
               if(flvplayback_internal::_vc.playing || flvplayback_internal::_vc.buffering)
               {
                  flvplayback_internal::_playAfterScrub = true;
               }
               else if(flvplayback_internal::_vc.state != VideoState.SEEKING)
               {
                  flvplayback_internal::_playAfterScrub = false;
               }
               flvplayback_internal::_seekBarTimer.start();
               flvplayback_internal::startHandleDrag(ctrl);
               flvplayback_internal::_vc.pause();
               break;
            case VOLUME_BAR_HIT:
            case VOLUME_BAR_HANDLE:
               ctrl = flvplayback_internal::controls[VOLUME_BAR];
               ctrlData = ctrlDataDict[ctrl];
               flvplayback_internal::calcPercentageFromHandle(ctrl);
               flvplayback_internal::_lastVolumePos = ctrlData.percentage;
               if(index == VOLUME_BAR_HIT)
               {
                  handle = flvplayback_internal::controls[VOLUME_BAR_HANDLE];
                  handle.x = handle.parent.mouseX;
                  handle.y = handle.parent.mouseY;
               }
               flvplayback_internal::_vc.removeEventListener(SoundEvent.SOUND_UPDATE,flvplayback_internal::handleSoundEvent);
               flvplayback_internal::_volumeBarTimer.start();
               flvplayback_internal::startHandleDrag(ctrl);
               break;
            case BACK_BUTTON:
               flvplayback_internal::_vc.seekToPrevNavCuePoint();
               break;
            case FORWARD_BUTTON:
               flvplayback_internal::_vc.seekToNextNavCuePoint();
               break;
            case MUTE_ON_BUTTON:
               if(!flvplayback_internal::_isMuted)
               {
                  flvplayback_internal::_isMuted = true;
                  flvplayback_internal::cachedSoundLevel = flvplayback_internal::_vc.volume;
                  flvplayback_internal::_vc.volume = 0;
                  flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_OFF_BUTTON]);
                  flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_ON_BUTTON]);
               }
               break;
            case MUTE_OFF_BUTTON:
               if(flvplayback_internal::_isMuted)
               {
                  flvplayback_internal::_isMuted = false;
                  flvplayback_internal::_vc.volume = flvplayback_internal::cachedSoundLevel;
                  flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_OFF_BUTTON]);
                  flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_ON_BUTTON]);
               }
               break;
            case FULL_SCREEN_ON_BUTTON:
               if(!flvplayback_internal::_fullScreen && flvplayback_internal::_vc.stage != null)
               {
                  enterFullScreenDisplayState();
                  flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
                  flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
               }
               break;
            case FULL_SCREEN_OFF_BUTTON:
               if(flvplayback_internal::_fullScreen && flvplayback_internal::_vc.stage != null)
               {
                  try
                  {
                     flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
                  }
                  catch(se:SecurityError)
                  {
                  }
                  flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
                  flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
                  flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
               }
               break;
            default:
               throw new Error("Unknown ButtonControl");
         }
         flvplayback_internal::_vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
      }
      
      flvplayback_internal function handleFullScreenEvent(param1:FullScreenEvent) : void
      {
         flvplayback_internal::_fullScreen = param1.fullScreen;
         flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
         flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
         flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
         flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
         if(flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver)
         {
            flvplayback_internal::enterFullScreenTakeOver();
         }
         else if(!flvplayback_internal::_fullScreen)
         {
            flvplayback_internal::exitFullScreenTakeOver();
         }
      }
      
      flvplayback_internal function handleLayoutEvent(param1:LayoutEvent) : void
      {
         var _loc2_:int = 0;
         if(flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver && flvplayback_internal::_fullScreenAccel && flvplayback_internal::_vc.stage != null)
         {
            if(flvplayback_internal::_vc.registrationX != 0 || flvplayback_internal::_vc.registrationY != 0 || flvplayback_internal::_vc.parent != flvplayback_internal::_vc.stage || flvplayback_internal::_vc.registrationWidth != flvplayback_internal::_vc.stage.stageWidth || flvplayback_internal::_vc.registrationHeight != flvplayback_internal::_vc.stage.stageHeight)
            {
               flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
               return;
            }
            _loc2_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
            flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
            if(flvplayback_internal::_vc.align != VideoAlign.CENTER)
            {
               flvplayback_internal::cacheFLVPlaybackAlign[flvplayback_internal::_vc.visibleVideoPlayerIndex] = flvplayback_internal::_vc.align;
               flvplayback_internal::_vc.align = VideoAlign.CENTER;
            }
            if(flvplayback_internal::_vc.scaleMode != VideoScaleMode.MAINTAIN_ASPECT_RATIO)
            {
               flvplayback_internal::cacheFLVPlaybackScaleMode[flvplayback_internal::_vc.visibleVideoPlayerIndex] = flvplayback_internal::_vc.scaleMode;
               flvplayback_internal::_vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
               flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
               return;
            }
            flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
         }
         flvplayback_internal::layoutSkin();
         flvplayback_internal::setupSkinAutoHide(false);
      }
      
      flvplayback_internal function seekBarListener(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         var _loc5_:Number = NaN;
         _loc2_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         _loc3_ = flvplayback_internal::controls[SEEK_BAR];
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = ctrlDataDict[_loc3_];
         flvplayback_internal::calcPercentageFromHandle(_loc3_);
         _loc5_ = _loc4_.percentage;
         if(param1 == null)
         {
            flvplayback_internal::_seekBarTimer.stop();
            if(_loc5_ != flvplayback_internal::_lastScrubPos)
            {
               flvplayback_internal::_vc.seekPercent(_loc5_);
            }
            flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,flvplayback_internal::handleIVPEvent);
            if(flvplayback_internal::_playAfterScrub)
            {
               flvplayback_internal::_vc.play();
            }
         }
         else if(flvplayback_internal::_vc.getVideoPlayer(flvplayback_internal::_vc.visibleVideoPlayerIndex).state != VideoState.SEEKING)
         {
            if(flvplayback_internal::_seekBarScrubTolerance <= 0 || Math.abs(_loc5_ - flvplayback_internal::_lastScrubPos) > flvplayback_internal::_seekBarScrubTolerance || _loc5_ < flvplayback_internal::_seekBarScrubTolerance || _loc5_ > 100 - flvplayback_internal::_seekBarScrubTolerance)
            {
               if(_loc5_ != flvplayback_internal::_lastScrubPos)
               {
                  flvplayback_internal::_lastScrubPos = _loc5_;
                  flvplayback_internal::_vc.seekPercent(_loc5_);
               }
            }
         }
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      public function get seekBarInterval() : Number
      {
         return flvplayback_internal::_seekBarTimer.delay;
      }
      
      public function set skinAutoHide(param1:Boolean) : void
      {
         if(param1 == flvplayback_internal::_skinAutoHide)
         {
            return;
         }
         flvplayback_internal::_skinAutoHide = param1;
         flvplayback_internal::cacheSkinAutoHide = param1;
         flvplayback_internal::setupSkinAutoHide(true);
      }
      
      flvplayback_internal function setCustomClip(param1:DisplayObject) : void
      {
         var dCopy:DisplayObject = null;
         var ctrlData:ControlData = null;
         var scale9Grid:Rectangle = null;
         var diff:Number = NaN;
         var numBorderBitmaps:int = 0;
         var i:int = 0;
         var lastXDim:Number = NaN;
         var floorLastXDim:Number = NaN;
         var lastYDim:Number = NaN;
         var floorLastYDim:Number = NaN;
         var newRect:Rectangle = null;
         var dispObj:DisplayObject = param1;
         dCopy = new dispObj["constructor"]();
         flvplayback_internal::skin_mc.addChild(dCopy);
         ctrlData = new ControlData(this,dCopy,null,-1);
         ctrlDataDict[dCopy] = ctrlData;
         ctrlData.avatar = dispObj;
         customClips.push(dCopy);
         if(dispObj.name == "border_mc")
         {
            flvplayback_internal::border_mc = dCopy;
            try
            {
               flvplayback_internal::borderCopy = ctrlData.avatar["colorMe"] ? new Sprite() : null;
            }
            catch(re:ReferenceError)
            {
               flvplayback_internal::borderCopy = null;
            }
            if(flvplayback_internal::borderCopy != null)
            {
               flvplayback_internal::border_mc.visible = false;
               scale9Grid = flvplayback_internal::border_mc.scale9Grid;
               scale9Grid.x = Math.round(scale9Grid.x);
               scale9Grid.y = Math.round(scale9Grid.y);
               scale9Grid.width = Math.round(scale9Grid.width);
               diff = scale9Grid.x + scale9Grid.width - flvplayback_internal::border_mc.scale9Grid.right;
               if(diff > 0.5)
               {
                  --scale9Grid.width;
               }
               else if(diff < -0.5)
               {
                  ++scale9Grid.width;
               }
               scale9Grid.height = Math.round(scale9Grid.height);
               diff = scale9Grid.y + scale9Grid.height - flvplayback_internal::border_mc.scale9Grid.bottom;
               if(diff > 0.5)
               {
                  --scale9Grid.height;
               }
               else if(diff < -0.5)
               {
                  ++scale9Grid.height;
               }
               if(scale9Grid != null)
               {
                  flvplayback_internal::borderScale9Rects = new Array();
                  lastXDim = flvplayback_internal::border_mc.width - (scale9Grid.x + scale9Grid.width);
                  floorLastXDim = Math.floor(lastXDim);
                  if(lastXDim - floorLastXDim < 0.05)
                  {
                     lastXDim = floorLastXDim;
                  }
                  else
                  {
                     lastXDim = floorLastXDim + 1;
                  }
                  lastYDim = flvplayback_internal::border_mc.height - (scale9Grid.y + scale9Grid.height);
                  floorLastYDim = Math.floor(lastYDim);
                  if(lastYDim - floorLastYDim < 0.05)
                  {
                     lastYDim = floorLastYDim;
                  }
                  else
                  {
                     lastYDim = floorLastYDim + 1;
                  }
                  newRect = new Rectangle(0,0,scale9Grid.x,scale9Grid.y);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,0,lastXDim,scale9Grid.y);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,scale9Grid.y,scale9Grid.width,scale9Grid.height);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,scale9Grid.y,lastXDim,scale9Grid.height);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(0,scale9Grid.y + scale9Grid.height,scale9Grid.x,lastYDim);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,scale9Grid.y + scale9Grid.height,scale9Grid.width,lastYDim);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,scale9Grid.y + scale9Grid.height,lastXDim,lastYDim);
                  flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  i = 0;
                  while(i < flvplayback_internal::borderScale9Rects.length)
                  {
                     if(flvplayback_internal::borderScale9Rects[i] != null)
                     {
                        break;
                     }
                     i++;
                  }
                  if(i >= flvplayback_internal::borderScale9Rects.length)
                  {
                     flvplayback_internal::borderScale9Rects = null;
                  }
               }
               numBorderBitmaps = flvplayback_internal::borderScale9Rects == null ? 1 : 9;
               i = 0;
               while(i < numBorderBitmaps)
               {
                  if(flvplayback_internal::borderScale9Rects == null || flvplayback_internal::borderScale9Rects[i] != null)
                  {
                     flvplayback_internal::borderCopy.addChild(new Bitmap());
                  }
                  i++;
               }
               flvplayback_internal::skin_mc.addChild(flvplayback_internal::borderCopy);
               flvplayback_internal::borderPrevRect = null;
            }
         }
      }
      
      public function get fullScreenSkinDelay() : int
      {
         return flvplayback_internal::_skinAutoHideMotionTimeout;
      }
      
      flvplayback_internal function doBufferingDelay(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         flvplayback_internal::_bufferingDelayTimer.reset();
         _loc2_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         if(flvplayback_internal::_vc.state == VideoState.BUFFERING)
         {
            flvplayback_internal::_bufferingOn = true;
            flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,VideoState.BUFFERING,NaN,flvplayback_internal::_vc.visibleVideoPlayerIndex));
         }
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      flvplayback_internal function volumeBarListener(param1:TimerEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:ControlData = null;
         var _loc4_:Number = NaN;
         var _loc5_:* = false;
         _loc2_ = flvplayback_internal::controls[VOLUME_BAR];
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = ctrlDataDict[_loc2_];
         flvplayback_internal::calcPercentageFromHandle(_loc2_);
         _loc4_ = _loc3_.percentage;
         _loc5_ = param1 == null;
         if(_loc5_)
         {
            flvplayback_internal::_volumeBarTimer.stop();
            flvplayback_internal::_vc.addEventListener(SoundEvent.SOUND_UPDATE,flvplayback_internal::handleSoundEvent);
         }
         if(_loc5_ || flvplayback_internal::_volumeBarScrubTolerance <= 0 || Math.abs(_loc4_ - flvplayback_internal::_lastVolumePos) > flvplayback_internal::_volumeBarScrubTolerance || _loc4_ < flvplayback_internal::_volumeBarScrubTolerance || _loc4_ > 100 - flvplayback_internal::_volumeBarScrubTolerance)
         {
            if(_loc4_ != flvplayback_internal::_lastVolumePos)
            {
               if(flvplayback_internal::_isMuted)
               {
                  flvplayback_internal::cachedSoundLevel = _loc4_ / 100;
               }
               else
               {
                  flvplayback_internal::_vc.volume = _loc4_ / 100;
               }
               flvplayback_internal::_lastVolumePos = _loc4_;
            }
         }
      }
      
      public function get visible() : Boolean
      {
         return flvplayback_internal::__visible;
      }
      
      flvplayback_internal function fixUpBar(param1:DisplayObject, param2:String, param3:DisplayObject, param4:String) : void
      {
         var ctrlData:ControlData = null;
         var bar:DisplayObject = null;
         var barData:ControlData = null;
         var definitionHolder:DisplayObject = param1;
         var propPrefix:String = param2;
         var ctrl:DisplayObject = param3;
         var name:String = param4;
         ctrlData = ctrlDataDict[ctrl];
         if(ctrlData[name] != null)
         {
            return;
         }
         try
         {
            bar = ctrl[name];
         }
         catch(re:ReferenceError)
         {
            bar = null;
         }
         if(bar == null)
         {
            try
            {
               bar = flvplayback_internal::createSkin(definitionHolder,propPrefix + "LinkageID");
            }
            catch(ve:VideoError)
            {
               bar = null;
            }
            if(bar == null)
            {
               return;
            }
            if(ctrl.parent != null)
            {
               if(flvplayback_internal::getBooleanPropSafe(ctrl,propPrefix + "Below"))
               {
                  ctrl.parent.addChildAt(bar,ctrl.parent.getChildIndex(ctrl));
               }
               else
               {
                  ctrl.parent.addChild(bar);
               }
            }
         }
         ctrlData[name] = bar;
         barData = ctrlDataDict[bar];
         if(barData == null)
         {
            barData = new ControlData(this,bar,ctrl,-1);
            ctrlDataDict[bar] = barData;
         }
      }
      
      public function get volumeBarInterval() : Number
      {
         return flvplayback_internal::_volumeBarTimer.delay;
      }
      
      public function get bufferingBarHidesAndDisablesOthers() : Boolean
      {
         return flvplayback_internal::_bufferingBarHides;
      }
      
      flvplayback_internal function calcLayoutControl(param1:DisplayObject) : Rectangle
      {
         var rect:Rectangle = null;
         var ctrlData:ControlData = null;
         var anchorRight:Boolean = false;
         var anchorLeft:Boolean = false;
         var anchorTop:Boolean = false;
         var anchorBottom:Boolean = false;
         var ctrl:DisplayObject = param1;
         rect = new Rectangle();
         if(ctrl == null)
         {
            return rect;
         }
         ctrlData = ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            return rect;
         }
         if(ctrlData.avatar == null)
         {
            return rect;
         }
         anchorRight = false;
         anchorLeft = true;
         anchorTop = false;
         anchorBottom = true;
         try
         {
            anchorRight = Boolean(ctrlData.avatar["anchorRight"]);
         }
         catch(re1:ReferenceError)
         {
            anchorRight = false;
         }
         try
         {
            anchorLeft = Boolean(ctrlData.avatar["anchorLeft"]);
         }
         catch(re1:ReferenceError)
         {
            anchorLeft = true;
         }
         try
         {
            anchorTop = Boolean(ctrlData.avatar["anchorTop"]);
         }
         catch(re1:ReferenceError)
         {
            anchorTop = false;
         }
         try
         {
            anchorBottom = Boolean(ctrlData.avatar["anchorBottom"]);
         }
         catch(re1:ReferenceError)
         {
            anchorBottom = true;
         }
         if(anchorRight)
         {
            if(anchorLeft)
            {
               rect.x = ctrlData.avatar.x - flvplayback_internal::placeholderLeft + flvplayback_internal::videoLeft;
               rect.width = ctrlData.avatar.x + ctrlData.avatar.width - flvplayback_internal::placeholderRight + flvplayback_internal::videoRight - rect.x;
               ctrlData.origWidth = NaN;
            }
            else
            {
               rect.x = ctrlData.avatar.x - flvplayback_internal::placeholderRight + flvplayback_internal::videoRight;
               rect.width = ctrl.width;
            }
         }
         else
         {
            rect.x = ctrlData.avatar.x - flvplayback_internal::placeholderLeft + flvplayback_internal::videoLeft;
            rect.width = ctrl.width;
         }
         if(anchorTop)
         {
            if(anchorBottom)
            {
               rect.y = ctrlData.avatar.y - flvplayback_internal::placeholderTop + flvplayback_internal::videoTop;
               rect.height = ctrlData.avatar.y + ctrlData.avatar.height - flvplayback_internal::placeholderBottom + flvplayback_internal::videoBottom - rect.y;
               ctrlData.origHeight = NaN;
            }
            else
            {
               rect.y = ctrlData.avatar.y - flvplayback_internal::placeholderTop + flvplayback_internal::videoTop;
               rect.height = ctrl.height;
            }
         }
         else
         {
            rect.y = ctrlData.avatar.y - flvplayback_internal::placeholderBottom + flvplayback_internal::videoBottom;
            rect.height = ctrl.height;
         }
         try
         {
            if(ctrl["layoutSelf"] is Function)
            {
               rect = ctrl["layoutSelf"](rect);
            }
         }
         catch(re3:ReferenceError)
         {
         }
         return rect;
      }
      
      flvplayback_internal function skinFadeMore(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!flvplayback_internal::_skinFadingIn && flvplayback_internal::skin_mc.alpha <= 0.5 || flvplayback_internal::_skinFadingIn && flvplayback_internal::skin_mc.alpha >= 0.95)
         {
            flvplayback_internal::skin_mc.visible = flvplayback_internal::_skinFadingIn;
            flvplayback_internal::skin_mc.alpha = 1;
            flvplayback_internal::_skinFadingTimer.stop();
         }
         else
         {
            _loc2_ = (getTimer() - flvplayback_internal::_skinFadeStartTime) / flvplayback_internal::_skinFadingMaxTime;
            if(!flvplayback_internal::_skinFadingIn)
            {
               _loc2_ = 1 - _loc2_;
            }
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            else if(_loc2_ > 1)
            {
               _loc2_ = 1;
            }
            flvplayback_internal::skin_mc.alpha = _loc2_;
         }
      }
      
      flvplayback_internal function bitmapCopyBorder() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Bitmap = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(flvplayback_internal::border_mc == null || flvplayback_internal::borderCopy == null)
         {
            return;
         }
         _loc1_ = flvplayback_internal::border_mc.getBounds(flvplayback_internal::skin_mc);
         if(flvplayback_internal::borderPrevRect == null || !flvplayback_internal::borderPrevRect.equals(_loc1_))
         {
            flvplayback_internal::borderCopy.x = _loc1_.x;
            flvplayback_internal::borderCopy.y = _loc1_.y;
            _loc3_ = new Matrix(flvplayback_internal::border_mc.scaleX,0,0,flvplayback_internal::border_mc.scaleY,0,0);
            if(flvplayback_internal::borderScale9Rects == null)
            {
               _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
               _loc2_.draw(flvplayback_internal::border_mc,_loc3_,flvplayback_internal::borderColorTransform);
               Bitmap(flvplayback_internal::borderCopy.getChildAt(0)).bitmapData = _loc2_;
            }
            else
            {
               _loc4_ = 0;
               _loc5_ = 0;
               _loc6_ = new Rectangle(0,0,0,0);
               _loc7_ = 0;
               _loc8_ = 0;
               if(flvplayback_internal::borderScale9Rects[3] != null)
               {
                  _loc8_ += flvplayback_internal::borderScale9Rects[3].width;
               }
               if(flvplayback_internal::borderScale9Rects[5] != null)
               {
                  _loc8_ += flvplayback_internal::borderScale9Rects[5].width;
               }
               _loc9_ = 0;
               if(flvplayback_internal::borderScale9Rects[1] != null)
               {
                  _loc9_ += flvplayback_internal::borderScale9Rects[1].height;
               }
               if(flvplayback_internal::borderScale9Rects[7] != null)
               {
                  _loc9_ += flvplayback_internal::borderScale9Rects[7].height;
               }
               _loc10_ = 0;
               while(_loc10_ < flvplayback_internal::borderScale9Rects.length)
               {
                  if(_loc10_ % 3 == 0)
                  {
                     _loc4_ = 0;
                     _loc5_ += _loc6_.height;
                  }
                  if(flvplayback_internal::borderScale9Rects[_loc10_] != null)
                  {
                     _loc6_ = Rectangle(flvplayback_internal::borderScale9Rects[_loc10_]).clone();
                     _loc3_.a = 1;
                     if(_loc10_ == 1 || _loc10_ == 4 || _loc10_ == 7)
                     {
                        _loc12_ = (_loc1_.width - _loc8_) / _loc6_.width;
                        _loc6_.x *= _loc12_;
                        _loc6_.width *= _loc12_;
                        _loc6_.width = Math.round(_loc6_.width);
                        _loc3_.a *= _loc12_;
                     }
                     _loc3_.tx = -_loc6_.x;
                     _loc6_.x = 0;
                     _loc3_.d = 1;
                     if(_loc10_ >= 3 && _loc10_ <= 5)
                     {
                        _loc13_ = (_loc1_.height - _loc9_) / _loc6_.height;
                        _loc6_.y *= _loc13_;
                        _loc6_.height *= _loc13_;
                        _loc6_.height = Math.round(_loc6_.height);
                        _loc3_.d *= _loc13_;
                     }
                     _loc3_.ty = -_loc6_.y;
                     _loc6_.y = 0;
                     _loc2_ = new BitmapData(_loc6_.width,_loc6_.height,true,0);
                     _loc2_.draw(flvplayback_internal::border_mc,_loc3_,flvplayback_internal::borderColorTransform,null,_loc6_,false);
                     _loc11_ = Bitmap(flvplayback_internal::borderCopy.getChildAt(_loc7_));
                     _loc7_++;
                     _loc11_.bitmapData = _loc2_;
                     _loc11_.x = _loc4_;
                     _loc11_.y = _loc5_;
                     _loc4_ += _loc6_.width;
                  }
                  _loc10_++;
               }
            }
            flvplayback_internal::borderPrevRect = _loc1_;
         }
      }
      
      flvplayback_internal function resetPlayPause() : void
      {
         var _loc1_:int = 0;
         if(flvplayback_internal::controls[PLAY_PAUSE_BUTTON] == undefined)
         {
            return;
         }
         _loc1_ = PAUSE_BUTTON;
         while(_loc1_ <= PLAY_BUTTON)
         {
            flvplayback_internal::removeButtonListeners(flvplayback_internal::controls[_loc1_]);
            delete ctrlDataDict[flvplayback_internal::controls[_loc1_]];
            delete flvplayback_internal::controls[_loc1_];
            _loc1_++;
         }
         delete ctrlDataDict[flvplayback_internal::controls[PLAY_PAUSE_BUTTON]];
         delete flvplayback_internal::controls[PLAY_PAUSE_BUTTON];
      }
      
      public function setControl(param1:int, param2:Sprite) : void
      {
         var ctrlData:ControlData = null;
         var index:int = param1;
         var ctrl:Sprite = param2;
         if(ctrl == flvplayback_internal::controls[index])
         {
            return;
         }
         switch(index)
         {
            case PAUSE_BUTTON:
            case PLAY_BUTTON:
               flvplayback_internal::resetPlayPause();
               break;
            case PLAY_PAUSE_BUTTON:
               if(ctrl == null || ctrl.parent != flvplayback_internal::skin_mc)
               {
                  flvplayback_internal::resetPlayPause();
               }
               if(ctrl != null)
               {
                  setControl(PAUSE_BUTTON,Sprite(ctrl.getChildByName("pause_mc")));
                  setControl(PLAY_BUTTON,Sprite(ctrl.getChildByName("play_mc")));
               }
               break;
            case FULL_SCREEN_BUTTON:
               if(ctrl != null)
               {
                  setControl(FULL_SCREEN_ON_BUTTON,Sprite(ctrl.getChildByName("on_mc")));
                  setControl(FULL_SCREEN_OFF_BUTTON,Sprite(ctrl.getChildByName("off_mc")));
               }
               break;
            case MUTE_BUTTON:
               if(ctrl != null)
               {
                  setControl(MUTE_ON_BUTTON,Sprite(ctrl.getChildByName("on_mc")));
                  setControl(MUTE_OFF_BUTTON,Sprite(ctrl.getChildByName("off_mc")));
               }
         }
         if(flvplayback_internal::controls[index] != null)
         {
            try
            {
               delete flvplayback_internal::controls[index]["uiMgr"];
            }
            catch(re:ReferenceError)
            {
            }
            if(index < NUM_BUTTONS)
            {
               flvplayback_internal::removeButtonListeners(flvplayback_internal::controls[index]);
            }
            delete ctrlDataDict[flvplayback_internal::controls[index]];
            delete flvplayback_internal::controls[index];
         }
         if(ctrl == null)
         {
            return;
         }
         ctrlData = ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            ctrlData = new ControlData(this,ctrl,null,index);
            ctrlDataDict[ctrl] = ctrlData;
         }
         else
         {
            ctrlData.index = index;
         }
         if(index >= NUM_BUTTONS)
         {
            flvplayback_internal::controls[index] = ctrl;
            switch(index)
            {
               case SEEK_BAR:
                  flvplayback_internal::addBarControl(ctrl);
                  break;
               case VOLUME_BAR:
                  flvplayback_internal::addBarControl(ctrl);
                  ctrlData.percentage = flvplayback_internal::_vc.volume * 100;
                  break;
               case BUFFERING_BAR:
                  if(ctrl.parent == flvplayback_internal::skin_mc)
                  {
                     flvplayback_internal::finishAddBufferingBar();
                  }
                  else
                  {
                     ctrl.addEventListener(Event.ENTER_FRAME,flvplayback_internal::finishAddBufferingBar);
                  }
            }
            flvplayback_internal::setEnabledAndVisibleForState(index,flvplayback_internal::_vc.state);
         }
         else
         {
            flvplayback_internal::controls[index] = ctrl;
            flvplayback_internal::addButtonControl(ctrl);
         }
      }
      
      flvplayback_internal function createSkin(param1:DisplayObject, param2:String) : DisplayObject
      {
         var stateSkinDesc:* = undefined;
         var theClass:Class = null;
         var definitionHolder:DisplayObject = param1;
         var skinName:String = param2;
         try
         {
            stateSkinDesc = definitionHolder[skinName];
            if(stateSkinDesc is String)
            {
               try
               {
                  theClass = Class(definitionHolder.loaderInfo.applicationDomain.getDefinition(stateSkinDesc));
               }
               catch(err1:Error)
               {
                  theClass = Class(getDefinitionByName(stateSkinDesc));
               }
               return DisplayObject(new theClass());
            }
            if(stateSkinDesc is Class)
            {
               return new stateSkinDesc();
            }
            if(stateSkinDesc is DisplayObject)
            {
               return stateSkinDesc;
            }
         }
         catch(err2:Error)
         {
            throw new VideoError(VideoError.MISSING_SKIN_STYLE,skinName);
         }
         return null;
      }
      
      flvplayback_internal function addButtonControl(param1:Sprite) : void
      {
         var _loc2_:ControlData = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = ctrlDataDict[param1];
         param1.mouseChildren = false;
         _loc3_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         _loc2_.state = NORMAL_STATE;
         flvplayback_internal::setEnabledAndVisibleForState(_loc2_.index,flvplayback_internal::_vc.state);
         param1.addEventListener(MouseEvent.ROLL_OVER,flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.ROLL_OUT,flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.CLICK,flvplayback_internal::handleButtonEvent);
         if(param1.parent == flvplayback_internal::skin_mc)
         {
            flvplayback_internal::skinButtonControl(param1);
         }
         else
         {
            param1.addEventListener(Event.ENTER_FRAME,flvplayback_internal::skinButtonControl);
         }
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc3_;
      }
      
      flvplayback_internal function hookUpCustomComponents() : void
      {
         var searchHash:Object = null;
         var doTheSearch:Boolean = false;
         var i:int = 0;
         var dispObj:DisplayObject = null;
         var name:String = null;
         var index:int = 0;
         var ctrl:Sprite = null;
         searchHash = new Object();
         doTheSearch = false;
         i = 0;
         while(i < NUM_CONTROLS)
         {
            if(flvplayback_internal::controls[i] == null)
            {
               searchHash[flvplayback_internal::customComponentClassNames[i]] = i;
               doTheSearch = true;
            }
            i++;
         }
         if(!doTheSearch)
         {
            return;
         }
         i = 0;
         for(; i < flvplayback_internal::_vc.parent.numChildren; i++)
         {
            dispObj = flvplayback_internal::_vc.parent.getChildAt(i);
            name = getQualifiedClassName(dispObj);
            if(searchHash[name] != undefined)
            {
               if(typeof searchHash[name] == "number")
               {
                  index = int(searchHash[name]);
                  try
                  {
                     ctrl = Sprite(dispObj);
                     if((index >= NUM_BUTTONS || ctrl["placeholder_mc"] is DisplayObject) && ctrl["uiMgr"] == null)
                     {
                        setControl(index,ctrl);
                        searchHash[name] = ctrl;
                     }
                  }
                  catch(err:Error)
                  {
                     continue;
                  }
               }
            }
         }
      }
      
      flvplayback_internal function positionHandle(param1:Sprite) : void
      {
         var _loc2_:ControlData = null;
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         if(param1["positionHandle"] is Function && Boolean(param1["positionHandle"]()))
         {
            return;
         }
         _loc2_ = ctrlDataDict[param1];
         _loc3_ = _loc2_.handle_mc;
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = ctrlDataDict[_loc3_];
         _loc5_ = isNaN(_loc2_.origWidth) ? param1.width : _loc2_.origWidth;
         _loc6_ = _loc5_ - _loc4_.rightMargin - _loc4_.leftMargin;
         _loc3_.x = param1.x + _loc4_.leftMargin + _loc6_ * _loc2_.percentage / 100;
         _loc3_.y = param1.y + _loc4_.origY;
         if(_loc2_.fullness_mc != null)
         {
            flvplayback_internal::positionBar(param1,"fullness",_loc2_.percentage);
         }
      }
      
      flvplayback_internal function exitFullScreenTakeOver() : void
      {
         var fullScreenBG:Sprite = null;
         var cacheActiveIndex:int = 0;
         var i:int = 0;
         var vp:VideoPlayer = null;
         if(flvplayback_internal::cacheFLVPlaybackParent == null)
         {
            return;
         }
         flvplayback_internal::_vc.removeEventListener(Event.ADDED_TO_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
         try
         {
            if(flvplayback_internal::_fullScreenAccel)
            {
               flvplayback_internal::_vc.stage.fullScreenSourceRect = new Rectangle(0,0,-1,-1);
            }
            else
            {
               flvplayback_internal::_vc.stage.align = flvplayback_internal::cacheStageAlign;
               flvplayback_internal::_vc.stage.scaleMode = flvplayback_internal::cacheStageScaleMode;
            }
            fullScreenBG = Sprite(flvplayback_internal::_vc.getChildByName("fullScreenBG"));
            if(fullScreenBG != null)
            {
               flvplayback_internal::_vc.removeChild(fullScreenBG);
            }
            if(flvplayback_internal::_vc.parent != flvplayback_internal::cacheFLVPlaybackParent)
            {
               flvplayback_internal::cacheFLVPlaybackParent.addChildAt(flvplayback_internal::_vc,flvplayback_internal::cacheFLVPlaybackIndex);
            }
            else
            {
               flvplayback_internal::cacheFLVPlaybackParent.setChildIndex(flvplayback_internal::_vc,flvplayback_internal::cacheFLVPlaybackIndex);
            }
            cacheActiveIndex = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
            i = 0;
            while(i < flvplayback_internal::_vc.flvplayback_internal::videoPlayers.length)
            {
               vp = flvplayback_internal::_vc.flvplayback_internal::videoPlayers[i] as VideoPlayer;
               if(vp != null)
               {
                  flvplayback_internal::_vc.activeVideoPlayerIndex = i;
                  if(flvplayback_internal::cacheFLVPlaybackScaleMode[i] != undefined)
                  {
                     flvplayback_internal::_vc.scaleMode = flvplayback_internal::cacheFLVPlaybackScaleMode[i];
                  }
                  if(flvplayback_internal::cacheFLVPlaybackAlign[i])
                  {
                     flvplayback_internal::_vc.align = flvplayback_internal::cacheFLVPlaybackAlign[i];
                  }
               }
               i++;
            }
            flvplayback_internal::_vc.activeVideoPlayerIndex = cacheActiveIndex;
            flvplayback_internal::_vc.registrationX = flvplayback_internal::cacheFLVPlaybackLocation.x;
            flvplayback_internal::_vc.registrationY = flvplayback_internal::cacheFLVPlaybackLocation.y;
            flvplayback_internal::_vc.setSize(flvplayback_internal::cacheFLVPlaybackLocation.width,flvplayback_internal::cacheFLVPlaybackLocation.height);
         }
         catch(err:Error)
         {
         }
         flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
         flvplayback_internal::_fullScreen = false;
         flvplayback_internal::_fullScreenAccel = false;
         flvplayback_internal::cacheStageAlign = null;
         flvplayback_internal::cacheStageScaleMode = null;
         flvplayback_internal::cacheFLVPlaybackParent = null;
         flvplayback_internal::cacheFLVPlaybackIndex = 0;
         flvplayback_internal::cacheFLVPlaybackLocation = null;
         flvplayback_internal::cacheFLVPlaybackScaleMode = null;
         flvplayback_internal::cacheFLVPlaybackAlign = null;
         if(flvplayback_internal::_skinAutoHide != flvplayback_internal::cacheSkinAutoHide)
         {
            flvplayback_internal::_skinAutoHide = flvplayback_internal::cacheSkinAutoHide;
            flvplayback_internal::setupSkinAutoHide(false);
         }
      }
      
      flvplayback_internal function positionMaskedFill(param1:DisplayObject, param2:Number) : void
      {
         var ctrlData:ControlData = null;
         var fill:DisplayObject = null;
         var mask:DisplayObject = null;
         var fillData:ControlData = null;
         var maskData:ControlData = null;
         var slideReveal:Boolean = false;
         var maskSprite:Sprite = null;
         var barData:ControlData = null;
         var ctrl:DisplayObject = param1;
         var percent:Number = param2;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = ctrlDataDict[ctrl];
         fill = ctrlData.fill_mc;
         if(fill == null)
         {
            return;
         }
         mask = ctrlData.mask_mc;
         if(ctrlData.mask_mc == null)
         {
            try
            {
               ctrlData.mask_mc = mask = ctrl["mask_mc"];
            }
            catch(re:ReferenceError)
            {
               ctrlData.mask_mc = null;
            }
            if(ctrlData.mask_mc == null)
            {
               maskSprite = new Sprite();
               ctrlData.mask_mc = mask = maskSprite;
               maskSprite.graphics.beginFill(16777215);
               maskSprite.graphics.drawRect(0,0,1,1);
               maskSprite.graphics.endFill();
               barData = ctrlDataDict[fill];
               maskSprite.x = barData.origX;
               maskSprite.y = barData.origY;
               maskSprite.width = barData.origWidth;
               maskSprite.height = barData.origHeight;
               maskSprite.visible = false;
               fill.parent.addChild(maskSprite);
               fill.mask = maskSprite;
            }
            if(ctrlData.mask_mc != null)
            {
               flvplayback_internal::calcBarMargins(ctrl,"mask",true);
            }
         }
         fillData = ctrlDataDict[fill];
         maskData = ctrlDataDict[mask];
         try
         {
            slideReveal = Boolean(fill["slideReveal"]);
         }
         catch(re:ReferenceError)
         {
            slideReveal = false;
         }
         if(fill.parent == ctrl)
         {
            if(slideReveal)
            {
               fill.x = maskData.origX - fillData.origWidth + fillData.origWidth * percent / 100;
            }
            else
            {
               mask.width = fillData.origWidth * percent / 100;
            }
         }
         else if(fill.parent == ctrl.parent)
         {
            if(slideReveal)
            {
               mask.x = ctrl.x + maskData.leftMargin;
               mask.y = ctrl.y + maskData.topMargin;
               mask.width = ctrl.width - maskData.rightMargin - maskData.leftMargin;
               mask.height = ctrl.height - maskData.topMargin - maskData.bottomMargin;
               fill.x = mask.x - fillData.origWidth + maskData.origWidth * percent / 100;
               fill.y = ctrl.y + fillData.topMargin;
            }
            else
            {
               fill.x = ctrl.x + fillData.leftMargin;
               fill.y = ctrl.y + fillData.topMargin;
               mask.x = fill.x;
               mask.y = fill.y;
               mask.width = (ctrl.width - fillData.rightMargin - fillData.leftMargin) * percent / 100;
               mask.height = ctrl.height - fillData.topMargin - fillData.bottomMargin;
            }
         }
      }
      
      flvplayback_internal function calcPercentageFromHandle(param1:Sprite) : void
      {
         var _loc2_:ControlData = null;
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = ctrlDataDict[param1];
         if(param1["calcPercentageFromHandle"] is Function && Boolean(param1["calcPercentageFromHandle"]()))
         {
            if(_loc2_.percentage < 0)
            {
               _loc2_.percentage = 0;
            }
            if(_loc2_.percentage > 100)
            {
               _loc2_.percentage = 100;
            }
            return;
         }
         _loc3_ = _loc2_.handle_mc;
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = ctrlDataDict[_loc3_];
         _loc5_ = isNaN(_loc2_.origWidth) ? param1.width : _loc2_.origWidth;
         _loc6_ = _loc5_ - _loc4_.rightMargin - _loc4_.leftMargin;
         _loc7_ = _loc3_.x - (param1.x + _loc4_.leftMargin);
         _loc2_.percentage = _loc7_ / _loc6_ * 100;
         if(_loc2_.percentage < 0)
         {
            _loc2_.percentage = 0;
         }
         if(_loc2_.percentage > 100)
         {
            _loc2_.percentage = 100;
         }
         if(_loc2_.fullness_mc != null)
         {
            flvplayback_internal::positionBar(param1,"fullness",_loc2_.percentage);
         }
      }
      
      flvplayback_internal function handleRelease(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         if(param1 == SEEK_BAR)
         {
            flvplayback_internal::seekBarListener(null);
         }
         else if(param1 == VOLUME_BAR)
         {
            flvplayback_internal::volumeBarListener(null);
         }
         flvplayback_internal::stopHandleDrag(flvplayback_internal::controls[param1]);
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
         if(param1 == SEEK_BAR)
         {
            flvplayback_internal::_vc.flvplayback_internal::_scrubFinish();
         }
      }
      
      flvplayback_internal function setTwoButtonHolderSkin(param1:int, param2:int, param3:String, param4:int, param5:String) : Sprite
      {
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         var _loc8_:ControlData = null;
         _loc7_ = new Sprite();
         _loc8_ = new ControlData(this,_loc7_,null,param1);
         ctrlDataDict[_loc7_] = _loc8_;
         flvplayback_internal::skin_mc.addChild(_loc7_);
         _loc6_ = flvplayback_internal::setupButtonSkin(param2);
         _loc6_.name = param3;
         _loc6_.visible = true;
         _loc7_.addChild(_loc6_);
         _loc6_ = flvplayback_internal::setupButtonSkin(param4);
         _loc6_.name = param5;
         _loc6_.visible = false;
         _loc7_.addChild(_loc6_);
         return _loc7_;
      }
      
      flvplayback_internal function skinAutoHideHitTest(param1:TimerEvent, param2:Boolean = true) : void
      {
         var visibleVP:VideoPlayer = null;
         var hit:Boolean = false;
         var e:TimerEvent = param1;
         var doFade:Boolean = param2;
         try
         {
            if(!flvplayback_internal::__visible)
            {
               flvplayback_internal::skin_mc.visible = false;
            }
            else if(flvplayback_internal::_vc.stage != null)
            {
               visibleVP = flvplayback_internal::_vc.getVideoPlayer(flvplayback_internal::_vc.visibleVideoPlayerIndex);
               hit = visibleVP.hitTestPoint(flvplayback_internal::_vc.stage.mouseX,flvplayback_internal::_vc.stage.mouseY,true);
               if(flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver && e != null)
               {
                  if(flvplayback_internal::_vc.stage.mouseX == flvplayback_internal::_skinAutoHideMouseX && flvplayback_internal::_vc.stage.mouseY == flvplayback_internal::_skinAutoHideMouseY)
                  {
                     if(getTimer() - flvplayback_internal::_skinAutoHideLastMotionTime > flvplayback_internal::_skinAutoHideMotionTimeout)
                     {
                        hit = false;
                     }
                  }
                  else
                  {
                     flvplayback_internal::_skinAutoHideLastMotionTime = getTimer();
                     flvplayback_internal::_skinAutoHideMouseX = flvplayback_internal::_vc.stage.mouseX;
                     flvplayback_internal::_skinAutoHideMouseY = flvplayback_internal::_vc.stage.mouseY;
                  }
               }
               if(!hit && flvplayback_internal::border_mc != null)
               {
                  hit = flvplayback_internal::border_mc.hitTestPoint(flvplayback_internal::_vc.stage.mouseX,flvplayback_internal::_vc.stage.mouseY,true);
                  if(hit && flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver)
                  {
                     flvplayback_internal::_skinAutoHideLastMotionTime = getTimer();
                  }
               }
               if(!doFade || flvplayback_internal::_skinFadingMaxTime <= 0)
               {
                  flvplayback_internal::_skinFadingTimer.stop();
                  flvplayback_internal::skin_mc.visible = hit;
                  flvplayback_internal::skin_mc.alpha = 1;
               }
               else if(!(hit && flvplayback_internal::skin_mc.visible && (!flvplayback_internal::_skinFadingTimer.running || flvplayback_internal::_skinFadingIn) || !hit && (!flvplayback_internal::skin_mc.visible || flvplayback_internal::_skinFadingTimer.running && !flvplayback_internal::_skinFadingIn)))
               {
                  flvplayback_internal::_skinFadingTimer.stop();
                  flvplayback_internal::_skinFadingIn = hit;
                  if(flvplayback_internal::_skinFadingIn && flvplayback_internal::skin_mc.alpha == 1)
                  {
                     flvplayback_internal::skin_mc.alpha = 0;
                  }
                  flvplayback_internal::_skinFadeStartTime = getTimer();
                  flvplayback_internal::_skinFadingTimer.start();
                  flvplayback_internal::skin_mc.visible = true;
               }
            }
         }
         catch(se:SecurityError)
         {
            flvplayback_internal::_skinAutoHideTimer.stop();
            flvplayback_internal::_skinFadingTimer.stop();
            flvplayback_internal::skin_mc.visible = flvplayback_internal::__visible;
            flvplayback_internal::skin_mc.alpha = 1;
         }
      }
      
      public function set seekBarInterval(param1:Number) : void
      {
         if(flvplayback_internal::_seekBarTimer.delay == param1)
         {
            return;
         }
         flvplayback_internal::_seekBarTimer.delay = param1;
      }
      
      flvplayback_internal function layoutControl(param1:DisplayObject) : void
      {
         var _loc2_:ControlData = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Sprite = null;
         var _loc5_:Rectangle = null;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = ctrlDataDict[param1];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.avatar == null)
         {
            return;
         }
         _loc3_ = flvplayback_internal::calcLayoutControl(param1);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         param1.width = _loc3_.width;
         param1.height = _loc3_.height;
         switch(_loc2_.index)
         {
            case SEEK_BAR:
            case VOLUME_BAR:
               if(_loc2_.hit_mc != null && _loc2_.hit_mc.parent == flvplayback_internal::skin_mc)
               {
                  _loc4_ = _loc2_.hit_mc;
                  _loc5_ = flvplayback_internal::calcLayoutControl(_loc4_);
                  _loc4_.x = _loc5_.x;
                  _loc4_.y = _loc5_.y;
                  _loc4_.width = _loc5_.width;
                  _loc4_.height = _loc5_.height;
               }
               if(_loc2_.progress_mc != null)
               {
                  if(isNaN(flvplayback_internal::_progressPercent))
                  {
                     flvplayback_internal::_progressPercent = flvplayback_internal::_vc.isRTMP ? 100 : 0;
                  }
                  flvplayback_internal::positionBar(Sprite(param1),"progress",flvplayback_internal::_progressPercent);
               }
               flvplayback_internal::positionHandle(Sprite(param1));
               break;
            case BUFFERING_BAR:
               flvplayback_internal::positionMaskedFill(param1,100);
         }
      }
      
      public function set fullScreenSkinDelay(param1:int) : void
      {
         flvplayback_internal::_skinAutoHideMotionTimeout = param1;
      }
      
      flvplayback_internal function captureMouseEvent(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      flvplayback_internal function handleMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:ControlData = null;
         _loc2_ = flvplayback_internal::controls[flvplayback_internal::mouseCaptureCtrl];
         if(_loc2_ != null)
         {
            _loc3_ = ctrlDataDict[_loc2_];
            _loc3_.state = _loc2_.hitTestPoint(param1.stageX,param1.stageY,true) ? OVER_STATE : NORMAL_STATE;
            flvplayback_internal::skinButtonControl(_loc2_);
            switch(flvplayback_internal::mouseCaptureCtrl)
            {
               case SEEK_BAR_HANDLE:
               case SEEK_BAR_HIT:
                  flvplayback_internal::handleRelease(SEEK_BAR);
                  break;
               case VOLUME_BAR_HANDLE:
               case VOLUME_BAR_HIT:
                  flvplayback_internal::handleRelease(VOLUME_BAR);
            }
         }
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT,flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER,flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,flvplayback_internal::handleMouseUp);
         param1.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.ROLL_OVER,flvplayback_internal::captureMouseEvent,true);
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(flvplayback_internal::__visible == param1)
         {
            return;
         }
         flvplayback_internal::__visible = param1;
         if(!flvplayback_internal::__visible)
         {
            flvplayback_internal::skin_mc.visible = false;
         }
         else
         {
            flvplayback_internal::setupSkinAutoHide(false);
         }
      }
      
      public function get bufferingDelayInterval() : Number
      {
         return flvplayback_internal::_bufferingDelayTimer.delay;
      }
      
      public function set fullScreenBackgroundColor(param1:uint) : void
      {
         if(flvplayback_internal::_fullScreenBgColor != param1)
         {
            flvplayback_internal::_fullScreenBgColor = param1;
            if(!flvplayback_internal::_vc)
            {
            }
         }
      }
      
      public function get fullScreenTakeOver() : Boolean
      {
         return flvplayback_internal::_fullScreenTakeOver;
      }
      
      public function set skin(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            flvplayback_internal::removeSkin();
            flvplayback_internal::_skin = null;
            flvplayback_internal::_skinReady = true;
         }
         else
         {
            _loc2_ = String(param1);
            if(param1 == flvplayback_internal::_skin)
            {
               return;
            }
            flvplayback_internal::removeSkin();
            flvplayback_internal::_skin = String(param1);
            flvplayback_internal::_skinReady = flvplayback_internal::_skin == "";
            if(!flvplayback_internal::_skinReady)
            {
               flvplayback_internal::downloadSkin();
            }
         }
      }
      
      public function set volumeBarInterval(param1:Number) : void
      {
         if(flvplayback_internal::_volumeBarTimer.delay == param1)
         {
            return;
         }
         flvplayback_internal::_volumeBarTimer.delay = param1;
      }
      
      flvplayback_internal function setSkin(param1:int, param2:DisplayObject) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         var _loc5_:String = null;
         if(param1 >= NUM_CONTROLS)
         {
            return;
         }
         if(param1 < NUM_BUTTONS)
         {
            _loc3_ = flvplayback_internal::setupButtonSkin(param1);
            flvplayback_internal::skin_mc.addChild(_loc3_);
            _loc4_ = ctrlDataDict[_loc3_];
         }
         else
         {
            switch(param1)
            {
               case PLAY_PAUSE_BUTTON:
                  _loc3_ = flvplayback_internal::setTwoButtonHolderSkin(param1,PLAY_BUTTON,"play_mc",PAUSE_BUTTON,"pause_mc");
                  _loc4_ = ctrlDataDict[_loc3_];
                  break;
               case FULL_SCREEN_BUTTON:
                  _loc3_ = flvplayback_internal::setTwoButtonHolderSkin(param1,FULL_SCREEN_ON_BUTTON,"on_mc",FULL_SCREEN_OFF_BUTTON,"off_mc");
                  _loc4_ = ctrlDataDict[_loc3_];
                  break;
               case MUTE_BUTTON:
                  _loc3_ = flvplayback_internal::setTwoButtonHolderSkin(param1,MUTE_ON_BUTTON,"on_mc",MUTE_OFF_BUTTON,"off_mc");
                  _loc4_ = ctrlDataDict[_loc3_];
                  break;
               case SEEK_BAR:
               case VOLUME_BAR:
                  _loc5_ = flvplayback_internal::skinClassPrefixes[param1];
                  _loc3_ = Sprite(flvplayback_internal::createSkin(flvplayback_internal::skinTemplate,_loc5_));
                  if(_loc3_ != null)
                  {
                     flvplayback_internal::skin_mc.addChild(_loc3_);
                     _loc4_ = new ControlData(this,_loc3_,null,param1);
                     ctrlDataDict[_loc3_] = _loc4_;
                     _loc4_.progress_mc = flvplayback_internal::setupBarSkinPart(_loc3_,param2,flvplayback_internal::skinTemplate,_loc5_ + "Progress","progress_mc");
                     _loc4_.fullness_mc = flvplayback_internal::setupBarSkinPart(_loc3_,param2,flvplayback_internal::skinTemplate,_loc5_ + "Fullness","fullness_mc");
                     _loc4_.hit_mc = Sprite(flvplayback_internal::setupBarSkinPart(_loc3_,param2,flvplayback_internal::skinTemplate,_loc5_ + "Hit","hit_mc"));
                     _loc4_.handle_mc = Sprite(flvplayback_internal::setupBarSkinPart(_loc3_,param2,flvplayback_internal::skinTemplate,_loc5_ + "Handle","handle_mc",true));
                     _loc3_.width = param2.width;
                     _loc3_.height = param2.height;
                  }
                  break;
               case BUFFERING_BAR:
                  _loc5_ = flvplayback_internal::skinClassPrefixes[param1];
                  _loc3_ = Sprite(flvplayback_internal::createSkin(flvplayback_internal::skinTemplate,_loc5_));
                  if(_loc3_ != null)
                  {
                     flvplayback_internal::skin_mc.addChild(_loc3_);
                     _loc4_ = new ControlData(this,_loc3_,null,param1);
                     ctrlDataDict[_loc3_] = _loc4_;
                     _loc4_.fill_mc = flvplayback_internal::setupBarSkinPart(_loc3_,param2,flvplayback_internal::skinTemplate,_loc5_ + "Fill","fill_mc");
                     _loc3_.width = param2.width;
                     _loc3_.height = param2.height;
                  }
            }
         }
         _loc4_.avatar = param2;
         ctrlDataDict[_loc3_] = _loc4_;
         flvplayback_internal::delayedControls[param1] = _loc3_;
      }
      
      public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
      {
         flvplayback_internal::_bufferingBarHides = param1;
      }
      
      flvplayback_internal function handleSoundEvent(param1:SoundEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:ControlData = null;
         if(flvplayback_internal::_isMuted && param1.soundTransform.volume > 0)
         {
            flvplayback_internal::_isMuted = false;
            flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
            flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_OFF_BUTTON]);
            flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
            flvplayback_internal::skinButtonControl(flvplayback_internal::controls[MUTE_ON_BUTTON]);
         }
         _loc2_ = flvplayback_internal::controls[VOLUME_BAR];
         if(_loc2_ != null)
         {
            _loc3_ = ctrlDataDict[_loc2_];
            _loc3_.percentage = (flvplayback_internal::_isMuted ? flvplayback_internal::cachedSoundLevel : param1.soundTransform.volume) * 100;
            if(_loc3_.percentage < 0)
            {
               _loc3_.percentage = 0;
            }
            else if(_loc3_.percentage > 100)
            {
               _loc3_.percentage = 100;
            }
            flvplayback_internal::positionHandle(_loc2_);
         }
      }
      
      flvplayback_internal function stopHandleDrag(param1:Sprite) : void
      {
         var ctrlData:ControlData = null;
         var handle:Sprite = null;
         var ctrl:Sprite = param1;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = ctrlDataDict[ctrl];
         try
         {
            if(ctrl["stopHandleDrag"] is Function && Boolean(ctrl["stopHandleDrag"]()))
            {
               ctrlData.isDragging = false;
               return;
            }
         }
         catch(re:ReferenceError)
         {
         }
         handle = ctrlData.handle_mc;
         if(handle == null)
         {
            return;
         }
         handle.stopDrag();
         ctrlData.isDragging = false;
      }
      
      public function set skinBackgroundAlpha(param1:Number) : void
      {
         if(flvplayback_internal::borderAlpha != param1)
         {
            flvplayback_internal::borderAlpha = param1;
            flvplayback_internal::borderColorTransform.alphaOffset = 255 * param1;
            flvplayback_internal::borderPrevRect = null;
            flvplayback_internal::layoutSkin();
         }
      }
      
      public function getControl(param1:int) : Sprite
      {
         return flvplayback_internal::controls[param1];
      }
      
      public function set skinScaleMaximum(param1:Number) : void
      {
         flvplayback_internal::_skinScaleMaximum = param1;
      }
      
      flvplayback_internal function handleLoad(param1:Event) : void
      {
         var i:int = 0;
         var dispObj:DisplayObject = null;
         var index:Number = NaN;
         var e:Event = param1;
         try
         {
            flvplayback_internal::skin_mc = new Sprite();
            if(e != null)
            {
               flvplayback_internal::skinTemplate = Sprite(flvplayback_internal::skinLoader.content);
            }
            flvplayback_internal::layout_mc = flvplayback_internal::skinTemplate;
            customClips = new Array();
            flvplayback_internal::delayedControls = new Array();
            i = 0;
            while(i < flvplayback_internal::layout_mc.numChildren)
            {
               dispObj = flvplayback_internal::layout_mc.getChildAt(i);
               index = Number(flvplayback_internal::layoutNameToIndexMappings[dispObj.name]);
               if(!isNaN(index))
               {
                  flvplayback_internal::setSkin(int(index),dispObj);
               }
               else if(dispObj.name != "video_mc")
               {
                  flvplayback_internal::setCustomClip(dispObj);
               }
               i++;
            }
            flvplayback_internal::skinLoadDelayCount = 0;
            flvplayback_internal::_vc.addEventListener(Event.ENTER_FRAME,flvplayback_internal::finishLoad);
         }
         catch(err:Error)
         {
            flvplayback_internal::_vc.flvplayback_internal::skinError(err.message);
            flvplayback_internal::removeSkin();
         }
      }
      
      flvplayback_internal function calcBarMargins(param1:DisplayObject, param2:String, param3:Boolean) : void
      {
         var ctrlData:ControlData = null;
         var bar:DisplayObject = null;
         var barData:ControlData = null;
         var ctrl:DisplayObject = param1;
         var type:String = param2;
         var symmetricMargins:Boolean = param3;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = ctrlDataDict[ctrl];
         bar = ctrlData[type + "_mc"];
         if(bar == null)
         {
            try
            {
               bar = ctrl[type + "_mc"];
            }
            catch(re:ReferenceError)
            {
               bar = null;
            }
            if(bar == null)
            {
               return;
            }
            ctrlData[type + "_mc"] = bar;
         }
         barData = ctrlDataDict[bar];
         if(barData == null)
         {
            barData = new ControlData(this,bar,ctrl,-1);
            ctrlDataDict[bar] = barData;
         }
         barData.leftMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "LeftMargin");
         if(isNaN(barData.leftMargin) && bar.parent == ctrl.parent)
         {
            barData.leftMargin = bar.x - ctrl.x;
         }
         barData.rightMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "RightMargin");
         if(isNaN(barData.rightMargin))
         {
            if(symmetricMargins)
            {
               barData.rightMargin = barData.leftMargin;
            }
            else if(bar.parent == ctrl.parent)
            {
               barData.rightMargin = ctrl.width - bar.width - bar.x + ctrl.x;
            }
         }
         barData.topMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "TopMargin");
         if(isNaN(barData.topMargin) && bar.parent == ctrl.parent)
         {
            barData.topMargin = bar.y - ctrl.y;
         }
         barData.bottomMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "BottomMargin");
         if(isNaN(barData.bottomMargin))
         {
            if(symmetricMargins)
            {
               barData.bottomMargin = barData.topMargin;
            }
            else if(bar.parent == ctrl.parent)
            {
               barData.bottomMargin = ctrl.height - bar.height - bar.y + ctrl.y;
            }
         }
         barData.origX = flvplayback_internal::getNumberPropSafe(ctrl,type + "X");
         if(isNaN(barData.origX))
         {
            if(bar.parent == ctrl.parent)
            {
               barData.origX = bar.x - ctrl.x;
            }
            else if(bar.parent == ctrl)
            {
               barData.origX = bar.x;
            }
         }
         barData.origY = flvplayback_internal::getNumberPropSafe(ctrl,type + "Y");
         if(isNaN(barData.origY))
         {
            if(bar.parent == ctrl.parent)
            {
               barData.origY = bar.y - ctrl.y;
            }
            else if(bar.parent == ctrl)
            {
               barData.origY = bar.y;
            }
         }
         barData.origWidth = bar.width;
         barData.origHeight = bar.height;
         barData.origScaleX = bar.scaleX;
         barData.origScaleY = bar.scaleY;
      }
      
      public function set skinBackgroundColor(param1:uint) : void
      {
         if(flvplayback_internal::borderColor != param1)
         {
            flvplayback_internal::borderColor = param1;
            flvplayback_internal::borderColorTransform.redOffset = flvplayback_internal::borderColor >> 16 & 0xFF;
            flvplayback_internal::borderColorTransform.greenOffset = flvplayback_internal::borderColor >> 8 & 0xFF;
            flvplayback_internal::borderColorTransform.blueOffset = flvplayback_internal::borderColor & 0xFF;
            flvplayback_internal::borderPrevRect = null;
            flvplayback_internal::layoutSkin();
         }
      }
      
      public function set volumeBarScrubTolerance(param1:Number) : void
      {
         flvplayback_internal::_volumeBarScrubTolerance = param1;
      }
      
      flvplayback_internal function finishAddBufferingBar(param1:Event = null) : void
      {
         var _loc2_:Sprite = null;
         if(param1 != null)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::finishAddBufferingBar);
         }
         _loc2_ = flvplayback_internal::controls[BUFFERING_BAR];
         flvplayback_internal::calcBarMargins(_loc2_,"fill",true);
         flvplayback_internal::fixUpBar(_loc2_,"fill",_loc2_,"fill_mc");
         flvplayback_internal::positionMaskedFill(_loc2_,100);
      }
      
      flvplayback_internal function handleButtonEvent(param1:MouseEvent) : void
      {
         var ctrlData:ControlData = null;
         var topLevel:DisplayObject = null;
         var e:MouseEvent = param1;
         ctrlData = ctrlDataDict[e.currentTarget];
         switch(e.type)
         {
            case MouseEvent.ROLL_OVER:
               ctrlData.state = OVER_STATE;
               break;
            case MouseEvent.ROLL_OUT:
               ctrlData.state = NORMAL_STATE;
               break;
            case MouseEvent.MOUSE_DOWN:
               ctrlData.state = DOWN_STATE;
               flvplayback_internal::mouseCaptureCtrl = ctrlData.index;
               switch(flvplayback_internal::mouseCaptureCtrl)
               {
                  case SEEK_BAR_HANDLE:
                  case SEEK_BAR_HIT:
                  case VOLUME_BAR_HANDLE:
                  case VOLUME_BAR_HIT:
                     flvplayback_internal::dispatchMessage(ctrlData.index);
               }
               topLevel = flvplayback_internal::_vc.stage;
               try
               {
                  topLevel.addEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::captureMouseEvent,true);
               }
               catch(se:SecurityError)
               {
                  topLevel = flvplayback_internal::_vc.root;
                  topLevel.addEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::captureMouseEvent,true);
               }
               topLevel.addEventListener(MouseEvent.MOUSE_OUT,flvplayback_internal::captureMouseEvent,true);
               topLevel.addEventListener(MouseEvent.MOUSE_OVER,flvplayback_internal::captureMouseEvent,true);
               topLevel.addEventListener(MouseEvent.MOUSE_UP,flvplayback_internal::handleMouseUp);
               topLevel.addEventListener(MouseEvent.ROLL_OUT,flvplayback_internal::captureMouseEvent,true);
               topLevel.addEventListener(MouseEvent.ROLL_OVER,flvplayback_internal::captureMouseEvent,true);
               break;
            case MouseEvent.CLICK:
               switch(flvplayback_internal::mouseCaptureCtrl)
               {
                  case SEEK_BAR_HANDLE:
                  case SEEK_BAR_HIT:
                  case VOLUME_BAR_HANDLE:
                  case VOLUME_BAR_HIT:
                     break;
                  default:
                     flvplayback_internal::dispatchMessage(ctrlData.index);
               }
               return;
         }
         flvplayback_internal::skinButtonControl(e.currentTarget);
      }
      
      flvplayback_internal function applySkinState(param1:ControlData, param2:DisplayObject) : void
      {
         if(param2 != param1.currentState_mc)
         {
            if(param1.currentState_mc != null)
            {
               param1.currentState_mc.visible = false;
            }
            param1.currentState_mc = param2;
            param1.currentState_mc.visible = true;
         }
      }
      
      flvplayback_internal function handleLoadErrorEvent(param1:ErrorEvent) : void
      {
         flvplayback_internal::_skinReady = true;
         flvplayback_internal::_vc.flvplayback_internal::skinError(param1.toString());
      }
      
      flvplayback_internal function addBarControl(param1:Sprite) : void
      {
         var _loc2_:ControlData = null;
         _loc2_ = ctrlDataDict[param1];
         _loc2_.isDragging = false;
         _loc2_.percentage = 0;
         if(param1.parent == flvplayback_internal::skin_mc && flvplayback_internal::skin_mc != null)
         {
            flvplayback_internal::finishAddBarControl(param1);
         }
         else
         {
            param1.addEventListener(Event.REMOVED_FROM_STAGE,flvplayback_internal::cleanupHandle);
            param1.addEventListener(Event.ENTER_FRAME,flvplayback_internal::finishAddBarControl);
         }
      }
      
      flvplayback_internal function handleEvent(param1:Event) : void
      {
         var e:Event = param1;
         switch(e.type)
         {
            case Event.ADDED_TO_STAGE:
               flvplayback_internal::_fullScreen = false;
               if(flvplayback_internal::_vc.stage != null)
               {
                  try
                  {
                     flvplayback_internal::_fullScreen = flvplayback_internal::_vc.stage.displayState == StageDisplayState.FULL_SCREEN;
                     flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
                  }
                  catch(se:SecurityError)
                  {
                  }
               }
               if(!flvplayback_internal::_fullScreen)
               {
                  flvplayback_internal::_fullScreenAccel = false;
               }
               flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
               flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
               flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
               flvplayback_internal::skinButtonControl(flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
               if(flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver)
               {
                  flvplayback_internal::enterFullScreenTakeOver();
               }
               else if(!flvplayback_internal::_fullScreen)
               {
                  flvplayback_internal::exitFullScreenTakeOver();
               }
               flvplayback_internal::layoutSkin();
               flvplayback_internal::setupSkinAutoHide(false);
               break;
            case Event.REMOVED_FROM_STAGE:
               flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
         }
      }
      
      flvplayback_internal function skinButtonControl(param1:Object) : void
      {
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var e:Event = null;
         var ctrlOrEvent:Object = param1;
         if(ctrlOrEvent == null)
         {
            return;
         }
         if(ctrlOrEvent is Event)
         {
            e = Event(ctrlOrEvent);
            ctrl = Sprite(e.currentTarget);
            ctrl.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::skinButtonControl);
         }
         else
         {
            ctrl = Sprite(ctrlOrEvent);
         }
         ctrlData = ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            return;
         }
         try
         {
            if(ctrl["placeholder_mc"] != undefined)
            {
               ctrl.removeChild(ctrl["placeholder_mc"]);
               ctrl["placeholder_mc"] = null;
            }
         }
         catch(re:ReferenceError)
         {
         }
         if(ctrlData.state_mc == null)
         {
            ctrlData.state_mc = new Array();
         }
         if(ctrlData.state_mc[NORMAL_STATE] == undefined)
         {
            ctrlData.state_mc[NORMAL_STATE] = flvplayback_internal::setupButtonSkinState(ctrl,ctrl,flvplayback_internal::buttonSkinLinkageIDs[NORMAL_STATE],null);
         }
         if(ctrlData.enabled && flvplayback_internal::_controlsEnabled)
         {
            if(ctrlData.state_mc[ctrlData.state] == undefined)
            {
               ctrlData.state_mc[ctrlData.state] = flvplayback_internal::setupButtonSkinState(ctrl,ctrl,flvplayback_internal::buttonSkinLinkageIDs[ctrlData.state],ctrlData.state_mc[NORMAL_STATE]);
            }
            if(ctrlData.state_mc[ctrlData.state] != ctrlData.currentState_mc)
            {
               if(ctrlData.currentState_mc != null)
               {
                  ctrlData.currentState_mc.visible = false;
               }
               ctrlData.currentState_mc = ctrlData.state_mc[ctrlData.state];
               ctrlData.currentState_mc.visible = true;
            }
            flvplayback_internal::applySkinState(ctrlData,ctrlData.state_mc[ctrlData.state]);
         }
         else
         {
            ctrlData.state = NORMAL_STATE;
            if(ctrlData.disabled_mc == null)
            {
               ctrlData.disabled_mc = flvplayback_internal::setupButtonSkinState(ctrl,ctrl,"disabledLinkageID",ctrlData.state_mc[NORMAL_STATE]);
            }
            flvplayback_internal::applySkinState(ctrlData,ctrlData.disabled_mc);
         }
      }
      
      public function set controlsEnabled(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(flvplayback_internal::_controlsEnabled == param1)
         {
            return;
         }
         flvplayback_internal::_controlsEnabled = param1;
         _loc2_ = 0;
         while(_loc2_ < NUM_BUTTONS)
         {
            flvplayback_internal::skinButtonControl(flvplayback_internal::controls[_loc2_]);
            _loc2_++;
         }
      }
      
      flvplayback_internal function setupSkinAutoHide(param1:Boolean) : void
      {
         if(flvplayback_internal::_skinAutoHide && flvplayback_internal::skin_mc != null)
         {
            flvplayback_internal::skinAutoHideHitTest(null,param1);
            flvplayback_internal::_skinAutoHideTimer.start();
         }
         else
         {
            if(flvplayback_internal::skin_mc != null)
            {
               if(param1 && flvplayback_internal::_skinFadingMaxTime > 0 && (!flvplayback_internal::skin_mc.visible || flvplayback_internal::skin_mc.alpha < 1) && flvplayback_internal::__visible)
               {
                  flvplayback_internal::_skinFadingTimer.stop();
                  flvplayback_internal::_skinFadeStartTime = getTimer();
                  flvplayback_internal::_skinFadingIn = true;
                  if(flvplayback_internal::skin_mc.alpha == 1)
                  {
                     flvplayback_internal::skin_mc.alpha = 0;
                  }
                  flvplayback_internal::_skinFadingTimer.start();
               }
               else if(flvplayback_internal::_skinFadingMaxTime <= 0)
               {
                  flvplayback_internal::_skinFadingTimer.stop();
                  flvplayback_internal::skin_mc.alpha = 1;
               }
               flvplayback_internal::skin_mc.visible = flvplayback_internal::__visible;
            }
            flvplayback_internal::_skinAutoHideTimer.stop();
         }
      }
      
      public function enterFullScreenDisplayState() : void
      {
         var theRect:Rectangle = null;
         var vp:VideoPlayer = null;
         var effectiveWidth:int = 0;
         var effectiveHeight:int = 0;
         var videoAspectRatio:Number = NaN;
         var screenAspectRatio:Number = NaN;
         var effectiveMinWidth:int = 0;
         var effectiveMinHeight:int = 0;
         var skinScaleMinWidth:int = 0;
         var skinScaleMinHeight:int = 0;
         if(!flvplayback_internal::_fullScreen && flvplayback_internal::_vc.stage != null)
         {
            if(flvplayback_internal::_fullScreenTakeOver)
            {
               try
               {
                  theRect = flvplayback_internal::_vc.stage.fullScreenSourceRect;
                  flvplayback_internal::_fullScreenAccel = true;
                  vp = flvplayback_internal::_vc.getVideoPlayer(flvplayback_internal::_vc.visibleVideoPlayerIndex);
                  effectiveWidth = vp.videoWidth;
                  effectiveHeight = vp.videoHeight;
                  videoAspectRatio = effectiveWidth / effectiveHeight;
                  screenAspectRatio = flvplayback_internal::_vc.stage.fullScreenWidth / flvplayback_internal::_vc.stage.fullScreenHeight;
                  if(videoAspectRatio > screenAspectRatio)
                  {
                     effectiveHeight = effectiveWidth / screenAspectRatio;
                  }
                  else if(videoAspectRatio < screenAspectRatio)
                  {
                     effectiveWidth = effectiveHeight * screenAspectRatio;
                  }
                  effectiveMinWidth = int(flvplayback_internal::fullScreenSourceRectMinWidth);
                  effectiveMinHeight = int(flvplayback_internal::fullScreenSourceRectMinHeight);
                  if(flvplayback_internal::fullScreenSourceRectMinAspectRatio > screenAspectRatio)
                  {
                     effectiveMinHeight = effectiveMinWidth / screenAspectRatio;
                  }
                  else if(flvplayback_internal::fullScreenSourceRectMinAspectRatio < screenAspectRatio)
                  {
                     effectiveMinWidth = effectiveMinHeight * screenAspectRatio;
                  }
                  skinScaleMinWidth = flvplayback_internal::_vc.stage.fullScreenWidth / flvplayback_internal::_skinScaleMaximum;
                  skinScaleMinHeight = flvplayback_internal::_vc.stage.fullScreenHeight / flvplayback_internal::_skinScaleMaximum;
                  if(effectiveMinWidth < skinScaleMinWidth || effectiveMinHeight < skinScaleMinHeight)
                  {
                     effectiveMinWidth = skinScaleMinWidth;
                     effectiveMinHeight = skinScaleMinHeight;
                  }
                  if(effectiveWidth < effectiveMinWidth || effectiveHeight < effectiveMinHeight)
                  {
                     effectiveWidth = effectiveMinWidth;
                     effectiveHeight = effectiveMinHeight;
                  }
                  flvplayback_internal::_vc.stage.fullScreenSourceRect = new Rectangle(0,0,effectiveWidth,effectiveHeight);
                  flvplayback_internal::_vc.stage.displayState = StageDisplayState.FULL_SCREEN;
               }
               catch(re:ReferenceError)
               {
                  flvplayback_internal::_fullScreenAccel = false;
               }
               catch(re:SecurityError)
               {
                  flvplayback_internal::_fullScreenAccel = false;
               }
            }
            try
            {
               flvplayback_internal::_vc.stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            catch(se:SecurityError)
            {
            }
         }
      }
      
      public function get skin() : String
      {
         return flvplayback_internal::_skin;
      }
      
      flvplayback_internal function finishAddBarControl(param1:Object) : void
      {
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var e:Event = null;
         var ctrlOrEvent:Object = param1;
         if(ctrlOrEvent == null)
         {
            return;
         }
         if(ctrlOrEvent is Event)
         {
            e = Event(ctrlOrEvent);
            ctrl = Sprite(e.currentTarget);
            ctrl.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::finishAddBarControl);
         }
         else
         {
            ctrl = Sprite(ctrlOrEvent);
         }
         ctrlData = ctrlDataDict[ctrl];
         try
         {
            if(ctrl["addBarControl"] is Function)
            {
               ctrl["addBarControl"]();
            }
         }
         catch(re:ReferenceError)
         {
         }
         ctrlData.origWidth = ctrl.width;
         ctrlData.origHeight = ctrl.height;
         flvplayback_internal::fixUpBar(ctrl,"progress",ctrl,"progress_mc");
         flvplayback_internal::calcBarMargins(ctrl,"progress",false);
         if(ctrlData.progress_mc != null)
         {
            flvplayback_internal::fixUpBar(ctrl,"progressBarFill",ctrlData.progress_mc,"fill_mc");
            flvplayback_internal::calcBarMargins(ctrlData.progress_mc,"fill",false);
            flvplayback_internal::calcBarMargins(ctrlData.progress_mc,"mask",false);
            if(isNaN(flvplayback_internal::_progressPercent))
            {
               flvplayback_internal::_progressPercent = flvplayback_internal::_vc.isRTMP ? 100 : 0;
            }
            flvplayback_internal::positionBar(ctrl,"progress",flvplayback_internal::_progressPercent);
         }
         flvplayback_internal::fixUpBar(ctrl,"fullness",ctrl,"fullness_mc");
         flvplayback_internal::calcBarMargins(ctrl,"fullness",false);
         if(ctrlData.fullness_mc != null)
         {
            flvplayback_internal::fixUpBar(ctrl,"fullnessBarFill",ctrlData.fullness_mc,"fill_mc");
            flvplayback_internal::calcBarMargins(ctrlData.fullness_mc,"fill",false);
            flvplayback_internal::calcBarMargins(ctrlData.fullness_mc,"mask",false);
         }
         flvplayback_internal::fixUpBar(ctrl,"hit",ctrl,"hit_mc");
         flvplayback_internal::fixUpBar(ctrl,"handle",ctrl,"handle_mc");
         flvplayback_internal::calcBarMargins(ctrl,"handle",true);
         switch(ctrlData.index)
         {
            case SEEK_BAR:
               setControl(SEEK_BAR_HANDLE,ctrlData.handle_mc);
               if(ctrlData.hit_mc != null)
               {
                  setControl(SEEK_BAR_HIT,ctrlData.hit_mc);
               }
               break;
            case VOLUME_BAR:
               setControl(VOLUME_BAR_HANDLE,ctrlData.handle_mc);
               if(ctrlData.hit_mc != null)
               {
                  setControl(VOLUME_BAR_HIT,ctrlData.hit_mc);
               }
         }
         flvplayback_internal::positionHandle(ctrl);
      }
      
      public function get fullScreenBackgroundColor() : uint
      {
         return flvplayback_internal::_fullScreenBgColor;
      }
      
      flvplayback_internal function startHandleDrag(param1:Sprite) : void
      {
         var ctrlData:ControlData = null;
         var handle:Sprite = null;
         var handleData:ControlData = null;
         var theY:Number = NaN;
         var theWidth:Number = NaN;
         var bounds:Rectangle = null;
         var ctrl:Sprite = param1;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = ctrlDataDict[ctrl];
         try
         {
            if(ctrl["startHandleDrag"] is Function && Boolean(ctrl["startHandleDrag"]()))
            {
               ctrlData.isDragging = true;
               return;
            }
         }
         catch(re:ReferenceError)
         {
         }
         handle = ctrlData.handle_mc;
         if(handle == null)
         {
            return;
         }
         handleData = ctrlDataDict[handle];
         theY = ctrl.y + handleData.origY;
         theWidth = isNaN(ctrlData.origWidth) ? ctrl.width : ctrlData.origWidth;
         bounds = new Rectangle(ctrl.x + handleData.leftMargin,theY,theWidth - handleData.rightMargin,0);
         handle.startDrag(false,bounds);
         ctrlData.isDragging = true;
      }
      
      flvplayback_internal function setupBarSkinPart(param1:Sprite, param2:DisplayObject, param3:Sprite, param4:String, param5:String, param6:Boolean = false) : DisplayObject
      {
         var part:DisplayObject = null;
         var partAvatar:DisplayObject = null;
         var ctrlData:ControlData = null;
         var partData:ControlData = null;
         var ctrl:Sprite = param1;
         var avatar:DisplayObject = param2;
         var definitionHolder:Sprite = param3;
         var skinName:String = param4;
         var partName:String = param5;
         var required:Boolean = param6;
         try
         {
            part = ctrl[partName];
         }
         catch(re:ReferenceError)
         {
            part = null;
         }
         if(part == null)
         {
            try
            {
               part = flvplayback_internal::createSkin(definitionHolder,skinName);
            }
            catch(ve:VideoError)
            {
               if(required)
               {
                  throw ve;
               }
            }
            if(part != null)
            {
               flvplayback_internal::skin_mc.addChild(part);
               part.x = ctrl.x;
               part.y = ctrl.y;
               partAvatar = flvplayback_internal::layout_mc.getChildByName(skinName + "_mc");
               if(partAvatar != null)
               {
                  if(partName == "hit_mc")
                  {
                     ctrlData = ctrlDataDict[ctrl];
                     partData = new ControlData(this,part,flvplayback_internal::controls[ctrlData.index],-1);
                     partData.avatar = partAvatar;
                     ctrlDataDict[part] = partData;
                  }
                  else
                  {
                     part.x += partAvatar.x - avatar.x;
                     part.y += partAvatar.y - avatar.y;
                     part.width = partAvatar.width;
                     part.height = partAvatar.height;
                  }
               }
            }
         }
         if(required && part == null)
         {
            throw new VideoError(VideoError.MISSING_SKIN_STYLE,skinName);
         }
         return part;
      }
      
      public function get skinBackgroundAlpha() : Number
      {
         return flvplayback_internal::borderAlpha;
      }
      
      public function get volumeBarScrubTolerance() : Number
      {
         return flvplayback_internal::_volumeBarScrubTolerance;
      }
      
      public function get skinScaleMaximum() : Number
      {
         return flvplayback_internal::_skinScaleMaximum;
      }
      
      public function get skinBackgroundColor() : uint
      {
         return flvplayback_internal::borderColor;
      }
      
      public function get controlsEnabled() : Boolean
      {
         return flvplayback_internal::_controlsEnabled;
      }
      
      flvplayback_internal function handleIVPEvent(param1:IVPEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:fl.video.VideoEvent = null;
         var _loc5_:Sprite = null;
         var _loc6_:ControlData = null;
         var _loc7_:VideoProgressEvent = null;
         var _loc8_:VideoPlayerState = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1.vp != flvplayback_internal::_vc.visibleVideoPlayerIndex)
         {
            return;
         }
         _loc2_ = flvplayback_internal::_vc.activeVideoPlayerIndex;
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         switch(param1.type)
         {
            case fl.video.VideoEvent.STATE_CHANGE:
               _loc4_ = VideoEvent(param1);
               if(_loc4_.state == VideoState.BUFFERING)
               {
                  if(!flvplayback_internal::_bufferingOn)
                  {
                     flvplayback_internal::_bufferingDelayTimer.reset();
                     flvplayback_internal::_bufferingDelayTimer.start();
                  }
               }
               else
               {
                  flvplayback_internal::_bufferingDelayTimer.reset();
                  flvplayback_internal::_bufferingOn = false;
               }
               if(_loc4_.state == VideoState.LOADING)
               {
                  flvplayback_internal::_progressPercent = flvplayback_internal::_vc.getVideoPlayer(param1.vp).isRTMP ? 100 : 0;
                  _loc3_ = SEEK_BAR;
                  while(_loc3_ <= VOLUME_BAR)
                  {
                     _loc5_ = flvplayback_internal::controls[_loc3_];
                     if(flvplayback_internal::controls[_loc3_] != null)
                     {
                        _loc6_ = ctrlDataDict[_loc5_];
                        if(_loc6_.progress_mc != null)
                        {
                           flvplayback_internal::positionBar(_loc5_,"progress",flvplayback_internal::_progressPercent);
                        }
                     }
                     _loc3_++;
                  }
               }
               _loc3_ = 0;
               while(_loc3_ < NUM_CONTROLS)
               {
                  if(flvplayback_internal::controls[_loc3_] != undefined)
                  {
                     flvplayback_internal::setEnabledAndVisibleForState(_loc3_,_loc4_.state);
                     if(_loc3_ < NUM_BUTTONS)
                     {
                        flvplayback_internal::skinButtonControl(flvplayback_internal::controls[_loc3_]);
                     }
                  }
                  _loc3_++;
               }
               break;
            case fl.video.VideoEvent.READY:
            case MetadataEvent.METADATA_RECEIVED:
               _loc3_ = 0;
               while(_loc3_ < NUM_CONTROLS)
               {
                  if(flvplayback_internal::controls[_loc3_] != undefined)
                  {
                     flvplayback_internal::setEnabledAndVisibleForState(_loc3_,flvplayback_internal::_vc.state);
                     if(_loc3_ < NUM_BUTTONS)
                     {
                        flvplayback_internal::skinButtonControl(flvplayback_internal::controls[_loc3_]);
                     }
                  }
                  _loc3_++;
               }
               if(flvplayback_internal::_vc.getVideoPlayer(param1.vp).isRTMP)
               {
                  flvplayback_internal::_progressPercent = 100;
                  _loc3_ = SEEK_BAR;
                  while(_loc3_ <= VOLUME_BAR)
                  {
                     _loc5_ = flvplayback_internal::controls[_loc3_];
                     if(_loc5_ != null)
                     {
                        _loc6_ = ctrlDataDict[_loc5_];
                        if(_loc6_.progress_mc != null)
                        {
                           flvplayback_internal::positionBar(_loc5_,"progress",flvplayback_internal::_progressPercent);
                        }
                     }
                     _loc3_++;
                  }
               }
               break;
            case fl.video.VideoEvent.PLAYHEAD_UPDATE:
               if(flvplayback_internal::controls[SEEK_BAR] != undefined && !flvplayback_internal::_vc.isLive && !isNaN(flvplayback_internal::_vc.totalTime) && flvplayback_internal::_vc.getVideoPlayer(flvplayback_internal::_vc.visibleVideoPlayerIndex).state != VideoState.SEEKING)
               {
                  _loc4_ = VideoEvent(param1);
                  _loc10_ = _loc4_.playheadTime / flvplayback_internal::_vc.totalTime * 100;
                  if(_loc10_ < 0)
                  {
                     _loc10_ = 0;
                  }
                  else if(_loc10_ > 100)
                  {
                     _loc10_ = 100;
                  }
                  _loc5_ = flvplayback_internal::controls[SEEK_BAR];
                  _loc6_ = ctrlDataDict[_loc5_];
                  _loc6_.percentage = _loc10_;
                  flvplayback_internal::positionHandle(_loc5_);
               }
               break;
            case VideoProgressEvent.PROGRESS:
               _loc7_ = VideoProgressEvent(param1);
               flvplayback_internal::_progressPercent = _loc7_.bytesTotal <= 0 ? 100 : _loc7_.bytesLoaded / _loc7_.bytesTotal * 100;
               _loc8_ = flvplayback_internal::_vc.flvplayback_internal::videoPlayerStates[param1.vp];
               _loc9_ = _loc8_.minProgressPercent;
               if(!isNaN(_loc9_) && _loc9_ > flvplayback_internal::_progressPercent)
               {
                  flvplayback_internal::_progressPercent = _loc9_;
               }
               if(!isNaN(flvplayback_internal::_vc.totalTime))
               {
                  _loc11_ = flvplayback_internal::_vc.playheadTime / flvplayback_internal::_vc.totalTime * 100;
                  if(_loc11_ > flvplayback_internal::_progressPercent)
                  {
                     flvplayback_internal::_progressPercent = _loc11_;
                     _loc8_.minProgressPercent = flvplayback_internal::_progressPercent;
                  }
               }
               _loc3_ = SEEK_BAR;
               while(_loc3_ <= VOLUME_BAR)
               {
                  _loc5_ = flvplayback_internal::controls[_loc3_];
                  if(_loc5_ != null)
                  {
                     _loc6_ = ctrlDataDict[_loc5_];
                     if(_loc6_.progress_mc != null)
                     {
                        flvplayback_internal::positionBar(_loc5_,"progress",flvplayback_internal::_progressPercent);
                     }
                  }
                  _loc3_++;
               }
         }
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      flvplayback_internal function setupButtonSkinState(param1:Sprite, param2:Sprite, param3:String, param4:DisplayObject = null) : DisplayObject
      {
         var stateSkin:DisplayObject = null;
         var ctrl:Sprite = param1;
         var definitionHolder:Sprite = param2;
         var skinName:String = param3;
         var defaultSkin:DisplayObject = param4;
         try
         {
            stateSkin = flvplayback_internal::createSkin(definitionHolder,skinName);
         }
         catch(ve:VideoError)
         {
            if(defaultSkin == null)
            {
               throw ve;
            }
            stateSkin = null;
         }
         if(stateSkin != null)
         {
            stateSkin.visible = false;
            ctrl.addChild(stateSkin);
         }
         else if(defaultSkin != null)
         {
            stateSkin = defaultSkin;
         }
         return stateSkin;
      }
      
      flvplayback_internal function layoutSkin() : void
      {
         var video_mc:DisplayObject = null;
         var i:int = 0;
         var borderRect:Rectangle = null;
         var forceSkinAutoHide:Boolean = false;
         var minWidth:Number = NaN;
         var vidWidth:Number = NaN;
         var minHeight:Number = NaN;
         var vidHeight:Number = NaN;
         if(flvplayback_internal::layout_mc == null)
         {
            return;
         }
         if(flvplayback_internal::skinLoadDelayCount < 2)
         {
            return;
         }
         video_mc = flvplayback_internal::layout_mc["video_mc"];
         if(video_mc == null)
         {
            throw new Error("No layout_mc.video_mc");
         }
         flvplayback_internal::placeholderLeft = video_mc.x;
         flvplayback_internal::placeholderRight = video_mc.x + video_mc.width;
         flvplayback_internal::placeholderTop = video_mc.y;
         flvplayback_internal::placeholderBottom = video_mc.y + video_mc.height;
         flvplayback_internal::videoLeft = flvplayback_internal::_vc.x - flvplayback_internal::_vc.registrationX;
         flvplayback_internal::videoRight = flvplayback_internal::videoLeft + flvplayback_internal::_vc.width;
         flvplayback_internal::videoTop = flvplayback_internal::_vc.y - flvplayback_internal::_vc.registrationY;
         flvplayback_internal::videoBottom = flvplayback_internal::videoTop + flvplayback_internal::_vc.height;
         if(flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenTakeOver && flvplayback_internal::border_mc != null)
         {
            borderRect = flvplayback_internal::calcLayoutControl(flvplayback_internal::border_mc);
            forceSkinAutoHide = false;
            if(borderRect.width > 0 && borderRect.height > 0)
            {
               if(borderRect.x < 0)
               {
                  flvplayback_internal::placeholderLeft += flvplayback_internal::videoLeft - borderRect.x;
                  forceSkinAutoHide = true;
               }
               if(borderRect.x + borderRect.width > flvplayback_internal::_vc.registrationWidth)
               {
                  flvplayback_internal::placeholderRight += borderRect.x + borderRect.width - flvplayback_internal::videoRight;
                  forceSkinAutoHide = true;
               }
               if(borderRect.y < 0)
               {
                  flvplayback_internal::placeholderTop += flvplayback_internal::videoTop - borderRect.y;
                  forceSkinAutoHide = true;
               }
               if(borderRect.y + borderRect.height > flvplayback_internal::_vc.registrationHeight)
               {
                  flvplayback_internal::placeholderBottom += borderRect.y + borderRect.height - flvplayback_internal::videoBottom;
                  forceSkinAutoHide = true;
               }
               if(forceSkinAutoHide)
               {
                  flvplayback_internal::_skinAutoHide = true;
                  flvplayback_internal::setupSkinAutoHide(true);
               }
            }
         }
         try
         {
            if(!isNaN(flvplayback_internal::layout_mc["minWidth"]))
            {
               minWidth = Number(flvplayback_internal::layout_mc["minWidth"]);
               vidWidth = flvplayback_internal::videoRight - flvplayback_internal::videoLeft;
               if(minWidth > 0 && minWidth > vidWidth)
               {
                  flvplayback_internal::videoLeft -= (minWidth - vidWidth) / 2;
                  flvplayback_internal::videoRight = minWidth + flvplayback_internal::videoLeft;
               }
            }
         }
         catch(re1:ReferenceError)
         {
         }
         try
         {
            if(!isNaN(flvplayback_internal::layout_mc["minHeight"]))
            {
               minHeight = Number(flvplayback_internal::layout_mc["minHeight"]);
               vidHeight = flvplayback_internal::videoBottom - flvplayback_internal::videoTop;
               if(minHeight > 0 && minHeight > vidHeight)
               {
                  flvplayback_internal::videoTop -= (minHeight - vidHeight) / 2;
                  flvplayback_internal::videoBottom = minHeight + flvplayback_internal::videoTop;
               }
            }
         }
         catch(re2:ReferenceError)
         {
         }
         i = 0;
         while(i < customClips.length)
         {
            flvplayback_internal::layoutControl(customClips[i]);
            if(customClips[i] == flvplayback_internal::border_mc)
            {
               flvplayback_internal::bitmapCopyBorder();
            }
            i++;
         }
         i = 0;
         while(i < NUM_CONTROLS)
         {
            flvplayback_internal::layoutControl(flvplayback_internal::controls[i]);
            i++;
         }
      }
      
      public function set bufferingDelayInterval(param1:Number) : void
      {
         if(flvplayback_internal::_bufferingDelayTimer.delay == param1)
         {
            return;
         }
         flvplayback_internal::_bufferingDelayTimer.delay = param1;
      }
      
      flvplayback_internal function setEnabledAndVisibleForState(param1:int, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Sprite = null;
         var _loc6_:ControlData = null;
         var _loc7_:Boolean = false;
         var _loc8_:ControlData = null;
         var _loc9_:ControlData = null;
         var _loc10_:ControlData = null;
         var _loc11_:ControlData = null;
         _loc3_ = int(flvplayback_internal::_vc.activeVideoPlayerIndex);
         flvplayback_internal::_vc.activeVideoPlayerIndex = flvplayback_internal::_vc.visibleVideoPlayerIndex;
         _loc4_ = param2;
         if(_loc4_ == VideoState.BUFFERING && !flvplayback_internal::_bufferingOn)
         {
            _loc4_ = VideoState.PLAYING;
         }
         _loc5_ = flvplayback_internal::controls[param1];
         if(_loc5_ == null)
         {
            return;
         }
         _loc6_ = ctrlDataDict[_loc5_];
         if(_loc6_ == null)
         {
            return;
         }
         switch(param1)
         {
            case VOLUME_BAR:
            case VOLUME_BAR_HANDLE:
            case VOLUME_BAR_HIT:
               _loc6_.enabled = true;
               break;
            case FULL_SCREEN_ON_BUTTON:
               _loc6_.enabled = !flvplayback_internal::_fullScreen;
               if(flvplayback_internal::controls[FULL_SCREEN_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
               }
               break;
            case FULL_SCREEN_OFF_BUTTON:
               _loc6_.enabled = flvplayback_internal::_fullScreen;
               if(flvplayback_internal::controls[FULL_SCREEN_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
               }
               break;
            case MUTE_ON_BUTTON:
               _loc6_.enabled = !flvplayback_internal::_isMuted;
               if(flvplayback_internal::controls[MUTE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
               }
               break;
            case MUTE_OFF_BUTTON:
               _loc6_.enabled = flvplayback_internal::_isMuted;
               if(flvplayback_internal::controls[MUTE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
               }
               break;
            default:
               switch(_loc4_)
               {
                  case VideoState.LOADING:
                  case VideoState.CONNECTION_ERROR:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.DISCONNECTED:
                     _loc6_.enabled = flvplayback_internal::_vc.source != null && flvplayback_internal::_vc.source != "";
                     break;
                  case VideoState.SEEKING:
                     break;
                  default:
                     _loc6_.enabled = true;
               }
         }
         switch(param1)
         {
            case SEEK_BAR:
               switch(_loc4_)
               {
                  case VideoState.STOPPED:
                  case VideoState.PLAYING:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                  case VideoState.SEEKING:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !flvplayback_internal::_bufferingBarHides || flvplayback_internal::controls[BUFFERING_BAR] == undefined;
                     break;
                  default:
                     _loc6_.enabled = false;
               }
               if(_loc6_.enabled)
               {
                  _loc6_.enabled = !isNaN(flvplayback_internal::_vc.totalTime);
               }
               if(_loc6_.handle_mc != null)
               {
                  _loc8_ = ctrlDataDict[_loc6_.handle_mc];
                  _loc8_.enabled = _loc6_.enabled;
                  _loc6_.handle_mc.visible = _loc8_.enabled;
               }
               if(_loc6_.hit_mc != null)
               {
                  _loc9_ = ctrlDataDict[_loc6_.hit_mc];
                  _loc9_.enabled = _loc6_.enabled;
                  _loc6_.hit_mc.visible = _loc9_.enabled;
               }
               _loc7_ = !flvplayback_internal::_bufferingBarHides || _loc6_.enabled || flvplayback_internal::controls[BUFFERING_BAR] == undefined || !flvplayback_internal::controls[BUFFERING_BAR].visible;
               _loc5_.visible = _loc7_;
               if(_loc6_.progress_mc != null)
               {
                  _loc6_.progress_mc.visible = _loc7_;
                  _loc10_ = ctrlDataDict[_loc6_.progress_mc];
                  if(_loc10_.fill_mc != null)
                  {
                     _loc10_.fill_mc.visible = _loc7_;
                  }
               }
               if(_loc6_.fullness_mc != null)
               {
                  _loc6_.fullness_mc.visible = _loc7_;
                  _loc11_ = ctrlDataDict[_loc6_.fullness_mc];
                  if(_loc11_.fill_mc != null)
                  {
                     _loc11_.fill_mc.visible = _loc7_;
                  }
               }
               break;
            case BUFFERING_BAR:
               switch(_loc4_)
               {
                  case VideoState.STOPPED:
                  case VideoState.PLAYING:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                  case VideoState.SEEKING:
                     _loc6_.enabled = false;
                     break;
                  default:
                     _loc6_.enabled = true;
               }
               _loc5_.visible = _loc6_.enabled;
               if(_loc6_.fill_mc != null)
               {
                  _loc6_.fill_mc.visible = _loc6_.enabled;
               }
               break;
            case PAUSE_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.DISCONNECTED:
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.PLAYING:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !flvplayback_internal::_bufferingBarHides || flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
               if(flvplayback_internal::controls[PLAY_PAUSE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
               }
               break;
            case PLAY_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.PLAYING:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !flvplayback_internal::_bufferingBarHides || flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
               if(flvplayback_internal::controls[PLAY_PAUSE_BUTTON] != undefined)
               {
                  _loc5_.visible = !flvplayback_internal::controls[PAUSE_BUTTON].visible;
               }
               break;
            case STOP_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.DISCONNECTED:
                  case VideoState.STOPPED:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.PAUSED:
                  case VideoState.PLAYING:
                  case VideoState.BUFFERING:
                     _loc6_.enabled = true;
               }
               break;
            case BACK_BUTTON:
            case FORWARD_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !flvplayback_internal::_bufferingBarHides || flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
         }
         _loc5_.mouseEnabled = _loc6_.enabled;
         flvplayback_internal::_vc.activeVideoPlayerIndex = _loc3_;
      }
      
      public function set fullScreenTakeOver(param1:Boolean) : void
      {
         var v:Boolean = param1;
         if(flvplayback_internal::_fullScreenTakeOver != v)
         {
            flvplayback_internal::_fullScreenTakeOver = v;
            if(flvplayback_internal::_fullScreenTakeOver)
            {
               flvplayback_internal::enterFullScreenTakeOver();
            }
            else
            {
               if(flvplayback_internal::_vc.stage != null && flvplayback_internal::_fullScreen && flvplayback_internal::_fullScreenAccel)
               {
                  try
                  {
                     flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
                  }
                  catch(se:SecurityError)
                  {
                  }
               }
               flvplayback_internal::exitFullScreenTakeOver();
            }
         }
      }
      
      flvplayback_internal function enterFullScreenTakeOver() : void
      {
         var i:int = 0;
         var fullScreenBG:Sprite = null;
         var vp:VideoPlayer = null;
         if(!flvplayback_internal::_fullScreen || flvplayback_internal::cacheFLVPlaybackParent != null)
         {
            return;
         }
         flvplayback_internal::_vc.removeEventListener(LayoutEvent.LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.removeEventListener(AutoLayoutEvent.AUTO_LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.removeEventListener(Event.ADDED_TO_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
         try
         {
            flvplayback_internal::cacheFLVPlaybackScaleMode = new Array();
            flvplayback_internal::cacheFLVPlaybackAlign = new Array();
            i = 0;
            while(i < flvplayback_internal::_vc.flvplayback_internal::videoPlayers.length)
            {
               vp = flvplayback_internal::_vc.flvplayback_internal::videoPlayers[i] as VideoPlayer;
               if(vp != null)
               {
                  flvplayback_internal::cacheFLVPlaybackScaleMode[i] = vp.scaleMode;
                  flvplayback_internal::cacheFLVPlaybackAlign[i] = vp.align;
               }
               i++;
            }
            flvplayback_internal::cacheFLVPlaybackParent = flvplayback_internal::_vc.parent;
            flvplayback_internal::cacheFLVPlaybackIndex = flvplayback_internal::_vc.parent.getChildIndex(flvplayback_internal::_vc);
            flvplayback_internal::cacheFLVPlaybackLocation = new Rectangle(flvplayback_internal::_vc.registrationX,flvplayback_internal::_vc.registrationY,flvplayback_internal::_vc.registrationWidth,flvplayback_internal::_vc.registrationHeight);
            if(!flvplayback_internal::_fullScreenAccel)
            {
               flvplayback_internal::cacheStageAlign = flvplayback_internal::_vc.stage.align;
               flvplayback_internal::cacheStageScaleMode = flvplayback_internal::_vc.stage.scaleMode;
               flvplayback_internal::_vc.stage.align = StageAlign.TOP_LEFT;
               flvplayback_internal::_vc.stage.scaleMode = StageScaleMode.NO_SCALE;
            }
            flvplayback_internal::_vc.align = VideoAlign.CENTER;
            flvplayback_internal::_vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
            flvplayback_internal::_vc.registrationX = 0;
            flvplayback_internal::_vc.registrationY = 0;
            flvplayback_internal::_vc.setSize(flvplayback_internal::_vc.stage.stageWidth,flvplayback_internal::_vc.stage.stageHeight);
            if(flvplayback_internal::_vc.stage != flvplayback_internal::_vc.parent)
            {
               flvplayback_internal::_vc.stage.addChild(flvplayback_internal::_vc);
            }
            else
            {
               flvplayback_internal::_vc.stage.setChildIndex(flvplayback_internal::_vc,flvplayback_internal::_vc.stage.numChildren - 1);
            }
            fullScreenBG = Sprite(flvplayback_internal::_vc.getChildByName("fullScreenBG"));
            if(fullScreenBG == null)
            {
               fullScreenBG = new Sprite();
               fullScreenBG.name = "fullScreenBG";
               flvplayback_internal::_vc.addChildAt(fullScreenBG,0);
            }
            else
            {
               flvplayback_internal::_vc.setChildIndex(fullScreenBG,0);
            }
            fullScreenBG.graphics.beginFill(flvplayback_internal::_fullScreenBgColor);
            fullScreenBG.graphics.drawRect(0,0,flvplayback_internal::_vc.stage.stageWidth,flvplayback_internal::_vc.stage.stageHeight);
            flvplayback_internal::layoutSkin();
            flvplayback_internal::setupSkinAutoHide(false);
         }
         catch(err:Error)
         {
            flvplayback_internal::cacheFLVPlaybackParent = null;
         }
         flvplayback_internal::_vc.addEventListener(LayoutEvent.LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,flvplayback_internal::handleLayoutEvent);
         flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,flvplayback_internal::handleEvent);
         flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,flvplayback_internal::handleFullScreenEvent);
      }
      
      public function set seekBarScrubTolerance(param1:Number) : void
      {
         flvplayback_internal::_seekBarScrubTolerance = param1;
      }
      
      flvplayback_internal function cleanupHandle(param1:Object) : void
      {
         var e:Event = null;
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var ctrlOrEvent:Object = param1;
         try
         {
            if(ctrlOrEvent is Event)
            {
               e = Event(ctrlOrEvent);
            }
            ctrl = e == null ? Sprite(ctrlOrEvent) : Sprite(e.currentTarget);
            ctrlData = ctrlDataDict[ctrl];
            if(ctrlData == null || e == null)
            {
               ctrl.removeEventListener(Event.REMOVED_FROM_STAGE,flvplayback_internal::cleanupHandle,false);
               if(ctrlData == null)
               {
                  return;
               }
            }
            ctrl.removeEventListener(Event.ENTER_FRAME,flvplayback_internal::finishAddBarControl);
            if(ctrlData.handle_mc != null)
            {
               if(ctrlData.handle_mc.parent != null)
               {
                  ctrlData.handle_mc.parent.removeChild(ctrlData.handle_mc);
               }
               delete ctrlDataDict[ctrlData.handle_mc];
               ctrlData.handle_mc = null;
            }
            if(ctrlData.hit_mc != null)
            {
               if(ctrlData.hit_mc.parent != null)
               {
                  ctrlData.hit_mc.parent.removeChild(ctrlData.hit_mc);
               }
               delete ctrlDataDict[ctrlData.hit_mc];
               ctrlData.hit_mc = null;
            }
         }
         catch(err:Error)
         {
         }
      }
   }
}

