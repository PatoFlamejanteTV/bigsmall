package net.pluginmedia.bigandsmall.pages.shared.video
{
   import flash.utils.Dictionary;
   import gs.TweenMax;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class FramedVideoPage3D extends VideoPage3D
   {
      
      protected var lowResFrame:DisplayObject3D;
      
      protected var hiResFrameLayer:ViewportLayer;
      
      protected var hiResFrame:DAEFixed;
      
      protected var room:DisplayObject3D;
      
      public function FramedVideoPage3D(param1:BasicView, param2:Number3D, param3:OrbitCamera3D, param4:OrbitCamera3D, param5:String, param6:Page3D = null, param7:Number = 448, param8:Number = 252)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         if(hiResFrameLayer)
         {
            hiResFrameLayer.alpha = 0;
            TweenMax.to(hiResFrameLayer,0.25,{
               "alpha":1,
               "overwrite":true
            });
         }
      }
      
      override protected function handleSetTransitionFX(param1:SharerInfo) : void
      {
         var _loc2_:Dictionary = param1.reference as Dictionary;
         transitionFX.setUserDataPool(param1.reference as Dictionary);
      }
      
      protected function handleSetLowResFrame(param1:SharerInfo) : void
      {
         lowResFrame = param1.reference as DisplayObject3D;
      }
      
      protected function receiveFrame(param1:IAssetLoader) : void
      {
         hiResFrame = DAEFixed(param1.getContent());
         hiResFrameLayer = basicView.viewport.getChildLayer(hiResFrame,true);
         setReadyState();
      }
      
      override protected function handleVideoWipeOut() : void
      {
         if(hiResFrameLayer)
         {
            TweenMax.to(hiResFrameLayer,0.25,{
               "alpha":0,
               "overwrite":true
            });
         }
      }
      
      override protected function initLayers() : void
      {
         videoLayer = hiResFrameLayer.getChildLayer(videoPlane,true);
      }
      
      override public function activate() : void
      {
         super.activate();
         if(lowResFrame)
         {
            lowResFrame.visible = false;
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(lowResFrame)
         {
            lowResFrame.visible = true;
         }
      }
   }
}

