package net.pluginmedia.brain.managers
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Manager;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.loading.*;
   
   public class LoadManager extends Manager
   {
      
      private var assetCollections:Dictionary = new Dictionary();
      
      private var IAssetLoaders:Dictionary = new Dictionary();
      
      private var totalLoads:int = 0;
      
      private var assetLoaderQueue:Array = [];
      
      private var _isLoading:Boolean = false;
      
      public function LoadManager()
      {
         super();
      }
      
      private function handleAssetError(param1:IOErrorEvent) : void
      {
         var _loc4_:AssetRequest = null;
         var _loc5_:ILoadable = null;
         trace("IO Error Event :: ",param1,"\nProceeding to next item in load Queue");
         var _loc2_:IAssetLoader = param1.target as IAssetLoader;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.assetRequests.length)
         {
            _loc4_ = _loc2_.assetRequests[_loc3_] as AssetRequest;
            _loc4_.doIOErrorCallback(_loc2_);
            _loc5_ = _loc4_.loadable;
            trace(_loc5_,"requested this failed object");
            _loc5_.ioErrorCallback(param1);
            _loc3_++;
         }
         tryNextLoadInQueue();
      }
      
      private function traceLoadQueue() : void
      {
         var _loc2_:IAssetLoader = null;
         trace("LoadManager :: queue currently reads -- (* = is loaded)");
         var _loc1_:Number = 0;
         while(_loc1_ < assetLoaderQueue.length)
         {
            _loc2_ = IAssetLoader(assetLoaderQueue[_loc1_]);
            if(_loc2_.isLoaded)
            {
               trace(_loc2_.resourcePath,"*");
            }
            else
            {
               trace(assetLoaderQueue[_loc1_].resourcePath);
            }
            _loc1_++;
         }
         trace("---------------------------------------");
      }
      
      private function handleAssetRequest(param1:LoaderEvent) : void
      {
         BrainLogger.out("|---> LoadManager :: got runtime asset request:",param1.target,param1.assetLoaderInfo.handle,param1.assetLoaderInfo.url);
         addIAssetLoader(param1.assetLoaderInfo);
         if(!_isLoading && param1.assetLoaderInfo.autoStartQueue)
         {
            tryNextLoadInQueue();
         }
      }
      
      public function stopLoad() : void
      {
         var _loc2_:IAssetLoader = null;
         var _loc1_:uint = 0;
         while(_loc1_ < assetLoaderQueue.length)
         {
            _loc2_ = assetLoaderQueue[_loc1_] as IAssetLoader;
            if(_loc2_.isLoading)
            {
               removeListeners(_loc2_ as EventDispatcher);
               trace("stopping",_loc2_.handle,"from loading");
               _loc2_.stopLoad();
            }
            _loc1_++;
         }
         _isLoading = false;
      }
      
      public function resetQueuePriorityForILoadables(param1:Array) : void
      {
         var _loc3_:ILoadable = null;
         stopLoad();
         var _loc2_:int = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1[_loc2_];
            resetQueuePriorityForILoadable(_loc3_,false);
            _loc2_--;
         }
         startLoad();
      }
      
      private function initListeners(param1:EventDispatcher) : void
      {
         if(!param1.hasEventListener("ILoaderComplete"))
         {
            param1.addEventListener("ILoaderComplete",handleAssetLoaded);
         }
         if(!param1.hasEventListener(LoaderEvent.PROGRESS))
         {
            param1.addEventListener(LoaderEvent.PROGRESS,handleAssetProgress);
         }
         if(!param1.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            param1.addEventListener(IOErrorEvent.IO_ERROR,handleAssetError);
         }
      }
      
      private function handleAssetDemand(param1:Event) : void
      {
         trace("ASSET DEMAND ISSUED...");
         resetQueuePriorityForILoadable(param1.target as ILoadable);
         traceLoadQueue();
      }
      
      private function handleAssetLoaded(param1:Event) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:AssetRequest = null;
         var _loc5_:ILoadable = null;
         var _loc6_:AssetCollection = null;
         var _loc2_:IAssetLoader = param1.target as IAssetLoader;
         removeListeners(_loc2_ as EventDispatcher);
         while(_loc3_ < _loc2_.assetRequests.length)
         {
            _loc4_ = _loc2_.assetRequests[_loc3_] as AssetRequest;
            _loc5_ = _loc4_.loadable;
            _loc6_ = assetCollections[_loc5_];
            _loc4_.doLoadedCallback(_loc2_);
            _loc5_.receiveAsset(_loc2_,_loc4_.handle);
            if(_loc6_.collectionLoadComplete() && !_loc5_.loadFailed)
            {
               _loc5_.unitLoaded = 1;
               _loc5_.collectionQueueEmpty();
            }
            _loc3_++;
         }
         tryNextLoadInQueue();
      }
      
      public function getTotalUnitLoaded() : Number
      {
         var _loc3_:Object = null;
         var _loc4_:AssetCollection = null;
         var _loc1_:Number = 0;
         var _loc2_:uint = 0;
         for each(_loc3_ in assetCollections)
         {
            _loc4_ = _loc3_ as AssetCollection;
            if(_loc4_.length > 0)
            {
               _loc2_++;
               _loc1_ += _loc4_.unitLoaded;
            }
         }
         return _loc1_ / _loc2_;
      }
      
      private function removeListeners(param1:EventDispatcher) : void
      {
         param1.removeEventListener("ILoaderComplete",handleAssetLoaded);
         param1.removeEventListener(LoaderEvent.PROGRESS,handleAssetProgress);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,handleAssetError);
      }
      
      public function getListUnitLoaded(param1:Array) : Number
      {
         var _loc4_:Object = null;
         var _loc5_:AssetCollection = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         for each(_loc4_ in assetCollections)
         {
            _loc5_ = _loc4_ as AssetCollection;
            _loc6_ = false;
            for each(_loc7_ in param1)
            {
               if(assetCollections[_loc7_] == _loc5_)
               {
                  _loc6_ = true;
                  break;
               }
            }
            if(_loc6_)
            {
               if(_loc5_.length > 0)
               {
                  _loc3_++;
                  if(_loc5_.isLoaded)
                  {
                     _loc2_ += 1;
                  }
                  else
                  {
                     _loc2_ += _loc5_.unitLoaded;
                  }
               }
            }
         }
         if(_loc3_ > 0)
         {
            _loc2_ /= _loc3_;
         }
         return _loc2_;
      }
      
      private function getUniqueAssetLoaderForURL(param1:String) : IAssetLoader
      {
         var _loc7_:AssetLoaderInfo = null;
         var _loc8_:Object = null;
         var _loc9_:Class = null;
         var _loc2_:Array = param1.split(".");
         var _loc3_:String = _loc2_[_loc2_.length - 1];
         var _loc4_:IAssetLoader = null;
         var _loc5_:String = "";
         var _loc6_:Number = assetLoaderQueue.length;
         for each(_loc8_ in IAssetLoaders)
         {
            _loc7_ = _loc8_ as AssetLoaderInfo;
            for each(_loc5_ in _loc7_.fileTypes)
            {
               if(_loc3_ == _loc5_)
               {
                  _loc9_ = _loc7_.IAssetLoader;
                  return new _loc9_(_loc6_,param1);
               }
            }
         }
         return null;
      }
      
      override public function register(param1:Object) : void
      {
         super.register(param1);
         var _loc2_:ILoadable = param1 as ILoadable;
         param1.addEventListener(LoaderEvent.DEMAND_ASSETS,handleAssetDemand);
         param1.addEventListener(LoaderEvent.ASSET_REQUEST,handleAssetRequest);
         assetCollections[_loc2_] = new AssetCollection();
         _loc2_.onRegistration();
      }
      
      public function startLoad() : void
      {
         tryNextLoadInQueue();
      }
      
      public function resetQueuePriorityForILoadable(param1:ILoadable, param2:Boolean = true) : void
      {
         var _loc4_:String = null;
         var _loc5_:IAssetLoader = null;
         var _loc6_:Number = NaN;
         var _loc7_:IAssetLoader = null;
         if(param2)
         {
            stopLoad();
         }
         var _loc3_:AssetCollection = assetCollections[param1];
         for(_loc4_ in _loc3_.assetLoaders)
         {
            _loc5_ = assetCollections[param1].assetLoaders[_loc4_];
            _loc6_ = assetLoaderQueue.length - 1;
            while(_loc6_ >= 0)
            {
               _loc7_ = assetLoaderQueue[_loc6_];
               if(_loc5_ == _loc7_)
               {
                  assetLoaderQueue.splice(_loc6_,1);
                  assetLoaderQueue.unshift(_loc5_);
               }
               _loc6_--;
            }
         }
         if(param2)
         {
            startLoad();
         }
      }
      
      private function handleAssetProgress(param1:Event) : void
      {
         var _loc4_:ILoadable = null;
         var _loc5_:AssetCollection = null;
         var _loc6_:IAssetLoader = null;
         var _loc2_:IAssetLoader = param1.target as IAssetLoader;
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.assetRequests.length)
         {
            _loc4_ = AssetRequest(_loc2_.assetRequests[_loc3_]).loadable;
            _loc5_ = assetCollections[_loc4_] as AssetCollection;
            _loc5_.bytesTotal = _loc5_.bytesLoaded = 0;
            for each(_loc6_ in _loc5_.assetLoaders)
            {
               if(_loc6_.isLoaded)
               {
                  _loc5_.bytesLoaded += 10000;
               }
               else if(_loc6_.isLoading)
               {
                  _loc5_.bytesLoaded += _loc6_.getBytesLoaded() / _loc6_.getBytesTotal() * 10000;
               }
               _loc5_.bytesTotal += 10000;
            }
            _loc4_.unitLoaded = _loc5_.unitLoaded;
            _loc3_++;
         }
      }
      
      private function getIAssetLoaderForURL(param1:String) : IAssetLoader
      {
         var _loc3_:uint = 0;
         var _loc2_:IAssetLoader = assetLoaderQueue[_loc3_] as IAssetLoader;
         _loc3_ = 0;
         while(_loc3_ < assetLoaderQueue.length)
         {
            if(_loc2_.resourcePath == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function tryNextLoadInQueue() : void
      {
         var _loc2_:IAssetLoader = null;
         var _loc1_:Number = 0;
         while(_loc1_ < assetLoaderQueue.length)
         {
            _loc2_ = assetLoaderQueue[_loc1_] as IAssetLoader;
            if(!_loc2_.isLoaded && !_loc2_.isLoading)
            {
               initListeners(_loc2_ as EventDispatcher);
               _loc2_.startLoad();
               _isLoading = true;
               return;
            }
            _loc1_++;
         }
         _isLoading = false;
      }
      
      private function addIAssetLoader(param1:AssetRequest) : void
      {
         var _loc2_:ILoadable = param1.loadable;
         var _loc3_:IAssetLoader = getIAssetLoaderForURL(param1.url);
         if(_loc3_ === null || param1.isUnique)
         {
            _loc3_ = getUniqueAssetLoaderForURL(param1.url);
            assetLoaderQueue.push(_loc3_);
         }
         AssetCollection(assetCollections[_loc2_]).pushAsset(_loc3_,param1);
         _loc3_.addLoadableRequest(param1);
      }
      
      override public function unregister(param1:Object) : Boolean
      {
         var _loc2_:ILoadable = param1 as ILoadable;
         param1.removeEventListener(LoaderEvent.DEMAND_ASSETS,handleAssetDemand);
         param1.removeEventListener(LoaderEvent.ASSET_REQUEST,handleAssetRequest);
         assetCollections[_loc2_] = null;
         delete assetCollections[_loc2_];
         return super.unregister(param1);
      }
      
      public function registerIAssetLoader(param1:Class, param2:String, param3:Array) : void
      {
         var _loc5_:AssetLoaderInfo = null;
         var _loc4_:* = new param1(0,"");
         if(!(_loc4_ is param1))
         {
            throw new Error("LoadManager :: cannot register non IAssetLoader to load content");
         }
         _loc5_ = new AssetLoaderInfo(param1,param2,param3);
         IAssetLoaders[param2] = _loc5_;
      }
   }
}

