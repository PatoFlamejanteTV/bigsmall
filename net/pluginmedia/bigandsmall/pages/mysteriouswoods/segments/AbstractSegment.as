package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.pv3d.DAEFixed;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   import org.papervision3d.view.layer.util.ViewportLayerSortMode;
   
   public class AbstractSegment extends DisplayObject3D
   {
      
      public var previousSegmentPath:String;
      
      public var previousSegment:PathSegment;
      
      protected var dae:DisplayObject3D;
      
      public var compLayer:ViewportLayer;
      
      protected var woodsLayer:ViewportLayer;
      
      protected var geomLayer:ViewportLayer;
      
      protected var _orientation:Number = 0;
      
      public var segmentSize:Number;
      
      protected var uiLayer:ViewportLayer;
      
      protected var currentPOV:String;
      
      protected var _resources:ResourceController;
      
      protected var _dirtyLayers:Array = [];
      
      protected var floorTex:BitmapMaterial;
      
      public function AbstractSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:Number = 1200, param6:Boolean = false)
      {
         super();
         uiLayer = param1;
         compLayer = param2;
         compLayer.sortMode = ViewportLayerSortMode.INDEX_SORT;
         geomLayer = compLayer.getChildLayer(new DisplayObject3D(),true);
         geomLayer.layerIndex = 1;
         geomLayer.mouseEnabled = false;
         geomLayer.mouseChildren = false;
         woodsLayer = compLayer.getChildLayer(new DisplayObject3D(),true);
         woodsLayer.layerIndex = 2;
         woodsLayer.mouseEnabled = false;
         woodsLayer.mouseChildren = false;
         _resources = param4;
         segmentSize = param5;
         init();
         buildDisplay(param3,param6);
      }
      
      public function get cameraPlacement() : Number3D
      {
         var _loc1_:Number3D = this.position;
         _loc1_.z -= 500;
         return _loc1_;
      }
      
      public function prepare() : void
      {
      }
      
      public function unflagDirtyLayer(param1:ViewportLayer) : void
      {
         var _loc2_:int = int(_dirtyLayers.indexOf(param1));
         if(_loc2_ != -1)
         {
            _dirtyLayers.splice(_loc2_,1);
         }
      }
      
      public function activate() : void
      {
      }
      
      public function get orientation() : Number
      {
         return -_orientation;
      }
      
      protected function init() : void
      {
      }
      
      public function set orientation(param1:Number) : void
      {
         _orientation = -param1;
         rotationY = param1;
      }
      
      public function get dirtyLayers() : Array
      {
         return _dirtyLayers;
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
      }
      
      public function flagDirtyLayer(param1:ViewportLayer) : void
      {
         if(_dirtyLayers.indexOf(param1) == -1)
         {
            _dirtyLayers.push(param1);
         }
      }
      
      protected function buildDisplay(param1:DAEFixed, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:DisplayObject3D = null;
         var _loc5_:DisplayObject3D = null;
         dae = param1.clone();
         dae.scale = 25;
         dae.rotationY = 180;
         addChild(dae);
         if(param2)
         {
            dae.scaleX *= -1;
            flipMats(dae);
         }
         for each(_loc3_ in dae.children)
         {
            if(_loc3_.name.indexOf("COLLADA_Scene") > -1)
            {
               for each(_loc4_ in _loc3_.children)
               {
                  if(_loc4_.name.indexOf("floor") > -1)
                  {
                     geomLayer.addDisplayObject3D(_loc4_,true);
                  }
                  else if(_loc4_.name.indexOf("junction") > -1 || _loc4_.name.indexOf("reward") > -1)
                  {
                     for each(_loc5_ in _loc4_.children)
                     {
                        if(_loc5_.name.indexOf("floor") > -1)
                        {
                           geomLayer.addDisplayObject3D(_loc5_,true);
                        }
                        else if(_loc5_.name.indexOf("trees") > -1)
                        {
                           woodsLayer.addDisplayObject3D(_loc5_,true);
                        }
                     }
                  }
                  else
                  {
                     woodsLayer.addDisplayObject3D(_loc4_,true);
                  }
               }
            }
         }
      }
      
      protected function flipMats(param1:DisplayObject3D) : void
      {
         var _loc2_:DisplayObject3D = null;
         var _loc3_:Triangle3D = null;
         var _loc4_:Vertex3D = null;
         var _loc5_:NumberUV = null;
         for each(_loc2_ in param1.children)
         {
            flipMats(_loc2_);
         }
         if(param1.geometry)
         {
            for each(_loc3_ in param1.geometry.faces)
            {
               _loc4_ = _loc3_.v0;
               _loc3_.v0 = _loc3_.v2;
               _loc3_.v2 = _loc4_;
               _loc5_ = _loc3_.uv0;
               _loc3_.uv0 = _loc3_.uv2;
               _loc3_.uv2 = _loc5_;
            }
         }
      }
      
      public function deactivate() : void
      {
         _dirtyLayers = [];
      }
      
      public function park() : void
      {
      }
   }
}

