package net.pluginmedia.bigandsmall.pages.livingroom
{
   import flash.display.BitmapData;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class CompDiscardedPaperPlane extends DisplayObject3D
   {
      
      public var oldPaperPlanes:Array = [];
      
      public function CompDiscardedPaperPlane(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         z = param3;
      }
      
      public function getRandomTargetPlane() : DiscardedPaperPlane
      {
         var _loc1_:Number = Math.round(Math.random() * (oldPaperPlanes.length - 1));
         return oldPaperPlanes[_loc1_];
      }
      
      public function captureSheet(param1:BitmapData, param2:Number = 1) : void
      {
         getRandomTargetPlane().capture(param1,param2);
      }
      
      public function registerDPPlane(param1:DiscardedPaperPlane) : void
      {
         addChild(param1);
         oldPaperPlanes.push(param1);
      }
      
      public function setupLayers(param1:Viewport3D) : Array
      {
         var _loc4_:DiscardedPaperPlane = null;
         var _loc5_:ViewportLayer = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < oldPaperPlanes.length)
         {
            _loc4_ = oldPaperPlanes[_loc3_] as DiscardedPaperPlane;
            _loc5_ = param1.getChildLayer(_loc4_,true);
            _loc2_.push(_loc5_);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

