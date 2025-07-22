package net.pluginmedia.maths
{
   import flash.geom.Point;
   
   public class Vector2D extends Point
   {
      
      public function Vector2D(param1:Number = 0, param2:Number = 0)
      {
         super(param1,param2);
      }
      
      public function getClosestPointOnLine(param1:Point, param2:Point) : Point
      {
         var _loc3_:Number = y / x;
         var _loc4_:Number = x / -y;
         var _loc5_:Number = param1.y - _loc3_ * param1.x;
         var _loc6_:Number = param2.y - _loc4_ * param2.x;
         var _loc7_:Number = (_loc6_ - _loc5_) / (_loc3_ - _loc4_);
         var _loc8_:Number = _loc3_ * _loc7_ + _loc5_;
         return new Point(_loc7_,_loc8_);
      }
      
      public function isMagLessThan(param1:Number) : Boolean
      {
         var _loc2_:Number = x * x + y * y;
         if(_loc2_ < param1 * param1)
         {
            return true;
         }
         return false;
      }
      
      public function divideEq(param1:Object) : void
      {
         var value:Object = param1;
         if(value is Vector2D)
         {
            with(this)
            {
               
               x /= Vector2D(value).x;
               y /= Vector2D(value).y;
            }
         }
         else if(typeof value == "number")
         {
            with(this)
            {
               
               x /= Number(value);
               y /= Number(value);
            }
         }
         else
         {
            trace("ERROR - multiply method sent neither number or vector");
         }
      }
      
      public function cross(param1:Vector2D) : Number
      {
         return this.x * param1.y - this.y * param1.x;
      }
      
      public function dot(param1:Vector2D) : Number
      {
         var v:Vector2D = param1;
         var _loc3_:* = this;
         with(_loc3_)
         {
            return x * v.x + y * v.y;
         }
         
         public function reset(param1:Number, param2:Number) : void
         {
            this.x = param1;
            this.y = param2;
         }
         
         public function copyTo(param1:Vector2D) : void
         {
            param1.x = this.x;
            param1.y = this.y;
         }
         
         public function angle() : Number
         {
            var _loc2_:* = this;
            with(_loc2_)
            {
               return SuperMath.radiansToDegrees(Math.atan2(y,x));
            }
            
            public function convertToNormal() : void
            {
               var _loc1_:Number = x;
               x = -y;
               y = _loc1_;
            }
            
            public function isCloseTo(param1:Vector2D, param2:Number) : Boolean
            {
               if(this.equals(param1))
               {
                  return true;
               }
               var _loc3_:Vector2D = new Vector2D(0,0);
               _loc3_ = this.subtractNew(param1);
               var _loc4_:Number = _loc3_.x * _loc3_.x + _loc3_.y * _loc3_.y;
               if(_loc4_ < param2 * param2)
               {
                  return true;
               }
               return false;
            }
            
            public function getMagnitude() : Number
            {
               return Point.distance(new Point(),Point(this));
            }
            
            public function rotate(param1:Number) : void
            {
               var _loc4_:Vector2D = null;
               var _loc2_:Number = SuperMath.cos(param1);
               var _loc3_:Number = SuperMath.sin(param1);
               _loc4_ = this.getClone();
               this.x = _loc4_.x * _loc2_ - _loc4_.y * _loc3_;
               this.y = _loc4_.x * _loc3_ + _loc4_.y * _loc2_;
            }
            
            public function multiplyNew(param1:Object) : Vector2D
            {
               var _loc2_:Vector2D = this.getClone();
               _loc2_.multiply(param1);
               return _loc2_;
            }
            
            public function getNormal() : Vector2D
            {
               return new Vector2D(-y,x);
            }
            
            public function reverse() : void
            {
               this.x = -this.x;
               this.y = -this.y;
            }
            
            public function multiply(param1:Object) : void
            {
               var value:Object = param1;
               if(value is Vector2D)
               {
                  with(this)
                  {
                     
                     x *= Vector2D(value).x;
                     y *= Vector2D(value).y;
                  }
               }
               else if(typeof value == "number")
               {
                  with(this)
                  {
                     
                     x *= Number(value);
                     y *= Number(value);
                  }
               }
               else
               {
                  trace("ERROR - multiply method sent neither number or vector");
               }
            }
            
            public function plusEq(param1:Vector2D) : void
            {
               x += param1.x;
               y += param1.y;
            }
            
            public function getClone() : Vector2D
            {
               return new Vector2D(this.x,this.y);
            }
            
            public function rotateAroundPoint(param1:Vector2D, param2:Number) : void
            {
               var _loc3_:Vector2D = getClone();
               trace("rotate around point " + _loc3_ + " " + param1 + " " + param2);
               _loc3_.subtract(param1);
               trace("after subtract " + _loc3_);
               _loc3_.rotate(param2);
               trace("after rotate " + _loc3_);
               _loc3_.plusEq(param1);
               trace("after add " + _loc3_);
               this.copyFrom(_loc3_);
            }
            
            public function projectOnto(param1:Vector2D) : Vector2D
            {
               var _loc2_:Number = this.dot(param1);
               var _loc3_:Number = _loc2_ / (param1.x * param1.x + param1.y * param1.y);
               return new Vector2D(_loc3_ * param1.x,_loc3_ * param1.y);
            }
            
            override public function toString() : String
            {
               var _loc1_:Number = Math.round(this.x * 1000) / 1000;
               var _loc2_:Number = Math.round(this.y * 1000) / 1000;
               return "[" + _loc1_ + ", " + _loc2_ + "]";
            }
            
            public function plusNew(param1:Vector2D) : Vector2D
            {
               return new Vector2D(x + param1.x,y + param1.y);
            }
            
            public function divideNew(param1:Object) : Vector2D
            {
               var _loc2_:Vector2D = this.getClone();
               _loc2_.divideEq(param1);
               return _loc2_;
            }
            
            public function multiplyScalar(param1:Number) : void
            {
               x *= param1;
               y *= param1;
            }
            
            public function isMagGreaterThan(param1:Number) : Boolean
            {
               var _loc2_:Number = x * x + y * y;
               if(_loc2_ > param1 * param1)
               {
                  return true;
               }
               return false;
            }
            
            public function normalise() : Vector2D
            {
               var _loc1_:Number = this.getMagnitude();
               this.x /= _loc1_;
               this.y /= _loc1_;
               return this;
            }
            
            public function angleBetween(param1:Vector2D) : Number
            {
               var _loc2_:Number = (this.angle() - param1.angle()) % 360;
               if(_loc2_ > 180)
               {
                  _loc2_ -= 360;
               }
               else if(_loc2_ < -180)
               {
                  _loc2_ += 360;
               }
               return _loc2_;
            }
            
            public function subtractNew(param1:Vector2D) : Vector2D
            {
               return new Vector2D(this.x - param1.x,this.y - param1.y);
            }
            
            public function minusEq(param1:Vector2D) : void
            {
               x -= param1.x;
               y -= param1.y;
            }
            
            public function copyFrom(param1:Vector2D) : void
            {
               this.x = param1.x;
               this.y = param1.y;
            }
         }
      }
      
      