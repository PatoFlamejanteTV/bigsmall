package net.pluginmedia.bigandsmall.pages
{
   import com.as3dmod.ModifierStack;
   import com.as3dmod.modifiers.Bend;
   import com.as3dmod.plugins.pv3d.LibraryPv3d;
   import com.as3dmod.util.ModConstant;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.ScreenDepthDefinitions;
   import net.pluginmedia.bigandsmall.definitions.VPortLayerDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.livingroom.CompDiscardedPaperPlane;
   import net.pluginmedia.bigandsmall.pages.livingroom.DiscardedPaperPlane;
   import net.pluginmedia.bigandsmall.pages.livingroom.characters.BigWateringPlant;
   import net.pluginmedia.bigandsmall.pages.livingroom.characters.CompanionCharacter;
   import net.pluginmedia.bigandsmall.pages.livingroom.characters.SmallRunLivingRoom;
   import net.pluginmedia.bigandsmall.pages.livingroom.incidentals.DancingRadio;
   import net.pluginmedia.bigandsmall.pages.livingroom.incidentals.HouseFlower;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.DoorEvent;
   import net.pluginmedia.bigandsmall.pages.shared.LowPolyVideoManager;
   import net.pluginmedia.bigandsmall.pages.shared.PerspectiveWindowPlane;
   import net.pluginmedia.bigandsmall.ui.StateablePointSpriteButton;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.bigandsmall.ui.VPortLayerComponent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.events.BrainSoundStopEvent;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.materials.WindowMaterial;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.ColorMaterial;
   import org.papervision3d.materials.special.ParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   import org.papervision3d.view.layer.util.ViewportLayerSortMode;
   
   public class LivingRoom extends BigAndSmallPage3D
   {
      
      private var rightTableFlower:HouseFlower;
      
      private var radioLayer:ViewportLayer;
      
      private var backTableCompLayer:ViewportLayer;
      
      private var stairsButton:VPortLayerComponent;
      
      private var radioTableCompLayer:ViewportLayer;
      
      private var clickVoxRotations:Dictionary;
      
      private var stairs:DisplayObject3D;
      
      public const INTRO:String = "Intro";
      
      private var lowPolyManager:LowPolyVideoManager;
      
      private var smallCharLayer:ViewportLayer;
      
      public const FLOWERS_RIGHT:String = "HouseFlowersRight";
      
      private var ceilingPlaneLyr:ViewportLayer;
      
      private var toLandingSprPosBig:Number3D;
      
      private var bigChar:BigWateringPlant;
      
      private var toUpstairsVPLayer:ViewportLayer;
      
      private var bigCharLayer:ViewportLayer;
      
      private var furnitureLayer:ViewportLayer;
      
      private var greenBFlyAnim:MovieClip;
      
      private var fishAnim:MovieClip;
      
      private var livingRoomWindowA:PerspectiveWindowPlane;
      
      public const FLOWERS_LEFT:String = "HouseFlowersLeft";
      
      private var companionChar:CompanionCharacter;
      
      private var gardenDoorButton:VPortLayerComponent;
      
      private var gardenDoorKnob:PointSprite;
      
      private var toLandingMat:SpriteParticleMaterial;
      
      private var orangeBFlyAnim:MovieClip;
      
      private var voxable:Boolean = true;
      
      private var gardenDoorWindowPlane:Plane;
      
      public const ROLLOVER:String = "_rollover";
      
      private var videoAccessors:Array;
      
      private var room:DAEFixed;
      
      private var soundLib:AssetLoader;
      
      private var toLandingSprHRect:Rectangle = null;
      
      private var gardenDoorDAE:DAEFixed;
      
      private var blueFlowerAnim:MovieClip;
      
      private var smallChar:SmallRunLivingRoom;
      
      private var toLandingSprHRectBig:Rectangle;
      
      private var voxEnableTimer:Timer;
      
      private var gardenDoorWindowVert:Vertex3D;
      
      public const PIANO:String = "Piano";
      
      private var toLandingSprPosSmall:Number3D;
      
      private var bandGameAccessor:VPortLayerButton;
      
      private var leftTableFlowerLayer:ViewportLayer;
      
      public const PICTURES:String = "Pictures";
      
      private var roomLayer:ViewportLayer;
      
      public const TIMEOUT:String = "Timeout";
      
      private var leftTableFlower:HouseFlower;
      
      private var rightTableFlowerLayer:ViewportLayer;
      
      private var comingSoonVisible:Boolean = false;
      
      public const GARDENDOOR:String = "GardenDoor";
      
      private var oldPaperPlaneComp:CompDiscardedPaperPlane;
      
      public const CLICK:String = "_click";
      
      private var gardenDoor:Door3D;
      
      private var pianoLayer:ViewportLayer;
      
      private var toyBox:DAEFixed;
      
      private var gardenDoorLayer:ViewportLayer;
      
      private var drawingGameAccessor:VPortLayerButton;
      
      private var ceilingPlane:Plane;
      
      public const TOYBOX:String = "Toybox";
      
      private var toLandingPointSprite:PointSprite;
      
      private var toyBoxLayer:ViewportLayer;
      
      private var toGardenPointSprite:StateablePointSpriteButton;
      
      private var toLandingSprHRectSmall:Rectangle;
      
      public const RADIO:String = "Radio";
      
      private var purpleFlowerAnim:MovieClip;
      
      private var redEggsAnim:MovieClip;
      
      private var furniture:DAEFixed;
      
      private var radio:DancingRadio;
      
      public function LivingRoom(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:OrbitCamera3D = null;
         toLandingSprHRectBig = new Rectangle(690,0,78,250);
         toLandingSprHRectSmall = new Rectangle(690,0,78,150);
         toLandingSprPosBig = new Number3D(310,245,125);
         toLandingSprPosSmall = new Number3D(300,245,100);
         voxEnableTimer = new Timer(90000);
         clickVoxRotations = new Dictionary();
         _loc4_ = new OrbitCamera3D(44);
         _loc4_.rotationYMin = -45;
         _loc4_.rotationYMax = 30;
         _loc4_.radius = 352;
         _loc4_.rotationXMin = 0;
         _loc4_.rotationXMax = -2;
         _loc4_.orbitCentre.x = -30;
         _loc4_.orbitCentre.y = 80;
         _loc4_.orbitCentre.z = 64;
         var _loc5_:OrbitCamera3D = new OrbitCamera3D(44);
         _loc5_.rotationYMin = -9.88;
         _loc5_.rotationYMax = 10;
         _loc5_.radius = 204;
         _loc5_.rotationXMin = 12.25;
         _loc5_.rotationXMax = 18.25;
         _loc5_.orbitCentre.x = -30;
         _loc5_.orbitCentre.y = 182;
         _loc5_.orbitCentre.z = 64 - 200;
         var _loc6_:Number3D = new Number3D(0,0,0);
         super(param1,_loc6_,_loc5_,_loc4_,param2);
         lowPolyManager = new LowPolyVideoManager(this);
      }
      
      private function handleComingSoonClick(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LANDING);
      }
      
      private function handlePianoClick(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_BANDGAME);
      }
      
      private function initRoom() : void
      {
         roomLayer = basicView.viewport.getChildLayer(room,true,true);
         roomLayer.screenDepth = ScreenDepthDefinitions.LIVINGROOM_ROOM;
         roomLayer.forceDepth = true;
         var _loc1_:DisplayObject3D = room.getChildByName("COLLADA_Scene").getChildByName("Room");
         var _loc2_:ViewportLayer = roomLayer.getChildLayer(_loc1_.getChildByName("StairPost1"));
         _loc2_.addDisplayObject3D(_loc1_.getChildByName("StairsWall2"));
         _loc2_.addDisplayObject3D(_loc1_.getChildByName("Stairs3"));
         stairsButton = new VPortLayerComponent(_loc2_);
         stairsButton.addEventListener(MouseEvent.CLICK,handleComingSoonClick);
         stairsButton.addEventListener(MouseEvent.ROLL_OUT,handleStairsOut);
         stairsButton.addEventListener(MouseEvent.ROLL_OVER,handleStairsOver);
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      private function handlePianoRollOver(param1:MouseEvent) : void
      {
         doCharacterVox(PIANO + ROLLOVER);
      }
      
      private function makeInteractive(param1:Sprite, param2:Function = null, param3:Function = null, param4:Function = null) : void
      {
         if(param2 !== null)
         {
            param1.addEventListener(MouseEvent.CLICK,param2);
         }
         if(param3 !== null)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,param3);
         }
         if(param4 !== null)
         {
            param1.addEventListener(MouseEvent.MOUSE_OUT,param4);
         }
         param1.buttonMode = true;
         param1.mouseChildren = false;
      }
      
      private function initToGardenArrow() : void
      {
         toGardenPointSprite = new StateablePointSpriteButton();
         toGardenPointSprite.registerState(CharacterDefinitions.BIG,unPackAsset("ToGardenBig"),-245,250,80,0.6);
         toGardenPointSprite.registerState(CharacterDefinitions.SMALL,unPackAsset("ToGardenSmall"),-245,250,80,0.6);
         toGardenPointSprite.viewportLayer = basicView.viewport.getChildLayer(toGardenPointSprite,true);
         toGardenPointSprite.addEventListener(MouseEvent.CLICK,handleToGardenClicked);
         toGardenPointSprite.addEventListener(MouseEvent.ROLL_OVER,handleToGardenOver);
         toGardenPointSprite.addEventListener(MouseEvent.ROLL_OUT,handleToGardenOut);
         toGardenPointSprite.selectState(currentPOV);
         toGardenPointSprite.setAlpha(0);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_TOGARDEN,toGardenPointSprite);
      }
      
      private function debugUpdateObjectLocation(param1:*, param2:Number = 1) : void
      {
         var _loc3_:Boolean = false;
         if(KeyUtils.isDown(Keyboard.LEFT))
         {
            param1.x -= param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.RIGHT))
         {
            param1.x += param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.UP))
         {
            param1.y += param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.DOWN))
         {
            param1.y -= param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_0))
         {
            param1.z += param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_1))
         {
            param1.z -= param2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_9))
         {
            param1.rotationY += param2 / 2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_8))
         {
            param1.rotationY -= param2 / 2;
            _loc3_ = true;
         }
         if(KeyUtils.isDown(Keyboard.SPACE))
         {
            if(!param1)
            {
               return;
            }
            trace("pos:",param1.x,param1.y,param1.z);
            if(param1.hasOwnProperty("rotationY"))
            {
               trace("rotationY:",param1.rotationY);
            }
         }
      }
      
      private function handleSmallTweenProgress(param1:Event) : void
      {
         flagDirtyLayer(smallCharLayer);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("LivingRoom.daeFurniture",DAELocations.livingRoomFurniture,receivedFurniture);
         dispatchAssetRequest("LivingRoom.daeRoom",DAELocations.livingRoom,receivedRoom);
         dispatchAssetRequest("LivingRoom.daeGardenDoor",DAELocations.livingRoomGardenDoor,receivedGardenDoor);
         dispatchAssetRequest("LivingRoom.daeToyBox",DAELocations.livingRoomToyBox,receivedToyBox);
         dispatchAssetRequest("LivingRoom.LIB_COMMON",SWFLocations.livingRoomLibraryCommon,assetLibLoaded);
         dispatchAssetRequest("LivingRoom.LIB_BIG",SWFLocations.livingRoomLibraryBig,assetLibLoaded);
         dispatchAssetRequest("LivingRoom.LIB_SMALL",SWFLocations.livingRoomLibrarySmall,assetLibLoaded);
         dispatchAssetRequest("LivingRoom.LIB_RADIO",SWFLocations.livingRoomRadio,receivedRadioAssets);
         dispatchAssetRequest("LivingRoom.VOX_BIG",SWFLocations.livingRoomVoxBig,assetLibLoaded);
         dispatchAssetRequest("LivingRoom.VOX_SMALL",SWFLocations.livingRoomVoxSmall,assetLibLoaded);
         dispatchAssetRequest("LivingRoom.LIB_VIDFRAMES",SWFLocations.livingRoomLibraryVideoFrames,lowPolyFramesLoaded);
      }
      
      private function receivedGardenDoor(param1:IAssetLoader) : void
      {
         gardenDoorDAE = DAEFixed(param1.getContent());
         gardenDoorDAE.scale = 25;
      }
      
      private function handleRadioStarted(param1:Event) : void
      {
         doCharacterVox(radio.label + CLICK);
      }
      
      private function handleToGardenClicked(param1:MouseEvent) : void
      {
         handleDoorClicked(param1);
      }
      
      private function receivedRoom(param1:IAssetLoader) : void
      {
         room = DAEFixed(param1.getContent());
         room.scale = 25;
         room.rotationY = 180;
      }
      
      private function initIncidentals() : void
      {
         leftTableFlower = new HouseFlower(FLOWERS_LEFT);
         leftTableFlower.setContent(unPackAsset("HousePlantWholeBIG"),unPackAsset("HousePlantWholeSMALL"));
         leftTableFlower.x = -260;
         leftTableFlower.y = 95;
         leftTableFlower.z = 170;
         leftTableFlower.scale = 0.45;
         rightTableFlower = new HouseFlower(FLOWERS_RIGHT);
         rightTableFlower.setContent(unPackAsset("BigsFlowerBIG"),unPackAsset("BigsFlowerSMALL"));
         rightTableFlower.x = 215;
         rightTableFlower.y = 63;
         rightTableFlower.z = 55;
         rightTableFlower.scale = 0.45;
         leftTableFlowerLayer = basicView.viewport.getChildLayer(leftTableFlower,true,true);
         dispatchShareable("LivingRoom.leftTableFlowerLayer",leftTableFlowerLayer);
         AccessibilityManager.addAccessibilityProperties(leftTableFlowerLayer,"House plant","Interactive houseplant",AccessibilityDefinitions.LIVINGROOM_INCIDENTAL);
         addIncidental(leftTableFlower,leftTableFlowerLayer);
      }
      
      override protected function build() : void
      {
         oldPaperPlaneComp = new CompDiscardedPaperPlane(0,0,0);
         oldPaperPlaneComp.name = "oldPaperLayer";
         var _loc1_:BitmapData = null;
         var _loc2_:DiscardedPaperPlane = new DiscardedPaperPlane(65280,150,90,4,6,80,80);
         _loc2_.rotationX = 90;
         _loc2_.x = -40;
         _loc2_.y = 0;
         _loc2_.z = -90;
         var _loc3_:ModifierStack = new ModifierStack(new LibraryPv3d(),_loc2_);
         var _loc4_:Bend = new Bend(2,0.65);
         _loc4_.bendAxis = ModConstant.Y;
         _loc4_.constraint = ModConstant.LEFT;
         _loc3_.addModifier(_loc4_);
         _loc3_.apply();
         var _loc5_:DiscardedPaperPlane = new DiscardedPaperPlane(255,155,130,1,1,80,80);
         _loc5_.rotationX = 90;
         _loc5_.rotationY = 90;
         _loc5_.x = 140;
         _loc5_.y = 0;
         _loc5_.z = 40;
         _loc5_.colourTrans = new ColorTransform(1,1,1,1,-50,-50,-50);
         oldPaperPlaneComp.registerDPPlane(_loc2_);
         oldPaperPlaneComp.registerDPPlane(_loc5_);
      }
      
      public function showComingSoon(param1:Boolean) : void
      {
         if(comingSoonVisible == param1)
         {
            return;
         }
         if(param1)
         {
            toLandingPointSprite.visible = true;
            TweenMax.to(toLandingMat.movie,0.25,{"alpha":1});
         }
         else
         {
            TweenMax.to(toLandingMat.movie,0.25,{
               "alpha":0,
               "onComplete":removeComingSoon
            });
         }
         comingSoonVisible = param1;
      }
      
      override public function deactivate() : void
      {
         var _loc1_:VPortLayerButton = null;
         super.deactivate();
         lowPolyManager.deactivate();
         bandGameAccessor.setEnabledState(false);
         drawingGameAccessor.setEnabledState(false);
         for each(_loc1_ in videoAccessors)
         {
            _loc1_.setEnabledState(false);
         }
         showComingSoon(false);
         voxEnableTimer.reset();
         voxEnableTimer.stop();
         SoundManagerOld.stopSoundChannel(1);
         companionChar.deactivate();
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         stairsButton.setEnabledState(false);
         gardenDoorButton.setEnabledState(false);
         toGardenPointSprite.deactivate();
      }
      
      private function handleStairsOver(param1:MouseEvent) : void
      {
         showComingSoon(true);
      }
      
      private function initSounds() : void
      {
         SoundManagerOld.addSound("lr_plant_watering",unPackAsset("lr_plant_watering"));
      }
      
      private function handleDoorAnimProgress(param1:Event) : void
      {
         this.flagDirtyLayer(gardenDoorLayer);
      }
      
      private function setUpToyBoxLayers() : void
      {
         toyBoxLayer = basicView.viewport.getChildLayer(toyBox,true,true);
         this.dispatchShareable(VPortLayerDefinitions.LIVINGROOM_VPLAYER_TOYBOX,toyBoxLayer);
         var _loc1_:ViewportLayer = null;
         var _loc2_:DisplayObject3D = toyBox.getChildByName("PaintPot1",true);
         _loc1_ = toyBoxLayer.getChildLayer(_loc2_,true,true);
         var _loc3_:DisplayObject3D = toyBox.getChildByName("Blocks1",true);
         var _loc4_:DisplayObject3D = toyBox.getChildByName("Block2",true);
         var _loc5_:ViewportLayer = toyBoxLayer.getChildLayer(_loc3_,true,true);
         var _loc6_:ViewportLayer = toyBoxLayer.getChildLayer(_loc4_,true,true);
         toyBoxLayer.removeLayer(_loc5_);
         toyBoxLayer.removeLayer(_loc6_);
         basicView.viewport.getChildLayer(_loc3_,true,true);
         basicView.viewport.getChildLayer(_loc4_,true,true);
         drawingGameAccessor = new VPortLayerButton(toyBoxLayer);
         AccessibilityManager.addAccessibilityProperties(toyBoxLayer,"Toybox","Play the drawing game",AccessibilityDefinitions.LIVINGROOM_ACCESSOR);
         drawingGameAccessor.addEventListener(MouseEvent.CLICK,handleToyBoxClick);
         drawingGameAccessor.addEventListener(MouseEvent.MOUSE_OVER,handleToyBoxRollOver);
      }
      
      private function handleCharClicked(param1:MouseEvent) : void
      {
         if(!voxable)
         {
            return;
         }
         var _loc2_:String = null;
         var _loc3_:Array = clickVoxRotations[currentPOV];
         if(_loc3_ === null)
         {
            BrainLogger.warning("LivingRoom :: handleCharClicked :: could not find rotation array in dict.");
         }
         _loc2_ = _loc3_.shift();
         if(_loc2_ == "UNSUMMON" && !SoundManagerOld.channelOccupied(1))
         {
            smallChar.unSummon();
         }
         else
         {
            companionChar.playVoiceOver(_loc2_,false,true);
         }
         _loc3_.push(_loc2_);
         BrainLogger.highlight("voxrotation modified :: ",_loc3_);
      }
      
      private function initGardenDoor() : void
      {
         gardenDoor = new Door3D(gardenDoorDAE);
         positionDO3D(gardenDoor,-309.5,0,-27.5);
         gardenDoor.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         gardenDoor.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         gardenDoor.addEventListener(Door3D.EV_ANIM_PROGRESS,handleDoorAnimProgress);
         gardenDoor.rotationY = 180;
         var _loc1_:ParticleMaterial = new SpriteParticleMaterial(unPackAsset("DoorKnob"));
         gardenDoorKnob = new PointSprite(_loc1_,0.135);
         positionDO3D(gardenDoorKnob,-0.36,5.35,-5.4);
         gardenDoorDAE.addChild(gardenDoorKnob);
         gardenDoorLayer = new ViewportLayer(basicView.viewport,null);
         roomLayer.addLayer(gardenDoorLayer);
         gardenDoorLayer.sortMode = ViewportLayerSortMode.INDEX_SORT;
         var _loc2_:ViewportLayer = gardenDoorLayer.getChildLayer(gardenDoor,true,true);
         _loc2_.layerIndex = 1;
         gardenDoorButton = new VPortLayerComponent(gardenDoorLayer);
         gardenDoorButton.addEventListener(MouseEvent.CLICK,handleDoorClicked);
         gardenDoorButton.addEventListener(MouseEvent.ROLL_OVER,handleDoorOver);
         gardenDoorButton.addEventListener(MouseEvent.ROLL_OUT,handleDoorOut);
         AccessibilityManager.addAccessibilityProperties(gardenDoorLayer,"Garden Door","Enter the Garden",AccessibilityDefinitions.LIVINGROOM_ACCESSOR);
         var _loc3_:DisplayObject = unPackAsset("GardenWindow");
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height);
         var _loc5_:Rectangle = _loc3_.getBounds(_loc3_);
         var _loc6_:Matrix = new Matrix();
         _loc6_.translate(-_loc5_.left,-_loc5_.top);
         _loc4_.draw(_loc3_,_loc6_,new ColorTransform(1.1,1.1,1.1));
         _loc4_.applyFilter(_loc4_,_loc4_.rect,new Point(),new BlurFilter(2,4));
         var _loc7_:WindowMaterial = new WindowMaterial(_loc4_,2);
         gardenDoorWindowPlane = new Plane(_loc7_,110,100,1,1);
         gardenDoorWindowPlane.x = -2;
         gardenDoorWindowPlane.y = 196;
         gardenDoorWindowPlane.z = -78;
         gardenDoorWindowVert = new Vertex3D();
         _loc7_.setDistanceVertex(gardenDoorWindowVert);
         gardenDoorWindowPlane.rotationY = 90;
         gardenDoorWindowPlane.geometry.vertices.push(gardenDoorWindowVert);
         gardenDoorWindowPlane.geometry.ready = true;
         gardenDoorWindowPlane.geometry.dirty = true;
         gardenDoor.addChild(gardenDoorWindowPlane);
         var _loc8_:ViewportLayer = gardenDoorLayer.getChildLayer(gardenDoorWindowPlane,true,true);
         _loc8_.layerIndex = 0;
      }
      
      override protected function handleIncidentalRollover(param1:MouseEvent) : Incidental
      {
         var _loc2_:Incidental = super.handleIncidentalRollover(param1);
         if(_loc2_.active && voxable)
         {
            companionChar.playVoiceOver(_loc2_.label + ROLLOVER);
         }
         return _loc2_;
      }
      
      private function handleToyBoxClick(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_DRAWINGGAME);
      }
      
      private function receivedRadioAssets(param1:IAssetLoader) : void
      {
         var _loc2_:AssetLoader = param1 as AssetLoader;
         radio = new DancingRadio(RADIO);
         radio.setContent(_loc2_);
         radio.addEventListener("animationProgress",handleRadioDanceProgress);
         radio.addEventListener("radioStarted",handleRadioStarted);
         radio.x = 175;
         radio.y = 95.5;
         radio.z = -27;
         radio.rotationY = 53;
         radioLayer = basicView.viewport.getChildLayer(radio,true,true);
         AccessibilityManager.addAccessibilityProperties(radioLayer,"Radio","Interactive radio",AccessibilityDefinitions.LIVINGROOM_INCIDENTAL);
         addIncidental(radio,radioLayer);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(DO3DDefinitions.DRAWINGGAME_PAPER);
         return _loc1_.concat(this._do3dList);
      }
      
      private function listChildren(param1:DisplayObject3D, param2:Number = 0) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:DisplayObject3D = null;
         for(_loc3_ in param1.children)
         {
            _loc4_ = param1.children[_loc3_];
            if(_loc4_.numChildren > 0)
            {
               listChildren(_loc4_,param2 + 1);
            }
            else
            {
               BrainLogger.highlight("do3d child " + _loc3_ + " = " + _loc4_.children[_loc3_]);
            }
         }
      }
      
      private function receivedToyBox(param1:IAssetLoader) : void
      {
         toyBox = DAEFixed(param1.getContent());
         toyBox.scale = 25;
         toyBox.rotationY = 180;
      }
      
      private function initCeilingPlane() : void
      {
         ceilingPlane = new Plane(new ColorMaterial(11707522),700,130);
         ceilingPlane.rotationX = -90;
         ceilingPlane.x = 40;
         ceilingPlane.y = 352;
         ceilingPlane.z = 185;
         ceilingPlaneLyr = roomLayer.getChildLayer(ceilingPlane,true);
         this.registerLiveDO3D(DO3DDefinitions.LIVINGROOM_CEILINGPLANE,ceilingPlane);
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         super.update(param1);
         if(basicView.stage.mouseX >= toLandingSprHRect.x && basicView.stage.mouseX <= toLandingSprHRect.x + toLandingSprHRect.width && basicView.stage.mouseY >= toLandingSprHRect.y && basicView.stage.mouseY <= toLandingSprHRect.y + toLandingSprHRect.height)
         {
            showComingSoon(true);
         }
         else
         {
            showComingSoon(false);
         }
      }
      
      private function initComingSoon() : void
      {
         toLandingMat = new SpriteParticleMaterial(unPackAsset("ComingSoonMat"));
         toLandingMat.smooth = true;
         toLandingPointSprite = new PointSprite(toLandingMat);
         toLandingPointSprite.size = 0.4;
         toLandingPointSprite.visible = false;
         toLandingMat.removeSprite();
         toUpstairsVPLayer = roomLayer.getChildLayer(room.getChildByName("StairsWall2",true),true);
         AccessibilityManager.addAccessibilityProperties(toUpstairsVPLayer,"Upstairs","To the Bedroom",AccessibilityDefinitions.LIVINGROOM_ACCESSOR);
         var _loc1_:ViewportLayer = toUpstairsVPLayer.getChildLayer(toLandingPointSprite,true);
         toUpstairsVPLayer.addEventListener(MouseEvent.CLICK,handleComingSoonClick);
         toUpstairsVPLayer.buttonMode = true;
      }
      
      override public function setCharacter(param1:String) : void
      {
         var _loc2_:CompanionCharacter = null;
         super.setCharacter(param1);
         if(smallChar === null || bigChar === null)
         {
            return;
         }
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            _loc2_ = bigChar;
         }
         else
         {
            _loc2_ = smallChar;
         }
         if(currentPOV == CharacterDefinitions.BIG)
         {
            toLandingSprHRect = toLandingSprHRectBig;
            toLandingPointSprite.x = toLandingSprPosBig.x;
            toLandingPointSprite.y = toLandingSprPosBig.y;
            toLandingPointSprite.z = toLandingSprPosBig.z;
            MovieClip(toLandingMat.movie).gotoAndStop("small");
            if(this.isLive)
            {
               bigCharLayer.tabEnabled = false;
               smallCharLayer.tabEnabled = true;
            }
         }
         else
         {
            toLandingSprHRect = toLandingSprHRectSmall;
            toLandingPointSprite.x = toLandingSprPosSmall.x;
            toLandingPointSprite.y = toLandingSprPosSmall.y;
            toLandingPointSprite.z = toLandingSprPosSmall.z;
            MovieClip(toLandingMat.movie).gotoAndStop("big");
            if(this.isLive)
            {
               smallCharLayer.tabEnabled = false;
               bigCharLayer.tabEnabled = true;
            }
         }
         setGardenDoorWindowVertToLoc(param1);
         if(Boolean(companionChar) && isActive)
         {
            companionChar.deactivate();
         }
         if(Boolean(companionChar) && isTransitionReady)
         {
            companionChar.park();
            companionChar.visible = false;
         }
         if(Boolean(_loc2_) && isTransitionReady)
         {
            _loc2_.visible = true;
            _loc2_.prepare();
         }
         if(Boolean(_loc2_) && isActive)
         {
            _loc2_.activate();
            _loc2_.visible = true;
         }
         companionChar = _loc2_;
         voxEnableTimer.reset();
         voxEnableTimer.start();
         companionChar.refreshPlayableLabels();
         if(toGardenPointSprite)
         {
            toGardenPointSprite.selectState(param1);
         }
      }
      
      override public function activate() : void
      {
         var _loc1_:VPortLayerButton = null;
         super.activate();
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         lowPolyManager.activate();
         bandGameAccessor.setEnabledState(true);
         drawingGameAccessor.setEnabledState(true);
         for each(_loc1_ in videoAccessors)
         {
            _loc1_.setEnabledState(true);
         }
         if(companionChar)
         {
            companionChar.activate();
            companionChar.refreshPlayableLabels();
         }
         voxEnableTimer.reset();
         voxEnableTimer.start();
         stairsButton.setEnabledState(true);
         if(voxable && companionChar && !companionChar.isTalking)
         {
            companionChar.playVoiceOver(INTRO,true);
         }
         gardenDoorButton.setEnabledState(true);
         toGardenPointSprite.activate();
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         if(companionChar)
         {
            companionChar.prepare();
         }
         broadcast(BigAndSmallEventType.SET_STAGE_COLOUR,null,11707522);
      }
      
      private function receivedFurniture(param1:IAssetLoader) : void
      {
         furniture = DAEFixed(param1.getContent());
         furniture.scale = 25;
         furniture.rotationY = 180;
      }
      
      private function handleRadioDanceProgress(param1:Event) : void
      {
         flagDirtyLayer(radioLayer);
      }
      
      private function doCharacterVox(param1:String) : void
      {
         if(voxable)
         {
            companionChar.playVoiceOver(param1);
            pushBackVoxRotation(param1);
         }
      }
      
      private function handleBigStartWatering(param1:Event) : void
      {
         SoundManagerOld.playSound("lr_plant_watering");
      }
      
      public function removeComingSoon() : void
      {
         toLandingPointSprite.visible = false;
         toLandingMat.removeSprite();
      }
      
      private function handleDoorClicked(param1:MouseEvent) : void
      {
         SoundManagerOld.stopSoundChannel(1);
         SoundManagerOld.stopSoundChannel(3);
         toGardenPointSprite.setAlpha(0);
         gardenDoor.setDoorModelOverState(false);
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.PREGARDEN);
      }
      
      private function initWindows() : void
      {
         var _loc1_:MovieClip = unPackAsset("SkyTexture");
         livingRoomWindowA = new PerspectiveWindowPlane(_loc1_,130,130,-40,255,260,1000,new Number3D(0,0,1));
         var _loc2_:ViewportLayer = basicView.viewport.getChildLayer(livingRoomWindowA,true,true);
         _loc2_.screenDepth = 1001;
         _loc2_.forceDepth = true;
      }
      
      private function handleToGardenOut(param1:MouseEvent) : void
      {
         handleDoorOut(param1);
      }
      
      private function handleStairsOut(param1:MouseEvent) : void
      {
         showComingSoon(false);
      }
      
      private function handleBigStopWatering(param1:Event) : void
      {
         dispatchEvent(new BrainSoundStopEvent(0.25,"lr_plant_watering"));
      }
      
      private function handleVoxEnableTimer(param1:TimerEvent) : void
      {
         BrainLogger.highlight("handleVoxEnableTimer...");
         companionChar.refreshPlayableLabels();
      }
      
      private function handleDoorOut(param1:MouseEvent) : void
      {
         gardenDoor.setDoorModelOverState(false);
         toGardenPointSprite.fadeOut();
      }
      
      private function handleDoorAnimShut(param1:Event) : void
      {
         SoundManagerOld.playSound("hf_door_close");
      }
      
      private function initCharacters() : void
      {
         bigChar = new BigWateringPlant();
         bigChar.parentUnpackAsset = unPackAsset;
         bigChar.setContent(unPackAsset("Big_Char"));
         bigChar.x = 200;
         bigChar.y = 0;
         bigChar.z = 200;
         var _loc1_:MovieClip = unPackAsset("SmallWhole");
         var _loc2_:MovieClip = unPackAsset("SmallWholeSkidTalk");
         var _loc3_:MovieClip = unPackAsset("SmallWholeJumping");
         var _loc4_:MovieClip = unPackAsset("SmallWholeAnticipation");
         var _loc5_:MovieClip = unPackAsset("SmallWholeRunForwardFast");
         smallChar = new SmallRunLivingRoom(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_);
         smallChar.addEventListener("TweenProgress",handleSmallTweenProgress);
         smallChar.enterPosition = new Number3D(-200,0,40);
         smallChar.idlePosition = new Number3D(27,0,100);
         smallChar.exitPosition = new Number3D(102,0,-250);
         smallChar.x = 0;
         smallChar.y = 0;
         smallChar.z = 0;
         smallChar.parentUnpackAsset = unPackAsset;
         bigChar.setVoiceOver(INTRO,"lr_big_intro",null,0,true);
         bigChar.setVoiceOver(RADIO + ROLLOVER,"lr_big_radio_over_first",null,0,true);
         bigChar.setVoiceOver(RADIO + CLICK,"lr_big_radio_reaction",null,1);
         bigChar.setVoiceOver(FLOWERS_LEFT + CLICK,"lr_big_heycareful",null,0,true);
         bigChar.setVoiceOver(FLOWERS_RIGHT + CLICK,"lr_big_heycareful",null,0,true);
         bigChar.setVoiceOver(PIANO + ROLLOVER,"lr_big_doyouwanttoplay",null,0,true);
         bigChar.setVoiceOver(TOYBOX + ROLLOVER,"lr_big_prompt_howbout","big_head_lr_prompt_howbout",0,true);
         bigChar.setVoiceOver(PICTURES + ROLLOVER,"lr_big_whatdoyou","big_head_lr_big_whatdoyou",0,true);
         bigChar.setVoiceOver(GARDENDOOR + "A","lr_bg_thatsthewayto","big_head_lr_thatsthewayto",0,true);
         bigChar.setVoiceOver(GARDENDOOR + "B","lr_bg_haveyouseen","big_head_lr_haveyouseen",0,true);
         bigChar.setVoiceOver(GARDENDOOR + "C","lr_bg_seethatdoor","big_head_lr_seethatdoor",0,true);
         smallChar.setVoiceOver(INTRO,"lr_sml_letsplaylook",null,1);
         smallChar.setVoiceOver(RADIO + ROLLOVER,"lr_sml_radio_over_first",null,0,true);
         smallChar.setVoiceOver(RADIO + CLICK,"lr_sml_radio_canwe",null,1);
         smallChar.setVoiceOver(PIANO + ROLLOVER,"lr_sml_piano_yeah",null,0,true);
         smallChar.setVoiceOver(FLOWERS_LEFT + CLICK,"lr_sml_plant_reaction",null,0,true);
         smallChar.setVoiceOver(FLOWERS_RIGHT + CLICK,"lr_sml_plant_reaction",null,0,true);
         smallChar.setVoiceOver(GARDENDOOR + "A","lr_sm_yahthegardendoor",null,0,true);
         smallChar.setVoiceOver(GARDENDOOR + "B","lr_sm_letsgooutside",null,0,true);
         smallChar.setVoiceOver(GARDENDOOR + "C","lr_sm_adoorgreatyou",null,0,true);
         voxEnableTimer.addEventListener(TimerEvent.TIMER,handleVoxEnableTimer);
         clickVoxRotations[CharacterDefinitions.SMALL] = [GARDENDOOR + "B",PIANO + ROLLOVER,PICTURES + ROLLOVER,TOYBOX + ROLLOVER];
         clickVoxRotations[CharacterDefinitions.BIG] = [GARDENDOOR + "B",RADIO + ROLLOVER,PIANO + ROLLOVER,INTRO,"UNSUMMON"];
         smallCharLayer = this.basicView.viewport.getChildLayer(smallChar,true,true);
         smallCharLayer.addEventListener(MouseEvent.CLICK,handleCharClicked);
         AccessibilityManager.addAccessibilityProperties(smallCharLayer,"Livingroom Small","Small jumping",AccessibilityDefinitions.LIVINGROOM_INCIDENTAL);
         bigCharLayer = this.basicView.viewport.getChildLayer(bigChar,true,true);
         bigCharLayer.addEventListener(MouseEvent.CLICK,handleCharClicked);
         AccessibilityManager.addAccessibilityProperties(bigCharLayer,"Livingroom Big","Big watering a plant",AccessibilityDefinitions.LIVINGROOM_INCIDENTAL);
      }
      
      private function pushBackVoxRotation(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         for each(_loc2_ in clickVoxRotations)
         {
            _loc3_ = int(_loc2_.indexOf(param1));
            if(_loc3_ < 0)
            {
               return;
            }
            _loc4_ = _loc2_[_loc3_];
            _loc2_.splice(_loc3_,1);
            _loc2_.push(_loc4_);
         }
      }
      
      private function setupFurnitureLayers() : void
      {
         var _loc1_:DisplayObject3D = furniture.getChildByName("Chair",true);
         var _loc2_:DisplayObject3D = furniture.getChildByName("Chair1",true);
         var _loc3_:DisplayObject3D = furniture.getChildByName("Piano",true);
         var _loc4_:DisplayObject3D = furniture.getChildByName("BookPile01",true);
         var _loc5_:DisplayObject3D = furniture.getChildByName("BookPile02",true);
         var _loc6_:DisplayObject3D = furniture.getChildByName("BookPile03",true);
         var _loc7_:DisplayObject3D = furniture.getChildByName("Book",true);
         var _loc8_:DisplayObject3D = furniture.getChildByName("Clock01",true);
         var _loc9_:DisplayObject3D = furniture.getChildByName("RadioTable",true);
         var _loc10_:DisplayObject3D = furniture.getChildByName("Table1",true);
         var _loc11_:DisplayObject3D = furniture.getChildByName("TableBook",true);
         var _loc12_:DisplayObject3D = furniture.getChildByName("ChestOfDrawers1",true);
         videoAccessors = new Array();
         var _loc13_:Array = [];
         var _loc14_:DisplayObject3D = furniture.getChildByName("RedEggsFrame",true);
         var _loc15_:DisplayObject3D = furniture.getChildByName("PurpleFlowerFrame",true);
         var _loc16_:DisplayObject3D = furniture.getChildByName("FishFrame",true);
         var _loc17_:DisplayObject3D = furniture.getChildByName("OrangeButterflyFrame",true);
         var _loc18_:DisplayObject3D = furniture.getChildByName("GreenButterflyFrame",true);
         var _loc19_:DisplayObject3D = furniture.getChildByName("BlueFlowerFrame",true);
         lowPolyManager.addFrame(_loc14_,redEggsAnim);
         lowPolyManager.addFrame(_loc15_,purpleFlowerAnim);
         lowPolyManager.addFrame(_loc19_,blueFlowerAnim);
         lowPolyManager.addFrame(_loc18_,greenBFlyAnim);
         lowPolyManager.addFrame(_loc17_,orangeBFlyAnim);
         lowPolyManager.addFrame(_loc16_,fishAnim);
         _loc13_.push(_loc14_);
         _loc13_.push(_loc15_);
         _loc13_.push(_loc16_);
         _loc13_.push(_loc17_);
         _loc13_.push(_loc18_);
         _loc13_.push(_loc19_);
         dispatchShareable("VideoFrame.RedEggs",_loc14_);
         dispatchShareable("VideoFrame.PurpleFlower",_loc15_);
         dispatchShareable("VideoFrame.Fish",_loc16_);
         dispatchShareable("VideoFrame.OrangeBFly",_loc17_);
         dispatchShareable("VideoFrame.GreenBFly",_loc18_);
         dispatchShareable("VideoFrame.BlueFlower",_loc19_);
         var _loc20_:DisplayObject3D = null;
         var _loc21_:VPortLayerButton = null;
         var _loc22_:ViewportLayer = null;
         var _loc23_:int = 0;
         while(_loc23_ < _loc13_.length)
         {
            _loc20_ = _loc13_[_loc23_] as DisplayObject3D;
            if(_loc20_ !== null)
            {
               _loc22_ = roomLayer.getChildLayer(_loc20_,true,true);
               _loc21_ = new VPortLayerButton(_loc22_);
               _loc21_.addEventListener(MouseEvent.CLICK,handleVideoFrameClick);
               _loc21_.addEventListener(MouseEvent.MOUSE_OVER,handleVideoFrameOver);
               AccessibilityManager.addAccessibilityProperties(_loc22_,"Video","Watch a video clip",AccessibilityDefinitions.LIVINGROOM_ACCESSOR);
               videoAccessors.push(_loc21_);
            }
            _loc23_++;
         }
         pianoLayer = basicView.viewport.getChildLayer(_loc3_,true,true);
         pianoLayer.addDisplayObject3D(_loc4_);
         pianoLayer.addDisplayObject3D(_loc5_);
         pianoLayer.addDisplayObject3D(_loc6_);
         pianoLayer.addDisplayObject3D(_loc8_);
         radioTableCompLayer = basicView.viewport.getChildLayer(_loc9_,true,true);
         radioTableCompLayer.addDisplayObject3D(_loc12_);
         rightTableFlowerLayer = basicView.viewport.getChildLayer(rightTableFlower,true,true);
         addIncidental(rightTableFlower,rightTableFlowerLayer);
         AccessibilityManager.addAccessibilityProperties(rightTableFlowerLayer,"House plant","Interactive houseplant",AccessibilityDefinitions.LIVINGROOM_INCIDENTAL);
         var _loc24_:ViewportLayer = null;
         _loc24_ = basicView.viewport.getChildLayer(_loc1_,true,true);
         _loc24_ = basicView.viewport.getChildLayer(_loc2_,true,true);
         backTableCompLayer = basicView.viewport.getChildLayer(_loc10_,true,true);
         backTableCompLayer.addDisplayObject3D(_loc11_);
         bandGameAccessor = new VPortLayerButton(pianoLayer);
         AccessibilityManager.addAccessibilityProperties(pianoLayer,"Piano","Play the band game",AccessibilityDefinitions.LIVINGROOM_ACCESSOR);
         bandGameAccessor.addEventListener(MouseEvent.CLICK,handlePianoClick);
         bandGameAccessor.addEventListener(MouseEvent.MOUSE_OVER,handlePianoRollOver);
      }
      
      private function lowPolyFramesLoaded(param1:IAssetLoader) : void
      {
         fishAnim = AssetLoader(param1).getAssetByName("FishAnim") as MovieClip;
         purpleFlowerAnim = AssetLoader(param1).getAssetByName("PurpleFlowerAnim") as MovieClip;
         blueFlowerAnim = AssetLoader(param1).getAssetByName("BlueFlowerAnim") as MovieClip;
         redEggsAnim = AssetLoader(param1).getAssetByName("RedEggsAnim") as MovieClip;
         greenBFlyAnim = AssetLoader(param1).getAssetByName("GreenBFlyAnim") as MovieClip;
         orangeBFlyAnim = AssetLoader(param1).getAssetByName("OrangeBFlyAnim") as MovieClip;
      }
      
      private function handleVideoFrameClick(param1:MouseEvent) : void
      {
         var _loc2_:VPortLayerButton = param1.target as VPortLayerButton;
         switch(_loc2_)
         {
            case videoAccessors[0]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_E);
               break;
            case videoAccessors[1]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_D);
               break;
            case videoAccessors[2]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_C);
               break;
            case videoAccessors[3]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_B);
               break;
            case videoAccessors[4]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_A);
               break;
            case videoAccessors[5]:
               broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM_VIDEO_F);
         }
      }
      
      private function setGardenDoorWindowVertToLoc(param1:String) : void
      {
         if(!gardenDoorWindowVert)
         {
            return;
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            gardenDoorWindowVert.x = 190;
            gardenDoorWindowVert.y = 96;
            gardenDoorWindowVert.z = 170;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            gardenDoorWindowVert.x = 190;
            gardenDoorWindowVert.y = 106;
            gardenDoorWindowVert.z = 170;
         }
      }
      
      override protected function handleIncidentalClick(param1:MouseEvent) : Incidental
      {
         var _loc2_:Incidental = super.handleIncidentalClick(param1);
         if(_loc2_.active)
         {
            doCharacterVox(_loc2_.label + CLICK);
         }
         return _loc2_;
      }
      
      private function handleToGardenOver(param1:MouseEvent) : void
      {
         handleDoorOver(param1);
      }
      
      private function handleDoorOver(param1:MouseEvent) : void
      {
         gardenDoor.rotYOnOver = 5;
         gardenDoor.setDoorModelOverState(true);
         if(Math.random() > 0.5)
         {
            doCharacterVox(GARDENDOOR + "A");
         }
         else
         {
            doCharacterVox(GARDENDOOR + "C");
         }
         toGardenPointSprite.fadeIn();
      }
      
      private function handleToyBoxRollOver(param1:MouseEvent) : void
      {
         doCharacterVox(TOYBOX + ROLLOVER);
      }
      
      private function handleVideoFrameOver(param1:MouseEvent) : void
      {
         doCharacterVox(PICTURES + ROLLOVER);
         var _loc2_:VPortLayerButton = param1.target as VPortLayerButton;
         switch(_loc2_)
         {
            case videoAccessors[0]:
               lowPolyManager.playFrame(0);
               break;
            case videoAccessors[1]:
               lowPolyManager.playFrame(1);
               break;
            case videoAccessors[2]:
               lowPolyManager.playFrame(5);
               break;
            case videoAccessors[3]:
               lowPolyManager.playFrame(4);
               break;
            case videoAccessors[4]:
               lowPolyManager.playFrame(3);
               break;
            case videoAccessors[5]:
               lowPolyManager.playFrame(2);
         }
      }
      
      override public function park() : void
      {
         super.park();
         companionChar.park();
         voxEnableTimer.reset();
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         radioLayer.tabEnabled = param1;
         pianoLayer.tabEnabled = param1;
         leftTableFlowerLayer.tabEnabled = param1;
         rightTableFlowerLayer.tabEnabled = param1;
         bigCharLayer.tabEnabled = param1;
         bigCharLayer.buttonMode = param1;
         smallCharLayer.tabEnabled = param1;
         smallCharLayer.buttonMode = param1;
         gardenDoorLayer.tabEnabled = param1;
         toyBoxLayer.tabEnabled = param1;
         toUpstairsVPLayer.tabEnabled = param1;
         var _loc2_:int = 0;
         while(_loc2_ < videoAccessors.length)
         {
            VPortLayerButton(videoAccessors[_loc2_]).viewportLayer.tabEnabled = param1;
            _loc2_++;
         }
      }
      
      override public function collectionQueueEmpty() : void
      {
         initRoom();
         initIncidentals();
         initCharacters();
         initWindows();
         oldPaperPlaneComp.setupLayers(basicView.viewport);
         setupFurnitureLayers();
         setUpToyBoxLayers();
         initSounds();
         initComingSoon();
         initGardenDoor();
         initToGardenArrow();
         initCeilingPlane();
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_BIG,bigChar);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_SMALL,smallChar);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_ROOM,room);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_TOYBOX,toyBox);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_FURNITURE,furniture);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_PAPER,oldPaperPlaneComp);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_TABLEFLOWERA,leftTableFlower);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_TABLEFLOWERB,rightTableFlower);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_WINDOW_A,livingRoomWindowA);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_RADIO,radio);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_COMINGSOON,toLandingPointSprite);
         registerLiveDO3D(DO3DDefinitions.LIVINGROOM_GARDENDOOR,gardenDoor);
         setReadyState();
      }
   }
}

