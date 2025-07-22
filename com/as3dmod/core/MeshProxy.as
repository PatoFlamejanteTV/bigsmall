package com.as3dmod.core
{
   import com.as3dmod.util.ModConstant;
   
   public class MeshProxy
   {
      
      protected var vertices:Array;
      
      protected var _midAxis:int;
      
      protected var _maxX:Number;
      
      protected var _maxZ:Number;
      
      protected var _maxY:Number;
      
      protected var _minAxis:int;
      
      protected var _minX:Number;
      
      protected var _minZ:Number;
      
      protected var _minY:Number;
      
      protected var _maxAxis:int;
      
      protected var _sizeX:Number;
      
      protected var _sizeY:Number;
      
      protected var _sizeZ:Number;
      
      public function MeshProxy()
      {
         super();
         vertices = new Array();
      }
      
      public function get minX() : Number
      {
         return _minX;
      }
      
      public function get minY() : Number
      {
         return _minY;
      }
      
      public function get minZ() : Number
      {
         return _minZ;
      }
      
      public function get midAxis() : int
      {
         return _midAxis;
      }
      
      public function get minAxis() : int
      {
         return _minAxis;
      }
      
      public function getMin(param1:int) : Number
      {
         switch(param1)
         {
            case ModConstant.X:
               return _minX;
            case ModConstant.Y:
               return _minY;
            case ModConstant.Z:
               return _minZ;
            default:
               return -1;
         }
      }
      
      public function analyzeGeometry() : void
      {
         var _loc2_:int = 0;
         var _loc3_:VertexProxy = null;
         var _loc1_:int = int(getVertices().length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getVertices()[_loc2_] as VertexProxy;
            if(_loc2_ == 0)
            {
               _minX = _maxX = _loc3_.x;
               _minY = _maxY = _loc3_.y;
               _minZ = _maxZ = _loc3_.z;
            }
            else
            {
               _minX = Math.min(_minX,_loc3_.x);
               _minY = Math.min(_minY,_loc3_.y);
               _minZ = Math.min(_minZ,_loc3_.z);
               _maxX = Math.max(_maxX,_loc3_.x);
               _maxY = Math.max(_maxY,_loc3_.y);
               _maxZ = Math.max(_maxZ,_loc3_.z);
            }
            _loc3_.setOriginalPosition(_loc3_.x,_loc3_.y,_loc3_.z);
            _loc2_++;
         }
         _sizeX = _maxX - _minX;
         _sizeY = _maxY - _minY;
         _sizeZ = _maxZ - _minZ;
         var _loc4_:Number = Math.max(_sizeX,Math.max(_sizeY,_sizeZ));
         var _loc5_:Number = Math.min(_sizeX,Math.min(_sizeY,_sizeZ));
         if(_loc4_ == _sizeX && _loc5_ == _sizeY)
         {
            _minAxis = ModConstant.Y;
            _midAxis = ModConstant.Z;
            _maxAxis = ModConstant.X;
         }
         else if(_loc4_ == _sizeX && _loc5_ == _sizeZ)
         {
            _minAxis = ModConstant.Z;
            _midAxis = ModConstant.Y;
            _maxAxis = ModConstant.X;
         }
         else if(_loc4_ == _sizeY && _loc5_ == _sizeX)
         {
            _minAxis = ModConstant.X;
            _midAxis = ModConstant.Z;
            _maxAxis = ModConstant.Y;
         }
         else if(_loc4_ == _sizeY && _loc5_ == _sizeZ)
         {
            _minAxis = ModConstant.Z;
            _midAxis = ModConstant.X;
            _maxAxis = ModConstant.Y;
         }
         else if(_loc4_ == _sizeZ && _loc5_ == _sizeX)
         {
            _minAxis = ModConstant.X;
            _midAxis = ModConstant.Y;
            _maxAxis = ModConstant.Z;
         }
         else if(_loc4_ == _sizeZ && _loc5_ == _sizeY)
         {
            _minAxis = ModConstant.Y;
            _midAxis = ModConstant.X;
            _maxAxis = ModConstant.Z;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getVertices()[_loc2_] as VertexProxy;
            _loc3_.setRatios((_loc3_.x - _minX) / _sizeX,(_loc3_.y - _minY) / _sizeY,(_loc3_.z - _minZ) / _sizeZ);
            _loc2_++;
         }
      }
      
      public function resetGeometry() : void
      {
         var _loc3_:VertexProxy = null;
         var _loc1_:int = int(getVertices().length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getVertices()[_loc2_] as VertexProxy;
            _loc3_.reset();
            _loc2_++;
         }
      }
      
      public function get maxAxis() : int
      {
         return _maxAxis;
      }
      
      public function getMax(param1:int) : Number
      {
         switch(param1)
         {
            case ModConstant.X:
               return _maxX;
            case ModConstant.Y:
               return _maxY;
            case ModConstant.Z:
               return _maxZ;
            default:
               return -1;
         }
      }
      
      public function setMesh(param1:*) : void
      {
      }
      
      public function get maxX() : Number
      {
         return _maxX;
      }
      
      public function get maxY() : Number
      {
         return _maxY;
      }
      
      public function get maxZ() : Number
      {
         return _maxZ;
      }
      
      public function getVertices() : Array
      {
         return vertices;
      }
      
      public function collapseGeometry() : void
      {
         var _loc3_:VertexProxy = null;
         var _loc1_:int = int(getVertices().length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getVertices()[_loc2_] as VertexProxy;
            _loc3_.collapse();
            _loc2_++;
         }
         analyzeGeometry();
      }
   }
}

