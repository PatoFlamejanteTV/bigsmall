package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.math.Number3D;
   
   public class Vertex3DInstance
   {
      
      public var y:Number;
      
      private var persp:Number = 0;
      
      public var normal:Number3D;
      
      public var visible:Boolean;
      
      public var extra:Object;
      
      public var x:Number;
      
      public var z:Number;
      
      public function Vertex3DInstance(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.visible = false;
         this.normal = new Number3D();
      }
      
      public static function cross(param1:Vertex3DInstance, param2:Vertex3DInstance) : Number
      {
         return param1.x * param2.y - param2.x * param1.y;
      }
      
      public static function dot(param1:Vertex3DInstance, param2:Vertex3DInstance) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function subTo(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance) : void
      {
         param3.x = param2.x - param1.x;
         param3.y = param2.y - param1.y;
      }
      
      public static function median(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Number) : Vertex3DInstance
      {
         var _loc4_:Number = (param1.z + param2.z) / 2;
         var _loc5_:Number = param3 + param1.z;
         var _loc6_:Number = param3 + param2.z;
         var _loc7_:Number = 1 / (param3 + _loc4_) / 2;
         return new Vertex3DInstance((param1.x * _loc5_ + param2.x * _loc6_) * _loc7_,(param1.y * _loc5_ + param2.y * _loc6_) * _loc7_,_loc4_);
      }
      
      public static function sub(param1:Vertex3DInstance, param2:Vertex3DInstance) : Vertex3DInstance
      {
         return new Vertex3DInstance(param2.x - param1.x,param2.y - param1.y);
      }
      
      public function deperspective(param1:Number) : Vertex3D
      {
         persp = 1 + z / param1;
         return new Vertex3D(x * persp,y * persp,z);
      }
      
      public function distance(param1:Vertex3DInstance) : Number
      {
         return Math.sqrt((x - param1.x) * (x - param1.x) + (y - param1.y) * (y - param1.y));
      }
      
      public function clone() : Vertex3DInstance
      {
         var _loc1_:Vertex3DInstance = new Vertex3DInstance(x,y,z);
         _loc1_.visible = visible;
         _loc1_.extra = extra;
         return _loc1_;
      }
      
      public function distanceSqr(param1:Vertex3DInstance) : Number
      {
         return (x - param1.x) * (x - param1.x) + (y - param1.y) * (y - param1.y);
      }
   }
}

