package org.ascollada.core
{
   public class DaeBlendWeight
   {
      
      public var weight:Number;
      
      public var originalWeight:Number;
      
      public var joint:String;
      
      public var vertexIndex:uint;
      
      public function DaeBlendWeight(param1:uint = 0, param2:String = "", param3:Number = 0)
      {
         super();
         this.vertexIndex = param1;
         this.joint = param2;
         this.originalWeight = this.weight = param3;
      }
      
      public function toString() : String
      {
         return "[v:" + this.vertexIndex + " j:" + this.joint + " w:" + this.weight + "]";
      }
   }
}

