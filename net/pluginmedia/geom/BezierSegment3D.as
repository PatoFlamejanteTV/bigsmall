package net.pluginmedia.geom
{
   import org.papervision3d.core.math.Number3D;
   
   public class BezierSegment3D
   {
      
      public var controlB:Number3D;
      
      public var controlA:Number3D;
      
      private var _length:Number = 0;
      
      public var pointB:Number3D;
      
      public var pointA:Number3D;
      
      public function BezierSegment3D(param1:Number3D, param2:Number3D, param3:Number3D, param4:Number3D)
      {
         super();
         pointA = param1;
         controlA = param2;
         pointB = param3;
         controlB = param4;
         var _loc5_:Number3D = new Number3D(param1.x - param3.x,param1.y - param3.y,param1.z - param3.z);
         _length = _loc5_.modulo;
      }
      
      protected static function B3(param1:Number) : Number
      {
         return 3 * param1 * param1 * (1 - param1);
      }
      
      protected static function B4(param1:Number) : Number
      {
         return param1 * param1 * param1;
      }
      
      protected static function B1(param1:Number) : Number
      {
         return (1 - param1) * (1 - param1) * (1 - param1);
      }
      
      protected static function B2(param1:Number) : Number
      {
         return 3 * param1 * (1 - param1) * (1 - param1);
      }
      
      public function get length() : Number
      {
         return _length;
      }
      
      public function getNumber3DAtT(param1:Number) : Number3D
      {
         var _loc2_:Number = pointA.x * B1(param1) + controlA.x * B2(param1) + controlB.x * B3(param1) + pointB.x * B4(param1);
         var _loc3_:Number = pointA.y * B1(param1) + controlA.y * B2(param1) + controlB.y * B3(param1) + pointB.y * B4(param1);
         var _loc4_:Number = pointA.z * B1(param1) + controlA.z * B2(param1) + controlB.z * B3(param1) + pointB.z * B4(param1);
         return new Number3D(_loc2_,_loc3_,_loc4_);
      }
   }
}

