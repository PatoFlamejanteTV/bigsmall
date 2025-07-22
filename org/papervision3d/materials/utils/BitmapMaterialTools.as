package org.papervision3d.materials.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import org.papervision3d.materials.BitmapMaterial;
   
   public class BitmapMaterialTools
   {
      
      public function BitmapMaterialTools()
      {
         super();
      }
      
      public static function createBitmapMaterial(param1:Class, param2:Boolean = true) : BitmapMaterial
      {
         var _loc3_:BitmapData = getTexture(param1);
         var _loc4_:BitmapMaterial = new BitmapMaterial(_loc3_);
         _loc4_.oneSide = param2;
         return _loc4_;
      }
      
      public static function mirrorBitmapY(param1:BitmapData) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.clone());
         _loc2_.scaleY = -1;
         _loc2_.y = param1.height;
         param1.draw(_loc2_,_loc2_.transform.matrix);
         _loc2_.bitmapData.dispose();
      }
      
      public static function mirrorBitmapX(param1:BitmapData) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.clone());
         _loc2_.scaleX = -1;
         _loc2_.x = param1.width;
         param1.draw(_loc2_,_loc2_.transform.matrix);
         _loc2_.bitmapData.dispose();
      }
      
      public static function getTexture(param1:Class) : BitmapData
      {
         var _loc2_:Bitmap = Bitmap(new param1());
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
         _loc3_.draw(_loc2_,new Matrix());
         return _loc3_;
      }
   }
}

