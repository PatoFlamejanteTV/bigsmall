package net.pluginmedia.brain
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Manager;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IBroadcaster;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.interfaces.IManager;
   import net.pluginmedia.brain.core.interfaces.IPage;
   import net.pluginmedia.brain.core.interfaces.IPageManager;
   import net.pluginmedia.brain.core.interfaces.ISharer;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.loading.LoadProgressRequestInfo;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeter;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeterInfo;
   import net.pluginmedia.brain.core.loading.URLAssetLoader;
   import net.pluginmedia.brain.managers.BroadcastManager;
   import net.pluginmedia.brain.managers.LoadManager;
   import net.pluginmedia.brain.managers.PageManager;
   import net.pluginmedia.brain.managers.ShareManager;
   import net.pluginmedia.brain.managers.UpdateManager;
   
   public class Brain extends Manager
   {
      
      protected var _appWidth:int;
      
      protected var shareManager:ShareManager;
      
      protected var _pageManager:IPageManager;
      
      protected var loaderProgress:MultiPageLoadProgressMeter;
      
      protected var updateManager:UpdateManager;
      
      protected var loadManager:LoadManager;
      
      protected var _appHeight:int;
      
      protected var broadcastManager:BroadcastManager;
      
      public function Brain(param1:int = 640, param2:int = 480)
      {
         super();
         shareManager = new ShareManager();
         updateManager = new UpdateManager();
         appWidth = param1;
         appHeight = param2;
         setPageManager();
         addChild(_pageManager as DisplayObject);
         broadcastManager = new BroadcastManager();
         broadcastManager.addEventListener(BrainEvent.ACTION,handleActionEvent);
         loadManager = new LoadManager();
         loadManager.registerIAssetLoader(URLAssetLoader,"URLLoaderAsset",["xml","txt","php"]);
         loadManager.registerIAssetLoader(AssetLoader,"LoaderAsset",["swf","png","gif","jpg"]);
         initLoadProgressMeter();
         addChild(loaderProgress);
         addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      protected function handleActionEvent(param1:BrainEvent) : void
      {
         switch(param1.actionType)
         {
            case BrainEventType.CHANGE_PAGE:
               _pageManager.changePageByID(param1.actionTarget);
               break;
            case BrainEventType.MULTIPAGE_LOADPROGRESS:
               loaderProgress.monitorPages(param1.data as MultiPageLoadProgressMeterInfo);
               break;
            case BrainEventType.HIDE_PRELOADER:
               loaderProgress.reset();
               loaderProgress.banish();
               break;
            case BrainEventType.GET_LOADPROGRESS:
               handleLoadProgressRequest(param1.data as LoadProgressRequestInfo);
               break;
            case BrainEventType.GET_PAGEOBJECTREF:
               handleGetPageRequest(param1.actionTarget,param1.data as Function);
               break;
            case BrainEventType.PRIORITISE_LOADQUEUE:
               handlePrioritiseLoadQueue(param1.data as Array);
         }
      }
      
      private function getPagesFromStrings(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:IPage = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            BrainLogger.out("getting defnition of string :",_loc3_,",",_pageManager.getPageByID(_loc3_ as String));
            _loc4_ = _pageManager.getPageByID(_loc3_ as String) as IPage;
            if(_loc4_ !== null)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      override public function unregister(param1:Object) : Boolean
      {
         trace(this,"unregistering",param1);
         if(param1 is IBroadcaster)
         {
            trace("broadcastManager unregistering",param1);
            broadcastManager.unregister(param1);
         }
         if(param1 is IUpdatable)
         {
            trace("updateManager unregistering",param1);
            updateManager.unregister(param1);
         }
         if(param1 is IPage)
         {
            trace("pageManager unregistering",param1);
            IManager(_pageManager).unregister(param1);
         }
         if(param1 is ILoadable)
         {
            trace("loadManager unregistering",param1);
            loadManager.unregister(param1);
         }
         if(param1 is ISharer)
         {
            trace("shareManager unregistering",param1);
            shareManager.unregister(param1);
         }
         return super.unregister(param1);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         updateManager.update(this.stage);
      }
      
      protected function set appHeight(param1:int) : void
      {
         _appHeight = param1;
      }
      
      protected function set appWidth(param1:int) : void
      {
         _appWidth = param1;
      }
      
      protected function handleLoadProgressRequest(param1:LoadProgressRequestInfo) : void
      {
         var unit:Number = NaN;
         var info:LoadProgressRequestInfo = param1;
         if(info.pages === null)
         {
            unit = loadManager.getTotalUnitLoaded();
         }
         else
         {
            unit = loadManager.getListUnitLoaded(getPagesFromStrings(info.pages));
         }
         try
         {
            info.callback(unit);
         }
         catch(e:Error)
         {
            BrainLogger.error("Got request for load manager progress which did would not receive unit");
         }
      }
      
      protected function handleGetPageRequest(param1:String, param2:Function) : void
      {
         var _loc3_:IPage = _pageManager.getPageByID(param1) as IPage;
         if(param2 is Function)
         {
            param2.apply(null,[_loc3_]);
         }
      }
      
      protected function setPageManager() : void
      {
         _pageManager = new PageManager(shareManager,appWidth,appHeight);
      }
      
      override public function register(param1:Object) : void
      {
         super.register(param1);
         if(param1 is IBroadcaster)
         {
            broadcastManager.register(param1);
         }
         if(param1 is IUpdatable)
         {
            updateManager.register(param1);
         }
         if(param1 is IPage)
         {
            IManager(_pageManager).register(param1);
         }
         if(param1 is ILoadable)
         {
            loadManager.register(param1);
         }
         if(param1 is ISharer)
         {
            shareManager.register(param1);
         }
      }
      
      protected function get appWidth() : int
      {
         return _appWidth;
      }
      
      protected function initLoadProgressMeter() : void
      {
         loaderProgress = new MultiPageLoadProgressMeter(appWidth,appHeight,loadManager,_pageManager);
      }
      
      protected function get appHeight() : int
      {
         return _appHeight;
      }
      
      protected function handlePrioritiseLoadQueue(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:ILoadable = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = _pageManager.getPageByID(_loc3_) as ILoadable;
            if(_loc4_)
            {
               _loc2_.push(_loc4_);
            }
         }
         loadManager.resetQueuePriorityForILoadables(_loc2_);
      }
   }
}

