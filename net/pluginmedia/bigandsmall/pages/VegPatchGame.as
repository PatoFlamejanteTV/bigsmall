package net.pluginmedia.bigandsmall.pages
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.garden.GardenDAEController;
   import net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller.FruitAppearEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller.PlantController3D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller.PlantSprite3D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.SeedSpawner;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.SpawnDraggableSeed;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.TrowelSpawner;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.UIController2D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.VegPatchGameDock;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.WateringCanSpawner;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.events.UIController2DEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.UIController3D;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.sound.BrainCollectionSoundFactory;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.ClickStickManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.DropTarget;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class VegPatchGame extends BigAndSmallPage3D
   {
      
      public static const SFX_ClickSeed:String = "VegPatchGame.SFX_ClickSeed";
      
      public static const SFX_SaplingPeek:String = "VegPatchGame.SFX_SaplingPeek";
      
      public static const SFX_TrowelClick:String = "VegPatchGame.SFX_TrowelClick";
      
      public static const SFX_TrowelDig:String = "VegPatchGame.SFX_TrowelDig";
      
      public static const SFX_WaterCanClick:String = "VegPatchGame.SFX_WaterCanClick";
      
      public static const SFX_WaterCanWater:String = "VegPatchGame.SFX_WaterCanWater";
      
      public static const SFX_UIArrowOver:String = "VegPatchGame.SFX_UIArrowOver";
      
      public static const SFX_UIArrowClick:String = "VegPatchGame.SFX_UIArrowClick";
      
      private var backButton:AssetButton;
      
      private var staticCam:ICameraUpdateable;
      
      private var seedLinkageSuffix:String = "Seed";
      
      private var seedDragPointSpriteDisplays:Dictionary;
      
      private var bigSeeds:Array;
      
      private var seedSpawnCounter:Number = -1;
      
      private var plantController3D:PlantController3D;
      
      private var smallPlantLinkages:Array = ["CandyCane","Firework","PurpleTentacle","Sucker","TieDie","Vine"];
      
      private var plantPointSpriteDisplays:Dictionary;
      
      private var uiController2D:UIController2D;
      
      private var timeoutVoxTimer:Timer;
      
      private var dock:VegPatchGameDock;
      
      private var waterSFXLoop:IBrainSoundInstance;
      
      private var uiController3D:UIController3D;
      
      private var daeController:GardenDAEController;
      
      private var bigPlantLinkages:Array = ["Tomato","Pepper","Lemon","Raspberry","Chili","Pea"];
      
      private var plantLinkageSuffix:String = "Plant";
      
      private var harvestButtonPos:Point;
      
      private var smallSeeds:Array;
      
      private var dockIconOverStateGlow:GlowFilter = new GlowFilter(16777215,1,4,4,5);
      
      private var draggingSeed:SpawnDraggableSeed;
      
      private var seedSpawnVoxAtCount:Number = 3;
      
      private var clickStick:ClickStickManager;
      
      private var timeoutVoxTriggerable:Boolean = false;
      
      private var harvestButton:AssetButton;
      
      private var dockMagnet:DropTarget;
      
      public function VegPatchGame(param1:BasicView, param2:String)
      {
         var _loc3_:Number3D = new Number3D(-992,150,182);
         var _loc4_:OrbitCamera3D = new OrbitCamera3D(32);
         _loc4_.target.position = _loc3_;
         _loc4_.rotationYMin = 1.4;
         _loc4_.rotationYMax = 1.4;
         _loc4_.radius = 638;
         _loc4_.rotationXMin = 24;
         _loc4_.rotationXMax = 24;
         staticCam = _loc4_;
         timeoutVoxTimer = new Timer(17500);
         timeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleTimeoutVoxTimer);
         super(param1,_loc3_,_loc4_,_loc4_,param2);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         banishUI();
         uiController2D.deactivate();
         uiController3D.deactivate();
         plantController3D.deactivate();
         timeoutVoxTimer.reset();
         timeoutVoxTimer.stop();
         SoundManager.stopChannel(SoundChannelDefinitions.VOX);
         SoundManager.stopSound(SFX_WaterCanWater);
         waterSFXLoop = null;
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         plantController3D.prepare();
         basicView.addChild(pageContainer2D);
      }
      
      private function handleStageMouseClick(param1:MouseEvent) : void
      {
      }
      
      private function handleBrainEvent(param1:BrainEvent) : void
      {
         dispatchEvent(new BrainEvent(param1.actionType,param1.actionTarget,param1.data));
      }
      
      private function initSeeds() : void
      {
         seedDragPointSpriteDisplays = new Dictionary();
         plantPointSpriteDisplays = new Dictionary();
         smallSeeds = parseInitSeeds(smallPlantLinkages);
         bigSeeds = parseInitSeeds(bigPlantLinkages);
      }
      
      override public function activate() : void
      {
         super.activate();
         summonUI();
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         uiController2D.activate();
         uiController3D.activate();
         plantController3D.activate();
         seedSpawnCounter = -1;
         timeoutVoxTimer.start();
         triggerVox("onActivate");
         waterSFXLoop = SoundManager.playSound(SFX_WaterCanWater,1,0,0,int.MAX_VALUE);
      }
      
      private function registerSoundCollection(param1:String, param2:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:Sound = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            _loc5_ = unPackAsset(_loc4_) as Sound;
            if(_loc5_)
            {
               _loc3_.push(_loc5_);
            }
         }
         SoundManager.registerSound(new BrainCollectionSoundFactory(param1,_loc3_,1,1,BrainCollectionSoundFactory.SEQUENCE));
      }
      
      override public function collectionQueueEmpty() : void
      {
         initSounds();
         initSeeds();
         initUIController2D();
         initUIController3D();
         initPlantController();
         uiController2D.setUIController3D(uiController3D);
         uiController3D.setUIController2D(uiController2D);
         uiController3D.setPlantController3D(plantController3D);
         plantController3D.setUIController3D(uiController3D);
         setReadyState();
      }
      
      private function triggerVox(param1:String) : void
      {
         if(SoundManager.isChannelBusy(SoundChannelDefinitions.VOX) || SoundManagerOld.channelOccupied(1))
         {
            return;
         }
         if(currentPOV == CharacterDefinitions.BIG)
         {
            SoundManager.playSoundOnChannel(param1 + "_" + pageID + "_" + CharacterDefinitions.BIG,SoundChannelDefinitions.VOX);
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            SoundManager.playSoundOnChannel(param1 + "_" + pageID + "_" + CharacterDefinitions.SMALL,SoundChannelDefinitions.VOX);
         }
      }
      
      private function initSounds() : void
      {
         SoundManager.quickRegisterSound("FruitAppear_I",unPackAsset("flower_i_whistle"));
         SoundManager.quickRegisterSound("FruitAppear_II",unPackAsset("flower_ii_whoosh"));
         SoundManager.quickRegisterSound("FruitAppear_III",unPackAsset("flower_iii_poff"));
         SoundManager.quickRegisterSound("FruitAppear_IV",unPackAsset("flower_iv_suck"));
         SoundManager.quickRegisterSound("FruitAppear_V",unPackAsset("flower_v_twist"));
         SoundManager.quickRegisterSound("onActivate" + "_" + pageID + "_" + CharacterDefinitions.BIG,unPackAsset("veg_sm_yayifitsveg"));
         SoundManager.quickRegisterSound("onActivate" + "_" + pageID + "_" + CharacterDefinitions.SMALL,unPackAsset("veg_bg_youseethe"));
         SoundManager.quickRegisterSound("onRollOverDockSeed" + "_" + pageID + "_" + CharacterDefinitions.BIG,unPackAsset("veg_sm_thatsaseed"));
         SoundManager.quickRegisterSound("onRollOverDockSeed" + "_" + pageID + "_" + CharacterDefinitions.SMALL,unPackAsset("veg_bg_goonpick"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_TOMATO_BIG",unPackAsset("veg_sm_tomatoes"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_PEA_BIG",unPackAsset("veg_sm_greenpeas"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_LEMON_BIG",unPackAsset("veg_sm_lemons"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_RASPBERRY_BIG",unPackAsset("veg_sm_raspberries"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_PEPPER_BIG",unPackAsset("veg_sm_areyougoing"));
         SoundManager.quickRegisterSound("onRollOverDockSeed_CHILLI_BIG",unPackAsset("veg_sm_chillies"));
         SoundManager.quickRegisterSound("onRollOverWaterCan" + "_" + pageID + "_" + CharacterDefinitions.BIG,unPackAsset("veg_sm_yaythewateringcan"));
         SoundManager.quickRegisterSound("onRollOverWaterCan" + "_" + pageID + "_" + CharacterDefinitions.SMALL,unPackAsset("veg_bg_theplantneeds"));
         SoundManager.quickRegisterSound("onRollOverTrowel" + "_" + pageID + "_" + CharacterDefinitions.BIG,unPackAsset("veg_sm_bigcallsthis"));
         SoundManager.quickRegisterSound("onRollOverTrowel" + "_" + pageID + "_" + CharacterDefinitions.SMALL,unPackAsset("veg_bg_hmmatrowel"));
         var _loc1_:Array = ["veg_bg_welldone","veg_bg_okrightthere","veg_bg_theresplenty"];
         registerSoundCollection("onClickDockSeed" + "_" + pageID + "_" + CharacterDefinitions.SMALL,_loc1_);
         var _loc2_:Array = ["veg_sm_yaythatsit","veg_sm_dropitdown","veg_sm_howabout"];
         registerSoundCollection("onClickDockSeed" + "_" + pageID + "_" + CharacterDefinitions.BIG,_loc2_);
         var _loc3_:Array = ["veg_bg_yourmaking","veg_bg_canthatgrow","veg_bg_thatsityou","veg_bg_lookitsgrown"];
         registerSoundCollection("growingTimeout" + "_" + pageID + "_" + CharacterDefinitions.SMALL,_loc3_);
         var _loc4_:Array = ["veg_sm_woohooits","veg_sm_wowisthat","veg_sm_morewater","veg_sm_heyicansee"];
         registerSoundCollection("growingTimeout" + "_" + pageID + "_" + CharacterDefinitions.BIG,_loc4_);
         var _loc5_:Array = ["veg_bg_iveneverseen","veg_bg_wowtheyare","veg_bg_didyougrow","veg_bg_hathosecolours"];
         registerSoundCollection("plantAdmireTimeout" + "_" + pageID + "_" + CharacterDefinitions.SMALL,_loc5_);
         var _loc6_:Array = ["veg_sm_differentseedsveg"];
         registerSoundCollection("plantAdmireTimeout" + "_" + pageID + "_" + CharacterDefinitions.BIG,_loc6_);
         SoundManager.quickRegisterSound("plantedTimeout" + "_" + pageID + "_" + CharacterDefinitions.BIG,unPackAsset("veg_sm_oktheseeds"));
         SoundManager.quickRegisterSound("plantedTimeout" + "_" + pageID + "_" + CharacterDefinitions.SMALL,unPackAsset("veg_bg_youknowsome"));
         SoundManager.quickRegisterSound(SFX_ClickSeed,unPackAsset("SFX_ClickSeed"));
         SoundManager.quickRegisterSound(SFX_SaplingPeek,unPackAsset("SFX_SaplingPeek"));
         SoundManager.quickRegisterSound(SFX_TrowelClick,unPackAsset("SFX_TrowelClick"));
         SoundManager.quickRegisterSound(SFX_TrowelDig,unPackAsset("SFX_TrowelDig"));
         SoundManager.quickRegisterSound(SFX_WaterCanClick,unPackAsset("SFX_WaterCanClick"));
         SoundManager.quickRegisterSound(SFX_WaterCanWater,unPackAsset("SFX_WaterCanWater"));
         SoundManager.quickRegisterSound(SFX_UIArrowOver,unPackAsset("SFX_UIArrowOver"));
         SoundManager.quickRegisterSound(SFX_UIArrowClick,unPackAsset("SFX_UIArrowClick"));
      }
      
      private function handleFruitAppear(param1:FruitAppearEvent) : void
      {
         switch(param1.plantSprite.type)
         {
            case "TomatoSeed":
               SoundManager.playSound("FruitAppear_IV",Math.random());
               break;
            case "PepperSeed":
               SoundManager.playSound("FruitAppear_III",Math.random());
               break;
            case "LemonSeed":
               SoundManager.playSound("FruitAppear_I",Math.random());
               break;
            case "ChiliSeed":
               SoundManager.playSound("FruitAppear_II",Math.random());
               break;
            case "PeaSeed":
               SoundManager.playSound("FruitAppear_I",Math.random());
               break;
            case "RaspberrySeed":
               SoundManager.playSound("FruitAppear_III",Math.random());
               break;
            case "CandyCaneSeed":
               SoundManager.playSound("FruitAppear_I",Math.random());
               break;
            case "FireworkSeed":
               SoundManager.playSound("FruitAppear_V",Math.random());
               break;
            case "PurpleTentacleSeed":
               SoundManager.playSound("FruitAppear_III",Math.random());
               break;
            case "SuckerSeed":
               SoundManager.playSound("FruitAppear_IV",Math.random());
               break;
            case "TieDieSeed":
               SoundManager.playSound("FruitAppear_V",Math.random());
               break;
            case "VineSeed":
               SoundManager.playSound("FruitAppear_I",Math.random());
               break;
            default:
               SoundManager.playSound("FruitAppear_I",Math.random());
         }
      }
      
      private function getRandomElement(param1:Array) : *
      {
         var _loc2_:int = int(Math.random() * param1.length);
         return param1[_loc2_];
      }
      
      private function handleTrowelClick(param1:Event) : void
      {
         SoundManager.playSound(SFX_TrowelClick);
      }
      
      private function banishUI() : void
      {
         uiController2D.banishUI();
      }
      
      private function handleDockSeedRollover(param1:MouseEvent) : void
      {
         if(timeoutVoxTriggerable)
         {
            if(currentPOV == CharacterDefinitions.BIG)
            {
               if(SoundManager.isChannelBusy(SoundChannelDefinitions.VOX) || SoundManagerOld.channelOccupied(1))
               {
                  return;
               }
               if(seedSpawnCounter == -1)
               {
                  triggerVox("onRollOverDockSeed");
               }
               else
               {
                  switch(SeedSpawner(param1.target).plantType)
                  {
                     case "RaspberrySeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_RASPBERRY_BIG",SoundChannelDefinitions.VOX);
                        break;
                     case "PepperSeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_PEPPER_BIG",SoundChannelDefinitions.VOX);
                        break;
                     case "TomatoSeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_TOMATO_BIG",SoundChannelDefinitions.VOX);
                        break;
                     case "PeaSeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_PEA_BIG",SoundChannelDefinitions.VOX);
                        break;
                     case "LemonSeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_LEMON_BIG",SoundChannelDefinitions.VOX);
                        break;
                     case "ChiliSeed":
                        SoundManager.playSoundOnChannel("onRollOverDockSeed_CHILLI_BIG",SoundChannelDefinitions.VOX);
                  }
               }
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               if(seedSpawnCounter == -1)
               {
                  triggerVox("onRollOverDockSeed");
               }
            }
            timeoutVoxTriggerable = false;
         }
      }
      
      private function handleGardenDAEControllerShared(param1:SharerInfo) : void
      {
         daeController = param1.reference as GardenDAEController;
      }
      
      private function summonUI() : void
      {
         uiController2D.summonUI();
      }
      
      private function initPlantController() : void
      {
         plantController3D = new PlantController3D();
         plantController3D.viewportLayer = daeController.dirtMoundContainerLyr.getChildLayer(plantController3D,true,true);
         plantController3D.viewportLayer.layerIndex = 1;
         plantController3D.init(plantPointSpriteDisplays,unPackAsset("PlantingAnim"),unPackAsset("PlantRemovalAnim"),unPackAsset("PlantRoots"));
         registerLiveDO3D(DO3DDefinitions.GARDEN_VEG_PLANTCONTROLLER,plantController3D);
         plantController3D.addEventListener(PlantController3D.SEED_PLANTED,handleSeedPlanted);
         plantController3D.addEventListener(FruitAppearEvent.FRUIT_APPEAR,handleFruitAppear);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("VegPatch.LIB_I",SWFLocations.vegPatchAssetsI,assetLibLoaded);
         dispatchAssetRequest("VegPatch.LIB_II",SWFLocations.vegPatchAssetsII,assetLibLoaded);
         dispatchAssetRequest("VegPatch.VOX_BIG_I",SWFLocations.vegPatchVoxBigI,assetLibLoaded);
         dispatchAssetRequest("VegPatch.VOX_BIG_II",SWFLocations.vegPatchVoxBigII,assetLibLoaded);
         dispatchAssetRequest("VegPatch.VOX_SMALL",SWFLocations.vegPatchVoxSmall,assetLibLoaded);
         dispatchAssetRequest("VegPatch.SFX",SWFLocations.vegPatchSFX,assetLibLoaded);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         return super.getLiveVisibleDisplayObjects().concat(DO3DDefinitions.GARDEN_DAE,DO3DDefinitions.GARDEN_PARALLAX);
      }
      
      private function handleDockCanRollover(param1:MouseEvent) : void
      {
         if(timeoutVoxTriggerable && plantController3D.plantedPlants.length > 0)
         {
            triggerVox("onRollOverWaterCan");
            timeoutVoxTriggerable = false;
         }
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:ViewportLayer = null;
         uiController2D.update();
         uiController3D.update();
         if(uiController3D.viewIsDirty)
         {
            this.flagDirtyLayer(uiController3D.viewportLayer);
         }
         plantController3D.update();
         for each(_loc2_ in plantController3D.dirtyLayers)
         {
            this.flagDirtyLayer(_loc2_);
         }
         if(waterSFXLoop)
         {
            if(uiController3D.isWatering)
            {
               waterSFXLoop.volume = 1;
            }
            else
            {
               waterSFXLoop.volume = 0;
            }
         }
      }
      
      private function initUIController2D() : void
      {
         var _loc1_:Class = unPackAsset("WateringCan3D",true) as Class;
         var _loc2_:WateringCanSpawner = new WateringCanSpawner(_loc1_,_loc1_,0,0,"WateringCan",dockIconOverStateGlow);
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,handleDockCanRollover);
         var _loc3_:Class = unPackAsset("Trowel2D",true) as Class;
         var _loc4_:TrowelSpawner = new TrowelSpawner(_loc3_,_loc3_,0,0,"Trowel",dockIconOverStateGlow);
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,handleTrowelRollover);
         backButton = new AssetButton(unPackAsset("ExitButton"));
         backButton.addEventListener(MouseEvent.CLICK,handleExitClick);
         backButton.addEventListener(MouseEvent.ROLL_OVER,handleExitOver);
         uiController2D = new UIController2D(basicView,smallSeeds,bigSeeds,_loc2_,_loc4_);
         uiController2D.initDock(unPackAsset("ToolDock") as MovieClip);
         uiController2D.initBackButton(backButton);
         uiController2D.setCharacter(currentPOV);
         uiController2D.addEventListener(UIController2DEvent.WATERING_CAN_PICKED_UP,handleDockCanClick);
         uiController2D.addEventListener(UIController2DEvent.TROWEL_PICKED_UP,handleTrowelClick);
         uiController2D.addEventListener(UIController2DEvent.TROWEL_DIG_ACTION,handleTrowelDig);
         pageContainer2D.addChild(uiController2D);
      }
      
      private function handleTrowelRollover(param1:MouseEvent) : void
      {
         if(timeoutVoxTriggerable && plantController3D.plantedPlants.length > 0)
         {
            triggerVox("onRollOverTrowel");
            timeoutVoxTriggerable = false;
         }
      }
      
      private function handleDockSeedSpawn(param1:Event) : void
      {
         ++seedSpawnCounter;
         if(seedSpawnCounter % seedSpawnVoxAtCount == 0)
         {
            triggerVox("onClickDockSeed");
         }
         SoundManager.playSound(SFX_ClickSeed);
      }
      
      private function handleExitClick(param1:Event) : void
      {
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_HUB);
      }
      
      private function handleTimeoutVoxTimer(param1:TimerEvent) : void
      {
         timeoutVoxTriggerable = true;
         if(plantController3D.growingPlants.length > 0)
         {
            triggerVox("growingTimeout");
            return;
         }
         if(plantController3D.plantedPlants.length > 0)
         {
            if(PlantSprite3D(plantController3D.plantedPlants[0]).growthUnit < 0.25)
            {
               triggerVox("plantedTimeout");
            }
            else
            {
               triggerVox("plantAdmireTimeout");
            }
            return;
         }
         triggerVox("onRollOverDockSeed");
      }
      
      private function handleExitOver(param1:Event) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      public function setSeedsEnabled(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DraggableSpawner = null;
         _loc2_ = 0;
         while(_loc2_ < smallSeeds.length)
         {
            _loc3_ = smallSeeds[_loc2_] as DraggableSpawner;
            if(_loc3_.isEnabled != param1)
            {
               _loc3_.setEnabledState(param1);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < bigSeeds.length)
         {
            _loc3_ = bigSeeds[_loc2_] as DraggableSpawner;
            if(_loc3_.isEnabled != param1)
            {
               _loc3_.setEnabledState(param1);
            }
            _loc2_++;
         }
      }
      
      private function initUIController3D() : void
      {
         uiController3D = new UIController3D(this.position,staticCam as CameraObject3D,seedDragPointSpriteDisplays,unPackAsset("DragSeedShadow"),unPackAsset("WateringCan3D"));
         uiController3D.viewportLayer = daeController.dirtMoundContainerLyr.getChildLayer(uiController3D,true,true);
         uiController3D.viewportLayer.layerIndex = 4;
         addChild(uiController3D);
         registerLiveDO3D("seedController3D",uiController3D);
      }
      
      override public function park() : void
      {
         super.park();
         plantController3D.park();
         flagDirtyLayer(plantController3D.viewportLayer);
         basicView.removeChild(pageContainer2D);
      }
      
      private function handleDockCanClick(param1:Event) : void
      {
         SoundManager.playSound(SFX_WaterCanClick);
      }
      
      private function handleTrowelDig(param1:Event) : void
      {
         SoundManager.playSound(SFX_TrowelDig);
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(uiController2D)
         {
            uiController2D.setCharacter(param1);
         }
      }
      
      override public function onShareableRegistration() : void
      {
         this.dispatchShareRequest(new ShareRequest(this,"Shareable.GardenDAEController",handleGardenDAEControllerShared));
      }
      
      private function handleSeedPlanted(param1:Event) : void
      {
         SoundManager.playSound(SFX_SaplingPeek);
      }
      
      private function parseInitSeeds(param1:Array) : Array
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Class = null;
         var _loc8_:Class = null;
         var _loc9_:Class = null;
         var _loc10_:SeedSpawner = null;
         var _loc2_:Array = [];
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_ + seedLinkageSuffix;
            _loc7_ = unPackAsset(_loc6_,true);
            _loc8_ = unPackAsset(_loc6_,true);
            _loc9_ = unPackAsset(_loc5_ + plantLinkageSuffix,true);
            _loc10_ = new SeedSpawner(_loc7_,Sprite,0,0,_loc5_ + seedLinkageSuffix,dockIconOverStateGlow);
            _loc10_.addEventListener(MouseEvent.ROLL_OVER,handleDockSeedRollover);
            _loc10_.addEventListener("didSpawn",handleDockSeedSpawn);
            _loc10_.plantType = _loc6_;
            seedDragPointSpriteDisplays[_loc6_] = _loc8_;
            plantPointSpriteDisplays[_loc6_] = _loc9_;
            _loc2_.push(_loc10_);
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

