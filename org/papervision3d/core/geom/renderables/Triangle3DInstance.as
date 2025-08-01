package org.papervision3d.core.geom.renderables
{
   import flash.display.Sprite;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Triangle3DInstance
   {
      
      public var container:Sprite;
      
      public var instance:DisplayObject3D;
      
      public var visible:Boolean = false;
      
      public var faceNormal:Number3D;
      
      public var screenZ:Number;
      
      public function Triangle3DInstance(param1:Triangle3D, param2:DisplayObject3D)
      {
         super();
         this.instance = param2;
         faceNormal = new Number3D();
      }
   }
}

