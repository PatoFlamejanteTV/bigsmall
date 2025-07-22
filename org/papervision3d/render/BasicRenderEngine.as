package org.papervision3d.render
{
   import flash.geom.Point;
   import org.papervision3d.core.clipping.DefaultClipping;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.AbstractRenderEngine;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.data.RenderStatistics;
   import org.papervision3d.core.render.filter.BasicRenderFilter;
   import org.papervision3d.core.render.filter.IRenderFilter;
   import org.papervision3d.core.render.material.MaterialManager;
   import org.papervision3d.core.render.project.BasicProjectionPipeline;
   import org.papervision3d.core.render.project.ProjectionPipeline;
   import org.papervision3d.core.render.sort.BasicRenderSorter;
   import org.papervision3d.core.render.sort.IRenderSorter;
   import org.papervision3d.core.utils.StopWatch;
   import org.papervision3d.events.RendererEvent;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BasicRenderEngine extends AbstractRenderEngine implements IRenderEngine
   {
      
      public var clipping:DefaultClipping;
      
      protected var renderDoneEvent:RendererEvent;
      
      public var sorter:IRenderSorter;
      
      public var projectionPipeline:ProjectionPipeline;
      
      protected var renderList:Array;
      
      protected var renderStatistics:RenderStatistics;
      
      protected var cleanRHD:RenderHitData = new RenderHitData();
      
      protected var projectionDoneEvent:RendererEvent;
      
      protected var renderSessionData:RenderSessionData;
      
      protected var stopWatch:StopWatch;
      
      public var filter:IRenderFilter;
      
      public function BasicRenderEngine()
      {
         super();
         init();
      }
      
      protected function doRender(param1:RenderSessionData, param2:Array = null) : RenderStatistics
      {
         var _loc3_:RenderableListItem = null;
         var _loc5_:ViewportLayer = null;
         stopWatch.reset();
         stopWatch.start();
         MaterialManager.getInstance().updateMaterialsBeforeRender(param1);
         filter.filter(renderList);
         sorter.sort(renderList);
         var _loc4_:Viewport3D = param1.viewPort;
         while(true)
         {
            _loc3_ = renderList.pop();
            if(!_loc3_)
            {
               break;
            }
            _loc5_ = _loc4_.accessLayerFor(_loc3_,true);
            _loc3_.render(param1,_loc5_.graphicsChannel);
            _loc4_.lastRenderList.push(_loc3_);
            _loc5_.processRenderItem(_loc3_);
         }
         MaterialManager.getInstance().updateMaterialsAfterRender(param1);
         param1.renderStatistics.renderTime = stopWatch.stop();
         param1.viewPort.updateAfterRender(param1);
         return renderStatistics;
      }
      
      protected function init() : void
      {
         renderStatistics = new RenderStatistics();
         projectionPipeline = new BasicProjectionPipeline();
         stopWatch = new StopWatch();
         sorter = new BasicRenderSorter();
         filter = new BasicRenderFilter();
         renderList = new Array();
         clipping = null;
         renderSessionData = new RenderSessionData();
         renderSessionData.renderer = this;
         projectionDoneEvent = new RendererEvent(RendererEvent.PROJECTION_DONE,renderSessionData);
         renderDoneEvent = new RendererEvent(RendererEvent.RENDER_DONE,renderSessionData);
      }
      
      override public function renderScene(param1:SceneObject3D, param2:CameraObject3D, param3:Viewport3D) : RenderStatistics
      {
         param2.viewport = param3.sizeRectangle;
         renderSessionData.scene = param1;
         renderSessionData.camera = param2;
         renderSessionData.viewPort = param3;
         renderSessionData.container = param3.containerSprite;
         renderSessionData.triangleCuller = param3.triangleCuller;
         renderSessionData.particleCuller = param3.particleCuller;
         renderSessionData.renderObjects = param1.objects;
         renderSessionData.renderLayers = null;
         renderSessionData.renderStatistics.clear();
         renderSessionData.clipping = clipping;
         if(clipping)
         {
            clipping.reset(renderSessionData);
         }
         param3.updateBeforeRender(renderSessionData);
         projectionPipeline.project(renderSessionData);
         if(hasEventListener(RendererEvent.PROJECTION_DONE))
         {
            dispatchEvent(projectionDoneEvent);
         }
         doRender(renderSessionData,null);
         if(hasEventListener(RendererEvent.RENDER_DONE))
         {
            dispatchEvent(renderDoneEvent);
         }
         return renderSessionData.renderStatistics;
      }
      
      public function hitTestPoint2D(param1:Point, param2:Viewport3D) : RenderHitData
      {
         return param2.hitTestPoint2D(param1);
      }
      
      override public function removeFromRenderList(param1:IRenderListItem) : int
      {
         return renderList.splice(renderList.indexOf(param1),1);
      }
      
      override public function addToRenderList(param1:RenderableListItem) : int
      {
         return renderList.push(param1);
      }
      
      private function getLayerObjects(param1:Array) : Array
      {
         var _loc3_:ViewportLayer = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc2_.concat(_loc3_.getLayerObjects());
         }
         return _loc2_;
      }
      
      public function destroy() : void
      {
         renderDoneEvent = null;
         projectionDoneEvent = null;
         projectionPipeline = null;
         sorter = null;
         filter = null;
         renderStatistics = null;
         renderList = null;
         renderSessionData.destroy();
         renderSessionData = null;
         cleanRHD = null;
         stopWatch = null;
         clipping = null;
      }
      
      public function renderLayers(param1:SceneObject3D, param2:CameraObject3D, param3:Viewport3D, param4:Array = null) : RenderStatistics
      {
         renderSessionData.scene = param1;
         renderSessionData.camera = param2;
         renderSessionData.viewPort = param3;
         renderSessionData.container = param3.containerSprite;
         renderSessionData.triangleCuller = param3.triangleCuller;
         renderSessionData.particleCuller = param3.particleCuller;
         renderSessionData.renderObjects = getLayerObjects(param4);
         renderSessionData.renderLayers = param4;
         renderSessionData.renderStatistics.clear();
         renderSessionData.clipping = clipping;
         param3.updateBeforeRender(renderSessionData);
         projectionPipeline.project(renderSessionData);
         if(hasEventListener(RendererEvent.PROJECTION_DONE))
         {
            dispatchEvent(projectionDoneEvent);
         }
         doRender(renderSessionData);
         if(hasEventListener(RendererEvent.RENDER_DONE))
         {
            dispatchEvent(renderDoneEvent);
         }
         return renderSessionData.renderStatistics;
      }
   }
}

