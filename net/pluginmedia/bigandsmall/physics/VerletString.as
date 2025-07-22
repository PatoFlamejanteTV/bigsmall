package net.pluginmedia.bigandsmall.physics
{
   import flash.display.Sprite;
   
   public class VerletString extends Sprite
   {
      
      public var restlength:Number = 30;
      
      public var spring:Number = 0.4;
      
      public var timeStep:Number = 1;
      
      public var cParts:Array;
      
      public function VerletString(param1:Number, param2:Number, param3:Number, param4:Number = 30, param5:Number = 0, param6:Number = 0)
      {
         var _loc8_:VerletParticle = null;
         cParts = [];
         super();
         this.restlength = param4;
         var _loc7_:int = 0;
         while(_loc7_ < param3)
         {
            _loc8_ = addNode(param1 + param5 * param4 * _loc7_,param2 + param6 * param4 * _loc7_);
            _loc7_++;
         }
      }
      
      public function addNode(param1:Number, param2:Number) : VerletParticle
      {
         var _loc3_:VerletParticle = new VerletParticle(param1 + Math.random(),param2 + Math.random());
         addChild(_loc3_);
         cParts.push(_loc3_);
         return _loc3_;
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
      
      public function satisfyConstraints(param1:Number) : void
      {
         var _loc2_:VerletParticle = null;
         var _loc3_:VerletParticle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param1 < cParts.length - 1)
         {
            _loc2_ = cParts[param1] as VerletParticle;
            _loc3_ = cParts[param1 + 1] as VerletParticle;
            _loc4_ = _loc2_.loc.x - _loc3_.loc.x;
            _loc5_ = _loc2_.loc.y - _loc3_.loc.y;
            _loc6_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
            _loc7_ = (_loc6_ - restlength) / restlength;
            _loc8_ = _loc4_ / _loc6_;
            _loc9_ = _loc5_ / _loc6_;
            if(!_loc3_.isDragging && !_loc3_.isPinned)
            {
               _loc3_.loc.x += _loc8_ * _loc7_ * restlength * spring;
               _loc3_.loc.y += _loc9_ * _loc7_ * restlength * spring;
            }
            if(!_loc2_.isDragging && !_loc2_.isPinned)
            {
               _loc2_.loc.x -= _loc8_ * _loc7_ * restlength * spring;
               _loc2_.loc.y -= _loc9_ * _loc7_ * restlength * spring;
            }
         }
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
         graphics.lineStyle(1,16776960,1);
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

