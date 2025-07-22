package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.geom.Rectangle;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.special.BitmapParticleMaterial;
   import org.papervision3d.materials.special.ParticleBitmap;
   
   public class Bubble extends Particle
   {
      
      public var velDiff:Number3D;
      
      public var minX:Number;
      
      public var minY:Number;
      
      public var bounce:Number = 0.5;
      
      public var killParticle:Boolean = false;
      
      public var targetVel:Number3D;
      
      public var respawnCount:int;
      
      public var lifeExpectancy:int;
      
      public var lifeCounter:int;
      
      public var bitmapIndex:int = 0;
      
      public var velocity:Number3D;
      
      public var playing:Boolean = false;
      
      public var bitmapArray:Array;
      
      public var targetSize:Number;
      
      public var maxX:Number;
      
      public var maxY:Number;
      
      public var maxZ:Number;
      
      public function Bubble(param1:Array)
      {
         bitmapArray = param1;
         var _loc2_:ParticleBitmap = bitmapArray[0];
         var _loc3_:BitmapParticleMaterial = new BitmapParticleMaterial(_loc2_);
         super(_loc3_);
         velocity = Number3D.ZERO;
         targetVel = Number3D.ZERO;
         velDiff = Number3D.ZERO;
         reset(x,y,z);
      }
      
      public function update(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:ParticleBitmap = null;
         ++lifeCounter;
         x += velocity.x;
         y += velocity.y;
         z += velocity.z;
         if(size < targetSize)
         {
            _loc3_ = targetSize - size;
            if(_loc3_ > 0.01)
            {
               _loc3_ *= 0.05;
            }
            size += _loc3_;
         }
         if(!isNaN(maxZ) && velocity.z > 0 && z >= maxZ)
         {
            velocity.z *= -bounce;
            targetVel.z *= -bounce;
         }
         if(!isNaN(maxX) && velocity.x > 0 && x >= maxX)
         {
            velocity.x *= -bounce;
            targetVel.x *= -bounce;
         }
         else if(!isNaN(minX) && velocity.x < 0 && x <= minX)
         {
            velocity.x *= -bounce;
            targetVel.x *= -bounce;
         }
         if(!isNaN(maxY) && y >= maxY)
         {
         }
         velDiff.copyFrom(targetVel);
         velDiff.minusEq(velocity);
         velDiff.multiplyEq(0.068);
         velocity.plusEq(velDiff);
         if(lifeCounter > lifeExpectancy)
         {
            playing = true;
         }
         if(playing)
         {
            ++bitmapIndex;
            if(bitmapIndex < bitmapArray.length)
            {
               _loc4_ = bitmapArray[bitmapIndex];
               BitmapParticleMaterial(material).particleBitmap = _loc4_;
            }
            else
            {
               killParticle = true;
            }
         }
      }
      
      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         x = param1;
         y = param2;
         z = param3;
         velocity.reset(0,SuperMath.random(0.5,1),0);
         targetVel.reset(SuperMath.random(-2,2),velocity.y,SuperMath.random(-3,3));
         size = 0.01;
         killParticle = false;
         lifeExpectancy = SuperMath.random(200,500);
         lifeCounter = 0;
         targetSize = SuperMath.random(0.3,0.6);
         bitmapIndex = 0;
         playing = false;
         var _loc4_:ParticleBitmap = bitmapArray[0];
         BitmapParticleMaterial(material).particleBitmap = _loc4_;
      }
      
      public function rectContainsPoint(param1:Rectangle, param2:Number2D) : Boolean
      {
         return true;
      }
   }
}

