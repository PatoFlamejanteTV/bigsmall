package org.papervision3d.core.render.data
{
   import org.papervision3d.core.geom.renderables.IRenderable;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class RenderHitData
   {
      
      public var y:Number;
      
      public var z:Number;
      
      public var endTime:int = 0;
      
      public var startTime:int = 0;
      
      public var displayObject3D:DisplayObject3D;
      
      public var hasHit:Boolean = false;
      
      public var material:MaterialObject3D;
      
      public var renderable:IRenderable;
      
      public var u:Number;
      
      public var v:Number;
      
      public var x:Number;
      
      public function RenderHitData()
      {
         super();
      }
      
      public function clear() : void
      {
         startTime = 0;
         endTime = 0;
         hasHit = false;
         displayObject3D = null;
         material = null;
         renderable = null;
         u = 0;
         v = 0;
         x = 0;
         y = 0;
         z = 0;
      }
      
      public function clone() : RenderHitData
      {
         var _loc1_:RenderHitData = new RenderHitData();
         _loc1_.startTime = startTime;
         _loc1_.endTime = endTime;
         _loc1_.hasHit = hasHit;
         _loc1_.displayObject3D = displayObject3D;
         _loc1_.material = material;
         _loc1_.renderable = renderable;
         _loc1_.u = u;
         _loc1_.v = v;
         _loc1_.x = x;
         _loc1_.y = y;
         _loc1_.z = z;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return displayObject3D + " " + renderable;
      }
   }
}

