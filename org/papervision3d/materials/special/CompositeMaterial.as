package org.papervision3d.materials.special
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CompositeMaterial extends TriangleMaterial implements ITriangleDrawer
   {
      
      public var materials:Array;
      
      public function CompositeMaterial()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         materials = new Array();
      }
      
      override public function registerObject(param1:DisplayObject3D) : void
      {
         var _loc2_:MaterialObject3D = null;
         super.registerObject(param1);
         for each(_loc2_ in materials)
         {
            _loc2_.registerObject(param1);
         }
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:MaterialObject3D = null;
         for each(_loc6_ in materials)
         {
            if(!_loc6_.invisible)
            {
               _loc6_.drawTriangle(param1,param2,param3);
            }
         }
      }
      
      public function removeAllMaterials() : void
      {
         materials = new Array();
      }
      
      override public function unregisterObject(param1:DisplayObject3D) : void
      {
         var _loc2_:MaterialObject3D = null;
         super.unregisterObject(param1);
         for each(_loc2_ in materials)
         {
            _loc2_.unregisterObject(param1);
         }
      }
      
      public function removeMaterial(param1:MaterialObject3D) : void
      {
         materials.splice(materials.indexOf(param1),1);
      }
      
      public function addMaterial(param1:MaterialObject3D) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject3D = null;
         materials.push(param1);
         for(_loc2_ in objects)
         {
            _loc3_ = _loc2_ as DisplayObject3D;
            param1.registerObject(_loc3_);
         }
      }
   }
}

