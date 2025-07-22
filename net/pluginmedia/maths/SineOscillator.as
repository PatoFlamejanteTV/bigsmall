package net.pluginmedia.maths
{
   public class SineOscillator
   {
      
      public static var PIOVERONEEIGHTY:Number = Math.PI / 180;
      
      public var amplitude:Number = 0;
      
      public var stepCtr:Number = 0;
      
      public var phase:Number = 0;
      
      public var frequency:Number = 0;
      
      public function SineOscillator(param1:Number, param2:Number, param3:Number)
      {
         super();
         stepCtr = 0;
         amplitude = param1;
         frequency = param2;
         phase = param3;
      }
      
      public static function getValueForTWithVars(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Number
      {
         return param2 * Math.sin(param1 * param3 * PIOVERONEEIGHTY + param4);
      }
      
      public function step(param1:Number = 1) : Number
      {
         stepCtr = (stepCtr + param1) % 360;
         return getValueForT(stepCtr);
      }
      
      public function getValueForT(param1:Number) : Number
      {
         return amplitude * Math.sin(param1 * frequency * PIOVERONEEIGHTY + phase);
      }
   }
}

