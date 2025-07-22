package net.pluginmedia.bigandsmall.core.mesh
{
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ReflectionPlane extends DisplayObject3D
   {
      
      public var reflectionPlane:Reflection;
      
      public var reflectionMat:BitmapMaterial;
      
      public var animationPlane:CharacterAnimationPlane;
      
      public function ReflectionPlane(param1:CharacterAnimationPlane)
      {
         super();
         this.animationPlane = param1;
         reflectionPlane = new Reflection(param1,0.5,0.5);
         addChild(param1);
         addChild(reflectionPlane);
      }
      
      public function get yOffset() : Number
      {
         return reflectionPlane.y;
      }
      
      public function set yOffset(param1:Number) : void
      {
         reflectionPlane.y = param1;
      }
   }
}

