package org.papervision3d.core.math
{
   import org.papervision3d.Papervision3D;
   
   public class Number3D
   {
      
      private static var temp:Number3D = Number3D.ZERO;
      
      public static var toDEGREES:Number = 180 / Math.PI;
      
      public static var toRADIANS:Number = Math.PI / 180;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Number3D(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public static function sub(param1:Number3D, param2:Number3D) : Number3D
      {
         return new Number3D(param1.x - param2.x,param1.y - param2.y,param1.z - param2.z);
      }
      
      public static function add(param1:Number3D, param2:Number3D) : Number3D
      {
         return new Number3D(param1.x + param2.x,param1.y + param2.y,param1.z + param2.z);
      }
      
      public static function cross(param1:Number3D, param2:Number3D, param3:Number3D = null) : Number3D
      {
         if(!param3)
         {
            param3 = ZERO;
         }
         param3.reset(param2.y * param1.z - param2.z * param1.y,param2.z * param1.x - param2.x * param1.z,param2.x * param1.y - param2.y * param1.x);
         return param3;
      }
      
      public static function dot(param1:Number3D, param2:Number3D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y + param2.z * param1.z;
      }
      
      public static function get ZERO() : Number3D
      {
         return new Number3D(0,0,0);
      }
      
      public function isModuloLessThan(param1:Number) : Boolean
      {
         return moduloSquared < param1 * param1;
      }
      
      public function rotateX(param1:Number) : void
      {
         if(Papervision3D.useDEGREES)
         {
            param1 *= toRADIANS;
         }
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         temp.copyFrom(this);
         this.y = temp.y * _loc2_ - temp.z * _loc3_;
         this.z = temp.y * _loc3_ + temp.z * _loc2_;
      }
      
      public function rotateY(param1:Number) : void
      {
         if(Papervision3D.useDEGREES)
         {
            param1 *= toRADIANS;
         }
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         temp.copyFrom(this);
         this.x = temp.x * _loc2_ + temp.z * _loc3_;
         this.z = temp.x * -_loc3_ + temp.z * _loc2_;
      }
      
      public function plusEq(param1:Number3D) : void
      {
         x += param1.x;
         y += param1.y;
         z += param1.z;
      }
      
      public function multiplyEq(param1:Number) : void
      {
         x *= param1;
         y *= param1;
         z *= param1;
      }
      
      public function toString() : String
      {
         return "x:" + Math.round(x * 100) / 100 + " y:" + Math.round(y * 100) / 100 + " z:" + Math.round(z * 100) / 100;
      }
      
      public function normalize() : void
      {
         var _loc1_:Number = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
         if(_loc1_ != 0 && _loc1_ != 1)
         {
            _loc1_ = 1 / _loc1_;
            this.x *= _loc1_;
            this.y *= _loc1_;
            this.z *= _loc1_;
         }
      }
      
      public function rotateZ(param1:Number) : void
      {
         if(Papervision3D.useDEGREES)
         {
            param1 *= toRADIANS;
         }
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         temp.copyFrom(this);
         this.x = temp.x * _loc2_ - temp.y * _loc3_;
         this.y = temp.x * _loc3_ + temp.y * _loc2_;
      }
      
      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         x = param1;
         y = param2;
         z = param3;
      }
      
      public function get moduloSquared() : Number
      {
         return this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function copyTo(param1:Number3D) : void
      {
         param1.x = x;
         param1.y = y;
         param1.z = z;
      }
      
      public function isModuloGreaterThan(param1:Number) : Boolean
      {
         return moduloSquared > param1 * param1;
      }
      
      public function minusEq(param1:Number3D) : void
      {
         x -= param1.x;
         y -= param1.y;
         z -= param1.z;
      }
      
      public function clone() : Number3D
      {
         return new Number3D(this.x,this.y,this.z);
      }
      
      public function isModuloEqualTo(param1:Number) : Boolean
      {
         return moduloSquared == param1 * param1;
      }
      
      public function copyFrom(param1:Number3D) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
   }
}

