package org.papervision3d.core.proto
{
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Sphere;
   
   public class LightObject3D extends DisplayObject3D
   {
      
      public var flipped:Boolean;
      
      public var lightMatrix:Matrix3D;
      
      private var _showLight:Boolean;
      
      private var displaySphere:Sphere;
      
      public function LightObject3D(param1:Boolean = false, param2:Boolean = false)
      {
         super();
         this.lightMatrix = Matrix3D.IDENTITY;
         this.showLight = param1;
         this.flipped = param2;
      }
      
      public function get showLight() : Boolean
      {
         return _showLight;
      }
      
      public function set showLight(param1:Boolean) : void
      {
         if(_showLight)
         {
            removeChild(displaySphere);
         }
         if(param1)
         {
            displaySphere = new Sphere(new WireframeMaterial(16776960),10,3,2);
            addChild(displaySphere);
         }
         _showLight = param1;
      }
   }
}

