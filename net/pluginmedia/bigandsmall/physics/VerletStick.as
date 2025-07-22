package net.pluginmedia.bigandsmall.physics
{
   import flash.display.Sprite;
   
   public class VerletStick extends Sprite
   {
      
      public var timeStep:Number = 1;
      
      public var restLength:Number = 30;
      
      public var cParts:Array = [];
      
      public function VerletStick(param1:Number, param2:Number, param3:Number)
      {
         super();
         var _loc4_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         cParts.push(_loc4_);
         addChild(_loc4_);
         var _loc5_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         cParts.push(_loc5_);
         addChild(_loc5_);
         restLength = param3;
      }
      
      public function get nodeB() : VerletParticle
      {
         return cParts[1] as VerletParticle;
      }
      
      public function satisfyConstraints(param1:Number) : void
      {
         var _loc3_:VerletParticle = null;
         var _loc4_:VerletParticle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Number = 0.5;
         if(param1 < cParts.length - 1)
         {
            _loc3_ = cParts[param1] as VerletParticle;
            _loc4_ = cParts[param1 + 1] as VerletParticle;
            _loc5_ = _loc3_.loc.x - _loc4_.loc.x;
            _loc6_ = _loc3_.loc.y - _loc4_.loc.y;
            _loc7_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
            _loc8_ = (_loc7_ - restLength) / restLength;
            _loc9_ = _loc5_ / _loc7_;
            _loc10_ = _loc6_ / _loc7_;
            if(!_loc4_.isDragging && !_loc4_.isPinned)
            {
               _loc4_.loc.x += _loc9_ * _loc8_ * restLength * _loc2_;
               _loc4_.loc.y += _loc10_ * _loc8_ * restLength * _loc2_;
            }
            if(!_loc3_.isDragging && !_loc3_.isPinned)
            {
               _loc3_.loc.x -= _loc9_ * _loc8_ * restLength * _loc2_;
               _loc3_.loc.y -= _loc10_ * _loc8_ * restLength * _loc2_;
            }
         }
      }
      
      public function get nodeA() : VerletParticle
      {
         return cParts[0] as VerletParticle;
      }
      
      public function accumulateForce(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < cParts.length)
         {
            VerletParticle(cParts[_loc3_]).accumulateForce(param1,param2);
            _loc3_++;
         }
      }
      
      override public function toString() : String
      {
         return "[object VerletStick A ::" + nodeA.x + ":" + nodeA.y + ", B :: " + nodeB.x + ":" + nodeB.y + " ]";
      }
      
      public function update() : void
      {
         var _loc2_:VerletParticle = null;
         var _loc1_:int = 0;
         while(_loc1_ < cParts.length)
         {
            satisfyConstraints(_loc1_);
            _loc2_ = cParts[_loc1_] as VerletParticle;
            _loc2_.verlet(timeStep);
            _loc2_.updateClip();
            _loc1_++;
         }
         renderConnections();
      }
      
      public function renderConnections() : void
      {
         graphics.clear();
         graphics.lineStyle(2,16711935,0.2,true,"none","round","round",1);
         graphics.moveTo(cParts[0].loc.x,cParts[0].loc.y);
         var _loc1_:int = 1;
         while(_loc1_ < cParts.length)
         {
            graphics.lineTo(cParts[_loc1_].loc.x,cParts[_loc1_].loc.y);
            _loc1_++;
         }
      }
   }
}

