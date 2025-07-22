package net.pluginmedia.brain.core.loading
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   
   public class URLAssetLoader extends URLLoader implements IAssetLoader
   {
      
      private var _uid:uint;
      
      private var _bytesLoaded:uint = 0;
      
      private var _percentLoaded:uint = 0;
      
      private var _isLoaded:Boolean;
      
      private var _isLoading:Boolean;
      
      private var _bytesTotal:uint = 0;
      
      private var _resourcePath:String;
      
      private var _isError:Boolean;
      
      private var _handle:String;
      
      private var _loadableInfoObjects:Array = [];
      
      public function URLAssetLoader(param1:uint, param2:String)
      {
         _resourcePath = param2;
         _handle = param2;
         super();
      }
      
      private function handleComplete(param1:Event) : void
      {
         _isLoaded = true;
         removeEventListeners();
         _isLoading = false;
         dispatchEvent(new Event("ILoaderComplete"));
      }
      
      public function stopLoad() : void
      {
         if(_isLoading)
         {
            try
            {
               close();
               removeEventListeners();
               _isLoading = false;
            }
            catch(e:Error)
            {
               BrainLogger.out("stopLoad error ::",e);
            }
            _percentLoaded = 0;
         }
      }
      
      public function getBytesTotal() : uint
      {
         return _bytesTotal;
      }
      
      public function getBytesLoaded() : uint
      {
         return _bytesLoaded;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get handle() : String
      {
         return _handle;
      }
      
      public function get isLoading() : Boolean
      {
         return _isLoading;
      }
      
      public function getContent() : Object
      {
         if(_isLoaded && !_isError)
         {
            return this.data;
         }
         return null;
      }
      
      private function addEventListeners() : void
      {
         if(!hasEventListener(Event.COMPLETE))
         {
            addEventListener(Event.COMPLETE,handleComplete);
         }
         if(!hasEventListener(IOErrorEvent.IO_ERROR))
         {
            addEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
         if(!hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
         {
            addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);
         }
         if(!hasEventListener(ProgressEvent.PROGRESS))
         {
            addEventListener(ProgressEvent.PROGRESS,handleProgress);
         }
      }
      
      public function get isLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      public function get uid() : uint
      {
         return _uid;
      }
      
      public function get resourcePath() : String
      {
         return _resourcePath;
      }
      
      public function get assetRequests() : Array
      {
         return _loadableInfoObjects;
      }
      
      public function addLoadableRequest(param1:AssetRequest) : void
      {
         assetRequests.push(param1);
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         throw new Error("URLLoaderAsset :: SECURITYERROR...");
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         BrainLogger.out("LoaderAsset :: IOERROR... ",param1);
         removeEventListeners();
         _isLoaded = true;
         _isLoading = false;
         _isError = true;
         dispatchEvent(param1);
      }
      
      public function startLoad() : void
      {
         addEventListeners();
         load(new URLRequest(_resourcePath));
         _isLoading = true;
         _isError = false;
      }
      
      private function removeEventListeners() : void
      {
         if(hasEventListener(Event.COMPLETE))
         {
            removeEventListener(Event.COMPLETE,handleComplete);
         }
         if(hasEventListener(IOErrorEvent.IO_ERROR))
         {
            removeEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
         if(hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
         {
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);
         }
         if(hasEventListener(ProgressEvent.PROGRESS))
         {
            removeEventListener(ProgressEvent.PROGRESS,handleProgress);
         }
      }
      
      private function handleProgress(param1:ProgressEvent) : void
      {
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         _percentLoaded = _bytesLoaded / _bytesTotal * 100;
         dispatchEvent(new Event(LoaderEvent.PROGRESS));
      }
      
      public function get isError() : Boolean
      {
         return _isError;
      }
   }
}

