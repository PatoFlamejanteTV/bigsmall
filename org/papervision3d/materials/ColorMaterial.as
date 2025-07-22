package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   
   public class ColorMaterial extends TriangleMaterial implements ITriangleDrawer
   {
      
      public function ColorMaterial(param1:Number = 16711935, param2:Number = 1, param3:Boolean = false)
      {
         super();
         this.fillColor = param1;
         this.fillAlpha = param2;
         this.interactive = param3;
      }
      
      override public function toString() : String
      {
         return "ColorMaterial - color:" + this.fillColor + " alpha:" + this.fillAlpha;
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:Number = param1.v0.x;
         var _loc7_:Number = param1.v0.y;
         var _loc8_:Number = param1.v1.x;
         var _loc9_:Number = param1.v1.y;
         var _loc10_:Number = param1.v2.x;
         var _loc11_:Number = param1.v2.y;
         param2.beginFill(fillColor,fillAlpha);
         param2.moveTo(_loc6_,_loc7_);
         param2.lineTo(_loc8_,_loc9_);
         param2.lineTo(_loc10_,_loc11_);
         param2.lineTo(_loc6_,_loc7_);
         param2.endFill();
         ++param3.renderStatistics.triangles;
      }
      
      override public function clone() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = new ColorMaterial();
         _loc1_.copy(this);
         return _loc1_;
      }
   }
}

