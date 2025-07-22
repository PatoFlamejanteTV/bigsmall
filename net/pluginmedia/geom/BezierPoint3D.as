package net.pluginmedia.geom
{
   import org.papervision3d.core.math.Number3D;
   
   public class BezierPoint3D extends Point3D
   {
      
      public var controlA:Number3D;
      
      public var controlB:Number3D;
      
      public function BezierPoint3D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number3D = null, param5:Number3D = null)
      {
         super(param1,param2,param3);
         if(param4)
         {
            controlA = param4;
         }
         else
         {
            controlA = new Number3D(param1,param2,param3);
         }
         if(param5)
         {
            controlB = param5;
         }
         else
         {
            controlB = new Number3D(param1,param2,param3);
         }
      }
   }
}

