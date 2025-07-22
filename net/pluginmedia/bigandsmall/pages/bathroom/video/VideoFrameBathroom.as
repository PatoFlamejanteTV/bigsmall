package net.pluginmedia.bigandsmall.pages.bathroom.video
{
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.pages.shared.video.FramedVideoPage3D;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class VideoFrameBathroom extends FramedVideoPage3D
   {
      
      private var bathroomPageSharedLayer:ViewportLayer;
      
      public function VideoFrameBathroom(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc5_:OrbitCamera3D = null;
         var _loc4_:Number3D = new Number3D(-348,545,-935);
         _loc5_ = new OrbitCamera3D(45);
         super(param1,_loc4_,_loc5_,_loc5_,param2,param3);
         _loc5_.rotationYMin = -17.1;
         _loc5_.rotationYMax = -13;
         _loc5_.radius = -60;
         _loc5_.rotationXMin = 2;
         _loc5_.rotationXMax = -2;
         _loc5_.orbitCentre.x = _loc4_.x;
         _loc5_.orbitCentre.y = _loc4_.y;
         _loc5_.orbitCentre.z = _loc4_.z;
         this.rotationY = 165;
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.BATHROOM_ROOM);
         return _loc1_;
      }
      
      private function handleVideoLayerShared(param1:SharerInfo) : void
      {
         bathroomPageSharedLayer = param1.reference as ViewportLayer;
      }
      
      override protected function receiveFrame(param1:IAssetLoader) : void
      {
         hiResFrame = DAEFixed(param1.getContent());
         hiResFrame.scale = 27;
         hiResFrame.rotationY = 180;
         videoPlane.z += 1.5;
         hiResFrame.removeChild(hiResFrame.getChildByName("BathroomImage",true));
         registerLiveDO3D(DO3DDefinitions.BATHROOM_HIPOLYVIDEOFRAME,hiResFrame);
         setReadyState();
      }
      
      override protected function initLayers() : void
      {
         if(bathroomPageSharedLayer)
         {
            hiResFrameLayer = bathroomPageSharedLayer.getChildLayer(hiResFrame,true,true);
         }
         else
         {
            hiResFrameLayer = basicView.viewport.getChildLayer(hiResFrame,true);
         }
         videoLayer = hiResFrameLayer.getChildLayer(videoPlane,true);
      }
      
      override public function onShareableRegistration() : void
      {
         super.onShareableRegistration();
         dispatchShareRequest(new ShareRequest(this,DO3DDefinitions.BATHROOM_LOPOLYVIDEOFRAME,handleSetLowResFrame));
         dispatchShareRequest(new ShareRequest(this,"VideoFileG",handleVideoLocation));
         dispatchShareRequest(new ShareRequest(this,"BathroomVideoFrameLayer",handleVideoLayerShared));
         registerLiveDO3D(DO3DDefinitions.BATHROOM_VIDEOPLANE,videoPlane);
      }
      
      override public function activate() : void
      {
         super.activate();
      }
      
      override public function onRegistration() : void
      {
         super.onRegistration();
         dispatchAssetRequest("VideoFrameBathroom.frameDae",DAELocations.bathroomVideoFrame,receiveFrame);
      }
   }
}

