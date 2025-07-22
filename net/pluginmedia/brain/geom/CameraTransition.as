package net.pluginmedia.brain.geom
{
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   
   public class CameraTransition extends BezierPath3D
   {
      
      public var cameraTargetPath:BezierPath3D;
      
      public function CameraTransition(param1:Number = 8, param2:BezierPath3D = null)
      {
         super(param1);
         if(param2 !== null)
         {
            cameraTargetPath = param2;
         }
         else
         {
            cameraTargetPath = new BezierPath3D(param1);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         cameraTargetPath.destroy();
         cameraTargetPath = null;
      }
      
      public function duplicate() : CameraTransition
      {
         var _loc4_:BezierPoint3D = null;
         var _loc1_:Array = _points.concat();
         var _loc2_:BezierPath3D = null;
         if(cameraTargetPath !== null)
         {
            _loc2_ = cameraTargetPath.clone();
         }
         var _loc3_:CameraTransition = new CameraTransition(curveMag,_loc2_);
         for each(_loc4_ in _loc1_)
         {
            _loc3_.addPoint3D(_loc4_);
         }
         _loc3_.transitStepInc = this.transitStepInc;
         return _loc3_;
      }
   }
}

