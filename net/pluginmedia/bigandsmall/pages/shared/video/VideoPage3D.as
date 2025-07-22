package net.pluginmedia.bigandsmall.pages.shared.video
{
   import fl.video.VideoEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.animation.BigAndSmallCompTransitionFX;
   import net.pluginmedia.bigandsmall.core.animation.CompositeTransitionFX;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.FLVLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.video.VideoPlayback;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class VideoPage3D extends BigAndSmallPage3D
   {
      
      protected var loadingBegun:Boolean = false;
      
      protected var videoMaterial:MovieMaterial;
      
      protected var videoFrame2D:MovieClip;
      
      protected var video2D:VideoPlayback;
      
      protected var videoLayer:ViewportLayer;
      
      public var parentPage:Page3D;
      
      protected var videoPlane:Plane;
      
      protected var transitionFX:CompositeTransitionFX;
      
      protected var videoURL:String;
      
      protected var backButton:AssetButton;
      
      public function VideoPage3D(param1:BasicView, param2:Number3D, param3:OrbitCamera3D, param4:OrbitCamera3D, param5:String, param6:Page3D = null, param7:Number = 448, param8:Number = 252)
      {
         parentPage = param6;
         super(param1,param2,param3,param4,param5);
         video2D = new VideoPlayback(param7,param8);
         transitionFX = new BigAndSmallCompTransitionFX();
         transitionFX.scaleX = transitionFX.scaleY = 0.7;
         transitionFX.x = video2D.width / 2;
         transitionFX.y = video2D.height / 2;
         video2D.addChild(transitionFX);
         videoMaterial = new MovieMaterial(video2D,true,false,false,video2D.getBounds(video2D));
         var _loc9_:Number = 0.126;
         videoPlane = new Plane(videoMaterial,448 * _loc9_,322 * _loc9_,4,4);
      }
      
      public function dropTransitionControl() : void
      {
         transitionFX.callback_onTransitComplete = null;
         hideVideo();
      }
      
      protected function handleVideoComplete(param1:VideoEvent) : void
      {
      }
      
      protected function handleVideoLocation(param1:SharerInfo) : void
      {
         videoURL = FLVLocations.prefixURL + param1.reference.toString();
      }
      
      protected function hideVideo() : void
      {
         video2D.flvPlayback.visible = video2D.controlPanel.visible = video2D.blackBackground.visible = false;
         transitionFX.doNamedTransitionOut("Transition_B",handleVideoWipeOut,null,false,3);
      }
      
      protected function handleTransitionInComplete() : void
      {
      }
      
      protected function initLayers() : void
      {
         videoLayer = basicView.viewport.getChildLayer(videoPlane,true);
      }
      
      override public function onShareableRegistration() : void
      {
         dispatchShareRequest(new ShareRequest(this,"GlobalAssets.TransitionFX",handleSetTransitionFX));
         dispatchShareRequest(new ShareRequest(this,"GlobalAssets.BackButton",handleSetBackButton));
      }
      
      protected function handleVideoWipeOut() : void
      {
      }
      
      override public function prepare(param1:String = null) : void
      {
         basicView.viewport.interactive = true;
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_BUTTONS));
         videoPlane.visible = true;
         video2D.controlPanel.visible = video2D.flvPlayback.visible = video2D.blackBackground.visible = false;
         transitionFX.doNamedTransitionIn("Transition_B",handleTransitionInMidpoint,null,false,3);
         video2D.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      override public function activate() : void
      {
         super.activate();
         dispatchEvent(new BrainEvent(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON));
         alwaysSmoothed = true;
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         pageContainer2D.addChild(video2D);
         var _loc1_:Number = 1.08;
         video2D.scaleX = video2D.scaleY = _loc1_;
         video2D.x = pageWidth / 2 - 224 * _loc1_;
         video2D.y = pageHeight / 2 - 162 * _loc1_;
         if(videoURL)
         {
            video2D.load(videoURL);
            loadingBegun = true;
         }
         video2D.controlPanel.setVolume(video2D.flvPlayback.volume);
         video2D.play();
      }
      
      protected function handleTransitionInMidpoint() : void
      {
         video2D.controlPanel.visible = video2D.flvPlayback.visible = video2D.blackBackground.visible = true;
         transitionFX.doNamedTransitionOut("Transition_B",handleTransitionInComplete,null,false,3);
      }
      
      protected function handleSetTransitionFX(param1:SharerInfo) : void
      {
         var _loc2_:Dictionary = param1.reference as Dictionary;
         transitionFX.setUserDataPool(param1.reference as Dictionary);
         setReadyState();
      }
      
      protected function handleBackButtonClick(param1:BrainEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(param1.actionType,param1.actionTarget);
      }
      
      override public function park() : void
      {
         videoPlane.visible = false;
         video2D.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      override protected function setReadyState() : void
      {
         initLayers();
         super.setReadyState();
      }
      
      protected function handleBackButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      protected function handleSetBackButton(param1:SharerInfo) : void
      {
         var _loc2_:Number = 5;
         backButton = new AssetButton(param1.reference as Class,BrainEventType.CHANGE_PAGE,parentPage.pageID);
         backButton.scaleX = backButton.scaleY = 0.75;
         backButton.x = pageWidth - backButton.width - _loc2_;
         backButton.y = pageHeight - backButton.height - _loc2_;
         backButton.addEventListener(BrainEvent.ACTION,handleBackButtonClick);
         backButton.addEventListener(MouseEvent.MOUSE_OVER,handleBackButtonOver);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Back",AccessibilityDefinitions.VIDEOFRAME_UI);
         pageContainer2D.addChild(backButton);
      }
      
      override public function deactivate() : void
      {
         alwaysSmoothed = false;
         basicView.viewport.interactive = false;
         video2D.stop();
         video2D.close();
         transitionFX.doNamedTransitionIn("Transition_B",hideVideo,null,false,3);
         pageContainer2D.removeChild(video2D);
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var lc:OrbitCamera3D = null;
         var e:Event = param1;
         video2D.alpha = 1;
         try
         {
            videoMaterial.drawBitmap();
         }
         catch(e:Error)
         {
            lc = _localCam as OrbitCamera3D;
            lc.rotationXMax = (lc.rotationXMax + lc.rotationXMin) / 2;
            lc.rotationXMin = lc.rotationXMax;
            lc.rotationYMax = (lc.rotationYMax + lc.rotationYMin) / 2;
            lc.rotationYMin = lc.rotationYMax;
            return;
         }
         video2D.alpha = 0;
      }
   }
}

