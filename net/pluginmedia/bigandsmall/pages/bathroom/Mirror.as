package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.shared.MirrorImageInfo;
   import net.pluginmedia.pv3d.materials.MirrorMaterial;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.special.CompositeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   
   public class Mirror extends EventDispatcher
   {
      
      public var filterPoint:Point = new Point();
      
      private var mirrorMaterial:MirrorMaterial;
      
      private var targetDisplayObject:DisplayObject3D;
      
      private var mirrorBitmapData:BitmapData;
      
      private var defaultBitmapData:BitmapData;
      
      private var cTweenDamping:Number = 1;
      
      private var viewport:Viewport3D;
      
      private var defaultCustomReflectionData:BitmapData;
      
      public var customReflectionBMPData:BitmapData;
      
      private var cVert:Vertex3D;
      
      public var blurFilter:BlurFilter = new BlurFilter(2,2);
      
      public var customReflectionMaterial:MirrorMaterial;
      
      private var bigData:BitmapData;
      
      private var cMirrorInfo:MirrorImageInfo;
      
      private var smallData:BitmapData;
      
      private var compositeMaterial:CompositeMaterial;
      
      private var labelledData:Dictionary = new Dictionary();
      
      private var frostingMaterial:MaterialObject3D;
      
      private var mirrorMatrix:Matrix;
      
      public var lighterTransform:ColorTransform = new ColorTransform(1,1,1,1,-40,-40,-40);
      
      private var _builtSnapshots:Boolean = false;
      
      private var _usingDefault:Boolean = false;
      
      private var defaultCol:uint = 15261650;
      
      public function Mirror(param1:Viewport3D, param2:DisplayObject3D)
      {
         super();
         viewport = param1;
         mirrorMatrix = new Matrix();
         targetDisplayObject = param2;
         frostingMaterial = Triangle3D(targetDisplayObject.geometry.faces[0]).material;
         cVert = new Vertex3D(0,0,0);
         targetDisplayObject.geometry.vertices.push(cVert);
         targetDisplayObject.geometry.ready = true;
         targetDisplayObject.geometry.dirty = true;
         defaultBitmapData = new BitmapData(viewport.viewportWidth,viewport.viewportHeight,false,defaultCol);
         mirrorBitmapData = new BitmapData(viewport.viewportWidth,viewport.viewportHeight,false,defaultCol);
         compositeMaterial = new CompositeMaterial();
         mirrorMaterial = new MirrorMaterial(mirrorBitmapData,1,false,defaultCol);
         mirrorMaterial.setDistanceVertex(cVert);
         defaultCustomReflectionData = new BitmapData(1,1,true,0);
         customReflectionMaterial = new MirrorMaterial(defaultCustomReflectionData,1,true,0);
         customReflectionMaterial.setDistanceVertex(cVert);
         compositeMaterial.addMaterial(mirrorMaterial);
         compositeMaterial.addMaterial(customReflectionMaterial);
         compositeMaterial.addMaterial(frostingMaterial);
         targetDisplayObject.material = compositeMaterial;
      }
      
      public function useDefaultData() : void
      {
         mirrorMaterial.bitmap.copyPixels(defaultBitmapData,defaultBitmapData.rect,filterPoint);
         _usingDefault = true;
      }
      
      public function set matScale(param1:Number) : void
      {
         mirrorMaterial.scale = param1;
      }
      
      public function get usingDefault() : Boolean
      {
         return _usingDefault;
      }
      
      public function releaseCustomReflection() : void
      {
         bindCustomReflection(defaultCustomReflectionData,1);
      }
      
      public function registerLabelledData(param1:String, param2:BitmapData, param3:Number, param4:Number, param5:Number, param6:Number = 1.45) : void
      {
         param2.applyFilter(param2,param2.rect,filterPoint,blurFilter);
         param2.colorTransform(param2.rect,lighterTransform);
         labelledData[param1] = new MirrorImageInfo(param1,param2,param3,param4,param5,param6);
      }
      
      private function updateManualMov() : void
      {
         var _loc1_:Number = 0.5;
         if(KeyUtils.isDown(Keyboard.UP))
         {
            cVert.y += _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.DOWN))
         {
            cVert.y -= _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.LEFT))
         {
            cVert.x += _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.RIGHT))
         {
            cVert.x -= _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_0))
         {
            cVert.z += _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_1))
         {
            cVert.z -= _loc1_;
         }
         if(KeyUtils.isDown(Keyboard.SPACE))
         {
            trace("/ cVert /---->");
            trace(cVert.x,cVert.y,cVert.z);
            trace("---->");
         }
      }
      
      private function updateTween() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(cMirrorInfo)
         {
            _loc1_ = 0;
            _loc2_ = cMirrorInfo.x - cVert.x;
            _loc1_ += Math.abs(_loc2_);
            _loc3_ = cMirrorInfo.y - cVert.y;
            _loc1_ += Math.abs(_loc3_);
            _loc4_ = cMirrorInfo.z - cVert.z;
            _loc1_ += Math.abs(_loc4_);
            _loc5_ = cMirrorInfo.scale - mirrorMaterial.scale;
            _loc1_ += Math.abs(_loc5_);
            cVert.x += _loc2_ * cTweenDamping;
            cVert.y += _loc3_ * cTweenDamping;
            cVert.z += _loc4_ * cTweenDamping;
            mirrorMaterial.scale += _loc5_ * cTweenDamping;
            if(_loc1_ < 0.05)
            {
               snapToInfo(cMirrorInfo);
               cMirrorInfo = null;
            }
         }
      }
      
      public function update() : void
      {
         updateTween();
      }
      
      public function snapToInfo(param1:MirrorImageInfo) : void
      {
         cVert.x = param1.x;
         cVert.y = param1.y;
         cVert.z = param1.z;
         mirrorMaterial.bitmap.copyPixels(param1.bitmapData,param1.bitmapData.rect,filterPoint);
         mirrorMaterial.scale = param1.scale;
         cMirrorInfo = null;
      }
      
      public function get builtSnapshots() : Boolean
      {
         return _builtSnapshots;
      }
      
      public function bindCustomReflection(param1:BitmapData, param2:Number = 1) : void
      {
         customReflectionBMPData = param1;
         customReflectionMaterial.bitmap = customReflectionBMPData;
         customReflectionMaterial.scale = param2;
      }
      
      public function selectLabelledData(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:MirrorImageInfo = labelledData[param1] as MirrorImageInfo;
         if(!_loc3_)
         {
            return;
         }
         if(param2)
         {
            snapToInfo(_loc3_);
            return;
         }
         cMirrorInfo = _loc3_;
         mirrorMaterial.bitmap.copyPixels(cMirrorInfo.bitmapData,cMirrorInfo.bitmapData.rect,filterPoint);
      }
   }
}

