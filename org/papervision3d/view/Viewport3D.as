package org.papervision3d.view
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.papervision3d.core.culling.DefaultLineCuller;
   import org.papervision3d.core.culling.DefaultParticleCuller;
   import org.papervision3d.core.culling.DefaultTriangleCuller;
   import org.papervision3d.core.culling.ILineCuller;
   import org.papervision3d.core.culling.IParticleCuller;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.culling.RectangleLineCuller;
   import org.papervision3d.core.culling.RectangleParticleCuller;
   import org.papervision3d.core.culling.RectangleTriangleCuller;
   import org.papervision3d.core.culling.ViewportObjectFilter;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.utils.InteractiveSceneManager;
   import org.papervision3d.core.view.IViewport3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportBaseLayer;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Viewport3D extends Sprite implements IViewport3D
   {
      
      public var interactiveSceneManager:InteractiveSceneManager;
      
      public var lastRenderList:Array;
      
      public var cullingRectangle:Rectangle;
      
      protected var _interactive:Boolean;
      
      private var stageScaleModeSet:Boolean = false;
      
      protected var _autoCulling:Boolean;
      
      protected var _viewportObjectFilter:ViewportObjectFilter;
      
      public var particleCuller:IParticleCuller;
      
      protected var _height:Number;
      
      protected var _width:Number;
      
      public var lineCuller:ILineCuller;
      
      protected var _layerInstances:Dictionary;
      
      protected var _autoScaleToStage:Boolean;
      
      public var triangleCuller:ITriangleCuller;
      
      protected var _lastRenderer:IRenderEngine;
      
      protected var _hWidth:Number;
      
      protected var _containerSprite:ViewportBaseLayer;
      
      protected var _hHeight:Number;
      
      public var sizeRectangle:Rectangle;
      
      protected var renderHitData:RenderHitData;
      
      protected var _autoClipping:Boolean;
      
      public function Viewport3D(param1:Number = 640, param2:Number = 480, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true, param6:Boolean = true)
      {
         super();
         init();
         this.interactive = param4;
         this.viewportWidth = param1;
         this.viewportHeight = param2;
         this.autoClipping = param5;
         this.autoCulling = param6;
         this.autoScaleToStage = param3;
         this._layerInstances = new Dictionary(true);
      }
      
      public function set viewportWidth(param1:Number) : void
      {
         _width = param1;
         _hWidth = param1 / 2;
         containerSprite.x = _hWidth;
         cullingRectangle.x = -_hWidth;
         cullingRectangle.width = param1;
         sizeRectangle.width = param1;
         if(_autoClipping)
         {
            scrollRect = sizeRectangle;
         }
      }
      
      public function get autoCulling() : Boolean
      {
         return _autoCulling;
      }
      
      protected function onStageResize(param1:Event = null) : void
      {
         if(_autoScaleToStage)
         {
            viewportWidth = stage.stageWidth;
            viewportHeight = stage.stageHeight;
         }
      }
      
      public function set autoCulling(param1:Boolean) : void
      {
         if(param1)
         {
            triangleCuller = new RectangleTriangleCuller(cullingRectangle);
            particleCuller = new RectangleParticleCuller(cullingRectangle);
            lineCuller = new RectangleLineCuller(cullingRectangle);
         }
         else if(!param1)
         {
            triangleCuller = new DefaultTriangleCuller();
            particleCuller = new DefaultParticleCuller();
            lineCuller = new DefaultLineCuller();
         }
         _autoCulling = param1;
      }
      
      public function getChildLayer(param1:DisplayObject3D, param2:Boolean = true, param3:Boolean = true) : ViewportLayer
      {
         return containerSprite.getChildLayer(param1,param2,param3);
      }
      
      protected function init() : void
      {
         this.renderHitData = new RenderHitData();
         lastRenderList = new Array();
         sizeRectangle = new Rectangle();
         cullingRectangle = new Rectangle();
         _containerSprite = new ViewportBaseLayer(this);
         _containerSprite.doubleClickEnabled = true;
         addChild(_containerSprite);
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
      }
      
      public function get autoClipping() : Boolean
      {
         return _autoClipping;
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
         var _loc2_:ViewportLayer = null;
         if(interactive)
         {
            interactiveSceneManager.updateAfterRender();
         }
         if(param1.renderLayers)
         {
            for each(_loc2_ in param1.renderLayers)
            {
               _loc2_.updateInfo();
               _loc2_.sortChildLayers();
               _loc2_.updateAfterRender();
            }
         }
         else
         {
            containerSprite.updateInfo();
            containerSprite.updateAfterRender();
         }
         containerSprite.sortChildLayers();
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         if(_autoScaleToStage)
         {
            setStageScaleMode();
         }
         stage.addEventListener(Event.RESIZE,onStageResize);
         onStageResize();
      }
      
      public function get containerSprite() : ViewportLayer
      {
         return _containerSprite;
      }
      
      public function set autoClipping(param1:Boolean) : void
      {
         if(param1)
         {
            scrollRect = sizeRectangle;
         }
         else
         {
            scrollRect = null;
         }
         _autoClipping = param1;
      }
      
      protected function setStageScaleMode() : void
      {
         if(!stageScaleModeSet)
         {
            PaperLogger.info("Viewport autoScaleToStage : Papervision has changed the Stage scale mode.");
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stageScaleModeSet = true;
         }
      }
      
      public function accessLayerFor(param1:RenderableListItem, param2:Boolean = false) : ViewportLayer
      {
         var _loc3_:DisplayObject3D = null;
         if(param1.renderableInstance)
         {
            _loc3_ = param1.renderableInstance.instance;
            _loc3_ = _loc3_.parentContainer ? _loc3_.parentContainer : _loc3_;
            if(containerSprite.layers[_loc3_])
            {
               if(param2)
               {
                  _loc3_.container = containerSprite.layers[_loc3_];
               }
               return containerSprite.layers[_loc3_];
            }
            if(_loc3_.useOwnContainer)
            {
               return containerSprite.getChildLayer(_loc3_,true,true);
            }
         }
         return containerSprite;
      }
      
      public function get viewportWidth() : Number
      {
         return _width;
      }
      
      public function set interactive(param1:Boolean) : void
      {
         if(param1 != _interactive)
         {
            if(_interactive && Boolean(interactiveSceneManager))
            {
               interactiveSceneManager.destroy();
               interactiveSceneManager = null;
            }
            _interactive = param1;
            if(param1)
            {
               interactiveSceneManager = new InteractiveSceneManager(this);
            }
         }
      }
      
      public function set viewportObjectFilter(param1:ViewportObjectFilter) : void
      {
         _viewportObjectFilter = param1;
      }
      
      public function set autoScaleToStage(param1:Boolean) : void
      {
         _autoScaleToStage = param1;
         if(param1 && stage != null)
         {
            setStageScaleMode();
            onStageResize();
         }
      }
      
      public function set viewportHeight(param1:Number) : void
      {
         _height = param1;
         _hHeight = param1 / 2;
         containerSprite.y = _hHeight;
         cullingRectangle.y = -_hHeight;
         cullingRectangle.height = param1;
         sizeRectangle.height = param1;
         if(_autoClipping)
         {
            scrollRect = sizeRectangle;
         }
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:ViewportLayer = null;
         lastRenderList.length = 0;
         if(param1.renderLayers)
         {
            for each(_loc2_ in param1.renderLayers)
            {
               _loc2_.updateBeforeRender();
            }
         }
         else
         {
            _containerSprite.updateBeforeRender();
         }
         _layerInstances = new Dictionary(true);
      }
      
      public function hitTestMouse() : RenderHitData
      {
         var _loc1_:Point = new Point(containerSprite.mouseX,containerSprite.mouseY);
         return hitTestPoint2D(_loc1_);
      }
      
      public function get interactive() : Boolean
      {
         return _interactive;
      }
      
      public function get autoScaleToStage() : Boolean
      {
         return _autoScaleToStage;
      }
      
      public function hitTestPointObject(param1:Point, param2:DisplayObject3D) : RenderHitData
      {
         var _loc3_:RenderableListItem = null;
         var _loc4_:RenderHitData = null;
         var _loc5_:IRenderListItem = null;
         var _loc6_:uint = 0;
         if(interactive)
         {
            _loc4_ = new RenderHitData();
            _loc6_ = lastRenderList.length;
            while(true)
            {
               _loc5_ = lastRenderList[--_loc6_];
               if(!_loc5_)
               {
                  break;
               }
               if(_loc5_ is RenderableListItem)
               {
                  _loc3_ = _loc5_ as RenderableListItem;
                  if(_loc3_.renderableInstance is Triangle3D)
                  {
                     if(Triangle3D(_loc3_.renderableInstance).instance == param2)
                     {
                        _loc4_ = _loc3_.hitTestPoint2D(param1,_loc4_);
                        if(_loc4_.hasHit)
                        {
                           return _loc4_;
                        }
                     }
                  }
               }
            }
         }
         return new RenderHitData();
      }
      
      public function hitTestPoint2D(param1:Point) : RenderHitData
      {
         var _loc2_:RenderableListItem = null;
         var _loc3_:RenderHitData = null;
         var _loc4_:IRenderListItem = null;
         var _loc5_:uint = 0;
         renderHitData.clear();
         if(interactive)
         {
            _loc3_ = renderHitData;
            _loc5_ = lastRenderList.length;
            while(true)
            {
               _loc4_ = lastRenderList[--_loc5_];
               if(!_loc4_)
               {
                  break;
               }
               if(_loc4_ is RenderableListItem)
               {
                  _loc2_ = _loc4_ as RenderableListItem;
                  _loc3_ = _loc2_.hitTestPoint2D(param1,_loc3_);
                  if(_loc3_.hasHit)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return renderHitData;
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,onStageResize);
      }
      
      public function get viewportHeight() : Number
      {
         return _height;
      }
      
      public function destroy() : void
      {
         if(interactiveSceneManager)
         {
            interactiveSceneManager.destroy();
            interactiveSceneManager = null;
         }
         lastRenderList = null;
      }
      
      public function get viewportObjectFilter() : ViewportObjectFilter
      {
         return _viewportObjectFilter;
      }
   }
}

