package org.papervision3d.core.math
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.util.ClassificationUtil;
   
   public class Plane3D
   {
      
      private static var _yUP:Number3D = new Number3D(0,1,0);
      
      private static var _zUP:Number3D = new Number3D(0,0,1);
      
      protected static var flipPlane:Plane3D = new Plane3D();
      
      public var d:Number;
      
      public var normal:Number3D;
      
      internal var eps:Number = 0.01;
      
      public function Plane3D(param1:Number3D = null, param2:Number3D = null)
      {
         super();
         if(Boolean(param1) && Boolean(param2))
         {
            this.normal = param1;
            this.d = -Number3D.dot(param1,param2);
         }
         else
         {
            this.normal = new Number3D();
            this.d = 0;
         }
      }
      
      public static function fromNormalAndPoint(param1:*, param2:*) : Plane3D
      {
         var _loc3_:Number3D = param1 is Number3D ? param1 : new Number3D(param1.x,param1.y,param1.z);
         var _loc4_:Number3D = param2 is Number3D ? param2 : new Number3D(param2.x,param2.y,param2.z);
         return new Plane3D(_loc3_,_loc4_);
      }
      
      public static function fromThreePoints(param1:*, param2:*, param3:*) : Plane3D
      {
         var _loc4_:Plane3D = new Plane3D();
         var _loc5_:Number3D = param1 is Number3D ? param1 : new Number3D(param1.x,param1.y,param1.z);
         var _loc6_:Number3D = param2 is Number3D ? param2 : new Number3D(param2.x,param2.y,param2.z);
         var _loc7_:Number3D = param3 is Number3D ? param3 : new Number3D(param3.x,param3.y,param3.z);
         _loc4_.setThreePoints(_loc5_,_loc6_,_loc7_);
         return _loc4_;
      }
      
      public static function fromCoefficients(param1:Number, param2:Number, param3:Number, param4:Number) : Plane3D
      {
         var _loc5_:Plane3D = new Plane3D();
         _loc5_.setCoefficients(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public function setCoefficients(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.normal.x = param1;
         this.normal.y = param2;
         this.normal.z = param3;
         this.d = param4;
         normalize();
      }
      
      public function setThreePoints(param1:Number3D, param2:Number3D, param3:Number3D) : void
      {
         var _loc4_:Number3D = Number3D.sub(param2,param1);
         var _loc5_:Number3D = Number3D.sub(param3,param1);
         this.normal = Number3D.cross(_loc4_,_loc5_);
         this.normal.normalize();
         this.d = -Number3D.dot(normal,param1);
      }
      
      public function setNormalAndPoint(param1:Number3D, param2:Number3D) : void
      {
         this.normal = param1;
         this.d = -Number3D.dot(param1,param2);
      }
      
      public function getFlip() : Plane3D
      {
         var _loc1_:Plane3D = Plane3D.fromThreePoints(new Number3D(),new Number3D(),new Number3D());
         _loc1_.normal.z = -normal.z;
         _loc1_.normal.y = -normal.y;
         _loc1_.normal.x = -normal.x;
         _loc1_.d = d;
         return _loc1_;
      }
      
      public function getTempFlip() : Plane3D
      {
         flipPlane.normal.z = -normal.z;
         flipPlane.normal.y = -normal.y;
         flipPlane.normal.x = -normal.x;
         flipPlane.d = d;
         return flipPlane;
      }
      
      public function pointOnSide(param1:Number3D) : int
      {
         var _loc2_:Number = distance(param1);
         if(_loc2_ < 0)
         {
            return ClassificationUtil.BACK;
         }
         if(_loc2_ > 0)
         {
            return ClassificationUtil.FRONT;
         }
         return ClassificationUtil.COINCIDING;
      }
      
      public function closestPointOnPlane(param1:Number3D, param2:Number3D) : Number3D
      {
         var _loc3_:Number = Number3D.dot(this.normal,Number3D.sub(param1,param2));
         var _loc4_:Number3D = param1.clone();
         _loc4_.x -= _loc3_ * this.normal.x;
         _loc4_.y -= _loc3_ * this.normal.y;
         _loc4_.z -= _loc3_ * this.normal.z;
         return _loc4_;
      }
      
      public function normalize() : void
      {
         var _loc1_:Number3D = this.normal;
         var _loc2_:Number = Math.sqrt(_loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y + _loc1_.z * _loc1_.z);
         _loc1_.x /= _loc2_;
         _loc1_.y /= _loc2_;
         _loc1_.z /= _loc2_;
         this.d /= _loc2_;
      }
      
      public function distance(param1:*) : Number
      {
         var _loc2_:Number3D = param1 is Vertex3D ? param1.toNumber3D() : param1;
         return Number3D.dot(_loc2_,normal) + d;
      }
      
      public function isCoplanar(param1:Plane3D) : Boolean
      {
         return Math.abs(normal.x - param1.normal.x) < eps && Math.abs(normal.y - param1.normal.y) < eps && Math.abs(normal.z - param1.normal.z) < eps && Math.abs(d - param1.d) < eps;
      }
      
      public function getIntersectionLineNumbers(param1:Number3D, param2:Number3D) : Number3D
      {
         var _loc3_:Number = normal.x * param1.x + normal.y * param1.y + normal.z * param1.z - d;
         var _loc4_:Number = normal.x * param2.x + normal.y * param2.y + normal.z * param2.z - d;
         var _loc5_:Number = _loc4_ / (_loc4_ - _loc3_);
         return new Number3D(param2.x + (param1.x - param2.x) * _loc5_,param2.y + (param1.y - param2.y) * _loc5_,param2.z + (param1.z - param2.z) * _loc5_);
      }
      
      public function getIntersectionLine(param1:Vertex3D, param2:Vertex3D) : Vertex3D
      {
         var _loc3_:Number = normal.x * param1.x + normal.y * param1.y + normal.z * param1.z - d;
         var _loc4_:Number = normal.x * param2.x + normal.y * param2.y + normal.z * param2.z - d;
         var _loc5_:Number = _loc4_ / (_loc4_ - _loc3_);
         return new Vertex3D(param2.x + (param1.x - param2.x) * _loc5_,param2.y + (param1.y - param2.y) * _loc5_,param2.z + (param1.z - param2.z) * _loc5_);
      }
      
      public function toString() : String
      {
         return "[a:" + normal.x + " b:" + normal.y + " c:" + normal.z + " d:" + d + "]";
      }
      
      public function projectPoints(param1:Array, param2:Number3D = null) : void
      {
         var _loc8_:* = undefined;
         var _loc3_:Number = Number3D.dot(_yUP,this.normal);
         var _loc4_:Number3D = Math.abs(_loc3_) > 0.99 ? _zUP : _yUP;
         var _loc5_:Number3D = Number3D.cross(_loc4_,normal);
         _loc5_.normalize();
         _loc4_ = Number3D.cross(normal,_loc5_);
         _loc4_.normalize();
         var _loc6_:Matrix3D = new Matrix3D([_loc5_.x,_loc4_.x,normal.x,0,_loc5_.y,_loc4_.y,normal.y,0,_loc5_.z,_loc4_.z,normal.z,0,0,0,0,1]);
         if(param2)
         {
            _loc6_ = Matrix3D.multiply(Matrix3D.translationMatrix(param2.x,param2.y,param2.z),_loc6_);
         }
         var _loc7_:Number3D = new Number3D();
         for each(_loc8_ in param1)
         {
            _loc7_.x = _loc8_["x"];
            _loc7_.y = _loc8_["y"];
            _loc7_.z = _loc8_["z"];
            Matrix3D.multiplyVector(_loc6_,_loc7_);
            _loc8_["x"] = _loc7_.x;
            _loc8_["y"] = _loc7_.y;
            _loc8_["z"] = _loc7_.z;
         }
      }
      
      public function clone() : Plane3D
      {
         return Plane3D.fromCoefficients(this.normal.x,this.normal.y,this.normal.z,this.d);
      }
      
      public function isCoplanarOpposite(param1:Plane3D) : Boolean
      {
         flipPlane.normal.z = -param1.normal.z;
         flipPlane.normal.y = -param1.normal.y;
         flipPlane.normal.x = -param1.normal.x;
         flipPlane.d = param1.d;
         return flipPlane.isCoplanar(param1);
      }
      
      public function vertDistance(param1:Vertex3D) : Number
      {
         return param1.x * normal.x + normal.y * param1.y + param1.z * normal.z + d;
      }
   }
}

