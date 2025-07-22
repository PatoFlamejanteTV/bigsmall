package net.pluginmedia.bigandsmall.pages
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
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
   import net.pluginmedia.bigandsmall.pages.bathroom.BathroomTapPlane;
   import net.pluginmedia.bigandsmall.pages.bathroom.BubbleManager;
   import net.pluginmedia.bigandsmall.pages.bathroom.Mirror;
   import net.pluginmedia.bigandsmall.pages.bathroom.ToothBrushHolder;
   import net.pluginmedia.bigandsmall.pages.bathroom.incidentals.BathFrogs;
   import net.pluginmedia.bigandsmall.pages.bathroom.incidentals.BubbleBathBottle;
   import net.pluginmedia.bigandsmall.pages.bathroom.incidentals.ShowerCurtain;
   import net.pluginmedia.bigandsmall.pages.bathroom.incidentals.ToiletFishPointSprite;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.BubbleEvent;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.DoorEvent;
   import net.pluginmedia.bigandsmall.pages.shared.LowPolyVideo;
   import net.pluginmedia.bigandsmall.pages.shared.PerspectiveWindowPlane;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.bigandsmall.ui.VPortLayerComponent;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Bathroom extends BigAndSmallPage3D
   {
      
      private var tapsLayer:ViewportLayer;
      
      private var toBedroomSprite:PointSprite;
      
      private var bigVoxTimeouts:String = "BigVoxTimeout";
      
      private var bathFrogs:BathFrogs;
      
      private var bathLayer:ViewportLayer;
      
      private var bubbleLayer:ViewportLayer;
      
      private var timeoutVoxTimer:Timer = new Timer(120000);
      
      private var bigEntryVox:String = "bath_big_bathroomlaughroom";
      
      private var bthDoorKnobPSprite:PointSprite;
      
      private var entryVoxTimer:Timer = new Timer(2000);
      
      private var videoFrameLoPoly:LowPolyVideo;
      
      private var bubbleBathBottle:BubbleBathBottle;
      
      private var sinkHandleRight:BathroomTapPlane;
      
      private var defaultBigFrogResponses:Array = [];
      
      private var bubbleVoxTimer:Timer = new Timer(25000);
      
      private var sinkTaps:BathroomTapPlane;
      
      private var bedroomDoorButton:VPortLayerComponent;
      
      private var sinkLayer:ViewportLayer;
      
      private var toBedroomMovBig:MovieClip;
      
      private var bigVoxBubbleOver:String = "BigBubbleBottleOver";
      
      private var cabKnobMat:MovieParticleMaterial;
      
      private var roomDAE:DAEFixed;
      
      private var transObjSet:Array = [];
      
      private var bathTaps:BathroomTapPlane;
      
      private var bedroomDoorLayer:ViewportLayer;
      
      private var showerCurtain:ShowerCurtain;
      
      private var roomContentLayer:ViewportLayer;
      
      private var fishPlane:ToiletFishPointSprite;
      
      private var bubbleBathLayer:ViewportLayer;
      
      private var playedEntryVox:Boolean = false;
      
      private var entryVox:String = bigEntryVox;
      
      private var videoLoPolyLayer:ViewportLayer;
      
      private var toBedroomDoor:Door3D;
      
      private var voxTimeouts:String;
      
      private var smallEntryVox:String = "bath_small_isntthisthegreatestbathroom";
      
      private var roomLayer:ViewportLayer;
      
      private var toothbrushVoxTimer:Timer = new Timer(25000);
      
      private var sinkHandleLeft:BathroomTapPlane;
      
      private var toiletLayer:ViewportLayer;
      
      private var bthDoorKnobMat:MovieParticleMaterial;
      
      private var allowToothbrushVox:Boolean = false;
      
      private var toBedroomMovSmall:MovieClip;
      
      private var voxEnabled:Boolean = false;
      
      private var vPortButtons:Array;
      
      private var defaultSmallFrogResponses:Array = [];
      
      private var allowBubbleVox:Boolean = false;
      
      private var toothBrushes:ToothBrushHolder;
      
      private var bubbleManager:BubbleManager;
      
      private var roomContentDAE:DAEFixed;
      
      private var voxToothbrushesOver:String;
      
      private var cabKnobPSprite:PointSprite;
      
      private var sinkButton:VPortLayerButton;
      
      private var smallVoxTimeouts:String = "SmallVoxTimeout";
      
      private var transOutOmitSet:Array = [];
      
      private var bigToothbrushesOver:String = "BigToothbrushesOver";
      
      private var smallToothbrushesOver:String = "SmallToothbrushesOver";
      
      private var toBedroomMat:SpriteParticleMaterial;
      
      private var mirror:Mirror;
      
      private var builtMirrorSnapshots:Boolean = false;
      
      private var bthDoorDAE:DAEFixed;
      
      private var voxBubbleOver:String;
      
      private var bathroomWindow:PerspectiveWindowPlane;
      
      private var allowTimeoutVox:Boolean = false;
      
      private var videoAccessor:VPortLayerButton;
      
      private var videoPageSharedLayer:ViewportLayer;
      
      private var smallVoxBubbleOver:String = "SmallBubbleBottleOver";
      
      public function Bathroom(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = new Number3D(-550,350,-728);
         var _loc5_:OrbitCamera3D = new OrbitCamera3D(48);
         _loc5_.rotationYMin = -213;
         _loc5_.rotationYMax = -170;
         _loc5_.rotationXMin = -6;
         _loc5_.rotationXMax = -8;
         _loc5_.orbitCentre.x = -492;
         _loc5_.orbitCentre.y = 450;
         _loc5_.orbitCentre.z = -822;
         _loc5_.radius = 322;
         var _loc6_:OrbitCamera3D = new OrbitCamera3D(38);
         _loc6_.rotationYMin = -195;
         _loc6_.rotationYMax = -186;
         _loc6_.rotationXMin = 8;
         _loc6_.rotationXMax = 12;
         _loc6_.orbitCentre.x = -532;
         _loc6_.orbitCentre.y = 532;
         _loc6_.orbitCentre.z = -560;
         _loc6_.radius = 224;
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_BEDDING);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_MOBILE);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_ROOM);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_OBJECTS);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_BATHROOMDOOR);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_WINDOW);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_ALARMCLOCK);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_BLINDPLANE);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CACTUS);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_BIG_BLUE);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_BIG_GREEN);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_BIG_TOY);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_SMALL_BLUE);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_SMALL_GREEN);
         transOutOmitSet.push(DO3DDefinitions.BEDROOM_CUSHION_SMALL_TOY);
         super(param1,_loc4_,_loc6_,_loc5_,param2);
         timeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleTimeoutVoxTimer);
         bubbleVoxTimer.addEventListener(TimerEvent.TIMER,handleBubbleVoxTimer);
         toothbrushVoxTimer.addEventListener(TimerEvent.TIMER,handleToothbrushVoxTimer);
         entryVoxTimer.addEventListener(TimerEvent.TIMER,handleEntryVoxTimer);
      }
      
      private function handleBubbleDeath(param1:BubbleEvent) : void
      {
         var _loc2_:Vertex3DInstance = param1.bubble.vertex3D.vertex3DInstance;
         var _loc3_:Number = (_loc2_.x + basicView.viewport.viewportWidth >> 1) / basicView.viewport.viewportWidth;
         SoundManagerOld.playSound("BubblePop",new SoundInfoOld(param1.bubble.targetSize * 1.2,_loc3_));
      }
      
      override public function collectionQueueEmpty() : void
      {
         registerSounds();
         initWindow();
         initToBedroom();
         initToothbrushes();
         initTaps();
         initFish();
         initBubbles();
         initShowerCurtain();
         initFrogs();
         initVideo();
         initMirror();
         initBathroomDoorKnob();
         initCabinetDoorKnob();
         initScene();
         setReadyState();
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      private function initFrogs() : void
      {
         bathFrogs = new BathFrogs("bathFrogs",showerCurtain,"bath_curtainrollover");
         defaultBigFrogResponses = ["bath_big_heyfrogshavinfun","bath_big_maybewellcome","bath_big_okaaay","bath_big_theyneverdidthatdown","bath_big_thinkillleavethem"];
         defaultSmallFrogResponses = ["bath_small_maybeillcomebacklater","bath_small_oostrangebutinteresting","bath_small_itspossibletobetooclean","bath_small_thatswhaticallwildlife","bath_small_uhokay"];
         var _loc1_:BrainSoundCollectionOld = quickRegisterCollection("big_bathroom_frogs",defaultBigFrogResponses,1);
         _loc1_.rotationType = BrainSoundCollectionOld.ROTATIONTYPE_SEQUENCE;
         var _loc2_:BrainSoundCollectionOld = quickRegisterCollection("small_bathroom_frogs",defaultSmallFrogResponses,1);
         _loc2_.rotationType = BrainSoundCollectionOld.ROTATIONTYPE_SEQUENCE;
         quickRegisterSound("bath_small_thatswhaticallwildlife",1);
         quickRegisterSound("bath_small_hahafrogsuprise",1);
         quickRegisterSound("bath_big_mustbethefrogstep",1);
         bathFrogs.registerBigAnim(unPackAsset("ShowerFrog1"),"big_bathroom_frogs");
         bathFrogs.registerBigAnim(unPackAsset("ShowerFrog2"),"big_bathroom_frogs");
         bathFrogs.registerBigAnim(unPackAsset("ShowerFrog3"),"bath_big_mustbethefrogstep");
         bathFrogs.registerBigAnim(unPackAsset("ShowerFrog4"),"big_bathroom_frogs");
         bathFrogs.registerSmallAnim(unPackAsset("ShowerFrog1"),"small_bathroom_frogs");
         bathFrogs.registerSmallAnim(unPackAsset("ShowerFrog2"),"small_bathroom_frogs");
         bathFrogs.registerSmallAnim(unPackAsset("ShowerFrog3"),"bath_small_thatswhaticallwildlife");
         bathFrogs.registerSmallAnim(unPackAsset("ShowerFrog4"),"bath_small_hahafrogsuprise");
         bathFrogs.registerSmallAnim(unPackAsset("ShowerFrog5"),"small_bathroom_frogs");
         positionDO3D(bathFrogs,-145,128,-137);
         bathFrogs.addEventListener("BEGIN_ANIM",handleFrogAnimBegin);
         bathFrogs.addEventListener("END_ANIM",handleFrogAnimEnd);
      }
      
      private function handleLowPolyVideoDirty(param1:Event) : void
      {
         flagDirtyLayer(videoLoPolyLayer);
      }
      
      private function initBubbles() : void
      {
         bubbleManager = new BubbleManager(unPackAsset("BathBubble1"),unPackAsset("BathBubble2"),unPackAsset("BathBubble3"));
         bubbleManager.addEventListener(BubbleEvent.BIRTH,handleBubbleBirth);
         bubbleManager.addEventListener(BubbleEvent.CLONEBIRTH,handleBubbleCloneBirth);
         bubbleManager.addEventListener(BubbleEvent.DEATH,handleBubbleDeath);
         bubbleBathBottle = new BubbleBathBottle("bubbleBathBottle",bubbleManager,unPackAsset("BubbleBathBottleBig"),unPackAsset("BubbleBathBottleSmall"),"bath_bubblerollover","bath_bubblesemitted",0,0,0.7);
         bubbleBathBottle.setCharacter(currentPOV);
         positionDO3D(bubbleBathBottle,-18,100,-200);
         bubbleBathBottle.addEventListener("DIRTY_RENDER",handleDirtyRender);
         bubbleManager.rotationY = -190;
         bubbleManager.x = bubbleBathBottle.x;
         bubbleManager.y = bubbleBathBottle.y + 45;
         bubbleManager.z = bubbleBathBottle.z;
      }
      
      private function handleToBedroomDoorClicked(param1:MouseEvent) : void
      {
         showArrow(toBedroomSprite,false);
         SoundManagerOld.stopSoundChannel(1);
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BEDROOM);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("Bathroom.ROOM",DAELocations.bathroomRoom,roomDAELoaded);
         dispatchAssetRequest("Bathroom.CONTENT",DAELocations.bathroomContent,contentDAELoaded);
         dispatchAssetRequest("Bathroom.DOOR",DAELocations.bathroomDoor,doorDAELoaded);
         dispatchAssetRequest("Bathroom.AUDIO_VOX",SWFLocations.bathroomVox,assetLibLoaded);
         dispatchAssetRequest("Bathroom.AUDIO_SFX",SWFLocations.bathroomSFX,assetLibLoaded);
         dispatchAssetRequest("Bathroom.LIBRARY",SWFLocations.bathroomLibrary,assetLibLoaded);
         dispatchAssetRequest("Bathroom.FROGS",SWFLocations.bathroomFrogs,assetLibLoaded);
      }
      
      private function handleBubbleBirth(param1:BubbleEvent) : void
      {
      }
      
      private function initButtons() : void
      {
         vPortButtons = [];
         sinkButton = new VPortLayerButton(sinkLayer);
         sinkButton.addEventListener(MouseEvent.ROLL_OVER,handleSinkRollover);
         sinkButton.addEventListener(MouseEvent.CLICK,handleSinkClicked);
         vPortButtons.push(sinkButton);
         bedroomDoorButton = new VPortLayerComponent(bedroomDoorLayer);
         bedroomDoorButton.addEventListener(MouseEvent.CLICK,handleToBedroomDoorClicked);
         bedroomDoorButton.addEventListener(MouseEvent.ROLL_OVER,handleToBedroomDoorOver);
         bedroomDoorButton.addEventListener(MouseEvent.ROLL_OUT,handleToBedroomDoorOut);
         vPortButtons.push(bedroomDoorButton);
         videoAccessor = new VPortLayerButton(videoLoPolyLayer);
         videoAccessor.addEventListener(MouseEvent.CLICK,handleVideoFrameClick);
         vPortButtons.push(videoAccessor);
      }
      
      private function setFishPlanePos(param1:String) : void
      {
         if(param1 == CharacterDefinitions.SMALL)
         {
            if(fishPlane)
            {
               fishPlane.y = 155;
            }
         }
         else if(param1 == CharacterDefinitions.BIG)
         {
            if(fishPlane)
            {
               fishPlane.y = 130;
            }
         }
      }
      
      private function initTaps() : void
      {
         sinkTaps = new BathroomTapPlane(unPackAsset("SinkTaps_Small"),unPackAsset("SinkTaps_Big"),new Rectangle(0,0,256,256),40,40,1,1);
         sinkHandleLeft = new BathroomTapPlane(unPackAsset("SinkTaps_TapsSmallLeft"),unPackAsset("SinkTaps_TapsBigLeft"),null,25,25);
         sinkHandleRight = new BathroomTapPlane(unPackAsset("SinkTaps_TapsSmallRight"),unPackAsset("SinkTaps_TapsBigRight"),null,25,25);
         bathTaps = new BathroomTapPlane(unPackAsset("BathTaps_Small"),unPackAsset("BathTaps_Big"),new Rectangle(0,0,256,256),60,60,1,1);
         positionDO3D(sinkTaps,235,161,-86);
         positionDO3D(sinkHandleLeft,254,154,-60);
         positionDO3D(sinkHandleRight,250,157,-100);
         positionDO3D(bathTaps,-128,139,-197);
         sinkTaps.rotationY = 157;
         sinkHandleLeft.rotationY = 120;
         sinkHandleRight.rotationY = 130;
         bathTaps.rotationY = 180;
         sinkTaps.setCharacter(currentPOV);
         sinkHandleLeft.setCharacter(currentPOV);
         sinkHandleRight.setCharacter(currentPOV);
         bathTaps.setCharacter(currentPOV);
      }
      
      override protected function build() : void
      {
      }
      
      private function initLayers() : void
      {
         roomLayer = basicView.viewport.getChildLayer(roomDAE,true,true);
         roomLayer.screenDepth = ScreenDepthDefinitions.BATHROOM;
         roomLayer.forceDepth = true;
         bedroomDoorLayer = basicView.viewport.getChildLayer(toBedroomDoor,true,true);
         bedroomDoorLayer.addDisplayObject3D(toBedroomSprite);
         AccessibilityManager.addAccessibilityProperties(bedroomDoorLayer,"To the bedroom","Go to the bedroom",AccessibilityDefinitions.BATHROOM_ACCESSOR);
         roomContentLayer = roomLayer.getChildLayer(roomContentDAE.getChildByName("cabinet",true),true,true);
         roomContentLayer.addDisplayObject3D(roomContentDAE.getChildByName("mirror",true));
         roomContentLayer.addDisplayObject3D(roomContentDAE.getChildByName("handle",true));
         roomContentLayer.addDisplayObject3D(roomContentDAE.getChildByName("stand",true));
         roomContentLayer.screenDepth = ScreenDepthDefinitions.BATHROOM_CONTENT;
         roomContentLayer.forceDepth = true;
         videoLoPolyLayer = roomContentLayer.getChildLayer(videoFrameLoPoly,true);
         AccessibilityManager.addAccessibilityProperties(videoLoPolyLayer,"Picture frame","Watch a video",AccessibilityDefinitions.BATHROOM_ACCESSOR);
         bathLayer = roomContentLayer.getChildLayer(roomContentDAE.getChildByName("bath_inside",true),true,true);
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_outside",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bathtap01",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bathtap02",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_tray",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_trayedge1",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_trayedge2",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_trayedge3",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("bath_trayedge4",true));
         bathLayer.addDisplayObject3D(roomContentDAE.getChildByName("showerrail",true));
         bathLayer.getChildLayer(showerCurtain,true,true);
         bathLayer.addDisplayObject3D(bathFrogs,true);
         bathLayer.addDisplayObject3D(bathTaps,true);
         AccessibilityManager.addAccessibilityProperties(bathLayer,"Bath","Interact with the bath",AccessibilityDefinitions.BATHROOM_INTERACTIVE);
         toiletLayer = roomContentLayer.getChildLayer(roomContentDAE.getChildByName("toilet_front_inside",true),true,true);
         toiletLayer.addDisplayObject3D(roomContentDAE.getChildByName("toilet_back",true));
         toiletLayer.addDisplayObject3D(roomContentDAE.getChildByName("toiletseat",true));
         toiletLayer.addDisplayObject3D(roomContentDAE.getChildByName("toilet_front_outside",true));
         toiletLayer.addDisplayObject3D(fishPlane,true);
         AccessibilityManager.addAccessibilityProperties(toiletLayer,"Toilet","Interact with the toilet",AccessibilityDefinitions.BATHROOM_INTERACTIVE);
         sinkLayer = roomContentLayer.getChildLayer(roomContentDAE.getChildByName("sink_top",true),true,true);
         sinkLayer.addDisplayObject3D(roomContentDAE.getChildByName("sink_plinth",true));
         sinkLayer.addDisplayObject3D(roomContentDAE.getChildByName("sinkbowl_outside",true));
         sinkLayer.addDisplayObject3D(roomContentDAE.getChildByName("sinkbowl_inside",true));
         sinkLayer.addDisplayObject3D(roomContentDAE.getChildByName("sinktaps",true));
         sinkLayer.addDisplayObject3D(toothBrushes);
         sinkLayer.addDisplayObject3D(sinkTaps);
         sinkLayer.addDisplayObject3D(sinkHandleLeft);
         sinkLayer.addDisplayObject3D(sinkHandleRight);
         AccessibilityManager.addAccessibilityProperties(sinkLayer,"Toothbrush Tackle","Play the bathroom game",AccessibilityDefinitions.BATHROOM_ACCESSOR);
         bubbleBathLayer = roomContentLayer.getChildLayer(bubbleBathBottle,true,true);
         AccessibilityManager.addAccessibilityProperties(bubbleBathLayer,"Bubblebath bottle","Make some bubbles",AccessibilityDefinitions.BATHROOM_INTERACTIVE);
         bubbleLayer = roomContentLayer.getChildLayer(bubbleManager,true);
         bubbleLayer.forceDepth = true;
         bubbleLayer.screenDepth = 0;
         bubbleLayer.addEventListener(MouseEvent.ROLL_OVER,handleBubbleOver);
         bubbleLayer.visible = true;
         addIncidental(fishPlane,toiletLayer);
         addIncidental(bathFrogs,bathLayer);
         addIncidental(bubbleBathBottle,bubbleBathLayer);
         dispatchShareable("BathroomVideoFrameLayer",videoLoPolyLayer);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         bubbleLayer.visible = false;
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         setVPortButtons(false);
         voxEnabled = false;
         timeoutVoxTimer.reset();
         timeoutVoxTimer.stop();
         bubbleVoxTimer.reset();
         bubbleVoxTimer.stop();
         bubbleVoxTimer.reset();
         toothbrushVoxTimer.stop();
         videoFrameLoPoly.deactivate();
         playedEntryVox = false;
         entryVoxTimer.reset();
         entryVoxTimer.stop();
         bubbleBathBottle.stop();
         SoundManagerOld.stopSoundChannel(1);
      }
      
      private function quickRegisterCollection(param1:String, param2:Array, param3:int = -1, param4:SoundInfoOld = null) : BrainSoundCollectionOld
      {
         var _loc6_:String = null;
         var _loc7_:BrainSoundOld = null;
         if(!param4)
         {
            param4 = new SoundInfoOld(1,0,0,0,param3);
         }
         var _loc5_:BrainSoundCollectionOld = new BrainSoundCollectionOld(param1,param4);
         for each(_loc6_ in param2)
         {
            _loc7_ = new BrainSoundOld(_loc6_,this.unPackAsset(_loc6_,true),null);
            _loc5_.pushSound(_loc7_);
         }
         SoundManagerOld.registerSoundCollection(_loc5_);
         return _loc5_;
      }
      
      private function initCabinetDoorKnob() : void
      {
         cabKnobMat = new MovieParticleMaterial(unPackAsset("CabKnobMat"));
         cabKnobMat.updateParticleBitmap(2);
         cabKnobPSprite = new PointSprite(cabKnobMat,0.5);
         var _loc1_:DisplayObject3D = roomContentDAE.getChildByName("cabinet",true);
         cabKnobPSprite.x = -7.55;
         cabKnobPSprite.y = 9.4;
         cabKnobPSprite.z = 11.25;
         _loc1_.addChild(cabKnobPSprite);
      }
      
      private function handleBubbleVoxTimer(param1:TimerEvent) : void
      {
         allowBubbleVox = true;
      }
      
      private function handleFrogAnimBegin(param1:Event) : void
      {
         voxEnabled = false;
      }
      
      private function initToBedroom() : void
      {
         toBedroomMovBig = unPackAsset("ToBedRoomBig");
         toBedroomMovSmall = unPackAsset("ToBedRoomSmall");
         toBedroomMovBig.alpha = 0;
         toBedroomMovSmall.alpha = 0;
         toBedroomMat = new SpriteParticleMaterial(toBedroomMovBig);
         toBedroomSprite = new PointSprite(toBedroomMat);
         toBedroomSprite.size = 0.75;
         setArrowPositions(CharacterDefinitions.BIG);
      }
      
      private function handleCurtainOpen(param1:Event) : void
      {
         entryVoxTimer.reset();
         entryVoxTimer.stop();
         SoundManagerOld.stopSoundChannel(1);
      }
      
      private function handleDirtyRender(param1:Event) : void
      {
         if(param1.target == bubbleBathBottle)
         {
            flagDirtyLayer(bubbleBathLayer);
         }
      }
      
      private function mirrorImageUpdate() : void
      {
         if(!mirror)
         {
            return;
         }
         if(mirror)
         {
            mirror.selectLabelledData("BATHROOM_" + currentPOV);
         }
         if(!builtMirrorSnapshots)
         {
            buildMirrorSnapshots();
         }
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         if(!isLive)
         {
            return;
         }
         bubbleManager.update(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY,currentPOV == CharacterDefinitions.BIG);
         flagDirtyLayer(bubbleLayer);
         if(toothBrushes.isShaking)
         {
            flagDirtyLayer(sinkLayer);
         }
         if(fishPlane.playing)
         {
            flagDirtyLayer(toiletLayer);
         }
         bathFrogs.update(param1);
         if(bathFrogs.doRender)
         {
            flagDirtyLayer(bathLayer);
         }
         if(mirror)
         {
            mirror.update();
         }
      }
      
      private function handleSinkRollover(param1:MouseEvent) : void
      {
         if(allowToothbrushVox && voxEnabled)
         {
            allowToothbrushVox = false;
            SoundManagerOld.playSound(voxToothbrushesOver);
            toothbrushVoxTimer.reset();
            toothbrushVoxTimer.start();
            toothBrushes.shake(false);
         }
         else if(SoundManagerOld.channelOccupied(1))
         {
            toothBrushes.shake(false);
         }
         else
         {
            toothBrushes.shake(true);
         }
      }
      
      private function initToothbrushes() : void
      {
         toothBrushes = new ToothBrushHolder(unPackAsset("ToothBrushPotBig"),unPackAsset("ToothBrushPotSmall"),2,2,0.5);
         toothBrushes.setCharacter(currentPOV);
         toothBrushes.rotationY = 160;
         positionDO3D(toothBrushes,240,186,-33);
      }
      
      private function handleTimeoutVoxTimer(param1:TimerEvent) : void
      {
         if(voxEnabled)
         {
            SoundManagerOld.playSound(voxTimeouts);
         }
      }
      
      private function initBathroomDoorKnob() : void
      {
         bthDoorKnobMat = new MovieParticleMaterial(unPackAsset("KnobMat"));
         bthDoorKnobMat.updateParticleBitmap(2);
         bthDoorKnobPSprite = new PointSprite(bthDoorKnobMat,1);
         bthDoorKnobPSprite.x = 0.3;
         bthDoorKnobPSprite.y = 5.15;
         bthDoorKnobPSprite.z = 6.6;
         bthDoorDAE.addChild(bthDoorKnobPSprite);
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(param1 == CharacterDefinitions.BIG)
         {
            voxTimeouts = bigVoxTimeouts;
            voxBubbleOver = bigVoxBubbleOver;
            voxToothbrushesOver = bigToothbrushesOver;
            entryVox = bigEntryVox;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            voxTimeouts = smallVoxTimeouts;
            voxBubbleOver = smallVoxBubbleOver;
            voxToothbrushesOver = smallToothbrushesOver;
            entryVox = smallEntryVox;
         }
         if(Boolean(toothBrushes) && Boolean(sinkLayer))
         {
            toothBrushes.setCharacter(param1);
         }
         if(toBedroomSprite)
         {
            setArrowPositions(param1);
         }
         if(bathTaps)
         {
            bathTaps.setCharacter(param1);
         }
         if(sinkTaps)
         {
            sinkTaps.setCharacter(param1);
         }
         if(sinkHandleLeft)
         {
            sinkHandleLeft.setCharacter(param1);
         }
         if(sinkHandleRight)
         {
            sinkHandleRight.setCharacter(param1);
         }
         if(fishPlane)
         {
            setFishPlanePos(param1);
         }
         if(Boolean(mirror) && isLive)
         {
            mirror.selectLabelledData("BATHROOM_" + param1);
         }
      }
      
      private function setVPortButtons(param1:Boolean) : void
      {
         var _loc2_:VPortLayerComponent = null;
         for each(_loc2_ in vPortButtons)
         {
            _loc2_.setEnabledState(param1);
         }
      }
      
      protected function handleSinkClicked(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE);
      }
      
      private function initMirror() : void
      {
         var _loc1_:DisplayObject3D = roomContentDAE.getChildByName("mirror",true);
         mirror = new Mirror(basicView.viewport,_loc1_);
         dispatchShareable("BathroomMirror",mirror);
      }
      
      private function handleEntryVoxTimer(param1:TimerEvent) : void
      {
         entryVoxTimer.reset();
         entryVoxTimer.stop();
         var _loc2_:Boolean = SoundManagerOld.playSound(entryVox);
         if(_loc2_)
         {
            playedEntryVox = true;
         }
      }
      
      override public function activate() : void
      {
         super.activate();
         bubbleLayer.visible = true;
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         setVPortButtons(true);
         if(!playedEntryVox)
         {
            entryVoxTimer.start();
         }
         timeoutVoxTimer.reset();
         timeoutVoxTimer.start();
         bubbleVoxTimer.reset();
         bubbleVoxTimer.start();
         allowBubbleVox = true;
         toothbrushVoxTimer.reset();
         toothbrushVoxTimer.start();
         allowToothbrushVox = true;
         voxEnabled = true;
         if(fishPlane)
         {
            setFishPlanePos(currentPOV);
         }
         videoFrameLoPoly.activate();
      }
      
      private function suspendVox() : void
      {
      }
      
      private function showArrow(param1:PointSprite, param2:Boolean) : void
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
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         bubbleLayer.visible = false;
         mirrorImageUpdate();
         bubbleLayer.visible = true;
      }
      
      override public function getTransitionOmitObjects() : Array
      {
         return super.getTransitionOmitObjects().concat(transObjSet);
      }
      
      private function roomDAELoaded(param1:IAssetLoader) : void
      {
         roomDAE = DAEFixed(param1.getContent());
         roomDAE.scale = 25;
         roomDAE.rotationY = 180;
         daeLoadHelper.addDAE(roomDAE);
      }
      
      private function initWindow() : void
      {
         var _loc1_:MovieClip = unPackAsset("SkyTexture");
         bathroomWindow = new PerspectiveWindowPlane(_loc1_,110,110,100,220,-250,-1000,new Number3D(0,0,-1));
         bathroomWindow.rotationY -= 12;
      }
      
      private function contentDAELoaded(param1:IAssetLoader) : void
      {
         roomContentDAE = DAEFixed(param1.getContent());
         roomContentDAE.scale = 25;
         roomContentDAE.rotationY = 180;
      }
      
      private function quickRegisterSound(param1:String, param2:Number = -1) : void
      {
         var _loc3_:SoundInfoOld = new SoundInfoOld(1,0,0,0,param2);
         SoundManagerOld.registerSound(new BrainSoundOld(param1,this.unPackAsset(param1,true),_loc3_));
      }
      
      private function handleCurtainToggle(param1:Event) : void
      {
         SoundManagerOld.playSound("bath_curtainopen");
      }
      
      private function initVideo() : void
      {
         videoFrameLoPoly = new LowPolyVideo(unPackAsset("FrameDuckAnim"),68,48);
         videoFrameLoPoly.rotationY = 165;
         videoFrameLoPoly.addEventListener(LowPolyVideo.DIRTY,handleLowPolyVideoDirty);
         positionDO3D(videoFrameLoPoly,202,195,-212);
      }
      
      override public function transitionProgressOut(param1:Number) : void
      {
         super.transitionProgressOut(param1);
         if(param1 < 0.5 && transObjSet.length == 0)
         {
            transObjSet = transOutOmitSet;
            dispatchEvent(new BrainEvent(BigAndSmallEventType.REFRESH_LIVEDISPLAYOBJECTS));
         }
      }
      
      private function handleBubbleCloneBirth(param1:BubbleEvent) : void
      {
         var _loc2_:Vertex3DInstance = param1.bubble.vertex3D.vertex3DInstance;
         var _loc3_:Number = (_loc2_.x + basicView.viewport.viewportWidth >> 1) / basicView.viewport.viewportWidth;
         SoundManagerOld.playSound("BubblePop",new SoundInfoOld(param1.bubble.targetSize * 0.9,_loc3_));
      }
      
      private function initScene() : void
      {
         registerLiveDO3D(DO3DDefinitions.BATHROOM_ROOM,roomDAE);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_CONTENT,roomContentDAE);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_BEDROOMDOOR,toBedroomDoor);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_WINDOW,bathroomWindow);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_TOOTHBRUSHCUP,toothBrushes);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_FISH,fishPlane);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_SHOWERCURTAIN,showerCurtain);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_BUBBLES,bubbleManager);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_BUBBLEBATHBOTTLE,bubbleBathBottle);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_TOBEDROOM,toBedroomSprite);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_FROGS,bathFrogs);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_LOPOLYVIDEOFRAME,videoFrameLoPoly);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_BATHTAPS,bathTaps);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_SINKTAPS,sinkTaps);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_SINKHANDLELEFT,sinkHandleLeft);
         registerLiveDO3D(DO3DDefinitions.BATHROOM_SINKHANDLERIGHT,sinkHandleRight);
         initLayers();
         initButtons();
      }
      
      private function setArrowPositions(param1:String) : void
      {
         if(!toBedroomSprite)
         {
            return;
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            toBedroomSprite.size = 0.8;
            toBedroomMat.movie = toBedroomMovBig;
            positionDO3D(toBedroomSprite,290,150,30);
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            toBedroomSprite.size = 0.8;
            toBedroomMat.movie = toBedroomMovSmall;
            positionDO3D(toBedroomSprite,300,90,30);
         }
      }
      
      override public function transitionProgressIn(param1:Number) : void
      {
         super.transitionProgressIn(param1);
         if(param1 < 0.5)
         {
            bthDoorKnobPSprite.visible = false;
         }
         else
         {
            bthDoorKnobPSprite.visible = true;
         }
      }
      
      private function handleToBedroomDoorOver(param1:MouseEvent) : void
      {
         toBedroomDoor.setDoorModelOverState(true);
         if(this._isActive)
         {
            showArrow(toBedroomSprite,true);
         }
      }
      
      private function handleDoorAnimShut(param1:Event) : void
      {
         SoundManagerOld.playSound("hf_door_close");
      }
      
      private function handleToothbrushVoxTimer(param1:TimerEvent) : void
      {
         allowToothbrushVox = true;
      }
      
      private function initFish() : void
      {
         fishPlane = new ToiletFishPointSprite("FishPlane",unPackAsset("fishSMALL"),unPackAsset("fishBIG"),"bath_toiletrollover");
         fishPlane.rotationY = 170;
         positionDO3D(fishPlane,70,130,-170);
      }
      
      private function handleFrogAnimEnd(param1:Event) : void
      {
         voxEnabled = true;
      }
      
      private function initShowerCurtain() : void
      {
         var _loc1_:MovieClip = unPackAsset("ShowerCurtainClosed");
         var _loc2_:MovieClip = unPackAsset("ShowerCurtainOpen");
         showerCurtain = new ShowerCurtain(_loc1_,_loc2_,350,205,7,6);
         showerCurtain.rotationY = 72;
         positionDO3D(showerCurtain,-162,319,106);
         showerCurtain.addEventListener("TOGGLE",handleCurtainToggle);
         showerCurtain.addEventListener("OPEN",handleCurtainOpen);
      }
      
      private function doorDAELoaded(param1:IAssetLoader) : void
      {
         bthDoorDAE = DAEFixed(param1.getContent());
         bthDoorDAE.scale = 25;
         bthDoorDAE.rotationY = 180;
         toBedroomDoor = new Door3D(bthDoorDAE);
         toBedroomDoor.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         toBedroomDoor.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         toBedroomDoor.defaultRotY = 180;
         toBedroomDoor.rotYOnOver = 195;
         toBedroomDoor.rotYOnOpen = 270;
         positionDO3D(toBedroomDoor,260,0,230);
      }
      
      private function handleVideoFrameClick(param1:Event) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BATHROOM_VIDEO_A);
      }
      
      private function mirrorImageDefault() : void
      {
         if(!mirror)
         {
            return;
         }
         mirror.useDefaultData();
      }
      
      private function registerSounds() : void
      {
         quickRegisterSound("bath_curtainopen");
         quickRegisterSound("bath_curtainrollover");
         quickRegisterSound("bath_toiletrollover");
         quickRegisterSound("bath_bubblerollover");
         quickRegisterSound("bath_bubblesemitted");
         quickRegisterSound("bubble_pop_1");
         quickRegisterSound("bubble_pop_2");
         quickRegisterSound("bubble_pop_3");
         quickRegisterSound("bath_toothbrushrollover_2");
         quickRegisterCollection("BubblePop",["bath_bubblepop1","bath_bubblepop2","bath_bubblepop3"]);
         quickRegisterSound(bigEntryVox,1);
         quickRegisterSound(smallEntryVox,1);
         quickRegisterCollection(bigVoxTimeouts,["bath_big_wonderwhatsgoingon","bath_big_hasanyoneseen","bath_big_letsgetsmallsteethbrushed"],1);
         quickRegisterCollection(smallVoxTimeouts,["bath_small_ibeticanget","bath_small_oowhereisthatfishhiding","bath_small_whatsgoingoninthebath"],1);
         quickRegisterCollection(bigVoxBubbleOver,["bath_big_ijustlovebubbles","bath_big_thatsbubbleriffic"],1);
         quickRegisterCollection(smallVoxBubbleOver,["bath_small_yayilovebubbles","bath_small_yaybubblepopping"],1);
         quickRegisterCollection(bigToothbrushesOver,["bath_big_letsbrushourteeth","bath_big_letsgetsmallsteethbrushed"],1);
         quickRegisterCollection(smallToothbrushesOver,["bath_small_ibeticanget"],1);
      }
      
      private function handleBubbleOver(param1:Event) : void
      {
         if(allowBubbleVox && voxEnabled)
         {
            allowBubbleVox = false;
            SoundManagerOld.playSound(voxBubbleOver);
            bubbleVoxTimer.reset();
            bubbleVoxTimer.start();
         }
      }
      
      private function buildMirrorSnapshots() : void
      {
         var _loc1_:Matrix = new Matrix();
         _loc1_.scale(-1,1);
         _loc1_.translate(basicView.viewport.viewportWidth,0);
         var _loc2_:BitmapData = new BitmapData(basicView.viewport.viewportWidth,basicView.viewport.viewportHeight,true);
         bigCam.updatePosition(0.5,0.5,1);
         basicView.renderer.renderScene(basicView.scene,bigCam as CameraObject3D,basicView.viewport);
         _loc2_.draw(basicView.viewport,_loc1_);
         var _loc3_:BitmapData = new BitmapData(basicView.viewport.viewportWidth,basicView.viewport.viewportHeight,true);
         smallCam.updatePosition(0.5,0.5,1);
         basicView.renderer.renderScene(basicView.scene,smallCam as CameraObject3D,basicView.viewport);
         _loc3_.draw(basicView.viewport,_loc1_);
         basicView.singleRender();
         mirror.registerLabelledData("BATHROOM_" + CharacterDefinitions.BIG,_loc2_,-7.75,-2.25,7);
         mirror.registerLabelledData("BATHROOM_" + CharacterDefinitions.SMALL,_loc3_,-6.75,-8.75,5.5);
         builtMirrorSnapshots = true;
         mirror.selectLabelledData("BATHROOM_" + currentPOV,true);
      }
      
      private function removeArrow(param1:PointSprite) : void
      {
         param1.visible = false;
         SpriteParticleMaterial(param1.material).removeSprite();
      }
      
      override public function park() : void
      {
         super.park();
         transObjSet = [];
         toBedroomDoor.closeDoor(true);
         bathFrogs.snapShut();
      }
      
      private function handleToBedroomDoorOut(param1:MouseEvent) : void
      {
         toBedroomDoor.setDoorModelOverState(false);
         showArrow(toBedroomSprite,false);
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
         sinkLayer.tabEnabled = param1;
         bathLayer.tabEnabled = param1;
         toiletLayer.tabEnabled = param1;
         videoLoPolyLayer.tabEnabled = param1;
         bedroomDoorLayer.tabEnabled = param1;
         bubbleBathLayer.tabEnabled = param1;
      }
   }
}

