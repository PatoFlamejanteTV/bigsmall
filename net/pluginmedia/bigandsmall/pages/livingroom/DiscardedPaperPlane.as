package net.pluginmedia.bigandsmall.pages.livingroom
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class DiscardedPaperPlane extends Plane
   {
      
      public var colourTrans:ColorTransform = new ColorTransform();
      
      public var spreadX:Number = 10;
      
      public var spreadY:Number = 10;
      
      public var bitmapData:BitmapData;
      
      public function DiscardedPaperPlane(param1:int = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 30, param7:Number = 30)
      {
         bitmapData = new BitmapData(param2 * 4,param3 * 4,true,param1);
         this.spreadX = param6;
         this.spreadY = param7;
         var _loc8_:BitmapMaterial = new BitmapMaterial(bitmapData);
         _loc8_.interactive = true;
         _loc8_.smooth = true;
         super(_loc8_,param2,param3,param4,param5);
         autoCalcScreenCoords = true;
      }
      
      public function capture(param1:BitmapData, param2:Number = 1) : void
      {
         var _loc3_:Bitmap = new Bitmap(param1,"auto",true);
         var _loc4_:Sprite = new Sprite();
         _loc4_.addChild(_loc3_);
         _loc3_.x -= _loc3_.width / 2;
         _loc3_.y -= _loc3_.height / 2;
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(param2,param2);
         _loc5_.rotate(Math.random() * 360);
         var _loc6_:Number = bitmapData.width / 2 + SuperMath.random(-spreadX,spreadX);
         var _loc7_:Number = bitmapData.height / 2 + SuperMath.random(-spreadY,spreadY);
         _loc5_.translate(_loc6_,_loc7_);
         bitmapData.draw(_loc4_,_loc5_,colourTrans,null,null,true);
         _loc4_ = null;
      }
   }
}

