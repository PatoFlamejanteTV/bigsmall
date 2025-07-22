package org.papervision3d.core.math.util
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Plane3D;
   
   public class ClassificationUtil
   {
      
      protected static var point:Vertex3D;
      
      public static const FRONT:uint = 0;
      
      public static const BACK:uint = 1;
      
      public static const COINCIDING:uint = 2;
      
      public static const STRADDLE:uint = 3;
      
      public function ClassificationUtil()
      {
         super();
      }
      
      public static function classifyPoint(param1:Vertex3D, param2:Plane3D, param3:Number = 0.01) : uint
      {
         var _loc4_:Number = param2.vertDistance(param1);
         if(_loc4_ < -param3)
         {
            return BACK;
         }
         if(_loc4_ > param3)
         {
            return FRONT;
         }
         return COINCIDING;
      }
      
      public static function classifyTriangle(param1:Triangle3D, param2:Plane3D, param3:Number = 0.01) : uint
      {
         if(!param1)
         {
            return null;
         }
         return classifyPoints(param1.vertices,param2,param3);
      }
      
      public static function classifyPoints(param1:Array, param2:Plane3D, param3:Number = 0.01) : uint
      {
         var _loc6_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for each(point in param1)
         {
            _loc6_ = classifyPoint(point,param2,param3);
            if(_loc6_ == FRONT)
            {
               _loc4_++;
            }
            else if(_loc6_ == BACK)
            {
               _loc5_++;
            }
         }
         if(_loc4_ > 0 && _loc5_ == 0)
         {
            return FRONT;
         }
         if(_loc4_ == 0 && _loc5_ > 0)
         {
            return BACK;
         }
         if(_loc4_ > 0 && _loc5_ > 0)
         {
            return STRADDLE;
         }
         return COINCIDING;
      }
   }
}

