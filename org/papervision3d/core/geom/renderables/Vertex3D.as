package org.papervision3d.core.geom.renderables
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.command.IRenderListItem;
   
   public class Vertex3D extends AbstractRenderable implements IRenderable
   {
      
      public var z:Number;
      
      public var vertex3DInstance:Vertex3DInstance;
      
      public var extra:Object;
      
      public var timestamp:Number;
      
      public var normal:Number3D;
      
      protected var position:Number3D = new Number3D();
      
      public var connectedFaces:Dictionary;
      
      public var x:Number;
      
      public var y:Number;
      
      private var persp:Number = 0;
      
      public function Vertex3D(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = position.x = param1;
         this.y = position.y = param2;
         this.z = position.z = param3;
         this.vertex3DInstance = new Vertex3DInstance();
         this.normal = new Number3D();
         this.connectedFaces = new Dictionary();
      }
      
      public static function weighted(param1:Vertex3D, param2:Vertex3D, param3:Number, param4:Number) : Vertex3D
      {
         var _loc5_:Number = param3 + param4;
         var _loc6_:Number = param3 / _loc5_;
         var _loc7_:Number = param4 / _loc5_;
         return new Vertex3D(param1.x * _loc6_ + param2.x * _loc7_,param1.y * _loc6_ + param2.y * _loc7_,param1.z * _loc6_ + param2.z * _loc7_);
      }
      
      public function perspective(param1:Number) : Vertex3DInstance
      {
         persp = 1 / (1 + z / param1);
         return new Vertex3DInstance(x * persp,y * persp,z);
      }
      
      public function toNumber3D() : Number3D
      {
         return new Number3D(x,y,z);
      }
      
      public function clone() : Vertex3D
      {
         var _loc1_:Vertex3D = new Vertex3D(x,y,z);
         _loc1_.extra = extra;
         _loc1_.vertex3DInstance = vertex3DInstance.clone();
         _loc1_.normal = normal.clone();
         return _loc1_;
      }
      
      public function getPosition() : Number3D
      {
         position.x = x;
         position.y = y;
         position.z = z;
         return position;
      }
      
      public function calculateNormal() : void
      {
         var _loc1_:Triangle3D = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number3D = null;
         _loc2_ = 0;
         normal.reset();
         for each(_loc1_ in connectedFaces)
         {
            if(_loc1_.faceNormal)
            {
               _loc2_++;
               normal.plusEq(_loc1_.faceNormal);
            }
         }
         _loc3_ = getPosition();
         _loc3_.x /= _loc2_;
         _loc3_.y /= _loc2_;
         _loc3_.z /= _loc2_;
         _loc3_.normalize();
         normal.plusEq(_loc3_);
         normal.normalize();
      }
      
      override public function getRenderListItem() : IRenderListItem
      {
         return null;
      }
   }
}

