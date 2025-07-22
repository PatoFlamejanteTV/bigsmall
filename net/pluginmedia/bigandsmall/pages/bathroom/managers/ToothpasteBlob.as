package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.special.ParticleMaterial;
   
   public class ToothpasteBlob extends Particle
   {
      
      public var collidable:Boolean = false;
      
      public var spin:Number = 0;
      
      public var bitmapIndex:int = 0;
      
      public var killParticle:Boolean = false;
      
      public var lifeCounter:int;
      
      public var bitmapArray:Array;
      
      public var gravity:Number = 1;
      
      public var drag:Number = 0.99;
      
      public var playing:Boolean = false;
      
      public var lifeExpectancy:int;
      
      public var velocity:Number3D = new Number3D();
      
      public function ToothpasteBlob(param1:ParticleMaterial, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number3D = null)
      {
         super(param1,param2,param3,param4,param5);
         resetBlob(param2,param3,param4,param5,param6);
      }
      
      public function update() : void
      {
         ++lifeCounter;
         x += velocity.x;
         y += velocity.y;
         z += velocity.z;
         velocity.y -= gravity;
         velocity.multiplyEq(drag);
         rotationZ += spin;
         spin *= 0.99;
         if(lifeCounter > lifeExpectancy)
         {
            killParticle = true;
         }
      }
      
      public function resetBlob(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number3D = null) : void
      {
         this.size = param1 * (0.5 + Math.random());
         this.x = param2;
         this.y = param3;
         this.z = param4;
         velocity.reset(0,5,0);
         velocity.rotateZ(SuperMath.random(-20,20));
         velocity.rotateY(SuperMath.random(0,360));
         if(param5)
         {
            velocity.plusEq(param5);
         }
         lifeExpectancy = 50;
         lifeCounter = 0;
         killParticle = false;
         gravity = Math.random() * 0.2 + 0.8;
         spin = 0;
         collidable = Math.random() < 0.1;
      }
   }
}

