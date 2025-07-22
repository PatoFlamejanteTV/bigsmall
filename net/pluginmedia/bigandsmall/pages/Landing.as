package net.pluginmedia.bigandsmall.pages
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.ScreenDepthDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.DoorEvent;
   import net.pluginmedia.bigandsmall.pages.shared.PerspectiveWindowPlane;
   import net.pluginmedia.bigandsmall.ui.VPortLayerComponent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeterInfo;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Landing extends BigAndSmallPage3D
   {
      
      private var bedroomLoaded:Boolean = false;
      
      private var timeoutBounceTimer:Timer;
      
      private var toLivingRoomLayer:ViewportLayer;
      
      private var landingLayer:ViewportLayer;
      
      private var timeoutVoxTimer:Timer;
      
      private var toLivingRoomHRect:Rectangle;
      
      private var toLivingRoomMovBig:MovieClip;
      
      private var toLivingRoomSprite:PointSprite;
      
      private var bigTimeouts:Array;
      
      private var toLivingRoomMat:SpriteParticleMaterial;
      
      private var landingDoorDAE:DAEFixed;
      
      private var landingDoor:Door3D;
      
      private var landingWindow:PerspectiveWindowPlane;
      
      private var landingDoorLayer:ViewportLayer;
      
      private var initIntroTimer:Timer;
      
      private var doorKnobPSprite:PointSprite;
      
      private var toLivingRoomMovSmall:MovieClip;
      
      private var landingDoorButton:VPortLayerComponent;
      
      private var landingDAE:DAEFixed;
      
      private var doorKnobMat:MovieParticleMaterial;
      
      public function Landing(param1:BasicView, param2:String)
      {
         var _loc5_:OrbitCamera3D = null;
         initIntroTimer = new Timer(1000);
         timeoutVoxTimer = new Timer(13000);
         timeoutBounceTimer = new Timer(600);
         bigTimeouts = [];
         toLivingRoomHRect = new Rectangle(540,0,248,250);
         var _loc3_:Number3D = new Number3D(-130,350,-500);
         var _loc4_:OrbitCamera3D = new OrbitCamera3D(44);
         _loc4_.rotationYMin = -95;
         _loc4_.rotationYMax = -85;
         _loc4_.radius = 92;
         _loc4_.rotationXMin = -13;
         _loc4_.rotationXMax = -4;
         _loc4_.orbitCentre.x = 500;
         _loc4_.orbitCentre.y = 465;
         _loc4_.orbitCentre.z = -440;
         _loc5_ = new OrbitCamera3D(44);
         _loc5_.rotationYMin = -95;
         _loc5_.rotationYMax = -85;
         _loc5_.radius = 90;
         _loc5_.rotationXMin = 5;
         _loc5_.rotationXMax = 15;
         _loc5_.orbitCentre.x = 500;
         _loc5_.orbitCentre.y = 570;
         _loc5_.orbitCentre.z = -430;
         super(param1,_loc3_,_loc5_,_loc4_,param2);
      }
      
      override public function getTransitionOmitObjects() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(DO3DDefinitions.BEDROOM_ROOM);
         _loc1_.push(DO3DDefinitions.BEDROOM_BATHROOMDOOR);
         return _loc1_.concat(super.getTransitionOmitObjects());
      }
      
      private function doBigSnoreLoop() : void
      {
         var _loc1_:SoundInfoOld = new SoundInfoOld(1,0,int.MAX_VALUE);
         _loc1_.targetChannel = 3;
         SoundManagerOld.playSound("obed_big_snoreloop",_loc1_);
      }
      
      private function handleToLivingRoomClick(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM);
      }
      
      private function handleDoorAnimShut(param1:Event) : void
      {
         SoundManagerOld.playSound("hf_door_close");
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         landingDoorLayer.screenDepth = 0;
      }
      
      private function handleSmallInitVoxComplete() : void
      {
         var _loc1_:SoundInfoOld = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         _loc1_.onCompleteFunc = handleBigInitVoxComplete;
         SoundManagerOld.playSound("obed_big_uhohknowwhothatis",_loc1_);
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      override public function transitionProgressIn(param1:Number) : void
      {
         if(param1 > 0.5)
         {
            landingLayer.screenDepth = 1;
         }
         else
         {
            landingLayer.screenDepth = ScreenDepthDefinitions.LANDING;
         }
      }
      
      private function beginBedroomIntroBig() : void
      {
         var _loc1_:SoundInfoOld = null;
         BrainLogger.highlight("Landing.beginBedroomIntroBig");
         _loc1_ = new SoundInfoOld(1,0,int.MAX_VALUE);
         _loc1_.targetChannel = 3;
         SoundManagerOld.playSound("obed_smallbouncing",_loc1_);
         _loc1_ = new SoundInfoOld();
         _loc1_.onCompleteFunc = handleSmallInitVoxComplete;
         _loc1_.targetChannel = 1;
         SoundManagerOld.playSound("obed_small_woohooicanbounce",_loc1_);
      }
      
      private function handleDoorOver(param1:MouseEvent) : void
      {
         landingDoor.setDoorModelOverState(true);
      }
      
      private function receivedLanding(param1:IAssetLoader) : void
      {
         landingDAE = DAEFixed(param1.getContent());
         landingDAE.scale = 25;
         landingDAE.rotationY = 180;
         positionDO3D(landingDAE);
      }
      
      private function handleDoorOut(param1:MouseEvent) : void
      {
         landingDoor.setDoorModelOverState(false);
      }
      
      private function setToLivingRoomPosition(param1:String) : void
      {
         if(!toLivingRoomSprite)
         {
            return;
         }
         removeToLivingRoom();
         toLivingRoomMat.movie.alpha = 0;
         if(param1 == CharacterDefinitions.BIG)
         {
            positionDO3D(toLivingRoomSprite,470,260,180);
            toLivingRoomMat.movie = toLivingRoomMovBig;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            positionDO3D(toLivingRoomSprite,470,245,195);
            toLivingRoomMat.movie = toLivingRoomMovSmall;
         }
      }
      
      private function initWindow() : void
      {
         var _loc1_:MovieClip = unPackAsset("SkyTexture");
         landingWindow = new PerspectiveWindowPlane(_loc1_,180,180,575,210,-400,-1000,new Number3D(0,0,-1));
         registerLiveDO3D(DO3DDefinitions.LANDING_WINDOW,landingWindow);
      }
      
      private function handleDoorAnimProgress(param1:Event) : void
      {
         this.flagDirtyLayer(landingDoorLayer);
      }
      
      private function handleVoxTimeouts(param1:TimerEvent) : void
      {
         var _loc2_:SoundInfoOld = null;
         var _loc3_:String = null;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            SoundManagerOld.playSound("obed_small_woohoothisisfun");
         }
         else
         {
            SoundManagerOld.stopSoundChannel(3);
            _loc2_ = new SoundInfoOld();
            _loc2_.targetChannel = 3;
            _loc2_.onCompleteFunc = doBigSnoreLoop;
            _loc3_ = bigTimeouts.shift();
            SoundManagerOld.playSound(_loc3_,_loc2_);
            bigTimeouts.push(_loc3_);
         }
      }
      
      private function showToLivingRoom(param1:Boolean) : void
      {
         if(param1)
         {
            toLivingRoomSprite.visible = true;
            TweenMax.to(SpriteParticleMaterial(toLivingRoomSprite.material).movie,0.25,{"alpha":1});
         }
         else
         {
            TweenMax.to(SpriteParticleMaterial(toLivingRoomSprite.material).movie,0.25,{
               "alpha":0,
               "onComplete":removeToLivingRoom
            });
         }
      }
      
      private function initKnob() : void
      {
         doorKnobMat = new MovieParticleMaterial(unPackAsset("KnobMat"));
         doorKnobMat.updateParticleBitmap(2);
         doorKnobPSprite = new PointSprite(doorKnobMat,1);
         doorKnobPSprite.x = -0.55;
         doorKnobPSprite.y = 5.15;
         doorKnobPSprite.z = 6.4;
         landingDoorDAE.addChild(doorKnobPSprite);
      }
      
      private function removeToLivingRoom() : void
      {
         toLivingRoomSprite.visible = false;
         SpriteParticleMaterial(toLivingRoomSprite.material).removeSprite();
      }
      
      private function initToLivingRoom() : void
      {
         toLivingRoomMovBig = unPackAsset("ToLivingRoomBig");
         toLivingRoomMovSmall = unPackAsset("ToLivingRoomSmall");
         toLivingRoomMat = new SpriteParticleMaterial(toLivingRoomMovBig);
         toLivingRoomSprite = new PointSprite(toLivingRoomMat);
         toLivingRoomSprite.size = 0.5;
         registerLiveDO3D(DO3DDefinitions.LANDING_TOLIVINGROOM,toLivingRoomSprite);
         setToLivingRoomPosition(this.currentPOV);
      }
      
      private function handleBigInitVoxComplete() : void
      {
         timeoutVoxTimer.start();
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("Landing.LANDING",DAELocations.landing,receivedLanding);
         dispatchAssetRequest("Landing.BEDROOM_DOOR",DAELocations.landingBedroomDoor,receivedLandingBedroomDoor);
         dispatchAssetRequest("Landing.WINDOW",SWFLocations.landingLibrary,assetLibLoaded);
      }
      
      private function setBedroomDoorEnabled(param1:Boolean = true) : void
      {
         landingDoorButton.setEnabledState(param1);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         if(basicView.stage.mouseX >= toLivingRoomHRect.x && basicView.stage.mouseX <= toLivingRoomHRect.x + toLivingRoomHRect.width && basicView.stage.mouseY >= toLivingRoomHRect.y && basicView.stage.mouseY <= toLivingRoomHRect.y + toLivingRoomHRect.height)
         {
            showToLivingRoom(true);
         }
         else
         {
            showToLivingRoom(false);
         }
      }
      
      private function handleBedroomLoaded() : void
      {
         bedroomLoaded = true;
         if(this._isLive)
         {
            initIntroTimer.start();
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(DO3DDefinitions.BEDROOM_ROOM);
         _loc1_.push(DO3DDefinitions.BEDROOM_BATHROOMDOOR);
         return _loc1_.concat(super.getLiveVisibleDisplayObjects());
      }
      
      override public function transitionProgressOut(param1:Number) : void
      {
         if(param1 > 0.5)
         {
            landingDAE.visible = false;
            landingDoor.visible = false;
         }
      }
      
      private function handleInitTimer(param1:TimerEvent) : void
      {
         initIntroTimer.reset();
         broadcast(BigAndSmallEventType.REFRESH_LIVEDISPLAYOBJECTS);
         setBedroomDoorEnabled(true);
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            beginBedroomIntroSmall();
         }
         else
         {
            beginBedroomIntroBig();
         }
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         super.update(param1);
      }
      
      private function receivedLandingBedroomDoor(param1:IAssetLoader) : void
      {
         landingDoorDAE = DAEFixed(param1.getContent());
         landingDoorDAE.scale = 25;
         landingDoorDAE.rotationY = 180;
         landingDoor = new Door3D(landingDoorDAE);
         landingDoor.defaultRotY = 180;
         landingDoor.rotYOnOver = 195;
         landingDoor.rotYOnOpen = 270;
         positionDO3D(landingDoorDAE,402,0,163);
      }
      
      private function handleBounceTimer(param1:TimerEvent) : void
      {
         SoundManagerOld.playSound("bed_small_bounce");
      }
      
      private function beginBedroomIntroSmall() : void
      {
         BrainLogger.highlight("Landing.beginBedroomIntroSmall");
         doBigSnoreLoop();
         timeoutVoxTimer.start();
      }
      
      private function handleDoorClicked(param1:MouseEvent) : void
      {
         landingDoor.openDoor();
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.stopSoundChannel(3);
         landingDoorLayer.screenDepth = 1;
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BEDROOM);
      }
      
      override public function activate() : void
      {
         super.activate();
         if(!bedroomLoaded)
         {
            broadcast(BrainEventType.MULTIPAGE_LOADPROGRESS,null,new MultiPageLoadProgressMeterInfo([PageDefinitions.BEDROOM],handleBedroomLoaded));
         }
         else
         {
            initIntroTimer.start();
         }
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         basicView.stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
         landingLayer.screenDepth = 0;
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
         landingDoorLayer.tabEnabled = param1;
         toLivingRoomLayer.tabEnabled = param1;
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(this._isLive)
         {
            SoundManagerOld.stopSoundChannel(1);
            SoundManagerOld.stopSoundChannel(3);
         }
         setToLivingRoomPosition(param1);
      }
      
      override public function park() : void
      {
         super.park();
         landingDAE.visible = true;
         landingDoor.visible = true;
         landingDoor.closeDoor(true);
      }
      
      override public function collectionQueueEmpty() : void
      {
         initWindow();
         registerLiveDO3D(DO3DDefinitions.LANDING,landingDAE);
         registerLiveDO3D(DO3DDefinitions.LANDING_BEDROOM_DOOR,landingDoor);
         var _loc1_:DisplayObject3D = landingDAE.getChildByName("Landing_Stairwell");
         var _loc2_:DisplayObject3D = landingDAE.getChildByName("Landing_Floor");
         landingLayer = basicView.viewport.getChildLayer(landingDAE,true);
         landingLayer.screenDepth = ScreenDepthDefinitions.LANDING;
         landingLayer.forceDepth = true;
         initKnob();
         landingDoorLayer = basicView.viewport.getChildLayer(landingDoorDAE,true,true);
         landingDoorLayer.forceDepth = true;
         landingDoorButton = new VPortLayerComponent(landingDoorLayer);
         landingDoor.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         landingDoor.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         landingDoorButton.addEventListener(MouseEvent.CLICK,handleDoorClicked);
         landingDoorButton.addEventListener(MouseEvent.ROLL_OVER,handleDoorOver);
         landingDoorButton.addEventListener(MouseEvent.ROLL_OUT,handleDoorOut);
         AccessibilityManager.addAccessibilityProperties(landingDoorLayer,"Landing Door","Enter the Bedroom",AccessibilityDefinitions.LANDING_DOOR);
         initToLivingRoom();
         toLivingRoomLayer = landingLayer.getChildLayer(toLivingRoomSprite,true,true);
         AccessibilityManager.addAccessibilityProperties(toLivingRoomLayer,"To the Living Room","Go to the Living Room",AccessibilityDefinitions.LANDING_DOOR);
         toLivingRoomLayer.addEventListener(MouseEvent.CLICK,handleToLivingRoomClick);
         toLivingRoomLayer.buttonMode = true;
         setReadyState();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         timeoutVoxTimer.reset();
         initIntroTimer.reset();
         timeoutBounceTimer.reset();
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.stopSoundChannel(3);
         setBedroomDoorEnabled(false);
         basicView.stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
         removeToLivingRoom();
      }
      
      override protected function build() : void
      {
         initIntroTimer.addEventListener(TimerEvent.TIMER,handleInitTimer);
         timeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleVoxTimeouts);
         timeoutBounceTimer.addEventListener(TimerEvent.TIMER,handleBounceTimer);
         bigTimeouts = ["obed_big_sleepy","obed_big_lovelysleep","obed_big_dreamboat","obed_big_allaboard"];
      }
   }
}

