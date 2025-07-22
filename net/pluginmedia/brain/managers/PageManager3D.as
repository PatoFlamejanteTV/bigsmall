package net.pluginmedia.brain.managers
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.PageEvent;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.interfaces.IManager;
   import net.pluginmedia.brain.core.interfaces.IPage;
   import net.pluginmedia.brain.core.interfaces.IPageManager;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.loading.PageLoadProgressMeter;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.pv3d.materials.special.LineMaterial3D;
   import org.papervision3d.cameras.CameraType;
   import org.papervision3d.core.geom.Lines3D;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapFileMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   
   public class PageManager3D extends BasicView implements IPageManager, IManager, IUpdatable
   {
      
      protected var _nextPage:Page3D = null;
      
      protected var registeredObjs:Array = [];
      
      protected var pageProgressMeter:PageLoadProgressMeter;
      
      protected var _debugMode:Boolean = false;
      
      protected var _pagesByID:Object = {};
      
      protected var lines3D:Lines3D;
      
      protected var _pageHeight:Number = 480;
      
      protected var _prevPage:Page3D = null;
      
      protected var smoothed:Boolean = false;
      
      protected var shareManager:ShareManager;
      
      protected var _paused:Boolean = false;
      
      protected var compressionManager:CompressionManager;
      
      protected var _currentPage:Page3D = null;
      
      protected var _pageWidth:Number = 640;
      
      protected var isTransiting:Boolean = false;
      
      public function PageManager3D(param1:ShareManager, param2:int = 640, param3:int = 480, param4:Boolean = true, param5:Boolean = true)
      {
         super(param2,param3,param4,param5,CameraType.FREE);
         this.setShareManager(param1);
         pageWidth = param2;
         pageHeight = param3;
         init3D();
         init2D();
         compressionManager = new CompressionManager();
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      protected function init3D() : void
      {
      }
      
      protected function handlePageReady(param1:Event) : void
      {
         pageProgressMeter.reset();
         if(this.contains(pageProgressMeter))
         {
            removeChild(pageProgressMeter);
         }
         trace("PageManager : target page is ready - end monitoring page load progress.");
         _nextPage.removeEventListener(PageEvent.TRANSITION_READY,handlePageReady);
         transitionPages(_currentPage,_nextPage);
      }
      
      protected function drawPath(param1:BezierPath3D, param2:uint = 16777215) : void
      {
         var _loc6_:Number3D = null;
         var _loc7_:Vertex3D = null;
         var _loc8_:LineMaterial3D = null;
         var _loc9_:Line3D = null;
         var _loc3_:Number = 0;
         var _loc4_:Number = param1.transitStepInc;
         var _loc5_:Vertex3D = null;
         while(_loc3_ <= 1)
         {
            switch(_loc5_)
            {
               default:
                  _loc8_ = new LineMaterial3D(param2,0.7);
                  _loc9_ = new Line3D(lines3D,_loc8_,2,_loc5_,_loc7_);
                  lines3D.addLine(_loc9_);
               case null:
                  _loc5_ = new Vertex3D(_loc6_.x,_loc6_.y,_loc6_.z);
                  break;
               case null:
            }
            _loc3_ += _loc4_;
         }
      }
      
      private function manageMaterialSquashage(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:SharerInfo = null;
         var _loc4_:DisplayObject3D = null;
         var _loc5_:MaterialsList = null;
         var _loc6_:MaterialObject3D = null;
         var _loc7_:BitmapFileMaterial = null;
         trace("-- > manageMaterialSquashage",param1);
         for each(_loc2_ in param1)
         {
            _loc3_ = null;
            _loc4_ = null;
            if(shareManager.referenceExists(_loc2_))
            {
               _loc3_ = shareManager.getReference(_loc2_);
               _loc4_ = _loc3_.reference as DisplayObject3D;
               if(_loc4_)
               {
                  _loc5_ = _loc4_.materials;
                  trace("squashage list",_loc4_.materialsList());
                  for each(_loc6_ in _loc5_)
                  {
                     if(_loc6_ is BitmapFileMaterial)
                     {
                        _loc7_ = _loc6_ as BitmapFileMaterial;
                        trace("squashage url",_loc7_.url);
                     }
                  }
               }
            }
         }
      }
      
      public function debugMode(param1:Boolean) : void
      {
         var _loc2_:Page3D = null;
         _debugMode = param1;
         for each(_loc2_ in registeredObjs)
         {
            _loc2_.debugMode(param1);
         }
      }
      
      public function get pageHeight() : Number
      {
         return _pageHeight;
      }
      
      public function get nextPage() : Page3D
      {
         return _nextPage;
      }
      
      public function register(param1:Object) : void
      {
         if(!param1 is Page3D)
         {
            throw new Error("cannot register non Page3D with PageManager3D");
         }
         BrainLogger.out("PageManager3D registers page...",param1);
         registeredObjs.push(param1);
         var _loc2_:Page3D = param1 as Page3D;
         _loc2_.pageWidth = pageWidth;
         _loc2_.pageHeight = pageHeight;
         scene.addChild(_loc2_);
         _pagesByID[_loc2_.pageID] = _loc2_;
      }
      
      public function setCamera(param1:CameraObject3D) : void
      {
         _camera = param1;
      }
      
      public function get currentPage() : Page3D
      {
         return _currentPage;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         _pageHeight = param1;
      }
      
      protected function smoothMaterials(param1:DisplayObject3D, param2:Boolean = true) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:MaterialObject3D = null;
         var _loc6_:Triangle3D = null;
         for(_loc3_ in param1.children)
         {
            smoothMaterials(param1.children[_loc3_],param2);
         }
         if(param1.material)
         {
            param1.material.smooth = param2;
         }
         if(param1.materials)
         {
            for(_loc4_ in param1.materials.materialsByName)
            {
               _loc5_ = param1.getMaterialByName(_loc4_);
               if(_loc5_ !== null)
               {
                  _loc5_.smooth = param2;
               }
            }
         }
         if(param1.geometry)
         {
            if(param1.geometry.faces)
            {
               for each(_loc6_ in param1.geometry.faces)
               {
                  if(_loc6_.material)
                  {
                     _loc6_.material.smooth = param2;
                  }
               }
            }
         }
      }
      
      public function changePageByID(param1:String) : void
      {
         if(isTransiting)
         {
            return;
         }
         BrainLogger.out("CHANGE PAGE ",param1);
         if(Boolean(_nextPage) && !_nextPage.isTransitionReady)
         {
            _nextPage.removeEventListener(PageEvent.TRANSITION_READY,handlePageReady);
         }
         _nextPage = getPageByID(param1) as Page3D;
         if(!_nextPage)
         {
            BrainLogger.out("Warning :: Could not source page from id \"" + param1 + "\" " + "transition failed");
            return;
         }
         if(!_currentPage)
         {
            _currentPage = _nextPage;
         }
         compressionManager.unSquash(_nextPage);
         if(_nextPage.isTransitionReady)
         {
            dispatchEvent(new BrainEvent(BrainEventType.TRANSITION,null,_nextPage));
            transitionPages(_currentPage,_nextPage);
         }
         else
         {
            if(_nextPage is ILoadable)
            {
               if(!this.contains(pageProgressMeter))
               {
                  addChild(pageProgressMeter);
               }
               pageProgressMeter.monitor(_nextPage as ILoadable);
            }
            _nextPage.addEventListener(PageEvent.TRANSITION_READY,handlePageReady);
         }
      }
      
      protected function clearPaths() : void
      {
         while(lines3D.lines.length > 0)
         {
            lines3D.removeLine(lines3D.lines[0]);
         }
         lines3D.lines = new Array();
      }
      
      public function unregister(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Page3D = param1 as Page3D;
         if(!_loc3_)
         {
            throw new Error("cannot unregister non Page3D with PageManager3D");
         }
         if(this.sceneContains(_loc3_))
         {
            scene.removeChild(_loc3_);
         }
         var _loc4_:int = int(registeredObjs.indexOf(param1));
         if(_loc4_ > -1)
         {
            _loc3_.destroy();
            registeredObjs.splice(_loc4_,1);
            _pagesByID[_loc3_.pageID] = null;
            delete _pagesByID[_loc3_.pageID];
            BrainLogger.out("PageManager3D unregisters page...",_loc3_);
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
         singleRender();
      }
      
      protected function sceneContains(param1:DisplayObject3D) : Boolean
      {
         var _loc2_:Page3D = null;
         var _loc3_:DisplayObject3D = null;
         if(param1 === null)
         {
            return false;
         }
         for each(_loc2_ in registeredObjs)
         {
            _loc3_ = _loc2_.getChildByName(param1.name);
            if(_loc3_ !== null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setShareManager(param1:ShareManager) : void
      {
         shareManager = param1;
      }
      
      public function smoothAllMaterials(param1:Boolean = true) : void
      {
         var _loc2_:DisplayObject3D = null;
         if(param1 == smoothed)
         {
            return;
         }
         for each(_loc2_ in scene.children)
         {
            smoothMaterials(_loc2_,param1);
         }
         smoothed = param1;
      }
      
      public function getPageByID(param1:String) : IPage
      {
         var _loc2_:Page3D = _pagesByID[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         BrainLogger.out("PageManager :: getPageByID - could not find ID:",param1);
         return null;
      }
      
      public function get prevPage() : Page3D
      {
         return _prevPage;
      }
      
      public function set pageWidth(param1:Number) : void
      {
         _pageWidth = param1;
      }
      
      protected function transitionPages(param1:Page3D, param2:Page3D) : void
      {
         trace("transitionPages",param1,param2);
         _camera.copyPosition(_nextPage.localCam);
         _camera.target = _nextPage;
      }
      
      protected function init2D() : void
      {
         pageProgressMeter = new PageLoadProgressMeter(_pageWidth,_pageHeight);
         addChild(pageProgressMeter);
      }
      
      public function get pageWidth() : Number
      {
         return _pageWidth;
      }
      
      public function pause(param1:Boolean = true) : void
      {
         _paused = param1;
      }
      
      public function get isPaused() : Boolean
      {
         return _paused;
      }
   }
}

