package net.pluginmedia.bigandsmall.pages.bedroom.mobile
{
   import flash.display.DisplayObject;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import net.pluginmedia.bigandsmall.physics.VerletParticle;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class MobileDecor extends Plane
   {
      
      public var spinDamp:Number = 0.99;
      
      private var toDEGREES:Number = 57.29577951308232;
      
      private var cpA:VerletParticle;
      
      private var cpB:VerletParticle;
      
      public var spinVel:Number = 0;
      
      private var _isDragging:Boolean = false;
      
      public function MobileDecor(param1:DisplayObject, param2:Number, param3:VerletParticle, param4:VerletParticle)
      {
         var _loc5_:MovieMaterial = new MovieMaterial(param1,true);
         var _loc6_:Number = param1.width * 0.4;
         var _loc7_:Number = param1.height * 0.4;
         _loc5_.doubleSided = true;
         cpA = param3;
         cpB = param4;
         super(_loc5_,_loc6_,_loc7_,param2,param2);
         param1.width = 512;
         param1.height = 256;
         _loc5_.texture = param1;
         _loc5_.bitmap.fillRect(_loc5_.bitmap.rect,0);
         _loc5_.bitmap.draw(param1,new Matrix(param1.scaleX,0,0,param1.scaleY),null,null,null,true);
         _loc5_.bitmap.applyFilter(_loc5_.bitmap,_loc5_.bitmap.rect,new Point(0,0),new BlurFilter(6,6,4));
         var _loc8_:Matrix3D = null;
         _loc8_ = Matrix3D.rotationZ(90 * Number3D.toRADIANS);
         geometry.transformVertices(_loc8_);
         _loc8_ = Matrix3D.translationMatrix(_loc7_ / 2,0,0);
         geometry.transformVertices(_loc8_);
      }
      
      public function accumulateSpinForce(param1:Number) : void
      {
         spinVel += param1;
      }
      
      public function update() : void
      {
         var _loc1_:Number = cpA.loc.x - cpB.loc.x;
         var _loc2_:Number = cpA.loc.y - cpB.loc.y;
         var _loc3_:Number = Math.atan2(_loc2_,_loc1_) * toDEGREES;
         this.rotationZ = _loc3_;
         this.x = cpA.loc.x;
         this.y = cpA.loc.y;
         if(Math.abs(spinVel) < 0.001)
         {
            spinVel = 0;
         }
         if(spinVel != 0)
         {
            this.rotationX += spinVel;
            spinVel *= spinDamp;
         }
      }
      
      public function drop() : void
      {
         _isDragging = false;
         cpA.isPinned = false;
      }
      
      public function get isDragging() : Boolean
      {
         return _isDragging;
      }
      
      public function pickUp() : void
      {
         _isDragging = true;
         cpA.isPinned = true;
      }
   }
}

