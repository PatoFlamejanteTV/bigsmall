package net.pluginmedia.bigandsmall.pages.garden.tree
{
   import org.papervision3d.core.math.Number3D;
   
   public class AppleTreeFloor
   {
      
      private var floor:Array;
      
      private var bigW:Number;
      
      private var bigY:Number;
      
      private var bigX:Number;
      
      public function AppleTreeFloor(param1:Array, param2:Number, param3:Number, param4:Number)
      {
         super();
         floor = param1;
         bigX = param2;
         bigY = param4;
         bigW = param3;
      }
      
      public function hitsBig(param1:AppleParticle) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1.x >= bigX && param1.x <= bigX + bigW)
         {
            if(param1.y > bigY && param1.y + param1.velocity.y < bigY)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function getGradientFromX(param1:Number) : Number
      {
         var _loc2_:Number3D = null;
         var _loc3_:Number3D = null;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:int = 0;
         while(_loc5_ < floor.length)
         {
            _loc2_ = floor[_loc5_];
            if(_loc5_ == floor.length - 1)
            {
               return 0;
            }
            if(_loc5_ == 0 && param1 < floor[0].x)
            {
               return 0;
            }
            _loc3_ = floor[_loc5_ + 1];
            _loc6_ = _loc2_.x;
            _loc7_ = _loc3_.x;
            if(param1 >= _loc6_ && param1 <= _loc7_)
            {
               _loc8_ = _loc3_.y - _loc2_.y;
               _loc9_ = _loc3_.x - _loc2_.x;
               _loc4_ = _loc8_ / _loc9_;
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getYFromX(param1:Number) : Number
      {
         var _loc2_:Number3D = null;
         var _loc3_:Number3D = null;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:int = 0;
         while(_loc5_ < floor.length)
         {
            _loc2_ = floor[_loc5_];
            if(_loc5_ == floor.length - 1)
            {
               _loc4_ = _loc2_.y;
               break;
            }
            if(_loc5_ == 0 && param1 < floor[0].x)
            {
               _loc4_ = _loc2_.y;
               break;
            }
            _loc3_ = floor[_loc5_ + 1];
            _loc6_ = _loc2_.x;
            _loc7_ = _loc3_.x;
            if(param1 >= _loc6_ && param1 <= _loc7_)
            {
               _loc8_ = _loc3_.y - _loc2_.y;
               _loc9_ = (param1 - _loc6_) / (_loc7_ - _loc6_);
               _loc4_ = _loc2_.y + _loc8_ * _loc9_;
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function get z() : Number
      {
         return Number(floor[0].z);
      }
   }
}

