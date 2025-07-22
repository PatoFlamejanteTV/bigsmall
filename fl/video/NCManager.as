package fl.video
{
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.Timer;
   
   use namespace flvplayback_internal;
   
   public class NCManager implements INCManager
   {
      
      public static const VERSION:String = "2.1.0.14";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal var _serverName:String;
      
      flvplayback_internal var _tryNCTimer:Timer;
      
      flvplayback_internal var _autoSenseBW:Boolean;
      
      flvplayback_internal var _fpadZone:Number;
      
      flvplayback_internal var _appName:String;
      
      public const DEFAULT_TIMEOUT:uint = 60000;
      
      flvplayback_internal var _ncConnected:Boolean;
      
      flvplayback_internal var _fpadMgr:FPADManager;
      
      flvplayback_internal var _bitrate:Number;
      
      flvplayback_internal var _timeoutTimer:Timer;
      
      flvplayback_internal var _wrappedURL:String;
      
      flvplayback_internal var _payload:Number;
      
      flvplayback_internal var _proxyType:String;
      
      flvplayback_internal var _nc:NetConnection;
      
      flvplayback_internal var _streamLength:Number;
      
      flvplayback_internal var _connTypeCounter:uint;
      
      flvplayback_internal var _streamWidth:int;
      
      flvplayback_internal var _ncUri:String;
      
      flvplayback_internal var _contentPath:String;
      
      flvplayback_internal var _smilMgr:SMILManager;
      
      flvplayback_internal var _streamHeight:int;
      
      flvplayback_internal var _isRTMP:Boolean;
      
      flvplayback_internal var _tryNC:Array;
      
      flvplayback_internal var _owner:VideoPlayer;
      
      flvplayback_internal var _streams:Array;
      
      flvplayback_internal var _portNumber:String;
      
      flvplayback_internal var _streamName:String;
      
      flvplayback_internal var _objectEncoding:uint;
      
      public var fallbackServerName:String;
      
      flvplayback_internal var _protocol:String;
      
      public function NCManager()
      {
         super();
         flvplayback_internal::_fpadZone = NaN;
         flvplayback_internal::_objectEncoding = ObjectEncoding.AMF0;
         flvplayback_internal::_proxyType = "best";
         flvplayback_internal::_timeoutTimer = new Timer(DEFAULT_TIMEOUT);
         flvplayback_internal::_timeoutTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::_onFMSConnectTimeOut);
         flvplayback_internal::_tryNCTimer = new Timer(1500,1);
         flvplayback_internal::_tryNCTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::nextConnect);
         flvplayback_internal::initNCInfo();
         flvplayback_internal::initOtherInfo();
         flvplayback_internal::_nc = null;
         flvplayback_internal::_ncConnected = false;
      }
      
      flvplayback_internal static function stripFrontAndBackWhiteSpace(param1:String) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = uint(param1.length);
         _loc4_ = 0;
         _loc5_ = int(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            switch(param1.charCodeAt(_loc2_))
            {
               case 9:
               case 10:
               case 13:
               case 32:
                  break;
               default:
                  _loc4_ = int(_loc2_);
            }
            _loc2_++;
         }
         _loc2_ = _loc3_;
         while(_loc2_ >= 0)
         {
            switch(param1.charCodeAt(_loc2_))
            {
               case 9:
               case 10:
               case 13:
               case 32:
                  break;
               default:
                  _loc5_ = _loc2_ + 1;
            }
            _loc2_--;
         }
         if(_loc5_ <= _loc4_)
         {
            return "";
         }
         return param1.slice(_loc4_,_loc5_);
      }
      
      flvplayback_internal function initNCInfo() : void
      {
         flvplayback_internal::_isRTMP = false;
         flvplayback_internal::_serverName = null;
         flvplayback_internal::_wrappedURL = null;
         flvplayback_internal::_portNumber = null;
         flvplayback_internal::_appName = null;
      }
      
      flvplayback_internal function cleanConns() : void
      {
         var _loc1_:uint = 0;
         flvplayback_internal::_tryNCTimer.reset();
         if(flvplayback_internal::_tryNC != null)
         {
            _loc1_ = 0;
            while(_loc1_ < flvplayback_internal::_tryNC.length)
            {
               if(flvplayback_internal::_tryNC[_loc1_] != null)
               {
                  flvplayback_internal::_tryNC[_loc1_].removeEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::connectOnStatus);
                  if(flvplayback_internal::_tryNC[_loc1_].client.pending)
                  {
                     flvplayback_internal::_tryNC[_loc1_].addEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::disconnectOnStatus);
                  }
                  else
                  {
                     flvplayback_internal::_tryNC[_loc1_].close();
                  }
               }
               flvplayback_internal::_tryNC[_loc1_] = null;
               _loc1_++;
            }
            flvplayback_internal::_tryNC = null;
         }
      }
      
      public function get streamWidth() : int
      {
         return flvplayback_internal::_streamWidth;
      }
      
      public function connectToURL(param1:String) : Boolean
      {
         var parseResults:ParseResults = null;
         var canReuse:Boolean = false;
         var name:String = null;
         var url:String = param1;
         flvplayback_internal::initOtherInfo();
         flvplayback_internal::_contentPath = url;
         if(flvplayback_internal::_contentPath == null || flvplayback_internal::_contentPath == "")
         {
            throw new VideoError(VideoError.INVALID_SOURCE);
         }
         parseResults = flvplayback_internal::parseURL(flvplayback_internal::_contentPath);
         if(parseResults.streamName == null || parseResults.streamName == "")
         {
            throw new VideoError(VideoError.INVALID_SOURCE,url);
         }
         if(parseResults.isRTMP)
         {
            canReuse = flvplayback_internal::canReuseOldConnection(parseResults);
            flvplayback_internal::_isRTMP = true;
            flvplayback_internal::_protocol = parseResults.protocol;
            flvplayback_internal::_streamName = parseResults.streamName;
            flvplayback_internal::_serverName = parseResults.serverName;
            flvplayback_internal::_wrappedURL = parseResults.wrappedURL;
            flvplayback_internal::_portNumber = parseResults.portNumber;
            flvplayback_internal::_appName = parseResults.appName;
            if(flvplayback_internal::_appName == null || flvplayback_internal::_appName == "" || flvplayback_internal::_streamName == null || flvplayback_internal::_streamName == "")
            {
               throw new VideoError(VideoError.INVALID_SOURCE,url);
            }
            flvplayback_internal::_autoSenseBW = flvplayback_internal::_streamName.indexOf(",") >= 0;
            return canReuse || flvplayback_internal::connectRTMP();
         }
         name = parseResults.streamName;
         if(name.indexOf("?") < 0 && (name.length < 4 || name.slice(-4).toLowerCase() != ".txt") && (name.length < 4 || name.slice(-4).toLowerCase() != ".xml") && (name.length < 5 || name.slice(-5).toLowerCase() != ".smil"))
         {
            canReuse = flvplayback_internal::canReuseOldConnection(parseResults);
            flvplayback_internal::_isRTMP = false;
            flvplayback_internal::_streamName = name;
            return canReuse || flvplayback_internal::connectHTTP();
         }
         if(name.indexOf("/fms/fpad") >= 0)
         {
            try
            {
               return flvplayback_internal::connectFPAD(name);
            }
            catch(err:Error)
            {
            }
         }
         flvplayback_internal::_smilMgr = new SMILManager(this);
         return flvplayback_internal::_smilMgr.flvplayback_internal::connectXML(name);
      }
      
      public function get streamName() : String
      {
         return flvplayback_internal::_streamName;
      }
      
      flvplayback_internal function reconnectOnStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetConnection.Connect.Failed" || param1.info.code == "NetConnection.Connect.Rejected")
         {
            flvplayback_internal::_nc = null;
            flvplayback_internal::_ncConnected = false;
            flvplayback_internal::_owner.ncReconnected();
         }
      }
      
      public function get videoPlayer() : VideoPlayer
      {
         return flvplayback_internal::_owner;
      }
      
      flvplayback_internal function getStreamLengthResult(param1:Number) : void
      {
         if(param1 > 0)
         {
            flvplayback_internal::_streamLength = param1;
         }
         flvplayback_internal::_owner.ncConnected();
      }
      
      flvplayback_internal function canReuseOldConnection(param1:ParseResults) : Boolean
      {
         if(flvplayback_internal::_nc == null || !flvplayback_internal::_ncConnected)
         {
            return false;
         }
         if(!param1.isRTMP)
         {
            if(!flvplayback_internal::_isRTMP)
            {
               return true;
            }
            flvplayback_internal::_owner.close();
            flvplayback_internal::_nc = null;
            flvplayback_internal::_ncConnected = false;
            flvplayback_internal::initNCInfo();
            return false;
         }
         if(flvplayback_internal::_isRTMP)
         {
            if(param1.serverName == flvplayback_internal::_serverName && param1.appName == flvplayback_internal::_appName && param1.protocol == flvplayback_internal::_protocol && param1.portNumber == flvplayback_internal::_portNumber && param1.wrappedURL == flvplayback_internal::_wrappedURL)
            {
               return true;
            }
            flvplayback_internal::_owner.close();
            flvplayback_internal::_nc = null;
            flvplayback_internal::_ncConnected = false;
         }
         flvplayback_internal::initNCInfo();
         return false;
      }
      
      public function getProperty(param1:String) : *
      {
         switch(param1)
         {
            case "fallbackServerName":
               return fallbackServerName;
            case "fpadZone":
               return flvplayback_internal::_fpadZone;
            case "objectEncoding":
               return flvplayback_internal::_objectEncoding;
            case "proxyType":
               return flvplayback_internal::_proxyType;
            default:
               throw new VideoError(VideoError.UNSUPPORTED_PROPERTY,param1);
         }
      }
      
      flvplayback_internal function connectRTMP() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         flvplayback_internal::_timeoutTimer.stop();
         flvplayback_internal::_timeoutTimer.start();
         flvplayback_internal::_tryNC = new Array();
         _loc1_ = flvplayback_internal::_protocol == "rtmp:/" || flvplayback_internal::_protocol == "rtmpe:/" ? 2 : 1;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            flvplayback_internal::_tryNC[_loc2_] = new NetConnection();
            flvplayback_internal::_tryNC[_loc2_].objectEncoding = flvplayback_internal::_objectEncoding;
            flvplayback_internal::_tryNC[_loc2_].proxyType = flvplayback_internal::_proxyType;
            if(!isNaN(flvplayback_internal::_fpadZone))
            {
               flvplayback_internal::_tryNC[_loc2_].fpadZone = flvplayback_internal::_fpadZone;
            }
            flvplayback_internal::_tryNC[_loc2_].client = new ConnectClient(this,flvplayback_internal::_tryNC[_loc2_],_loc2_);
            flvplayback_internal::_tryNC[_loc2_].addEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::connectOnStatus);
            _loc2_++;
         }
         flvplayback_internal::nextConnect();
         return false;
      }
      
      public function reconnect() : void
      {
         if(!flvplayback_internal::_isRTMP)
         {
            throw new Error("Cannot call reconnect on an http connection");
         }
         flvplayback_internal::_nc.client = new ReconnectClient(this);
         flvplayback_internal::_nc.addEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::reconnectOnStatus);
         flvplayback_internal::_nc.connect(flvplayback_internal::_ncUri,false);
      }
      
      public function helperDone(param1:Object, param2:Boolean) : void
      {
         var _loc3_:ParseResults = null;
         var _loc4_:* = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         if(!param2)
         {
            flvplayback_internal::_nc = null;
            flvplayback_internal::_ncConnected = false;
            flvplayback_internal::_owner.ncConnected();
            flvplayback_internal::_smilMgr = null;
            flvplayback_internal::_fpadMgr = null;
            return;
         }
         _loc5_ = false;
         if(param1 == flvplayback_internal::_fpadMgr)
         {
            _loc4_ = flvplayback_internal::_fpadMgr.flvplayback_internal::rtmpURL;
            flvplayback_internal::_fpadMgr = null;
            _loc3_ = flvplayback_internal::parseURL(_loc4_);
            flvplayback_internal::_isRTMP = _loc3_.isRTMP;
            flvplayback_internal::_protocol = _loc3_.protocol;
            flvplayback_internal::_serverName = _loc3_.serverName;
            flvplayback_internal::_portNumber = _loc3_.portNumber;
            flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
            flvplayback_internal::_appName = _loc3_.appName;
            flvplayback_internal::_streamName = _loc3_.streamName;
            _loc7_ = flvplayback_internal::_fpadZone;
            flvplayback_internal::_fpadZone = NaN;
            flvplayback_internal::connectRTMP();
            flvplayback_internal::_fpadZone = _loc7_;
            return;
         }
         if(param1 != flvplayback_internal::_smilMgr)
         {
            return;
         }
         flvplayback_internal::_streamWidth = flvplayback_internal::_smilMgr.flvplayback_internal::width;
         flvplayback_internal::_streamHeight = flvplayback_internal::_smilMgr.flvplayback_internal::height;
         _loc4_ = flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr[0];
         if(_loc4_ != null && _loc4_ != "")
         {
            if(_loc4_.charAt(_loc4_.length - 1) != "/")
            {
               _loc4_ += "/";
            }
            _loc3_ = flvplayback_internal::parseURL(_loc4_);
            flvplayback_internal::_isRTMP = _loc3_.isRTMP;
            _loc5_ = true;
            flvplayback_internal::_streamName = _loc3_.streamName;
            if(flvplayback_internal::_isRTMP)
            {
               flvplayback_internal::_protocol = _loc3_.protocol;
               flvplayback_internal::_serverName = _loc3_.serverName;
               flvplayback_internal::_portNumber = _loc3_.portNumber;
               flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
               flvplayback_internal::_appName = _loc3_.appName;
               if(flvplayback_internal::_appName == null || flvplayback_internal::_appName == "")
               {
                  flvplayback_internal::_smilMgr = null;
                  throw new VideoError(VideoError.INVALID_XML,"Base RTMP URL must include application name: " + _loc4_);
               }
               if(flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr.length > 1)
               {
                  _loc3_ = flvplayback_internal::parseURL(flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr[1]);
                  if(_loc3_.serverName != null)
                  {
                     fallbackServerName = _loc3_.serverName;
                  }
               }
            }
         }
         flvplayback_internal::_streams = flvplayback_internal::_smilMgr.flvplayback_internal::videoTags;
         flvplayback_internal::_smilMgr = null;
         _loc6_ = 0;
         while(_loc6_ < flvplayback_internal::_streams.length)
         {
            _loc4_ = flvplayback_internal::_streams[_loc6_].src;
            _loc3_ = flvplayback_internal::parseURL(_loc4_);
            if(!_loc5_)
            {
               flvplayback_internal::_isRTMP = _loc3_.isRTMP;
               _loc5_ = true;
               if(flvplayback_internal::_isRTMP)
               {
                  flvplayback_internal::_protocol = _loc3_.protocol;
                  if(flvplayback_internal::_streams.length > 1)
                  {
                     throw new VideoError(VideoError.INVALID_XML,"Cannot switch between multiple absolute RTMP URLs, must use meta tag base attribute.");
                  }
                  flvplayback_internal::_serverName = _loc3_.serverName;
                  flvplayback_internal::_portNumber = _loc3_.portNumber;
                  flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
                  flvplayback_internal::_appName = _loc3_.appName;
                  if(flvplayback_internal::_appName == null || flvplayback_internal::_appName == "")
                  {
                     throw new VideoError(VideoError.INVALID_XML,"Base RTMP URL must include application name: " + _loc4_);
                  }
               }
               else if(_loc3_.streamName.indexOf("/fms/fpad") >= 0 && flvplayback_internal::_streams.length > 1)
               {
                  throw new VideoError(VideoError.INVALID_XML,"Cannot switch between multiple absolute fpad URLs, must use meta tag base attribute.");
               }
            }
            else if(flvplayback_internal::_streamName != null && flvplayback_internal::_streamName != "" && !_loc3_.isRelative && flvplayback_internal::_streams.length > 1)
            {
               throw new VideoError(VideoError.INVALID_XML,"When using meta tag base attribute, cannot use absolute URLs for video or ref tag src attributes.");
            }
            flvplayback_internal::_streams[_loc6_].parseResults = _loc3_;
            _loc6_++;
         }
         flvplayback_internal::_autoSenseBW = flvplayback_internal::_streams.length > 1;
         if(!flvplayback_internal::_autoSenseBW)
         {
            if(flvplayback_internal::_streamName != null)
            {
               flvplayback_internal::_streamName += flvplayback_internal::_streams[0].parseResults.streamName;
            }
            else
            {
               flvplayback_internal::_streamName = flvplayback_internal::_streams[0].parseResults.streamName;
            }
            if(flvplayback_internal::_isRTMP && flvplayback_internal::_streamName.substr(-4).toLowerCase() == ".flv")
            {
               flvplayback_internal::_streamName = flvplayback_internal::_streamName.substr(0,flvplayback_internal::_streamName.length - 4);
            }
            flvplayback_internal::_streamLength = flvplayback_internal::_streams[0].dur;
         }
         if(flvplayback_internal::_isRTMP)
         {
            flvplayback_internal::connectRTMP();
         }
         else if(flvplayback_internal::_streamName != null && flvplayback_internal::_streamName.indexOf("/fms/fpad") >= 0)
         {
            flvplayback_internal::connectFPAD(flvplayback_internal::_streamName);
         }
         else
         {
            if(flvplayback_internal::_autoSenseBW)
            {
               flvplayback_internal::bitrateMatch();
            }
            flvplayback_internal::connectHTTP();
            flvplayback_internal::_owner.ncConnected();
         }
      }
      
      public function get netConnection() : NetConnection
      {
         return flvplayback_internal::_nc;
      }
      
      public function get bitrate() : Number
      {
         return flvplayback_internal::_bitrate;
      }
      
      public function setProperty(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case "fallbackServerName":
               fallbackServerName = String(param2);
               break;
            case "fpadZone":
               flvplayback_internal::_fpadZone = Number(param2);
               break;
            case "objectEncoding":
               flvplayback_internal::_objectEncoding = uint(param2);
               break;
            case "proxyType":
               flvplayback_internal::_proxyType = String(param2);
               break;
            default:
               throw new VideoError(VideoError.UNSUPPORTED_PROPERTY,param1);
         }
      }
      
      public function get timeout() : uint
      {
         return flvplayback_internal::_timeoutTimer.delay;
      }
      
      public function set videoPlayer(param1:VideoPlayer) : void
      {
         flvplayback_internal::_owner = param1;
      }
      
      flvplayback_internal function bitrateMatch() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = flvplayback_internal::_bitrate;
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         _loc2_ = flvplayback_internal::_streams.length;
         _loc3_ = 0;
         while(_loc3_ < flvplayback_internal::_streams.length)
         {
            if(isNaN(flvplayback_internal::_streams[_loc3_].bitrate) || _loc1_ >= flvplayback_internal::_streams[_loc3_].bitrate)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == flvplayback_internal::_streams.length)
         {
            throw new VideoError(VideoError.NO_BITRATE_MATCH);
         }
         if(flvplayback_internal::_streamName != null)
         {
            flvplayback_internal::_streamName += flvplayback_internal::_streams[_loc2_].src;
         }
         else
         {
            flvplayback_internal::_streamName = flvplayback_internal::_streams[_loc2_].src;
         }
         if(flvplayback_internal::_isRTMP && flvplayback_internal::_streamName.substr(-4).toLowerCase() == ".flv")
         {
            flvplayback_internal::_streamName = flvplayback_internal::_streamName.substr(0,flvplayback_internal::_streamName.length - 4);
         }
         flvplayback_internal::_streamLength = flvplayback_internal::_streams[_loc2_].dur;
      }
      
      flvplayback_internal function disconnectOnStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetConnection.Connect.Success")
         {
            param1.target.removeEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::disconnectOnStatus);
            param1.target.close();
         }
      }
      
      flvplayback_internal function nextConnect(param1:TimerEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(flvplayback_internal::_connTypeCounter == 0)
         {
            _loc2_ = flvplayback_internal::_protocol;
            _loc3_ = flvplayback_internal::_portNumber;
         }
         else
         {
            _loc3_ = null;
            if(flvplayback_internal::_protocol == "rtmp:/")
            {
               _loc2_ = "rtmpt:/";
            }
            else
            {
               if(flvplayback_internal::_protocol != "rtmpe:/")
               {
                  flvplayback_internal::_tryNC.pop();
                  return;
               }
               _loc2_ = "rtmpte:/";
            }
         }
         _loc4_ = _loc2_ + (flvplayback_internal::_serverName == null ? "" : "/" + flvplayback_internal::_serverName + (_loc3_ == null ? "" : ":" + _loc3_) + "/") + (flvplayback_internal::_wrappedURL == null ? "" : flvplayback_internal::_wrappedURL + "/") + flvplayback_internal::_appName;
         flvplayback_internal::_tryNC[flvplayback_internal::_connTypeCounter].client.pending = true;
         flvplayback_internal::_tryNC[flvplayback_internal::_connTypeCounter].connect(_loc4_,flvplayback_internal::_autoSenseBW);
         if(flvplayback_internal::_connTypeCounter < flvplayback_internal::_tryNC.length - 1)
         {
            ++flvplayback_internal::_connTypeCounter;
            flvplayback_internal::_tryNCTimer.reset();
            flvplayback_internal::_tryNCTimer.start();
         }
      }
      
      flvplayback_internal function connectFPAD(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:ParseResults = null;
         _loc2_ = /^(.+)(\?|\&)(uri=)([^&]+)(\&.*)?$/.exec(param1);
         if(_loc2_ == null)
         {
            throw new VideoError(VideoError.INVALID_SOURCE,"fpad url must include uri parameter: " + param1);
         }
         _loc3_ = _loc2_[1] + _loc2_[2];
         _loc4_ = _loc2_[4];
         _loc5_ = _loc2_[5] == undefined ? "" : _loc2_[5];
         _loc6_ = flvplayback_internal::parseURL(_loc4_);
         if(!_loc6_.isRTMP)
         {
            throw new VideoError(VideoError.INVALID_SOURCE,"fpad url uri parameter must be rtmp url: " + param1);
         }
         flvplayback_internal::_fpadMgr = new FPADManager(this);
         return flvplayback_internal::_fpadMgr.flvplayback_internal::connectXML(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      flvplayback_internal function connectHTTP() : Boolean
      {
         flvplayback_internal::_nc = new NetConnection();
         flvplayback_internal::_nc.connect(null);
         flvplayback_internal::_ncConnected = true;
         return true;
      }
      
      public function get isRTMP() : Boolean
      {
         return flvplayback_internal::_isRTMP;
      }
      
      public function get streamLength() : Number
      {
         return flvplayback_internal::_streamLength;
      }
      
      public function connectAgain() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = int(flvplayback_internal::_appName.indexOf("/"));
         if(_loc1_ < 0)
         {
            _loc1_ = int(flvplayback_internal::_streamName.indexOf("/"));
            if(_loc1_ >= 0)
            {
               flvplayback_internal::_appName += "/";
               flvplayback_internal::_appName += flvplayback_internal::_streamName.slice(0,_loc1_);
               flvplayback_internal::_streamName = flvplayback_internal::_streamName.slice(_loc1_ + 1);
            }
            return false;
         }
         _loc2_ = flvplayback_internal::_appName.slice(_loc1_ + 1);
         _loc2_ += "/";
         _loc2_ += flvplayback_internal::_streamName;
         flvplayback_internal::_streamName = _loc2_;
         flvplayback_internal::_appName = flvplayback_internal::_appName.slice(0,_loc1_);
         close();
         flvplayback_internal::_payload = 0;
         flvplayback_internal::_connTypeCounter = 0;
         flvplayback_internal::cleanConns();
         flvplayback_internal::connectRTMP();
         return true;
      }
      
      flvplayback_internal function parseURL(param1:String) : ParseResults
      {
         var _loc2_:ParseResults = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:ParseResults = null;
         _loc2_ = new ParseResults();
         _loc3_ = 0;
         _loc4_ = int(param1.indexOf(":/",_loc3_));
         if(_loc4_ >= 0)
         {
            _loc4_ += 2;
            _loc2_.protocol = param1.slice(_loc3_,_loc4_).toLowerCase();
            _loc2_.isRelative = false;
         }
         else
         {
            _loc2_.isRelative = true;
         }
         if(_loc2_.protocol != null && (_loc2_.protocol == "rtmp:/" || _loc2_.protocol == "rtmpt:/" || _loc2_.protocol == "rtmps:/" || _loc2_.protocol == "rtmpe:/" || _loc2_.protocol == "rtmpte:/"))
         {
            _loc2_.isRTMP = true;
            _loc3_ = _loc4_;
            if(param1.charAt(_loc3_) == "/")
            {
               _loc3_++;
               _loc5_ = int(param1.indexOf(":",_loc3_));
               _loc6_ = int(param1.indexOf("/",_loc3_));
               if(_loc6_ < 0)
               {
                  if(_loc5_ < 0)
                  {
                     _loc2_.serverName = param1.slice(_loc3_);
                  }
                  else
                  {
                     _loc4_ = _loc5_;
                     _loc2_.portNumber = param1.slice(_loc3_,_loc4_);
                     _loc3_ = _loc4_ + 1;
                     _loc2_.serverName = param1.slice(_loc3_);
                  }
                  return _loc2_;
               }
               if(_loc5_ >= 0 && _loc5_ < _loc6_)
               {
                  _loc4_ = _loc5_;
                  _loc2_.serverName = param1.slice(_loc3_,_loc4_);
                  _loc3_ = _loc4_ + 1;
                  _loc4_ = _loc6_;
                  _loc2_.portNumber = param1.slice(_loc3_,_loc4_);
               }
               else
               {
                  _loc4_ = _loc6_;
                  _loc2_.serverName = param1.slice(_loc3_,_loc4_);
               }
               _loc3_ = _loc4_ + 1;
            }
            if(param1.charAt(_loc3_) == "?")
            {
               _loc7_ = param1.slice(_loc3_ + 1);
               _loc8_ = flvplayback_internal::parseURL(_loc7_);
               if(_loc8_.protocol == null || !_loc8_.isRTMP)
               {
                  throw new VideoError(VideoError.INVALID_SOURCE,param1);
               }
               _loc2_.wrappedURL = "?";
               _loc2_.wrappedURL += _loc8_.protocol;
               if(_loc8_.serverName != null)
               {
                  _loc2_.wrappedURL += "/";
                  _loc2_.wrappedURL += _loc8_.serverName;
               }
               if(_loc8_.portNumber != null)
               {
                  _loc2_.wrappedURL += ":" + _loc8_.portNumber;
               }
               if(_loc8_.wrappedURL != null)
               {
                  _loc2_.wrappedURL += "/";
                  _loc2_.wrappedURL += _loc8_.wrappedURL;
               }
               _loc2_.appName = _loc8_.appName;
               _loc2_.streamName = _loc8_.streamName;
               return _loc2_;
            }
            _loc4_ = int(param1.indexOf("/",_loc3_));
            if(_loc4_ < 0)
            {
               _loc2_.appName = param1.slice(_loc3_);
               return _loc2_;
            }
            _loc2_.appName = param1.slice(_loc3_,_loc4_);
            _loc3_ = _loc4_ + 1;
            _loc4_ = int(param1.indexOf("/",_loc3_));
            if(_loc4_ < 0)
            {
               _loc2_.streamName = param1.slice(_loc3_);
               if(_loc2_.streamName.slice(-4).toLowerCase() == ".flv")
               {
                  _loc2_.streamName = _loc2_.streamName.slice(0,-4);
               }
               return _loc2_;
            }
            _loc2_.appName += "/";
            _loc2_.appName += param1.slice(_loc3_,_loc4_);
            _loc3_ = _loc4_ + 1;
            _loc2_.streamName = param1.slice(_loc3_);
            if(_loc2_.streamName.slice(-4).toLowerCase() == ".flv")
            {
               _loc2_.streamName = _loc2_.streamName.slice(0,-4);
            }
         }
         else
         {
            _loc2_.isRTMP = false;
            _loc2_.streamName = param1;
         }
         return _loc2_;
      }
      
      flvplayback_internal function initOtherInfo() : void
      {
         flvplayback_internal::_contentPath = null;
         flvplayback_internal::_streamName = null;
         flvplayback_internal::_streamWidth = -1;
         flvplayback_internal::_streamHeight = -1;
         flvplayback_internal::_streamLength = NaN;
         flvplayback_internal::_streams = null;
         flvplayback_internal::_autoSenseBW = false;
         flvplayback_internal::_payload = 0;
         flvplayback_internal::_connTypeCounter = 0;
         flvplayback_internal::cleanConns();
      }
      
      public function set timeout(param1:uint) : void
      {
         flvplayback_internal::_timeoutTimer.delay = param1;
      }
      
      flvplayback_internal function _onFMSConnectTimeOut(param1:TimerEvent = null) : void
      {
         flvplayback_internal::cleanConns();
         flvplayback_internal::_nc = null;
         flvplayback_internal::_ncConnected = false;
         if(!connectAgain())
         {
            flvplayback_internal::_owner.ncConnected();
         }
      }
      
      public function get streamHeight() : int
      {
         return flvplayback_internal::_streamHeight;
      }
      
      flvplayback_internal function connectOnStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:ParseResults = null;
         param1.target.client.pending = false;
         if(param1.info.code == "NetConnection.Connect.Success")
         {
            flvplayback_internal::_nc = flvplayback_internal::_tryNC[param1.target.client.connIndex];
            flvplayback_internal::cleanConns();
         }
         else if(param1.info.code == "NetConnection.Connect.Rejected" && param1.info.ex != null && param1.info.ex.code == 302)
         {
            flvplayback_internal::_connTypeCounter = 0;
            flvplayback_internal::cleanConns();
            _loc2_ = flvplayback_internal::parseURL(param1.info.ex.redirect);
            if(_loc2_.isRTMP)
            {
               flvplayback_internal::_protocol = _loc2_.protocol;
               flvplayback_internal::_serverName = _loc2_.serverName;
               flvplayback_internal::_wrappedURL = _loc2_.wrappedURL;
               flvplayback_internal::_portNumber = _loc2_.portNumber;
               flvplayback_internal::_appName = _loc2_.appName;
               if(_loc2_.streamName != null)
               {
                  flvplayback_internal::_appName += "/" + _loc2_.streamName;
               }
               flvplayback_internal::connectRTMP();
            }
            else
            {
               flvplayback_internal::tryFallBack();
            }
         }
         else if((param1.info.code == "NetConnection.Connect.Failed" || param1.info.code == "NetConnection.Connect.Rejected") && param1.target.client.connIndex == flvplayback_internal::_tryNC.length - 1)
         {
            if(!connectAgain())
            {
               flvplayback_internal::tryFallBack();
            }
         }
      }
      
      flvplayback_internal function onReconnected() : void
      {
         flvplayback_internal::_ncConnected = true;
         flvplayback_internal::_owner.ncReconnected();
      }
      
      flvplayback_internal function tryFallBack() : void
      {
         if(flvplayback_internal::_serverName == fallbackServerName || fallbackServerName == null)
         {
            flvplayback_internal::_nc = null;
            flvplayback_internal::_ncConnected = false;
            flvplayback_internal::_owner.ncConnected();
         }
         else
         {
            flvplayback_internal::_connTypeCounter = 0;
            flvplayback_internal::cleanConns();
            flvplayback_internal::_serverName = fallbackServerName;
            flvplayback_internal::connectRTMP();
         }
      }
      
      public function set bitrate(param1:Number) : void
      {
         if(!flvplayback_internal::_isRTMP)
         {
            flvplayback_internal::_bitrate = param1;
         }
      }
      
      flvplayback_internal function onConnected(param1:NetConnection, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         flvplayback_internal::_timeoutTimer.stop();
         param1.removeEventListener(NetStatusEvent.NET_STATUS,flvplayback_internal::connectOnStatus);
         flvplayback_internal::_nc = param1;
         flvplayback_internal::_ncUri = flvplayback_internal::_nc.uri;
         flvplayback_internal::_ncConnected = true;
         if(flvplayback_internal::_autoSenseBW)
         {
            flvplayback_internal::_bitrate = param2 * 1024;
            if(flvplayback_internal::_streams != null)
            {
               flvplayback_internal::bitrateMatch();
            }
            else
            {
               _loc3_ = flvplayback_internal::_streamName.split(",");
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = flvplayback_internal::stripFrontAndBackWhiteSpace(_loc3_[_loc4_]);
                  if(_loc4_ + 1 >= _loc3_.length)
                  {
                     flvplayback_internal::_streamName = _loc5_;
                     break;
                  }
                  if(param2 <= Number(_loc3_[_loc4_ + 1]))
                  {
                     flvplayback_internal::_streamName = _loc5_;
                     break;
                  }
                  _loc4_ += 2;
               }
               if(flvplayback_internal::_streamName.slice(-4).toLowerCase() == ".flv")
               {
                  flvplayback_internal::_streamName = flvplayback_internal::_streamName.slice(0,-4);
               }
            }
         }
         if(!flvplayback_internal::_owner.isLive && isNaN(flvplayback_internal::_streamLength))
         {
            flvplayback_internal::_nc.call("getStreamLength",new Responder(flvplayback_internal::getStreamLengthResult),flvplayback_internal::_streamName);
         }
         else
         {
            flvplayback_internal::_owner.ncConnected();
         }
      }
      
      public function close() : void
      {
         if(flvplayback_internal::_nc)
         {
            flvplayback_internal::_nc.close();
            flvplayback_internal::_ncConnected = false;
         }
      }
   }
}

