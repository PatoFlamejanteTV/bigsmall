package net.pluginmedia.bigandsmall.pages.livingroom.drawinggame
{
   import flash.display.BitmapData;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class Paper extends Plane
   {
      
      public var bitmapData:BitmapData;
      
      public function Paper(param1:BitmapData, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0)
      {
         bitmapData = param1;
         var _loc6_:BitmapMaterial = new BitmapMaterial(bitmapData);
         _loc6_.interactive = true;
         _loc6_.smooth = true;
         _loc6_.doubleSided = true;
         super(_loc6_,param2,param3,param4,param5);
         autoCalcScreenCoords = true;
      }
   }
}

