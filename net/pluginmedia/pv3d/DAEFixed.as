package net.pluginmedia.pv3d
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import org.ascollada.core.*;
   import org.ascollada.fx.*;
   import org.ascollada.namespaces.*;
   import org.ascollada.types.*;
   import org.papervision3d.core.animation.*;
   import org.papervision3d.core.animation.channel.*;
   import org.papervision3d.core.geom.*;
   import org.papervision3d.core.geom.renderables.*;
   import org.papervision3d.core.math.*;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.events.FileLoadEvent;
   import org.papervision3d.materials.*;
   import org.papervision3d.materials.special.*;
   import org.papervision3d.materials.utils.*;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.parsers.DAE;
   import org.papervision3d.objects.special.Skin3D;
   
   public class DAEFixed extends DAE
   {
      
      protected var _queuedMaterialsLength:int;
      
      public var parserBulkProgressQuota:Number = 0.25;
      
      protected var _parserProgress:Number = 0;
      
      protected var _loadingMaterialProgress:Number;
      
      protected var _parserComplete:Boolean = false;
      
      protected var _isLowTexMemMode:Boolean;
      
      protected const lowMemBmpSrc:BitmapData = new BitmapData(10,10,false,16711680);
      
      protected var processSuspended:Boolean = false;
      
      public function DAEFixed(param1:Boolean = true, param2:String = null, param3:Boolean = false)
      {
         super(param1,param2,param3);
         forceCoordSet = 0;
      }
      
      protected function onMaterialProgress(param1:FileLoadEvent) : void
      {
         _loadingMaterialProgress = Number(param1.bytesLoaded / param1.bytesTotal);
         dispatchBulkLoadEvent();
      }
      
      override protected function onParseComplete(param1:Event) : void
      {
         _parserComplete = true;
         super.onParseComplete(param1);
      }
      
      protected function dispatchBulkLoadEvent(param1:Number = -1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         if(param1 < 0 || param1 > 1)
         {
            _loc4_ = _parserProgress * parserBulkProgressQuota;
            _loc5_ = uint(_queuedMaterialsLength - _queuedMaterials.length);
            _loc6_ = (_loc5_ - 1 + _loadingMaterialProgress) / _queuedMaterialsLength * (1 - parserBulkProgressQuota);
            param1 = _loc4_ + _loc6_;
         }
         var _loc2_:Number = param1 * 10000;
         var _loc3_:Number = 10000;
         dispatchEvent(new DAELoadProgressEvent(DAELoadProgressEvent.LOAD_PROGRESS,param1,_loc3_,_loc2_));
      }
      
      public function destroy() : void
      {
         unloadBitmaps();
      }
      
      override protected function buildVertices(param1:DaeMesh) : Array
      {
         if(processSuspended)
         {
            return null;
         }
         return super.buildVertices(param1);
      }
      
      override protected function buildNode(param1:DaeNode, param2:DisplayObject3D) : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildNode(param1,param2);
      }
      
      public function reloadBitmaps() : void
      {
         var _loc1_:MaterialObject3D = null;
         var _loc2_:BitmapFileMaterial = null;
         for each(_loc1_ in this.materials.materialsByName)
         {
            _loc2_ = _loc1_ as BitmapFileMaterial;
            if(!_loc2_)
            {
            }
         }
      }
      
      override protected function buildImagePath(param1:String, param2:String) : String
      {
         if(processSuspended)
         {
            return null;
         }
         return super.buildImagePath(param1,param2);
      }
      
      override protected function buildSkin(param1:Skin3D, param2:DaeSkin, param3:Array, param4:DaeNode) : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildSkin(param1,param2,param3,param4);
      }
      
      override protected function buildGeometries() : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildGeometries();
      }
      
      override protected function buildFileInfo(param1:*) : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildFileInfo(param1);
      }
      
      override protected function onParseProgress(param1:ProgressEvent) : void
      {
         _parserProgress = param1.bytesLoaded / param1.bytesTotal;
         dispatchBulkLoadEvent(_parserProgress * parserBulkProgressQuota);
      }
      
      private function onMaterialIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function unloadBitmaps() : void
      {
         var _loc1_:MaterialObject3D = null;
         for each(_loc1_ in this.materials.materialsByName)
         {
            if(_loc1_ is BitmapFileMaterial)
            {
            }
         }
      }
      
      override protected function buildFaces(param1:DaePrimitive, param2:GeometryObject3D, param3:uint) : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildFaces(param1,param2,param3);
      }
      
      override protected function buildMaterials() : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildMaterials();
         _queuedMaterialsLength = _queuedMaterials.length;
      }
      
      override protected function loadNextMaterial(param1:FileLoadEvent = null) : void
      {
         var _loc2_:BitmapFileMaterial = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:BitmapFileMaterial = null;
         if(processSuspended)
         {
            return;
         }
         if(param1)
         {
            _loadingMaterialProgress = 0;
            dispatchBulkLoadEvent();
            param1.target.removeEventListener(FileLoadEvent.LOAD_COMPLETE,loadNextMaterial);
            param1.target.removeEventListener(FileLoadEvent.LOAD_ERROR,onMaterialError);
            param1.target.removeEventListener(FileLoadEvent.LOAD_PROGRESS,onMaterialProgress);
            _loc2_ = param1.target as BitmapFileMaterial;
            if(_rightHanded && Boolean(_loc2_))
            {
               BitmapMaterialTools.mirrorBitmapX(_loc2_.bitmap);
            }
         }
         if(_queuedMaterials.length)
         {
            _loc3_ = _queuedMaterials.shift();
            _loc4_ = _loc3_.url;
            _loc5_ = _loc3_.symbol;
            _loc6_ = _loc3_.target;
            _loc4_ = String(_loc4_.replace(/\.tga/i,"." + DEFAULT_TGA_ALTERNATIVE)).toLowerCase();
            _loc7_ = _loc3_.material;
            _loc7_.addEventListener(FileLoadEvent.LOAD_COMPLETE,loadNextMaterial);
            _loc7_.addEventListener(FileLoadEvent.LOAD_ERROR,onMaterialError);
            _loc7_.addEventListener(FileLoadEvent.LOAD_PROGRESS,onMaterialProgress);
            _loc7_.texture = _loc4_;
            if(useMaterialTargetName)
            {
               _loc7_.name = _loc6_;
               this.materials.addMaterial(_loc7_,_loc6_);
            }
            else
            {
               _loc7_.name = _loc5_;
               this.materials.addMaterial(_loc7_,_loc5_);
            }
         }
         else
         {
            dispatchEvent(new FileLoadEvent(FileLoadEvent.COLLADA_MATERIALS_DONE,this.filename));
            onMaterialsLoaded();
         }
      }
      
      public function killAllProcesses() : void
      {
         processSuspended = true;
      }
      
      override protected function buildAnimationChannel(param1:DisplayObject3D, param2:DaeChannel) : MatrixChannel3D
      {
         if(processSuspended)
         {
            return null;
         }
         return super.buildAnimationChannel(param1,param2);
      }
      
      override protected function buildScene() : void
      {
         if(processSuspended)
         {
            return;
         }
         super.buildScene();
         dispatchBulkLoadEvent(1);
      }
   }
}

