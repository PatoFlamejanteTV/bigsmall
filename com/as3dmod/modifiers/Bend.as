package com.as3dmod.modifiers
{
   import com.as3dmod.IModifier;
   import com.as3dmod.core.Modifier;
   import com.as3dmod.core.VertexProxy;
   import com.as3dmod.util.ModConstant;
   
   public class Bend extends Modifier implements IModifier
   {
      
      private var cst:int = 0;
      
      private var mia:int = 0;
      
      private var maa:int = 0;
      
      private var frc:Number;
      
      private var ofs:Number;
      
      public function Bend(param1:Number = 0, param2:Number = 0.5)
      {
         super();
         force = param1;
         offset = param2;
      }
      
      public function set constraint(param1:int) : void
      {
         cst = param1;
      }
      
      public function get offset() : Number
      {
         return ofs;
      }
      
      public function set pointAxis(param1:int) : void
      {
         mia = param1;
      }
      
      public function get force() : Number
      {
         return frc;
      }
      
      public function apply() : void
      {
         var _loc9_:VertexProxy = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(force == 0)
         {
            return;
         }
         if(maa == ModConstant.NONE)
         {
            maa = mod.maxAxis;
         }
         if(mia == ModConstant.NONE)
         {
            mia = mod.minAxis;
         }
         var _loc1_:Number = mod.getMin(maa);
         var _loc2_:Number = mod.getMax(maa) - _loc1_;
         var _loc3_:Array = mod.getVertices();
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Number = _loc1_ + _loc2_ * offset;
         var _loc6_:Number = _loc2_ / Math.PI / force;
         var _loc7_:Number = Math.PI * 2 * (_loc2_ / (_loc6_ * Math.PI * 2));
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_)
         {
            _loc9_ = _loc3_[_loc8_] as VertexProxy;
            _loc10_ = _loc9_.getRatio(maa);
            if(!(constraint == ModConstant.LEFT && _loc10_ <= offset))
            {
               if(!(constraint == ModConstant.RIGHT && _loc10_ >= offset))
               {
                  _loc11_ = Math.PI / 2 - _loc7_ * offset + _loc7_ * _loc10_;
                  _loc12_ = Math.sin(_loc11_) * (_loc6_ + _loc9_.getValue(mia)) - _loc6_;
                  _loc13_ = _loc5_ - Math.cos(_loc11_) * (_loc6_ + _loc9_.getValue(mia));
                  _loc9_.setValue(mia,_loc12_);
                  _loc9_.setValue(maa,_loc13_);
               }
            }
            _loc8_++;
         }
      }
      
      public function set bendAxis(param1:int) : void
      {
         maa = param1;
      }
      
      public function set offset(param1:Number) : void
      {
         ofs = param1;
         ofs = Math.max(0,param1);
         ofs = Math.min(1,param1);
      }
      
      public function set force(param1:Number) : void
      {
         frc = param1;
      }
      
      public function get constraint() : int
      {
         return cst;
      }
   }
}

