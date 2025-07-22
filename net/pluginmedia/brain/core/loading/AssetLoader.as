package net.pluginmedia.brain.core.loading
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   
   public class AssetLoader extends Loader implements IAssetLoader
   {
      
      private var _uid:uint;
      
      private var _bytesLoaded:uint = 0;
      
      private var _percentLoaded:uint = 0;
      
      private var _isLoaded:Boolean;
      
      private var _isLoading:Boolean;
      
      private var keepContent:Boolean;
      
      private var _bytesTotal:uint = 0;
      
      private var _resourcePath:String;
      
      private var _isError:Boolean;
      
      private var _handle:String;
      
      private var _loadableInfoObjects:Array = [];
      
      public function AssetLoader(param1:uint, param2:String, param3:Boolean = false)
      {
         _resourcePath = param2;
         _handle = param2;
         keepContent = param3;
         super();
      }
      
      public function getAssetClassByName(param1:String) : Class
      {
         var classdef:Class = null;
         var assetname:String = param1;
         try
         {
            classdef = contentLoaderInfo.applicationDomain.getDefinition(assetname) as Class;
            return classdef;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function stopLoad() : void
      {
         if(_isLoading)
         {
            _isLoading = false;
            _isLoaded = false;
            _isError = false;
            removeEventListeners();
            try
            {
               close();
               unload();
            }
            catch(e:Error)
            {
               BrainLogger.out("AssetLoader.stopLoad close/unload error ::",e);
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
      
      public function getContent() : Object
      {
         if(_isLoaded && !_isError)
         {
            return this.content;
         }
         return null;
      }
      
      private function stopAnimation(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:int = 0;
         if(param1 is MovieClip)
         {
            MovieClip(param1).stop();
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = param1 as DisplayObjectContainer;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               if(_loc2_.getChildAt(_loc3_) is DisplayObject)
               {
                  stopAnimation(_loc2_.getChildAt(_loc3_));
               }
               _loc3_++;
            }
         }
      }
      
      private function addEventListeners() : void
      {
         if(!contentLoaderInfo.hasEventListener(Event.INIT))
         {
            contentLoaderInfo.addEventListener(Event.INIT,handleInit);
         }
         if(!contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
         if(!contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))
         {
            contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,handleProgress);
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
      
      private function handleInit(param1:Event) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         _isLoaded = true;
         removeEventListeners();
         _isLoading = false;
         dispatchEvent(new Event("ILoaderComplete"));
         stopAnimation(content);
         if(!keepContent && content is DisplayObjectContainer)
         {
            _loc2_ = content as DisplayObjectContainer;
            while(_loc2_.numChildren > 0)
            {
               _loc2_.removeChildAt(0);
            }
         }
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
      
      public function getAssetByName(param1:String, param2:Class = null) : *
      {
         var classdef:Class = null;
         var assetname:String = param1;
         var type:Class = param2;
         try
         {
            classdef = getAssetClassByName(assetname);
            if(type == BitmapData)
            {
               return new classdef(0,0);
            }
            return new classdef();
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      private function removeEventListeners() : void
      {
         if(contentLoaderInfo.hasEventListener(Event.INIT))
         {
            contentLoaderInfo.removeEventListener(Event.INIT,handleInit);
         }
         if(contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         }
         if(contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))
         {
            contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,handleProgress);
         }
      }
      
      public function startLoad() : void
      {
         _isLoading = true;
         addEventListeners();
         load(new URLRequest(_resourcePath));
         _isError = false;
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

