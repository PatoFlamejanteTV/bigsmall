package net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions
{
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.AbstractSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.PathSegment;
   import net.pluginmedia.geom.BezierPath3D;
   
   public class TransitionObject
   {
      
      public var targetSegment:AbstractSegment;
      
      public var reverse:Boolean = false;
      
      public var pathSegment:PathSegment;
      
      public var transStepInc:Number;
      
      public var sourceOrientation:Number;
      
      public var sourceSegment:AbstractSegment;
      
      public var pathKey:String;
      
      public var targetOrientation:Number;
      
      public function TransitionObject(param1:AbstractSegment, param2:String, param3:AbstractSegment)
      {
         super();
         sourceSegment = param1;
         targetSegment = param3;
         pathKey = param2;
         sourceOrientation = param1.orientation;
         targetOrientation = param3.orientation;
      }
      
      public function get path() : BezierPath3D
      {
         return pathSegment.getBezierOfPath(pathKey);
      }
   }
}

