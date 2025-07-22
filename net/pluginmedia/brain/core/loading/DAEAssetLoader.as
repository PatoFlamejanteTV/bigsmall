package net.pluginmedia.brain.core.loading
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.DAELoadProgressEvent;
   import org.papervision3d.events.FileLoadEvent;
   
   public class DAEAssetLoader extends EventDispatcher implements IAssetLoader
   {
      
      private var _uid:uint;
      
      private var _bytesLoaded:uint = 0;
      
      private var _percentLoaded:uint = 0;
      
      private var _isLoaded:Boolean;
      
      private var _isLoading:Boolean;
      
      private var _bytesTotal:uint = 0;
      
      private var _isError:Boolean;
      
      private var _resourcePath:String;
      
      private var _handle:String;
      
      private var _loadableInfoObjects:Array = [];
      
      private var _daeObject:DAEFixed;
      
      public function DAEAssetLoader(param1:uint, param2:String)
      {
         super();
         _resourcePath = param2;
         _handle = param2;
      }
      
      private function handleComplete(param1:FileLoadEvent) : void
      {
         _bytesLoaded = 100000;
         _bytesTotal = 100000;
         _percentLoaded = 100;
         _isLoaded = true;
         removeEventListeners();
         _isLoading = false;
         dispatchEvent(new Event("ILoaderComplete"));
      }
      
      public function stopLoad() : void
      {
         removeEventListeners();
         _isLoading = false;
         _daeObject.killAllProcesses();
         _daeObject = null;
         _bytesLoaded = 0;
         _bytesTotal = 0;
         _percentLoaded = 0;
      }
      
      public function getBytesTotal() : uint
      {
         return _bytesTotal;
      }
      
      public function getBytesLoaded() : uint
      {
         return _bytesLoaded;
      }
      
      public function get handle() : String
      {
         return _handle;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get isLoading() : Boolean
      {
         return _isLoading;
      }
      
      private function handleError(param1:FileLoadEvent) : void
      {
         BrainLogger.out("LoaderAsset :: IOERROR... ",param1);
         removeEventListeners();
      }
      
      public function getContent() : Object
      {
         if(_isLoaded && !_isError)
         {
            return _daeObject;
         }
         return null;
      }
      
      private function addEventListeners() : void
      {
         if(!_daeObject.hasEventListener(FileLoadEvent.LOAD_COMPLETE))
         {
            _daeObject.addEventListener(FileLoadEvent.LOAD_COMPLETE,handleComplete);
         }
         if(!_daeObject.hasEventListener(DAELoadProgressEvent.LOAD_PROGRESS))
         {
            _daeObject.addEventListener(DAELoadProgressEvent.LOAD_PROGRESS,handleProgress);
         }
         if(!_daeObject.hasEventListener(FileLoadEvent.LOAD_ERROR))
         {
            _daeObject.addEventListener(FileLoadEvent.LOAD_ERROR,handleError);
         }
         if(!_daeObject.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            _daeObject.addEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
      }
      
      public function get isLoaded() : Boolean
      {
         return _isLoaded;
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
      
      public function get uid() : uint
      {
         return _uid;
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         _isLoaded = true;
         _isLoading = false;
         _isError = true;
         dispatchEvent(param1);
      }
      
      private function removeEventListeners() : void
      {
         if(_daeObject.hasEventListener(FileLoadEvent.LOAD_COMPLETE))
         {
            _daeObject.removeEventListener(FileLoadEvent.LOAD_COMPLETE,handleComplete);
         }
         if(_daeObject.hasEventListener(DAELoadProgressEvent.LOAD_PROGRESS))
         {
            _daeObject.removeEventListener(DAELoadProgressEvent.LOAD_PROGRESS,handleProgress);
         }
         if(_daeObject.hasEventListener(FileLoadEvent.LOAD_ERROR))
         {
            _daeObject.removeEventListener(FileLoadEvent.LOAD_ERROR,handleError);
         }
         if(_daeObject.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            _daeObject.removeEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
      }
      
      public function startLoad() : void
      {
         _daeObject = new DAEFixed();
         addEventListeners();
         _daeObject.load(_resourcePath,null,true);
         _isLoading = true;
         _isError = false;
      }
      
      private function handleProgress(param1:DAELoadProgressEvent) : void
      {
         _percentLoaded = param1.progress;
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         dispatchEvent(new Event(LoaderEvent.PROGRESS));
      }
      
      public function get isError() : Boolean
      {
         return _isError;
      }
   }
}

