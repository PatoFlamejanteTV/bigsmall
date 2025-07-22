package org.papervision3d.core.animation
{
   public class AnimationKeyFrame3D
   {
      
      public static const INTERPOLATION_LINEAR:String = "LINEAR";
      
      public static const INTERPOLATION_BEZIER:String = "BEZIER";
      
      public var inTangent:Array;
      
      public var output:Array;
      
      public var interpolation:String;
      
      public var name:String;
      
      public var time:Number;
      
      public var outTangent:Array;
      
      public function AnimationKeyFrame3D(param1:String, param2:Number, param3:Array = null, param4:String = null, param5:Array = null, param6:Array = null)
      {
         super();
         this.name = param1;
         this.time = param2;
         this.output = param3 || new Array();
         this.interpolation = param4 || INTERPOLATION_LINEAR;
         this.inTangent = param5 || new Array();
         this.outTangent = param6 || new Array();
      }
   }
}

