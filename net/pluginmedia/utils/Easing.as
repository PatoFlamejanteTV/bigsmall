package net.pluginmedia.utils
{
   public class Easing
   {
      
      public function Easing()
      {
         super();
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:int = 2, param5:Number = 1) : Number
      {
         return -param3 * (param1 = param1 / param5) * (param1 - 2) + param2;
      }
      
      public static function easeIn(param1:Number, param2:Number, param3:Number, param4:int = 2, param5:Number = 1) : Number
      {
         return param3 * (param1 = param1 / param5) * param1 + param2;
      }
      
      public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:int = 2, param5:Number = 1) : Number
      {
         param1 = param1 / (param5 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 + param2;
         }
         return -param3 / 2 * (--param1 * (param1 - 2) - 1) + param2;
      }
   }
}

