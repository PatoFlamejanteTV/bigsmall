package org.papervision3d.core.material
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.proto.LightObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   import org.papervision3d.materials.utils.LightMatrix;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class AbstractLightShadeMaterial extends TriangleMaterial implements ITriangleDrawer, IUpdateBeforeMaterial
   {
      
      protected static var lightMatrix:Matrix3D;
      
      public var lightMatrices:Dictionary;
      
      private var _light:LightObject3D;
      
      public function AbstractLightShadeMaterial()
      {
         super();
         init();
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject3D = null;
         for(_loc2_ in objects)
         {
            _loc3_ = _loc2_ as DisplayObject3D;
            lightMatrices[_loc2_] = LightMatrix.getLightMatrix(light,_loc3_,param1,lightMatrices[_loc2_]);
         }
      }
      
      protected function init() : void
      {
         lightMatrices = new Dictionary();
      }
      
      public function get light() : LightObject3D
      {
         return _light;
      }
      
      public function set light(param1:LightObject3D) : void
      {
         _light = param1;
      }
   }
}

