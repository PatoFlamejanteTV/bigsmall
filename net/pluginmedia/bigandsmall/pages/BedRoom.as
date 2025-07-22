package net.pluginmedia.bigandsmall.pages
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DarkTextureLocations;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.ScreenDepthDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.bedroom.BigDraggablePillows;
   import net.pluginmedia.bigandsmall.pages.bedroom.Blind;
   import net.pluginmedia.bigandsmall.pages.bedroom.DraggableBedroomObject;
   import net.pluginmedia.bigandsmall.pages.bedroom.ModifiableDuvet;
   import net.pluginmedia.bigandsmall.pages.bedroom.TableTopperPlane;
   import net.pluginmedia.bigandsmall.pages.bedroom.ThrowableBedroomObject;
   import net.pluginmedia.bigandsmall.pages.bedroom.characters.BigInBed;
   import net.pluginmedia.bigandsmall.pages.bedroom.characters.SmallBounceBed;
   import net.pluginmedia.bigandsmall.pages.bedroom.managers.BigWakeUpGameManager;
   import net.pluginmedia.bigandsmall.pages.bedroom.managers.LightDarkManager;
   import net.pluginmedia.bigandsmall.pages.bedroom.managers.SmallToSleepGameManager;
   import net.pluginmedia.bigandsmall.pages.bedroom.mobile.MobileStruct3D;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.PillowVPortLayerButton;
   import net.pluginmedia.bigandsmall.pages.bedroom.teddy.ThrowableFreakyAssTeddy;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.DoorEvent;
   import net.pluginmedia.bigandsmall.pages.shared.PerspectiveWindowPlane;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.bigandsmall.ui.VPortLayerComponent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.geom.BezierSegment3D;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.materials.FadeChangeableBitmapMaterial;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapFileMaterial;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BedRoom extends BigAndSmallPage3D implements IUpdatable
   {
      
      private var bigInBed:BigInBed;
      
      private var toBathroomSprite:PointSprite;
      
      private var bigCushion1Layer:ViewportLayer;
      
      private var toLivingRoomMovBig:MovieClip;
      
      private var cactus:TableTopperPlane;
      
      private var bigGameManager:BigWakeUpGameManager;
      
      private var alarmClock:TableTopperPlane;
      
      private var lightLinks:Array;
      
      private var duvetLayer:ViewportLayer;
      
      private var bthDoorKnobPSprite:PointSprite;
      
      private var darkTextures:Dictionary;
      
      private var smallCushions:Array;
      
      private var lightDarkManager:LightDarkManager;
      
      private var bedRoomBedding:DAEFixed;
      
      private var bdrDoorDAE:DAEFixed;
      
      private var bedRoomObjects:DAEFixed;
      
      private var bedroomDoorButton:VPortLayerComponent;
      
      private var furnitureLayer:ViewportLayer;
      
      private var bigDraggablePillows:BigDraggablePillows;
      
      private var blueThrowablePillow:ThrowableBedroomObject;
      
      private var throwableTeddy:ThrowableFreakyAssTeddy;
      
      private var bathroomDoor3D:Door3D;
      
      private var bigAnimStates:Array;
      
      private var toBathroomMovBig:MovieClip;
      
      private var bedroomDoor3D:Door3D;
      
      private var objectsLayer:ViewportLayer;
      
      private var mobile:MobileStruct3D;
      
      private var toBathroomMat:SpriteParticleMaterial;
      
      private var greenThrowablePillow:ThrowableBedroomObject;
      
      private var bigCushion2Layer:ViewportLayer;
      
      private var bedroomDoorLayer:ViewportLayer;
      
      private var bigTeddy:DraggableBedroomObject;
      
      private var smallBounceBedLayer:ViewportLayer;
      
      private var toLivingRoomMat:SpriteParticleMaterial;
      
      private var bdrDoorKnobPSprite:PointSprite;
      
      private var gameIsActive:Boolean = false;
      
      private var mobileDragHitArea:Sprite;
      
      private var bdrDoorKnobMat:MovieParticleMaterial;
      
      private var duvetMod:ModifiableDuvet;
      
      private var bedRoom:DAEFixed;
      
      private var blueThrowablePillowLayer:ViewportLayer;
      
      private var bigCushion2:DraggableBedroomObject;
      
      private var alarmClockLayer:ViewportLayer;
      
      private var bigCushion1:DraggableBedroomObject;
      
      private var greenThrowablePillowLayer:ViewportLayer;
      
      private var lampButton:VPortLayerButton;
      
      private var roomLayer:ViewportLayer;
      
      private var bthDoorKnobMat:MovieParticleMaterial;
      
      private var bigCushions:Array;
      
      private var blind:Blind;
      
      private var toBathroomMovSmall:MovieClip;
      
      private var bigTeddyLayer:ViewportLayer;
      
      private var bathroomDoorButton:VPortLayerComponent;
      
      private var toLivingRoomMovSmall:MovieClip;
      
      private var beddingLayer:ViewportLayer;
      
      private var bathroomDoorLayer:ViewportLayer;
      
      private var smallBounceBed:SmallBounceBed;
      
      private var toLivingRoomSprite:PointSprite;
      
      private var throwableTeddyLayer:ViewportLayer;
      
      private var smallBaseYPos:Number = 0;
      
      private var lightMaterials:Dictionary;
      
      private var bigsDuvet:DisplayObject3D;
      
      private var bthDoorDAE:DAEFixed;
      
      private var mobileLayer:ViewportLayer;
      
      private var lamp:TableTopperPlane;
      
      private var smallAnimStates:Array;
      
      private var smallGameManager:SmallToSleepGameManager;
      
      private var mobileLayerButton:VPortLayerButton;
      
      private var bedroomWindow:PerspectiveWindowPlane;
      
      private var lightTextures:Dictionary;
      
      private var darkLinks:Array;
      
      public function BedRoom(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc5_:OrbitCamera3D = null;
         smallAnimStates = [];
         bigAnimStates = [];
         darkLinks = [];
         lightLinks = [];
         lightMaterials = new Dictionary();
         var _loc4_:Number3D = new Number3D(-130,350,-495);
         _loc5_ = new OrbitCamera3D(44);
         _loc5_.rotationYMin = -215;
         _loc5_.rotationYMax = -180;
         _loc5_.radius = 400;
         _loc5_.rotationXMin = 0;
         _loc5_.rotationXMax = -2;
         _loc5_.orbitCentre.x = 0;
         _loc5_.orbitCentre.y = 450;
         _loc5_.orbitCentre.z = -650;
         var _loc6_:OrbitCamera3D = new OrbitCamera3D(38);
         _loc6_.rotationYMin = -190;
         _loc6_.rotationYMax = -179;
         _loc6_.radius = 294;
         _loc6_.rotationXMin = 10;
         _loc6_.rotationXMax = 20;
         _loc6_.orbitCentre.x = 0;
         _loc6_.orbitCentre.y = 556;
         _loc6_.orbitCentre.z = -442;
         super(param1,_loc4_,_loc6_,_loc5_,param2);
         lightDarkManager = new LightDarkManager(this);
      }
      
      private function flagBlueDraggablePillow(param1:Event) : void
      {
         this.flagDirtyLayer(DisplayObject3D(bigCushions[0]).container);
      }
      
      private function receivedBedroomDoor(param1:IAssetLoader) : void
      {
         bdrDoorDAE = param1.getContent() as DAEFixed;
         bdrDoorDAE.scale = 25;
         bdrDoorDAE.rotationY = 180;
         bedroomDoor3D = new Door3D(bdrDoorDAE);
         bedroomDoor3D.tweenSpeed = 0.1;
         bedroomDoor3D.defaultRotY = 180;
         bedroomDoor3D.rotYOnOver = 190;
         bedroomDoor3D.rotYOnOpen = 290;
         positionDO3D(bedroomDoor3D,400,0,164);
      }
      
      private function handleBlindAnimProgress(param1:AnimationOldEvent) : void
      {
         flagDirtyLayer(blind.viewportLayer);
      }
      
      private function handleThrowableInFlight(param1:Event) : void
      {
         this.flagDirtyLayer(DisplayObject3D(param1.target).container);
      }
      
      private function handleGreenPillowHitBig(param1:Event) : void
      {
         basicView.viewport.containerSprite.removeLayer(greenThrowablePillowLayer);
         furnitureLayer.addLayer(greenThrowablePillowLayer);
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      private function handleBathroomDoorClicked(param1:MouseEvent) : void
      {
         showArrow(toBathroomSprite,false);
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.stopSoundChannel(3);
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.PREBATHROOM);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("BedRoom.ROOM",DAELocations.bedRoom,receievedBedroom);
         dispatchAssetRequest("BedRoom.OBJECTS",DAELocations.bedRoomObjects,receievedBedroomObjects);
         dispatchAssetRequest("BedRoom.BEDDING",DAELocations.bedRoomBedding,receievedBedroomBedding);
         dispatchAssetRequest("BedRoom.BATHROOM_DOOR",DAELocations.bathRoomDoor,receievedBathroomDoor);
         dispatchAssetRequest("Bedroom.BEDROOM_DOOR",DAELocations.bedRoomDoor,receivedBedroomDoor);
         dispatchAssetRequest("BedRoom.LIBRARY",SWFLocations.bedRoomLibrary,assetLibLoaded);
         dispatchAssetRequest("BedRoom.BIG",SWFLocations.bedRoomBigLibraryI,assetLibLoaded);
         dispatchAssetRequest("BedRoom.BIG2",SWFLocations.bedRoomBigLibraryII,assetLibLoaded);
         dispatchAssetRequest("BedRoom.SMALL",SWFLocations.bedRoomSmallLibrary,assetLibLoaded);
         dispatchAssetRequest("BedRoom.SOUNDSA",SWFLocations.bedRoomSoundLibraryA,assetLibLoaded);
         dispatchAssetRequest("BedRoom.SOUNDSB",SWFLocations.bedRoomSoundLibraryB,assetLibLoaded);
         dispatchAssetRequest("BedRoom.SOUNDSC",SWFLocations.bedRoomSoundLibraryC,assetLibLoaded);
         dispatchAssetRequest("BedRoom.SOUNDSD",SWFLocations.bedRoomSoundLibraryD,assetLibLoaded);
         dispatchDarkTextureRequests();
         dispatchLightTextureRequests();
      }
      
      private function initDuvet() : void
      {
         duvetMod = new ModifiableDuvet();
         duvetMod.init(bigsDuvet,3.3);
      }
      
      private function handleLandingDoorClicked(param1:MouseEvent) : void
      {
         showArrow(toLivingRoomSprite,false);
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.stopSoundChannel(3);
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM);
      }
      
      private function addThrowablesToBasicView() : void
      {
         if(furnitureLayer.childLayers.indexOf(blueThrowablePillowLayer) != -1)
         {
            furnitureLayer.removeLayer(blueThrowablePillowLayer);
         }
         basicView.viewport.containerSprite.addLayer(blueThrowablePillowLayer);
         if(furnitureLayer.childLayers.indexOf(greenThrowablePillowLayer) != -1)
         {
            furnitureLayer.removeLayer(greenThrowablePillowLayer);
         }
         basicView.viewport.containerSprite.addLayer(greenThrowablePillowLayer);
         if(furnitureLayer.childLayers.indexOf(throwableTeddyLayer) != -1)
         {
            furnitureLayer.removeLayer(throwableTeddyLayer);
         }
         basicView.viewport.containerSprite.addLayer(throwableTeddyLayer);
      }
      
      override protected function build() : void
      {
      }
      
      private function handleBluePillowHitBig(param1:Event) : void
      {
         basicView.viewport.containerSprite.removeLayer(blueThrowablePillowLayer);
         furnitureLayer.addLayer(blueThrowablePillowLayer);
      }
      
      private function initLayers() : void
      {
         roomLayer = basicView.viewport.getChildLayer(bedRoom,true,true);
         roomLayer.screenDepth = ScreenDepthDefinitions.BEDROOM;
         roomLayer.forceDepth = true;
         var _loc1_:ViewportLayer = roomLayer.getChildLayer(bedRoomObjects.getChildByName("UnderBed_BookPile01",true),true);
         _loc1_.addDisplayObject3D(bedRoomObjects.getChildByName("UnderBed_BookPile03",true));
         blind.viewportLayer = roomLayer.getChildLayer(blind,true,true);
         AccessibilityManager.addAccessibilityProperties(blind.viewportLayer,"Blind","Change the lighting",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         blind.viewportLayerButton = new VPortLayerButton(blind.viewportLayer);
         blind.enabled = true;
         var _loc2_:DisplayObject3D = bedRoomBedding.getChildByName("Bedding",true);
         bigsDuvet = _loc2_.getChildByName("BigsDuvet",true);
         furnitureLayer = basicView.viewport.getChildLayer(_loc2_,true,true);
         furnitureLayer.forceDepth = true;
         furnitureLayer.screenDepth = ScreenDepthDefinitions.BEDROOM_FURNITURE;
         furnitureLayer.addDisplayObject3D(bedRoomObjects.getChildByName("BedFrame",true));
         furnitureLayer.addDisplayObject3D(bedRoomObjects.getChildByName("ChestOfDrawers_BookPile03",true));
         furnitureLayer.addDisplayObject3D(bedRoomObjects.getChildByName("ChestOfDrawers_BookPile02",true));
         furnitureLayer.addDisplayObject3D(bedRoomObjects.getChildByName("ChestOfDrawers",true));
         var _loc3_:ViewportLayer = basicView.viewport.getChildLayer(bedRoomObjects.getChildByName("BedsideTable",true),true);
         _loc3_.forceDepth = true;
         _loc3_.screenDepth = ScreenDepthDefinitions.BEDROOM_FURNITURE - 1;
         cactus.viewportLayer = _loc3_.getChildLayer(cactus);
         var _loc4_:DisplayObject3D = bedRoomObjects.getChildByName("BedsideTableBook",true);
         var _loc5_:ViewportLayer = _loc3_.getChildLayer(_loc4_,true,true);
         lamp.viewportLayer = _loc3_.getChildLayer(lamp,true,true);
         lampButton = new VPortLayerButton(lamp.viewportLayer);
         AccessibilityManager.addAccessibilityProperties(lamp.viewportLayer,"Lamp","Change the lighting",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         alarmClock.viewportLayer = roomLayer.getChildLayer(alarmClock,true,true);
         alarmClock.viewportLayer.addEventListener(MouseEvent.ROLL_OVER,handleAlarmRollover);
         smallBounceBedLayer = furnitureLayer.getChildLayer(smallBounceBed,true,true);
         smallBounceBedLayer.forceDepth = true;
         smallBounceBedLayer.screenDepth = 0;
         var _loc6_:ViewportLayer = furnitureLayer.getChildLayer(bigInBed,true,true);
         mobileLayer = furnitureLayer.getChildLayer(mobile,true);
         mobile.initLayers(mobileLayer);
         mobileLayer.screenDepth = 1;
         mobileLayer.forceDepth = true;
         mobileLayerButton = new VPortLayerButton(mobileLayer);
         AccessibilityManager.addAccessibilityProperties(mobileLayer,"Mobile","Interactive mobile",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         mobileLayer.addEventListener(FocusEvent.FOCUS_OUT,handleMobileLayerFocusOut);
         bedroomDoorLayer = basicView.viewport.getChildLayer(bedroomDoor3D,true,true);
         bedroomDoorButton = new VPortLayerComponent(bedroomDoorLayer);
         bedroomDoorLayer.addDisplayObject3D(toLivingRoomSprite);
         AccessibilityManager.addAccessibilityProperties(bedroomDoorLayer,"Bedroom Door","Go to the Living Room",AccessibilityDefinitions.BEDROOM_ACCESSOR);
         bedroomDoor3D.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         bedroomDoor3D.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         bedroomDoorButton.addEventListener(MouseEvent.CLICK,handleLandingDoorClicked);
         bedroomDoorButton.addEventListener(MouseEvent.ROLL_OVER,handleLandingDoorOver);
         bedroomDoorButton.addEventListener(MouseEvent.ROLL_OUT,handleLandingDoorOut);
         bathroomDoorLayer = roomLayer.getChildLayer(bathroomDoor3D,true,true);
         bathroomDoorButton = new VPortLayerComponent(bathroomDoorLayer);
         bathroomDoorLayer.addDisplayObject3D(toBathroomSprite);
         AccessibilityManager.addAccessibilityProperties(bathroomDoorLayer,"Bathroom Door","Go to the Bathroom",AccessibilityDefinitions.BEDROOM_ACCESSOR);
         bathroomDoorButton.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         bathroomDoorButton.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         bathroomDoorButton.addEventListener(MouseEvent.ROLL_OVER,handleBathroomDoorRollOver);
         bathroomDoorButton.addEventListener(MouseEvent.ROLL_OUT,handleBathroomDoorRollOut);
         bathroomDoorButton.addEventListener(MouseEvent.CLICK,handleBathroomDoorClicked);
         BrainLogger.highlight("bedRoom...",bedRoom.getChildByName("COLLADA_Scene").getChildByName("Bedroom").getChildByName("Room").childrenList());
         BrainLogger.highlight("bedRoomObjects...",bedRoomObjects.getChildByName("COLLADA_Scene").getChildByName("Bedroom").getChildByName("Objects").childrenList());
         BrainLogger.highlight("bedRoomBedding...",bedRoomObjects.getChildByName("COLLADA_Scene").getChildByName("Bedroom").getChildByName("Objects").childrenList());
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         bigGameManager.stopInteractive();
         smallGameManager.stopInteractive();
         bedroomDoorButton.setEnabledState(false);
         bathroomDoorButton.setEnabledState(false);
         SoundManagerOld.stopSoundChannel(5,1);
         SoundManagerOld.stopSoundChannel(1);
         bigInBed.stopSnores();
         SoundManager.stopChannel(SoundChannelDefinitions.VOX);
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         if(pageContainer2D.contains(mobileDragHitArea))
         {
            pageContainer2D.removeChild(mobileDragHitArea);
         }
         if(pageContainer2D.contains(bigDraggablePillows))
         {
            pageContainer2D.removeChild(bigDraggablePillows);
         }
      }
      
      private function handleBathroomDoorRollOver(param1:MouseEvent) : void
      {
         if(this._isActive)
         {
            showArrow(toBathroomSprite,true);
         }
      }
      
      private function handleDoorAnimProgress(param1:Event) : void
      {
         this.flagDirtyLayer(bedroomDoorLayer);
      }
      
      private function buildScene() : void
      {
         initToBathroom();
         initToLivingRoom();
         setArrowPositions(this.currentPOV);
         initBedroomDoorKnob();
         initBathroomDoorKnob();
         initBig();
         initSmall();
         initTableToppers();
         initBlinds();
         initMobile();
         initLayers();
         initCushions();
         initDuvet();
         initDarkTextures();
         initWindow();
         initGameManagers();
         lightDarkManager.currentPOV = this.currentPOV;
         lightDarkManager.update(true);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_ROOM,bedRoom);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_OBJECTS,bedRoomObjects);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_BEDDING,bedRoomBedding);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_DOOR,bedroomDoor3D);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_BATHROOMDOOR,bathroomDoor3D);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_BIG,bigInBed);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_SMALL,smallBounceBed);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_BLINDPLANE,blind);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_WINDOW,bedroomWindow);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_COMINGSOON,toBathroomSprite);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_TOLIVINGROOM,toLivingRoomSprite);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_LAMP,lamp);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_MOBILE,mobile);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_ALARMCLOCK,alarmClock);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CACTUS,cactus);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_SMALL_BLUE,blueThrowablePillow);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_SMALL_GREEN,greenThrowablePillow);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_SMALL_TOY,throwableTeddy);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_BIG_BLUE,bigCushion1);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_BIG_GREEN,bigCushion2);
         registerLiveDO3D(DO3DDefinitions.BEDROOM_CUSHION_BIG_TOY,bigTeddy);
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         mobile.update();
         this.flagDirtyLayer(mobileLayer);
         if(currentPOV == CharacterDefinitions.BIG)
         {
            duvetMod.update();
            flagDirtyLayer(duvetLayer);
            flagDirtyLayer(smallBounceBedLayer);
            smallBounceBed.y = smallBaseYPos + duvetMod.yCurrent * 25;
         }
         if(!isLive)
         {
            return;
         }
         if(currentPOV == CharacterDefinitions.BIG)
         {
            if(bigDraggablePillows.active)
            {
               bigDraggablePillows.update();
            }
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            bigGameManager.update(param1);
         }
      }
      
      protected function dispatchDarkTextureRequests() : void
      {
         darkTextures = new Dictionary();
         dispatchAssetRequest("BedRoom.LEFT_DARK",DarkTextureLocations.bedroomLeftWall,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.DRAWERS_DARK",DarkTextureLocations.bedroomChestOfDrawers,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.FLOOR_DARK",DarkTextureLocations.bedroomFloor,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.RIGHT_DARK",DarkTextureLocations.bedroomRightWall,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BACK_DARK",DarkTextureLocations.bedroomBackWall,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BEDISDE_DARK",DarkTextureLocations.bedroomBedsideTable,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BED_FRAME",DarkTextureLocations.bedroomBed,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.SMALL_PILLOW",DarkTextureLocations.bedroomSmallPillow,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.SMALL_DUVET",DarkTextureLocations.bedroomSmallDuvet,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BIG_PILLOW",DarkTextureLocations.bedroomBigPillow,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BIG_DUVET",DarkTextureLocations.bedroomBigDuvet,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BIG_DUVET",DarkTextureLocations.bedroomBigDuvet,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BOOK_BEDSIDE",DarkTextureLocations.bedroomBedsideBook,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BOOK_UNDERBED_LEFT",DarkTextureLocations.bedroomBookUnderBedLeft,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BOOK_UNDERBED_RIGHT",DarkTextureLocations.bedroomBookUnderBedRight,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BOOK_DRAWERS_TOP",DarkTextureLocations.bedroomBookDrawersTop,receiveDarkTexture);
         dispatchAssetRequest("BedRoom.BOOK_DRAWERS_BOTTOM",DarkTextureLocations.bedroomBookDrawersBottom,receiveDarkTexture);
      }
      
      protected function dispatchLightTextureRequest(param1:String, param2:String) : void
      {
         dispatchAssetRequest(param1,param2,receiveLightTexture);
      }
      
      private function flagGreenDraggablePillow(param1:Event) : void
      {
         this.flagDirtyLayer(DisplayObject3D(bigCushions[1]).container);
      }
      
      private function initBathroomDoorKnob() : void
      {
         bthDoorKnobMat = new MovieParticleMaterial(unPackAsset("KnobMat"));
         bthDoorKnobMat.updateParticleBitmap(2);
         bthDoorKnobPSprite = new PointSprite(bthDoorKnobMat,1);
         bthDoorKnobPSprite.x = -0.5;
         bthDoorKnobPSprite.y = 5.2;
         bthDoorKnobPSprite.z = 6.15;
         bthDoorDAE.addChild(bthDoorKnobPSprite);
      }
      
      private function flagDraggableTeddy(param1:Event) : void
      {
         this.flagDirtyLayer(DisplayObject3D(bigCushions[2]).container);
      }
      
      private function handleMobileJingleSoundComplete() : void
      {
         mobile.stopJingleSpin();
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(!this.isTransitionReady)
         {
            return;
         }
         setArrowPositions(param1);
         addThrowablesToBasicView();
         if(param1 == CharacterDefinitions.BIG)
         {
            if(this.isLive)
            {
               blueThrowablePillowLayer.tabEnabled = false;
               greenThrowablePillowLayer.tabEnabled = false;
               throwableTeddyLayer.tabEnabled = false;
               bigCushion1Layer.tabEnabled = true;
               bigCushion2Layer.tabEnabled = true;
               bigTeddyLayer.tabEnabled = true;
            }
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            if(this.isLive)
            {
               blueThrowablePillowLayer.tabEnabled = true;
               greenThrowablePillowLayer.tabEnabled = true;
               throwableTeddyLayer.tabEnabled = true;
               bigCushion1Layer.tabEnabled = false;
               bigCushion2Layer.tabEnabled = false;
               bigTeddyLayer.tabEnabled = false;
            }
         }
         if(this.isLive)
         {
            lightDarkManager.currentPOV = param1;
            SoundManagerOld.stopSoundChannel(1);
            updateDuvetLayer();
            if(param1 == CharacterDefinitions.BIG)
            {
               bigGameManager.park();
               smallGameManager.prepare();
               mobileDragHitArea.visible = false;
            }
            else if(param1 == CharacterDefinitions.SMALL)
            {
               smallGameManager.park();
               bigGameManager.prepare();
            }
         }
      }
      
      private function handleLandingDoorOut(param1:MouseEvent) : void
      {
         bedroomDoor3D.setDoorModelOverState(false);
         showArrow(toLivingRoomSprite,false);
      }
      
      override public function activate() : void
      {
         super.activate();
         bedroomDoorButton.setEnabledState(true);
         bathroomDoorButton.setEnabledState(true);
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            bigGameManager.activate();
            pageContainer2D.addChild(mobileDragHitArea);
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            smallGameManager.activate();
            pageContainer2D.addChild(bigDraggablePillows);
         }
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
      }
      
      private function initBlinds() : void
      {
         blind = new Blind(this.unPackAsset("blind"),0.25);
         blind.rotationY = 180;
         positionDO3D(blind,157,284,-345);
         blind.addEventListener(AnimationOldEvent.PROGRESS,handleBlindAnimProgress);
         lightDarkManager.setBlind(blind);
      }
      
      private function handleAlarmRollover(param1:Event) : void
      {
         SoundManagerOld.playSound("bed_clock_ping");
      }
      
      private function handleMobileLayerFocusOut(param1:FocusEvent) : void
      {
         if(mobile.isDragging)
         {
            mobile.stopDrag();
         }
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         if(this.currentPOV == CharacterDefinitions.BIG)
         {
            smallGameManager.prepare();
         }
         else if(this.currentPOV == CharacterDefinitions.SMALL)
         {
            bigGameManager.prepare();
         }
         updateDuvetLayer();
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SET_STAGE_COLOUR,null,0);
         lightDarkManager.currentPOV = currentPOV;
      }
      
      public function showArrow(param1:PointSprite, param2:Boolean) : void
      {
         if(param2)
         {
            param1.visible = true;
            TweenMax.to(SpriteParticleMaterial(param1.material).movie,0.25,{"alpha":1});
         }
         else
         {
            TweenMax.to(SpriteParticleMaterial(param1.material).movie,0.25,{
               "alpha":0,
               "onComplete":removeArrow,
               "onCompleteParams":[param1]
            });
         }
      }
      
      private function initBedroomDoorKnob() : void
      {
         bdrDoorKnobMat = new MovieParticleMaterial(unPackAsset("KnobMat"));
         bdrDoorKnobMat.updateParticleBitmap(2);
         bdrDoorKnobPSprite = new PointSprite(bdrDoorKnobMat,1);
         bdrDoorKnobPSprite.x = 0.7;
         bdrDoorKnobPSprite.y = 5.3;
         bdrDoorKnobPSprite.z = 6.25;
         bdrDoorDAE.addChild(bdrDoorKnobPSprite);
      }
      
      private function initWindow() : void
      {
         var _loc1_:MovieClip = unPackAsset("SkyTexture");
         bedroomWindow = new PerspectiveWindowPlane(_loc1_,210,210,150,210,-450,-1000,new Number3D(0,0,-1));
      }
      
      private function setCushionVPortLayers(param1:DisplayObject3D, param2:int, param3:Array) : void
      {
         var _loc4_:ViewportLayer = basicView.viewport.containerSprite.getChildLayer(param1,true,true);
         basicView.viewport.containerSprite.addLayer(_loc4_);
      }
      
      private function swapToLightDarkMaterial(param1:DAEFixed, param2:String, param3:String, param4:String, param5:Boolean = false, param6:Number = 1) : FadeChangeableBitmapMaterial
      {
         var _loc12_:BitmapData = null;
         var _loc13_:Matrix = null;
         var _loc7_:BitmapData = darkTextures[param4];
         var _loc8_:DisplayObject3D = param1.getChildByName(param2,true);
         var _loc9_:MaterialObject3D = param1.getMaterialByName(param3);
         var _loc10_:BitmapData = BitmapFileMaterial(_loc9_).bitmap;
         lightMaterials[param4] = _loc9_;
         if(param6 != 1)
         {
            _loc12_ = new BitmapData(_loc10_.width * param6,_loc10_.height * param6,param5);
            _loc13_ = new Matrix();
            _loc13_.scale(param6,param6);
            _loc12_.draw(_loc10_,_loc13_,null,null,null,true);
            _loc10_ = _loc12_;
         }
         var _loc11_:FadeChangeableBitmapMaterial = new FadeChangeableBitmapMaterial(_loc10_,"light",_loc10_.width,_loc10_.height,param5);
         _loc11_.addBitmap(_loc7_,"dark");
         lightLinks.push(BitmapFileMaterial(_loc9_).texture);
         darkLinks.push(param4);
         _loc8_.material = _loc11_;
         return _loc11_;
      }
      
      private function initToBathroom() : void
      {
         toBathroomMovBig = unPackAsset("ToBathroomBig");
         toBathroomMovSmall = unPackAsset("ToBathroomSmall");
         toBathroomMovBig.alpha = 0;
         toBathroomMovSmall.alpha = 0;
         toBathroomMat = new SpriteParticleMaterial(toBathroomMovBig);
         toBathroomSprite = new PointSprite(toBathroomMat);
         toBathroomSprite.size = 0.7;
      }
      
      private function handleTimelineVoxComplete_SmallEntryWooHoo(param1:Event) : void
      {
         smallBounceBed.removeEventListener("VOX_COMPLETE",handleTimelineVoxComplete_SmallEntryWooHoo);
         SoundManagerOld.playSound("bed_big_theremustbeawaytocalm");
      }
      
      private function handleTeddyHitBig(param1:Event) : void
      {
         basicView.viewport.containerSprite.removeLayer(throwableTeddyLayer);
         furnitureLayer.addLayer(throwableTeddyLayer);
      }
      
      private function initToLivingRoom() : void
      {
         toLivingRoomMovBig = unPackAsset("ToLivingRoomBig");
         toLivingRoomMovSmall = unPackAsset("ToLivingRoomSmall");
         toLivingRoomMovBig.alpha = 0;
         toLivingRoomMovSmall.alpha = 0;
         toLivingRoomMat = new SpriteParticleMaterial(toLivingRoomMovBig);
         toLivingRoomSprite = new PointSprite(toLivingRoomMat);
         toLivingRoomSprite.size = 0.75;
      }
      
      private function quickRegisterSound(param1:String, param2:Number = -1) : void
      {
         var _loc3_:SoundInfoOld = new SoundInfoOld(1,0,0,0,param2);
         SoundManagerOld.registerSound(new BrainSoundOld(param1,this.unPackAsset(param1,true),_loc3_));
      }
      
      private function initTableToppers() : void
      {
         var _loc1_:DisplayObject3D = bedRoom.getChildByName("Cactus",true);
         if(_loc1_)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         lamp = new TableTopperPlane(61.41,120,2,2);
         lamp.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("LampBigLight"));
         lamp.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("LampBigDark"));
         lamp.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("LampSmallLight"));
         lamp.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("LampSmallDark"));
         lamp.rotationY = -220;
         positionDO3D(lamp,355,165,-75);
         lightDarkManager.addTableTopper(lamp);
         alarmClock = new TableTopperPlane(50,50,2,2);
         alarmClock.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("AlarmClockBigLight"));
         alarmClock.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("AlarmClockBigDark"));
         alarmClock.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("AlarmClockSmallLight"));
         alarmClock.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("AlarmClockSmallDark"));
         alarmClock.rotationY = 20;
         alarmClock.scaleX *= -1;
         positionDO3D(alarmClock,120,156,-397);
         lightDarkManager.addTableTopper(alarmClock);
         cactus = new TableTopperPlane(80,80,1,1);
         cactus.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("CactusTextureBig"));
         cactus.newMaterialState(CharacterDefinitions.BIG + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("CactusTextureBig"));
         cactus.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_ON,this.unPackAsset("CactusTextureSmall"));
         cactus.newMaterialState(CharacterDefinitions.SMALL + "_" + LightDarkManager.LIGHTSTATE_OFF,this.unPackAsset("CactusTextureSmall"));
         lightDarkManager.addTableTopper(cactus);
         cactus.rotationY = 160;
         positionDO3D(cactus,338,142.5,-133);
      }
      
      private function handleBigWokenUp(param1:Event) : void
      {
         addThrowablesToBasicView();
      }
      
      private function initCushions() : void
      {
         var _loc1_:BezierSegment3D = null;
         var _loc2_:BezierSegment3D = null;
         var _loc3_:BezierSegment3D = null;
         smallCushions = [];
         _loc1_ = new BezierSegment3D(new Number3D(55,0,5),new Number3D(100,350,-80),new Number3D(230,120,-90),new Number3D(160,170,-90));
         _loc2_ = new BezierSegment3D(_loc1_.pointB,new Number3D(260,290,-105),new Number3D(303,143,-155),new Number3D(290,270,-115));
         _loc3_ = new BezierSegment3D(_loc2_.pointB,new Number3D(100,350,-80),_loc1_.pointA,new Number3D(160,170,-90));
         blueThrowablePillow = new ThrowableBedroomObject(this.unPackAsset("BigCushion1turn"),this.unPackAsset("BigCushion1"),_loc1_,_loc2_,_loc3_);
         blueThrowablePillowLayer = basicView.viewport.containerSprite.getChildLayer(blueThrowablePillow,true,true);
         blueThrowablePillowLayer.buttonMode = true;
         AccessibilityManager.addAccessibilityProperties(blueThrowablePillowLayer,"Blue Pillow x","Throw the pillow at Big",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         positionDO3D(blueThrowablePillow,-50,0,-100);
         smallCushions.push(blueThrowablePillow);
         _loc1_ = new BezierSegment3D(new Number3D(-30,0,15),new Number3D(-20,250,-10),new Number3D(-50,130,-40),new Number3D(-30,170,-20));
         _loc2_ = new BezierSegment3D(_loc1_.pointB,new Number3D(-50,295,-110),new Number3D(-130,145,-175),new Number3D(-70,265,-120));
         _loc3_ = new BezierSegment3D(_loc2_.pointB,new Number3D(-10,130,-60),_loc1_.pointA,new Number3D(-10,50,-60));
         greenThrowablePillow = new ThrowableBedroomObject(this.unPackAsset("BigCushion2turn"),this.unPackAsset("BigCushion2"),_loc1_,_loc2_,_loc3_);
         greenThrowablePillowLayer = basicView.viewport.containerSprite.getChildLayer(greenThrowablePillow,true,true);
         greenThrowablePillowLayer.buttonMode = true;
         AccessibilityManager.addAccessibilityProperties(greenThrowablePillowLayer,"Green Pillow x","Throw the pillow at Big",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         positionDO3D(greenThrowablePillow,260,0,-110);
         smallCushions.push(greenThrowablePillow);
         _loc1_ = new BezierSegment3D(new Number3D(),new Number3D(40,110,40),new Number3D(190,-75,90),new Number3D(110,40,75));
         _loc2_ = new BezierSegment3D(_loc1_.pointB,new Number3D(170,70,80),new Number3D(120,-75,90),new Number3D(150,0,80));
         _loc3_ = new BezierSegment3D(_loc2_.pointB,new Number3D(40,70,10),_loc1_.pointA,new Number3D(110,0,15));
         throwableTeddy = new ThrowableFreakyAssTeddy(this.unPackAsset("teddyanimbig"),_loc1_,_loc2_,_loc3_);
         throwableTeddyLayer = basicView.viewport.containerSprite.getChildLayer(throwableTeddy,true,true);
         throwableTeddyLayer.buttonMode = true;
         AccessibilityManager.addAccessibilityProperties(throwableTeddyLayer,"Sleep Toy Thingy x","Throw the toy at Big",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         positionDO3D(throwableTeddy,-40,190,-285);
         smallCushions.push(throwableTeddy);
         bigDraggablePillows = new BigDraggablePillows(basicView,this,smallBounceBed);
         bigCushions = new Array();
         bigCushion1 = new DraggableBedroomObject(this.unPackAsset("SmallCushion1"));
         bigCushion1.size = 0.85;
         positionDO3D(bigCushion1,-80,0,-120);
         bigCushions.push(bigCushion1);
         bigCushion2 = new DraggableBedroomObject(this.unPackAsset("SmallCushion2"));
         positionDO3D(bigCushion2,230,0,-90);
         bigCushion2.size = 0.85;
         bigCushions.push(bigCushion2);
         bigTeddy = new DraggableBedroomObject(this.unPackAsset("teddyanimsmall"));
         bigTeddy.size = 0.85;
         positionDO3D(bigTeddy,-40,187,-312);
         bigCushions.push(bigTeddy);
         bigCushion1Layer = basicView.viewport.containerSprite.getChildLayer(bigCushion1,true,true);
         bigCushion2Layer = basicView.viewport.containerSprite.getChildLayer(bigCushion2,true,true);
         bigTeddyLayer = basicView.viewport.containerSprite.getChildLayer(bigTeddy,true,true);
         bigDraggablePillows.setBluePillow(bigCushion1,new VPortLayerButton(bigCushion1Layer));
         bigDraggablePillows.setGreenPillow(bigCushion2,new VPortLayerButton(bigCushion2Layer));
         bigDraggablePillows.setTeddy(bigTeddy,new VPortLayerButton(bigTeddyLayer));
         bigCushion1.addEventListener(ThrowableBedroomObject.FLIGHT_PROGRESS,handleThrowableInFlight);
         bigCushion2.addEventListener(ThrowableBedroomObject.FLIGHT_PROGRESS,handleThrowableInFlight);
         bigTeddy.addEventListener(ThrowableBedroomObject.FLIGHT_PROGRESS,handleThrowableInFlight);
      }
      
      private function setArrowPositions(param1:String) : void
      {
         if(!toBathroomSprite)
         {
            return;
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            toLivingRoomSprite.size = 0.7;
            toBathroomSprite.size = 0.6;
            toLivingRoomMat.movie = toLivingRoomMovBig;
            toBathroomMat.movie = toBathroomMovBig;
            positionDO3D(toLivingRoomSprite,410,130,-20);
            positionDO3D(toBathroomSprite,-50,280,-60);
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            toLivingRoomSprite.size = 0.8;
            toBathroomSprite.size = 0.6;
            toLivingRoomMat.movie = toLivingRoomMovSmall;
            toBathroomMat.movie = toBathroomMovSmall;
            positionDO3D(toLivingRoomSprite,420,110,-10);
            positionDO3D(toBathroomSprite,-10,210,-60);
         }
      }
      
      override public function transitionProgressIn(param1:Number) : void
      {
         if(param1 < 0.5)
         {
            bdrDoorKnobPSprite.visible = false;
         }
         else
         {
            bdrDoorKnobPSprite.visible = true;
         }
         bigInBed.visible = param1 > 0.55;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            bigDraggablePillows.greenPillow.visible = param1 > 0.4;
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            if(param1 < 0.4)
            {
               greenThrowablePillowLayer.forceDepth = true;
               greenThrowablePillowLayer.screenDepth = ScreenDepthDefinitions.BEDROOM_FURNITURE + 2;
            }
            else
            {
               greenThrowablePillowLayer.forceDepth = false;
            }
            if(param1 < 0.3)
            {
               blueThrowablePillowLayer.forceDepth = true;
               blueThrowablePillowLayer.screenDepth = ScreenDepthDefinitions.BEDROOM_FURNITURE + 3;
            }
            else
            {
               blueThrowablePillowLayer.forceDepth = false;
            }
         }
      }
      
      private function handleDoorAnimShut(param1:Event) : void
      {
         SoundManagerOld.playSound("hf_door_close");
      }
      
      private function initDarkTextures() : void
      {
         lightTextures = new Dictionary();
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomLeftWall,swapToLightDarkMaterial(bedRoom,"LeftWall_BedroomWallpaper","lambert62SG",DarkTextureLocations.bedroomLeftWall));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomRightWall,swapToLightDarkMaterial(bedRoom,"RightWall","RightWall1SG",DarkTextureLocations.bedroomRightWall));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomFloor,swapToLightDarkMaterial(bedRoom,"Floor","BackWall2SG",DarkTextureLocations.bedroomFloor));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBackWall,swapToLightDarkMaterial(bedRoom,"BackWall","BackWall1SG",DarkTextureLocations.bedroomBackWall,true));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBed,swapToLightDarkMaterial(bedRoomObjects,"BedFrame","lambert42SG",DarkTextureLocations.bedroomBed));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBedsideTable,swapToLightDarkMaterial(bedRoomObjects,"BedsideTable","Floor3SG",DarkTextureLocations.bedroomBedsideTable));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomChestOfDrawers,swapToLightDarkMaterial(bedRoomObjects,"ChestOfDrawers","ChestOfDrawers1SG",DarkTextureLocations.bedroomChestOfDrawers));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomSmallPillow,swapToLightDarkMaterial(bedRoomBedding,"SmallsPillow","lambert45SG",DarkTextureLocations.bedroomSmallPillow));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomSmallDuvet,swapToLightDarkMaterial(bedRoomBedding,"SmallsDuvet","lambert44SG",DarkTextureLocations.bedroomSmallDuvet));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBigPillow,swapToLightDarkMaterial(bedRoomBedding,"BigsPillow","lambert49SG",DarkTextureLocations.bedroomBigPillow));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBigDuvet,swapToLightDarkMaterial(bedRoomBedding,"BigsDuvet","lambert43SG",DarkTextureLocations.bedroomBigDuvet,false));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBedsideBook,swapToLightDarkMaterial(bedRoomObjects,"BedsideTableBook","lambert16SG",DarkTextureLocations.bedroomBedsideBook));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBookUnderBedLeft,swapToLightDarkMaterial(bedRoomObjects,"UnderBed_BookPile01","lambert17SG",DarkTextureLocations.bedroomBookUnderBedLeft));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBookUnderBedRight,swapToLightDarkMaterial(bedRoomObjects,"UnderBed_BookPile03","lambert18SG",DarkTextureLocations.bedroomBookUnderBedRight));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBookDrawersTop,swapToLightDarkMaterial(bedRoomObjects,"ChestOfDrawers_BookPile02","lambert19SG",DarkTextureLocations.bedroomBookDrawersTop));
         lightDarkManager.addLightDarkMaterial(DarkTextureLocations.bedroomBookDrawersBottom,swapToLightDarkMaterial(bedRoomObjects,"ChestOfDrawers_BookPile03","BookPile05SG",DarkTextureLocations.bedroomBookDrawersBottom));
      }
      
      private function receievedBathroomDoor(param1:IAssetLoader) : void
      {
         bthDoorDAE = param1.getContent() as DAEFixed;
         bthDoorDAE.scale = 25;
         bthDoorDAE.rotationY = 180;
         positionDO3D(bthDoorDAE,-164,0,-1);
         bathroomDoor3D = new Door3D(bthDoorDAE);
         bathroomDoor3D.defaultRotY = 180;
         bathroomDoor3D.rotYOnOver = 180;
      }
      
      private function handleBathroomDoorRollOut(param1:MouseEvent) : void
      {
         showArrow(toBathroomSprite,false);
      }
      
      private function handleLandingDoorOver(param1:MouseEvent) : void
      {
         bedroomDoor3D.setDoorModelOverState(true);
         if(this._isActive)
         {
            showArrow(toLivingRoomSprite,true);
         }
      }
      
      protected function dispatchLightTextureRequests() : void
      {
         var _loc2_:BitmapFileMaterial = null;
         lightTextures = new Dictionary();
         var _loc1_:int = 0;
         for each(_loc2_ in lightMaterials)
         {
            _loc1_++;
            dispatchLightTextureRequest("lightTextureRequest" + _loc1_,_loc2_.texture.toString());
         }
      }
      
      private function receiveLightTexture(param1:IAssetLoader) : void
      {
         var _loc2_:FadeChangeableBitmapMaterial = lightDarkManager.fadeMaterials[darkLinks[lightLinks.indexOf(param1.resourcePath)]];
         var _loc3_:DisplayObject = param1.getContent() as DisplayObject;
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,_loc2_.transparent,0);
         _loc4_.draw(_loc3_);
         lightTextures[darkLinks[lightLinks.indexOf(param1.resourcePath)]] = _loc4_;
      }
      
      private function initGameManagers() : void
      {
         bigGameManager = new BigWakeUpGameManager(this,basicView);
         bigGameManager.setSmallCam(smallCam as OrbitCamera3D);
         bigGameManager.setThrowableObjects(blueThrowablePillow,new PillowVPortLayerButton(blueThrowablePillowLayer),greenThrowablePillow,new PillowVPortLayerButton(greenThrowablePillowLayer),throwableTeddy,new PillowVPortLayerButton(throwableTeddyLayer));
         bigGameManager.setLightDarkManager(lightDarkManager);
         bigGameManager.setBlind(blind,blind.viewportLayerButton);
         bigGameManager.setLamp(lamp,lampButton);
         bigGameManager.setAlarmClock(alarmClock,new VPortLayerButton(alarmClock.viewportLayer));
         bigGameManager.setMobile(mobile,mobileLayerButton);
         bigGameManager.setMobileHitArea(mobileDragHitArea);
         bigGameManager.init(bigInBed);
         bigGameManager.addEventListener(BigWakeUpGameManager.BLUEPILLOW_HITBIG,handleBluePillowHitBig);
         bigGameManager.addEventListener(BigWakeUpGameManager.GREENPILLOW_HITBIG,handleGreenPillowHitBig);
         bigGameManager.addEventListener(BigWakeUpGameManager.TEDDY_HITBIG,handleTeddyHitBig);
         bigGameManager.addEventListener(BigWakeUpGameManager.WOKEN_UP,handleBigWokenUp);
         bigGameManager.park();
         smallGameManager = new SmallToSleepGameManager(this,basicView);
         smallGameManager.setDuvet(duvetMod);
         smallGameManager.setDraggablePillows(bigDraggablePillows);
         smallGameManager.setLightDarkManager(lightDarkManager);
         smallGameManager.setBlind(blind,blind.viewportLayerButton);
         smallGameManager.setLamp(lamp,lampButton);
         smallGameManager.setAlarmClock(alarmClock,new VPortLayerButton(alarmClock.viewportLayer));
         smallGameManager.setMobile(mobile,mobileLayerButton);
         smallGameManager.setCamera(bigCam as OrbitCamera3D);
         smallGameManager.init(smallBounceBed);
         smallGameManager.addEventListener(BigDraggablePillows.BLUEPILLOW_MOVING,flagBlueDraggablePillow);
         smallGameManager.addEventListener(BigDraggablePillows.GREENPILLOW_MOVING,flagGreenDraggablePillow);
         smallGameManager.addEventListener(BigDraggablePillows.TEDDY_MOVING,flagDraggableTeddy);
         smallGameManager.park();
      }
      
      private function registerSounds() : void
      {
         var _loc1_:SoundInfoOld = new SoundInfoOld(0.3,0,0,0,5);
         _loc1_.onCompleteFunc = handleMobileJingleSoundComplete;
         SoundManagerOld.registerSound(new BrainSoundOld("bed_mobile_bigplays",this.unPackAsset("bed_mobile_bigplays",true),_loc1_));
         _loc1_ = new SoundInfoOld(0.8,0,0,0,1);
         _loc1_.onConflictResponse = SoundInfoOld.CHANCONFLICT_SKIP;
         SoundManagerOld.registerSound(new BrainSoundOld("bed_clock_ping",this.unPackAsset("bed_clock_ping",true),_loc1_));
         quickRegisterSound("bed_toy_smallthrow");
         quickRegisterSound("bed_toy_smallpickup");
         quickRegisterSound("bed_toy_bigpickup");
         quickRegisterSound("bed_toy_biggives");
         quickRegisterSound("bed_mobile_smallstretchloop",5);
         quickRegisterSound("bed_mobile_smallrelease");
         quickRegisterSound("bed_cushion");
         quickRegisterSound("bed_blinds_smallflapping");
         quickRegisterSound("bed_blinds_smallflap");
         quickRegisterSound("bed_blinds_bigclose");
         quickRegisterSound("bed_smallbouncing");
         quickRegisterSound("bed_mobile_jangling");
         var _loc2_:BrainSoundCollectionOld = new BrainSoundCollectionOld("bed_small_bounce");
         _loc2_.pushSound(new BrainSoundOld("bed_small_bounce1",this.unPackAsset("bed_small_bounce1",true)));
         _loc2_.pushSound(new BrainSoundOld("bed_small_bounce2",this.unPackAsset("bed_small_bounce2",true)));
         _loc2_.pushSound(new BrainSoundOld("bed_small_bounce3",this.unPackAsset("bed_small_bounce3",true)));
         _loc2_.pushSound(new BrainSoundOld("bed_small_bounce4",this.unPackAsset("bed_small_bounce4",true)));
         _loc2_.pushSound(new BrainSoundOld("bed_small_bounce5",this.unPackAsset("bed_small_bounce5",true)));
         SoundManagerOld.registerSoundCollection(_loc2_);
         _loc1_ = new SoundInfoOld(0.4,0,0,0,5);
         var _loc3_:BrainSoundCollectionOld = new BrainSoundCollectionOld("big_snore_in",_loc1_);
         _loc3_.pushSound(new BrainSoundOld("bed_big_insnore1",this.unPackAsset("bed_big_insnore1",true)));
         _loc3_.pushSound(new BrainSoundOld("bed_big_insnore2",this.unPackAsset("bed_big_insnore2",true)));
         _loc3_.pushSound(new BrainSoundOld("bed_big_insnore3",this.unPackAsset("bed_big_insnore3",true)));
         _loc3_.pushSound(new BrainSoundOld("bed_big_insnore4",this.unPackAsset("bed_big_insnore4",true)));
         SoundManagerOld.registerSoundCollection(_loc3_);
         _loc1_ = new SoundInfoOld(0.4,0,0,0,5);
         var _loc4_:BrainSoundCollectionOld = new BrainSoundCollectionOld("big_snore_out",_loc1_);
         _loc4_.pushSound(new BrainSoundOld("bed_big_outsnore1",this.unPackAsset("bed_big_outsnore1",true)));
         _loc4_.pushSound(new BrainSoundOld("bed_big_outsnore2",this.unPackAsset("bed_big_outsnore2",true)));
         _loc4_.pushSound(new BrainSoundOld("bed_big_outsnore3",this.unPackAsset("bed_big_outsnore3",true)));
         _loc4_.pushSound(new BrainSoundOld("bed_big_outsnore4",this.unPackAsset("bed_big_outsnore4",true)));
         SoundManagerOld.registerSoundCollection(_loc4_);
         var _loc5_:BrainSoundCollectionOld = new BrainSoundCollectionOld("big_ingame_vox",new SoundInfoOld(1,0,0,0,1));
         _loc5_.pushSound(new BrainSoundOld("bed_big_whatelsemightcalm",this.unPackAsset("bed_big_whatelsemightcalm",true)));
         _loc5_.pushSound(new BrainSoundOld("bed_big_howmuchbouncing",this.unPackAsset("bed_big_howmuchbouncing",true)));
         _loc5_.pushSound(new BrainSoundOld("bed_big_betterkeeplooking",this.unPackAsset("bed_big_betterkeeplooking",true)));
         SoundManagerOld.registerSoundCollection(_loc5_);
         var _loc6_:BrainSoundCollectionOld = new BrainSoundCollectionOld("small_pregame_vox",new SoundInfoOld(1,0,0,0,1));
         _loc6_.pushSound(new BrainSoundOld("bed_small_theremustbesomething",this.unPackAsset("bed_small_theremustbesomething",true)));
         _loc6_.pushSound(new BrainSoundOld("bed_small_cmonnbig",this.unPackAsset("bed_small_cmonnbig",true)));
         SoundManagerOld.registerSoundCollection(_loc6_);
         var _loc7_:BrainSoundCollectionOld = new BrainSoundCollectionOld("small_sleep_reinforce",new SoundInfoOld(1,0,0,0,1));
         _loc7_.pushSound(new BrainSoundOld("bed_big_positivereinforcement3",this.unPackAsset("bed_big_positivereinforcement3",true)));
         _loc7_.pushSound(new BrainSoundOld("bed_big_positivereinforcement2",this.unPackAsset("bed_big_positivereinforcement2",true)));
         _loc7_.pushSound(new BrainSoundOld("bed_big_positivereinforcement1",this.unPackAsset("bed_big_positivereinforcement1",true)));
         _loc7_.rotationType = BrainSoundCollectionOld.ROTATIONTYPE_PSEUDOSEQ;
         SoundManagerOld.registerSoundCollection(_loc7_);
         quickRegisterSound("bed_big_trybeingsmall",1);
         quickRegisterSound("bed_small_try_being_big",1);
         quickRegisterSound("bed_small_whataboutrocket",1);
         quickRegisterSound("bed_small_thatsleeptoythingy",1);
         quickRegisterSound("bed_small_OKlookatthose",1);
         quickRegisterSound("bed_small_maybenotbright",1);
         quickRegisterSound("bed_big_tadaididit",1);
         quickRegisterSound("bed_big_letsseeifwecan",1);
         quickRegisterSound("obed_big_snoreloop",1);
         quickRegisterSound("obed_big_sleepy",1);
         quickRegisterSound("obed_big_lovelysleep",1);
         quickRegisterSound("obed_big_dreamboat",1);
         quickRegisterSound("obed_big_allaboard",1);
         quickRegisterSound("bed_small_bigsfastasleepthats",1);
         quickRegisterSound("bed_big_snoreloop",1);
         quickRegisterSound("obed_smallbouncing");
         quickRegisterSound("obed_small_woohooicanbounce",1);
         quickRegisterSound("obed_big_uhohknowwhothatis",1);
         quickRegisterSound("bed_big_theremustbeawaytocalm",1);
      }
      
      private function handleVoxTimeout(param1:Event) : void
      {
      }
      
      private function initBig() : void
      {
         bigInBed = new BigInBed(unPackAsset("BigSleeping"));
         bigInBed.registerReaction("BigReaction1",unPackAsset("BigReaction1"),unPackAsset("React1Sound"));
         bigInBed.registerReaction("BigReaction2",unPackAsset("BigReaction2"),unPackAsset("React2Sound"));
         bigInBed.registerReaction("BigReaction3",unPackAsset("BigReaction3"),unPackAsset("React3Sound"));
         bigInBed.registerReaction("BigReaction4",unPackAsset("BigReaction4"),unPackAsset("React4Sound"));
         bigInBed.registerReaction("BigReaction5",unPackAsset("BigReaction5"),unPackAsset("React5Sound"));
         var _loc1_:BrainSoundCollectionOld = SoundManagerOld.getSoundByID("big_snore_in") as BrainSoundCollectionOld;
         var _loc2_:BrainSoundCollectionOld = SoundManagerOld.getSoundByID("big_snore_out") as BrainSoundCollectionOld;
         bigInBed.setSnoreCollections(_loc1_,_loc2_);
         positionDO3D(bigInBed,234,120,-190);
         bigInBed.deactivate();
      }
      
      private function initMobile() : void
      {
         mobile = new MobileStruct3D(this.basicView);
         positionDO3D(mobile,350,340,-185);
         var _loc1_:Number3D = new Number3D(this.x + mobile.x,this.y + mobile.y,this.z + mobile.z);
         mobile.init(_loc1_,this.unPackAsset("Mobile1"),this.unPackAsset("Mobile2"),this.unPackAsset("Mobile3"),this.unPackAsset("Mobile4"),this.unPackAsset("MobileHandle",true));
         mobile.update(45);
         mobileDragHitArea = new Sprite();
         var _loc2_:Graphics = mobileDragHitArea.graphics;
         _loc2_.beginFill(16711680,0);
         _loc2_.drawEllipse(-55,10,110,145);
      }
      
      private function initSmall() : void
      {
         var _loc2_:String = null;
         var _loc3_:AnimationOld = null;
         smallAnimStates = ["SmallJumping0","SmallJumping1","SmallJumping2","SmallJumping3","SmallJumping4","SmallJumping5"];
         var _loc1_:Dictionary = new Dictionary(true);
         for each(_loc2_ in smallAnimStates)
         {
            _loc3_ = new AnimationOld(unPackAsset(_loc2_));
            _loc3_.subjectClip.scaleX = _loc3_.subjectClip.scaleY = 1.05;
            _loc1_[_loc2_] = _loc3_;
         }
         smallBounceBed = new SmallBounceBed(_loc1_["SmallJumping0"]);
         smallBounceBed.setContent(_loc1_,smallAnimStates);
         positionDO3D(smallBounceBed,190,109,-310);
         smallBaseYPos = smallBounceBed.y;
         smallBounceBed.deactivate();
      }
      
      private function receiveDarkTexture(param1:IAssetLoader) : void
      {
         var _loc2_:FadeChangeableBitmapMaterial = lightDarkManager.fadeMaterials[param1.resourcePath];
         var _loc3_:Boolean = _loc2_ ? _loc2_.transparent : false;
         var _loc4_:DisplayObject = param1.getContent() as DisplayObject;
         var _loc5_:BitmapData = new BitmapData(_loc4_.width,_loc4_.height,_loc3_);
         _loc5_.draw(_loc4_);
         darkTextures[param1.resourcePath] = _loc5_;
      }
      
      private function removeArrow(param1:PointSprite) : void
      {
         param1.visible = false;
         SpriteParticleMaterial(param1.material).removeSprite();
      }
      
      public function updateDuvetLayer() : void
      {
         if(currentPOV == CharacterDefinitions.BIG)
         {
            if(!duvetLayer)
            {
               duvetLayer = furnitureLayer.getChildLayer(bigsDuvet,true);
            }
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            if(duvetLayer)
            {
               furnitureLayer.removeLayer(duvetLayer);
               duvetLayer.dynamicLayer = true;
               duvetLayer = null;
            }
            furnitureLayer.addDisplayObject3D(bigsDuvet);
         }
      }
      
      private function receievedBedroomBedding(param1:IAssetLoader) : void
      {
         bedRoomBedding = DAEFixed(param1.getContent());
         bedRoomBedding.scale = 25;
         bedRoomBedding.rotationY = 180;
      }
      
      override public function park() : void
      {
         if(this._isLive)
         {
            SoundManagerOld.stopSoundChannel(1,1);
         }
         super.park();
         smallGameManager.park();
         bigGameManager.park();
         bedroomDoor3D.closeDoor(true);
         addThrowablesToBasicView();
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
         mobileLayer.tabEnabled = param1;
         blind.viewportLayer.tabEnabled = param1;
         lamp.viewportLayer.tabEnabled = param1;
         bedroomDoorLayer.tabEnabled = param1;
         bathroomDoorLayer.tabEnabled = param1;
         blueThrowablePillowLayer.tabEnabled = param1;
         greenThrowablePillowLayer.tabEnabled = param1;
         throwableTeddyLayer.tabEnabled = param1;
         bigDraggablePillows.tabEnableViewports(param1);
         pageContainer2D.tabEnabled = param1;
      }
      
      override public function collectionQueueEmpty() : void
      {
         var _loc1_:FadeChangeableBitmapMaterial = null;
         var _loc2_:String = null;
         if(!this.isTransitionReady)
         {
            registerSounds();
            buildScene();
            setReadyState();
            park();
         }
         else
         {
            for(_loc2_ in lightDarkManager.fadeMaterials)
            {
               _loc1_ = lightDarkManager.fadeMaterials[_loc2_];
               _loc1_.addBitmap(BitmapData(lightTextures[_loc2_]),"light");
               _loc1_.addBitmap(BitmapData(darkTextures[_loc2_]),"dark");
               _loc1_.reset();
            }
            lightDarkManager.currentPOV = this.currentPOV;
            lightDarkManager.update(true);
         }
      }
      
      private function receievedBedroomObjects(param1:IAssetLoader) : void
      {
         bedRoomObjects = DAEFixed(param1.getContent());
         bedRoomObjects.scale = 25;
         bedRoomObjects.rotationY = 180;
      }
      
      private function receievedBedroom(param1:IAssetLoader) : void
      {
         bedRoom = DAEFixed(param1.getContent());
         bedRoom.scale = 25;
         bedRoom.rotationY = 180;
      }
   }
}

