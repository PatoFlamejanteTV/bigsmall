package org.papervision3d.core.math
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class AxisAlignedBoundingBox
   {
      
      public var minX:Number;
      
      public var minY:Number;
      
      public var minZ:Number;
      
      public var maxX:Number;
      
      public var maxY:Number;
      
      public var maxZ:Number;
      
      protected var _vertices:Array;
      
      public function AxisAlignedBoundingBox(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number)
      {
         super();
         this.minX = param1;
         this.minY = param2;
         this.minZ = param3;
         this.maxX = param4;
         this.maxY = param5;
         this.maxZ = param6;
         createBoxVertices();
      }
      
      public static function createFromVertices(param1:Array) : AxisAlignedBoundingBox
      {
         var _loc8_:Vertex3D = null;
         var _loc2_:Number = Number.MAX_VALUE;
         var _loc3_:Number = Number.MAX_VALUE;
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:Number = -_loc2_;
         var _loc6_:Number = -_loc3_;
         var _loc7_:Number = -_loc4_;
         for each(_loc8_ in param1)
         {
            _loc2_ = Math.min(_loc2_,_loc8_.x);
            _loc3_ = Math.min(_loc3_,_loc8_.y);
            _loc4_ = Math.min(_loc4_,_loc8_.z);
            _loc5_ = Math.max(_loc5_,_loc8_.x);
            _loc6_ = Math.max(_loc6_,_loc8_.y);
            _loc7_ = Math.max(_loc7_,_loc8_.z);
         }
         return new AxisAlignedBoundingBox(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
      }
      
      protected function createBoxVertices() : void
      {
         _vertices = new Array();
         _vertices.push(new Vertex3D(minX,minY,minZ));
         _vertices.push(new Vertex3D(minX,minY,maxZ));
         _vertices.push(new Vertex3D(minX,maxY,minZ));
         _vertices.push(new Vertex3D(minX,maxY,maxZ));
         _vertices.push(new Vertex3D(maxX,minY,minZ));
         _vertices.push(new Vertex3D(maxX,minY,maxZ));
         _vertices.push(new Vertex3D(maxX,maxY,minZ));
         _vertices.push(new Vertex3D(maxX,maxY,maxZ));
      }
      
      public function getBoxVertices() : Array
      {
         return _vertices;
      }
      
      public function merge(param1:AxisAlignedBoundingBox) : void
      {
         this.minX = Math.min(this.minX,param1.minX);
         this.minY = Math.min(this.minY,param1.minY);
         this.minZ = Math.min(this.minZ,param1.minZ);
         this.maxX = Math.max(this.maxX,param1.maxX);
         this.maxY = Math.max(this.maxY,param1.maxY);
         this.maxZ = Math.max(this.maxZ,param1.maxZ);
         createBoxVertices();
      }
   }
}

