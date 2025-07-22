package net.pluginmedia.bigandsmall.pages.livingroom.videos
{
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.pages.shared.video.FramedVideoPage3D;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   
   public class VideoFrameOrangeBFly extends FramedVideoPage3D
   {
      
      public function VideoFrameOrangeBFly(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc5_:OrbitCamera3D = null;
         var _loc4_:Number3D = new Number3D(85,296,244);
         _loc5_ = new OrbitCamera3D(45);
         _loc5_.rotationYMin = -0.1;
         _loc5_.rotationYMax = 0.1;
         _loc5_.radius = 60;
         _loc5_.rotationXMin = -0.1;
         _loc5_.rotationXMax = 0.1;
         _loc5_.orbitCentre.x = _loc4_.x;
         _loc5_.orbitCentre.y = _loc4_.y;
         _loc5_.orbitCentre.z = _loc4_.z;
         super(param1,_loc4_,_loc5_,_loc5_,param2,param3);
      }
      
      override protected function receiveFrame(param1:IAssetLoader) : void
      {
         super.receiveFrame(param1);
         hiResFrame.scale = 27;
         hiResFrame.rotationY = 180;
         videoPlane.z -= 1.5;
         registerLiveDO3D(DO3DDefinitions.VIDEOFRAME_B_FRAME,hiResFrame);
         var _loc2_:DisplayObject3D = hiResFrame.getChildByName("Image6",true);
         _loc2_.material = new WireframeMaterial(16711680,0);
      }
      
      override public function onShareableRegistration() : void
      {
         super.onShareableRegistration();
         dispatchShareRequest(new ShareRequest(this,"VideoFrame.OrangeBFly",handleSetLowResFrame));
         dispatchShareRequest(new ShareRequest(this,"VideoFileD",handleVideoLocation));
         registerLiveDO3D(DO3DDefinitions.VIDEOFRAME_B_VIDEO,videoPlane);
      }
      
      override public function onRegistration() : void
      {
         super.onRegistration();
         dispatchAssetRequest("VideoFrameOrangeBFly.frameDae",DAELocations.livingRoomVideoFrameOrangeBfly,receiveFrame);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.LIVINGROOM_ROOM);
         _loc1_.push(DO3DDefinitions.VIDEOFRAME_B_FRAME);
         _loc1_.push(DO3DDefinitions.VIDEOFRAME_B_VIDEO);
         return _loc1_;
      }
      
      override public function activate() : void
      {
         super.activate();
      }
   }
}

