package net.pluginmedia.bigandsmall.physics
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class VerletTriangle extends Sprite
   {
      
      public var desiredLengthAB:Number = 100;
      
      public var spring:Number = 0.4;
      
      public var baseLength:Number = 0;
      
      public var desiredLengthBC:Number = 100;
      
      public var spineHeight:Number = 0;
      
      public var timeStep:Number = 1;
      
      public var cParts:Array = [];
      
      public var desiredLengthCA:Number = 100;
      
      public function VerletTriangle()
      {
         super();
      }
      
      public function get nodeB() : VerletParticle
      {
         return cParts[1] as VerletParticle;
      }
      
      public function get nodeC() : VerletParticle
      {
         return cParts[2] as VerletParticle;
      }
      
      public function init(param1:Number, param2:Number, param3:Number = 100) : void
      {
         var _loc4_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         cParts.push(_loc4_);
         addChild(_loc4_);
         var _loc5_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         cParts.push(_loc5_);
         addChild(_loc5_);
         var _loc6_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         cParts.push(_loc6_);
         addChild(_loc6_);
      }
      
      public function initPoints(param1:VerletParticle, param2:VerletParticle, param3:VerletParticle, param4:Number = 100, param5:Number = 50) : void
      {
         cParts.push(param1);
         cParts.push(param2);
         cParts.push(param3);
         spineHeight = param5;
         baseLength = param4;
         desiredLengthBC = param4;
         var _loc6_:Number = param4 / 2;
         desiredLengthAB = desiredLengthCA = Math.sqrt(param5 * param5 + _loc6_ * _loc6_);
         defaultPositions();
      }
      
      public function update() : void
      {
         var _loc1_:VerletParticle = null;
         satisfyConstraints(nodeA,nodeB,desiredLengthAB);
         satisfyConstraints(nodeB,nodeC,desiredLengthBC);
         satisfyConstraints(nodeC,nodeA,desiredLengthCA);
         var _loc2_:int = 0;
         while(_loc2_ < cParts.length)
         {
            _loc1_ = cParts[_loc2_] as VerletParticle;
            _loc1_.verlet(timeStep);
            _loc1_.updateClip();
            _loc2_++;
         }
         renderConnections();
      }
      
      public function satisfyConstraints(param1:VerletParticle, param2:VerletParticle, param3:Number = 100) : void
      {
         var _loc4_:Number = param1.loc.x - param2.loc.x;
         var _loc5_:Number = param1.loc.y - param2.loc.y;
         var _loc6_:Number = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         var _loc7_:Number = (_loc6_ - param3) / param3;
         var _loc8_:Number = _loc4_ / _loc6_;
         var _loc9_:Number = _loc5_ / _loc6_;
         param2.loc.x += _loc8_ * _loc7_ * param3 * spring;
         param2.loc.y += _loc9_ * _loc7_ * param3 * spring;
         param1.loc.x -= _loc8_ * _loc7_ * param3 * spring;
         param1.loc.y -= _loc9_ * _loc7_ * param3 * spring;
      }
      
      public function get vCA() : Point
      {
         return new Point(nodeA.x - nodeC.x,nodeA.y - nodeC.y);
      }
      
      public function get vAB() : Point
      {
         return new Point(nodeA.x - nodeB.x,nodeA.y - nodeB.y);
      }
      
      public function renderConnections() : void
      {
         graphics.clear();
         graphics.lineStyle(1,16711935,1);
         var _loc1_:VerletParticle = null;
         var _loc2_:VerletParticle = null;
         var _loc3_:int = 0;
         while(_loc3_ < cParts.length - 1)
         {
            _loc1_ = cParts[_loc3_] as VerletParticle;
            _loc2_ = cParts[_loc3_ + 1] as VerletParticle;
            graphics.moveTo(_loc1_.loc.x,_loc1_.loc.y);
            graphics.lineTo(_loc2_.loc.x,_loc2_.loc.y);
            _loc3_++;
         }
         _loc1_ = cParts[0] as VerletParticle;
         graphics.moveTo(_loc1_.loc.x,_loc1_.loc.y);
         graphics.lineTo(_loc2_.loc.x,_loc2_.loc.y);
      }
      
      public function get lengthBC() : Number
      {
         var _loc1_:Point = this.vBC;
         return Math.sqrt(_loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y);
      }
      
      public function defaultPositions() : void
      {
         nodeB.forcePosition(nodeA.loc.x + baseLength / 2,nodeA.loc.y + spineHeight);
         nodeC.forcePosition(nodeA.loc.x + baseLength / 2,nodeA.loc.y + spineHeight);
      }
      
      public function get midBC() : Point
      {
         var _loc1_:Point = this.vBC;
         return new Point(nodeB.loc.x - _loc1_.x / 2,nodeB.loc.y - _loc1_.y / 2);
      }
      
      public function accumulateForce(param1:Number, param2:Number) : void
      {
         var _loc4_:VerletParticle = null;
         var _loc3_:int = 0;
         while(_loc3_ < cParts.length)
         {
            _loc4_ = cParts[_loc3_] as VerletParticle;
            if(!_loc4_.isPinned)
            {
               _loc4_.accumulateForce(param1,param2);
            }
            _loc3_++;
         }
      }
      
      public function get vBC() : Point
      {
         return new Point(nodeB.x - nodeC.x,nodeB.y - nodeC.y);
      }
      
      public function get nodeA() : VerletParticle
      {
         return cParts[0] as VerletParticle;
      }
   }
}

