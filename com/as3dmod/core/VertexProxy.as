package com.as3dmod.core
{
   import com.as3dmod.util.ModConstant;
   
   public class VertexProxy
   {
      
      private var _ratioX:Number;
      
      private var _ratioY:Number;
      
      private var _ratioZ:Number;
      
      protected var ox:Number;
      
      protected var oy:Number;
      
      protected var oz:Number;
      
      public function VertexProxy()
      {
         super();
      }
      
      public function get originalZ() : Number
      {
         return oz;
      }
      
      public function setRatios(param1:Number, param2:Number, param3:Number) : void
      {
         _ratioX = param1;
         _ratioY = param2;
         _ratioZ = param3;
      }
      
      public function reset() : void
      {
         x = ox;
         y = oy;
         z = oz;
      }
      
      public function getRatio(param1:int) : Number
      {
         switch(param1)
         {
            case ModConstant.X:
               return _ratioX;
            case ModConstant.Y:
               return _ratioY;
            case ModConstant.Z:
               return _ratioZ;
            default:
               return -1;
         }
      }
      
      public function setOriginalPosition(param1:Number, param2:Number, param3:Number) : void
      {
         this.ox = param1;
         this.oy = param2;
         this.oz = param3;
      }
      
      public function setVertex(param1:*) : void
      {
      }
      
      public function get originalX() : Number
      {
         return ox;
      }
      
      public function get originalY() : Number
      {
         return oy;
      }
      
      public function get ratioX() : Number
      {
         return _ratioX;
      }
      
      public function get ratioY() : Number
      {
         return _ratioY;
      }
      
      public function setValue(param1:int, param2:Number) : void
      {
         switch(param1)
         {
            case ModConstant.X:
               x = param2;
               break;
            case ModConstant.Y:
               y = param2;
               break;
            case ModConstant.Z:
               z = param2;
         }
      }
      
      public function set x(param1:Number) : void
      {
      }
      
      public function getOriginalValue(param1:int) : Number
      {
         switch(param1)
         {
            case ModConstant.X:
               return ox;
            case ModConstant.Y:
               return oy;
            case ModConstant.Z:
               return oz;
            default:
               return 0;
         }
      }
      
      public function set y(param1:Number) : void
      {
      }
      
      public function set z(param1:Number) : void
      {
      }
      
      public function get ratioZ() : Number
      {
         return _ratioZ;
      }
      
      public function get x() : Number
      {
         return 0;
      }
      
      public function get y() : Number
      {
         return 0;
      }
      
      public function get z() : Number
      {
         return 0;
      }
      
      public function getValue(param1:int) : Number
      {
         switch(param1)
         {
            case ModConstant.X:
               return x;
            case ModConstant.Y:
               return y;
            case ModConstant.Z:
               return z;
            default:
               return 0;
         }
      }
      
      public function collapse() : void
      {
         ox = x;
         oy = y;
         oz = z;
      }
   }
}

