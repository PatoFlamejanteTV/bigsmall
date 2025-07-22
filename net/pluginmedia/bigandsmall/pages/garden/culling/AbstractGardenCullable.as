package net.pluginmedia.bigandsmall.pages.garden.culling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.pages.garden.interfaces.IGardenCullable;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class AbstractGardenCullable implements IGardenCullable
   {
      
      protected var do3dParent:DisplayObjectContainer3D;
      
      protected var cullPoints:Array;
      
      protected var do3d:DisplayObject3D;
      
      public function AbstractGardenCullable(param1:DisplayObject3D)
      {
         super();
         this.do3d = param1;
         do3dParent = param1.parent;
         cullPoints = [];
      }
      
      public function get referringDisplayObject3D() : DisplayObject3D
      {
         return do3d;
      }
      
      public function get points() : Array
      {
         return cullPoints;
      }
      
      public function initCullPoints() : void
      {
      }
      
      public function manuallyDefineCullRect(param1:Rectangle) : void
      {
         cullPoints = [];
         cullPoints.push(param1.topLeft);
         cullPoints.push(new Point(param1.right,param1.top));
         cullPoints.push(param1.bottomRight);
         cullPoints.push(new Point(param1.left,param1.bottom));
      }
      
      public function checkIsIn(param1:Number, param2:Number) : Boolean
      {
         return false;
      }
      
      public function get referringDisplayObject3DParent() : DisplayObjectContainer3D
      {
         return do3dParent;
      }
   }
}

