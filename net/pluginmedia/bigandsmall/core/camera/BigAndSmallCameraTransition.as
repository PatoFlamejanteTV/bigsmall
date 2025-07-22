package net.pluginmedia.bigandsmall.core.camera
{
   import net.pluginmedia.bigandsmall.core.SceneChangeInfo;
   import net.pluginmedia.brain.geom.CameraTransition;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   
   public class BigAndSmallCameraTransition extends CameraTransition
   {
      
      public var sceneChangeInfo:SceneChangeInfo = null;
      
      public function BigAndSmallCameraTransition(param1:Number = 8, param2:BezierPath3D = null, param3:SceneChangeInfo = null)
      {
         sceneChangeInfo = param3;
         super(param1,param2);
      }
      
      override public function duplicate() : CameraTransition
      {
         var _loc5_:BezierPoint3D = null;
         var _loc1_:Array = _points.concat();
         var _loc2_:BezierPath3D = null;
         if(cameraTargetPath !== null)
         {
            _loc2_ = cameraTargetPath.clone();
         }
         var _loc3_:SceneChangeInfo = null;
         if(sceneChangeInfo)
         {
            _loc3_ = new SceneChangeInfo(sceneChangeInfo.useTransition,sceneChangeInfo.changeAtT1,sceneChangeInfo.changeAtT2);
         }
         var _loc4_:BigAndSmallCameraTransition = new BigAndSmallCameraTransition(curveMag,_loc2_,_loc3_);
         for each(_loc5_ in _loc1_)
         {
            _loc4_.addPoint3D(_loc5_);
         }
         _loc4_.transitStepInc = this.transitStepInc;
         return _loc4_;
      }
   }
}

