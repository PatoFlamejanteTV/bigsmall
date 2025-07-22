package fl.video
{
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   use namespace flvplayback_internal;
   
   public class FPADManager
   {
      
      public static const VERSION:String = "2.1.0.14";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal var _parseResults:ParseResults;
      
      flvplayback_internal var rtmpURL:String;
      
      flvplayback_internal var _url:String;
      
      flvplayback_internal var xmlLoader:URLLoader;
      
      flvplayback_internal var xml:XML;
      
      flvplayback_internal var _uriParam:String;
      
      private var _owner:INCManager;
      
      public function FPADManager(param1:INCManager)
      {
         super();
         _owner = param1;
      }
      
      flvplayback_internal function connectXML(param1:String, param2:String, param3:String, param4:ParseResults) : Boolean
      {
         flvplayback_internal::_uriParam = param2;
         flvplayback_internal::_parseResults = param4;
         flvplayback_internal::_url = param1 + "uri=" + flvplayback_internal::_parseResults.protocol;
         if(flvplayback_internal::_parseResults.serverName != null)
         {
            flvplayback_internal::_url += "/" + flvplayback_internal::_parseResults.serverName;
         }
         if(flvplayback_internal::_parseResults.portNumber != null)
         {
            flvplayback_internal::_url += ":" + flvplayback_internal::_parseResults.portNumber;
         }
         if(flvplayback_internal::_parseResults.wrappedURL != null)
         {
            flvplayback_internal::_url += "/?" + flvplayback_internal::_parseResults.wrappedURL;
         }
         flvplayback_internal::_url += "/" + flvplayback_internal::_parseResults.appName;
         flvplayback_internal::_url += param3;
         flvplayback_internal::xml = new XML();
         flvplayback_internal::xmlLoader = new URLLoader();
         flvplayback_internal::xmlLoader.addEventListener(Event.COMPLETE,flvplayback_internal::xmlLoadEventHandler);
         flvplayback_internal::xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,flvplayback_internal::xmlLoadEventHandler);
         flvplayback_internal::xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,flvplayback_internal::xmlLoadEventHandler);
         flvplayback_internal::xmlLoader.load(new URLRequest(flvplayback_internal::_url));
         return false;
      }
      
      flvplayback_internal function xmlLoadEventHandler(param1:Event) : void
      {
         var proxy:String = null;
         var e:Event = param1;
         try
         {
            if(e.type != Event.COMPLETE)
            {
               _owner.helperDone(this,false);
            }
            else
            {
               flvplayback_internal::xml = new XML(flvplayback_internal::xmlLoader.data);
               if(flvplayback_internal::xml == null || flvplayback_internal::xml.localName() == null)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + flvplayback_internal::_url + "\" No root node found; if url is for an flv it must have .flv extension and take no parameters");
               }
               if(flvplayback_internal::xml.localName() != "fpad")
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + flvplayback_internal::_url + "\" Root node not fpad");
               }
               proxy = null;
               if(flvplayback_internal::xml.proxy.length() > 0 && flvplayback_internal::xml.proxy.hasSimpleContent() && flvplayback_internal::xml.proxy.*[0].nodeKind() == "text")
               {
                  proxy = flvplayback_internal::xml.proxy.*[0].toString();
               }
               if(proxy == null)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + flvplayback_internal::_url + "\" fpad xml requires proxy tag.");
               }
               flvplayback_internal::rtmpURL = flvplayback_internal::_parseResults.protocol + "/" + proxy + "/?" + flvplayback_internal::_uriParam;
               _owner.helperDone(this,true);
            }
         }
         catch(err:Error)
         {
            _owner.helperDone(this,false);
            throw err;
         }
      }
   }
}

