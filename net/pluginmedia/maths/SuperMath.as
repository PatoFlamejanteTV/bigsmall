package net.pluginmedia.maths
{
   import flash.utils.getTimer;
   
   public class SuperMath
   {
      
      protected static var cosLookUp:Array;
      
      protected static var sinLookUp:Array;
      
      protected static var tanLookUp:Array;
      
      public static var performance_int:Number;
      
      public static var ACCURACY:Number;
      
      public static var TWOPI:Number = 2 * Math.PI;
      
      public static var initialised:Boolean = false;
      
      public static var RADS_TO_DEGREES:Number = 180 / Math.PI;
      
      public static var DEGREES_TO_RADS:Number = Math.PI / 180;
      
      public function SuperMath()
      {
         super();
      }
      
      public static function random(param1:Number, param2:Number = NaN) : Number
      {
         if(isNaN(param2))
         {
            return Math.random() * param1;
         }
         return Math.random() * (param2 - param1) + param1;
      }
      
      public static function log(param1:Number, param2:Number) : Number
      {
         return Math.log(param2) / Math.log(param1);
      }
      
      public static function ceil(param1:Number) : int
      {
         return param1 > 0 ? int(param1) + 1 : int(param1);
      }
      
      public static function acos(param1:Number) : Number
      {
         return radiansToDegrees(Math.acos(param1));
      }
      
      public static function cos(param1:Number) : Number
      {
         return Math.cos(degreesToRadians(param1));
      }
      
      public static function floor(param1:Number) : int
      {
         return param1 > 0 ? int(param1) : int(param1) - 1;
      }
      
      public static function degreesToRadians(param1:Number) : Number
      {
         return param1 * DEGREES_TO_RADS;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param1;
         _loc4_ = _loc4_ < param2 ? param2 : _loc4_;
         return _loc4_ > param3 ? param3 : _loc4_;
      }
      
      public static function sin(param1:Number) : Number
      {
         return Math.sin(degreesToRadians(param1));
      }
      
      public static function atan2(param1:Number, param2:Number) : Number
      {
         return radiansToDegrees(Math.atan2(param1,param2));
      }
      
      protected static function B2(param1:Number) : Number
      {
         return 3 * param1 * (1 - param1) * (1 - param1);
      }
      
      protected static function B4(param1:Number) : Number
      {
         return param1 * param1 * param1;
      }
      
      public static function radiansToDegrees(param1:Number) : Number
      {
         return param1 * RADS_TO_DEGREES;
      }
      
      public static function atan(param1:Number) : Number
      {
         return radiansToDegrees(Math.atan(param1));
      }
      
      public static function tan(param1:Number) : Number
      {
         return Math.tan(degreesToRadians(param1));
      }
      
      protected static function B1(param1:Number) : Number
      {
         return (1 - param1) * (1 - param1) * (1 - param1);
      }
      
      public static function get performance() : Number
      {
         if(!initialised)
         {
            initialise();
         }
         return performance_int;
      }
      
      protected static function B3(param1:Number) : Number
      {
         return 3 * param1 * param1 * (1 - param1);
      }
      
      public static function initialise(param1:Number = 10) : void
      {
         var _loc2_:Number = NaN;
         ACCURACY = param1;
         sinLookUp = new Array();
         cosLookUp = new Array();
         tanLookUp = new Array();
         var _loc3_:Number = getTimer();
         _loc2_ = 0;
         while(_loc2_ <= 360 * ACCURACY)
         {
            sinLookUp[_loc2_] = Math.sin(degreesToRadians(_loc2_ / ACCURACY));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ <= 360 * ACCURACY)
         {
            cosLookUp[_loc2_] = Math.cos(degreesToRadians(_loc2_ / ACCURACY));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ <= 360 * ACCURACY)
         {
            tanLookUp[_loc2_] = Math.tan(degreesToRadians(_loc2_ / ACCURACY));
            _loc2_++;
         }
         performance_int = Math.round((getTimer() - _loc3_) / 3.6 / ACCURACY);
         initialised = true;
      }
      
      public static function getBezierPoint(param1:*, param2:*, param3:*, param4:*, param5:Number) : Object
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1 is Vector3D)
         {
            _loc6_ = param1.x * B1(param5) + param3.x * B2(param5) + param4.x * B3(param5) + param2.x * B4(param5);
            _loc7_ = param1.y * B1(param5) + param3.y * B2(param5) + param4.y * B3(param5) + param2.y * B4(param5);
            _loc8_ = param1.z * B1(param5) + param3.z * B2(param5) + param4.z * B3(param5) + param2.z * B4(param5);
            return new Vector3D(_loc6_,_loc7_,_loc8_);
         }
         if(param1 is Vector3D)
         {
            _loc6_ = param1.x * B1(param5) + param3.x * B2(param5) + param4.x * B3(param5) + param2.x * B4(param5);
            _loc7_ = param1.y * B1(param5) + param3.y * B2(param5) + param4.y * B3(param5) + param2.y * B4(param5);
            return new Vector2D(_loc6_,_loc7_);
         }
         if(param1 is Number)
         {
            return param1 * B1(param5) + param3 * B2(param5) + param4 * B3(param5) + param2 * B4(param5);
         }
         trace("WARNING - getBezierPoint needs Vector2D or Vector3D");
         return null;
      }
      
      public static function calcRatio(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = param1 / (param3 - param2);
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         else if(_loc6_ > 1)
         {
            _loc6_ = 1;
         }
         return (param5 - param4) * _loc6_ + param4;
      }
      
      public static function normaliseAngle(param1:Number) : Number
      {
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         return param1;
      }
   }
}

