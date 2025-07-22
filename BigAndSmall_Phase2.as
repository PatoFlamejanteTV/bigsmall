package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPageManager3D;
   import net.pluginmedia.bigandsmall.core.SceneChangeInfo;
   import net.pluginmedia.bigandsmall.core.camera.BigAndSmallCameraTransition;
   import net.pluginmedia.bigandsmall.core.loading.BigAndSmallMultiPageLoadProgressMeter;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.FLVLocations;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.definitions.XMLLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.AppleTreeGame;
   import net.pluginmedia.bigandsmall.pages.Bathroom;
   import net.pluginmedia.bigandsmall.pages.BedRoom;
   import net.pluginmedia.bigandsmall.pages.CriticalErrorPage;
   import net.pluginmedia.bigandsmall.pages.FrontGarden;
   import net.pluginmedia.bigandsmall.pages.FrontOfHouse;
   import net.pluginmedia.bigandsmall.pages.Garden;
   import net.pluginmedia.bigandsmall.pages.GlobalAssets;
   import net.pluginmedia.bigandsmall.pages.Landing;
   import net.pluginmedia.bigandsmall.pages.LivingRoom;
   import net.pluginmedia.bigandsmall.pages.MysteriousWoods;
   import net.pluginmedia.bigandsmall.pages.PreBathroom;
   import net.pluginmedia.bigandsmall.pages.PreGarden;
   import net.pluginmedia.bigandsmall.pages.VegPatchGame;
   import net.pluginmedia.bigandsmall.pages.bathroom.ToothBrushTackle;
   import net.pluginmedia.bigandsmall.pages.bathroom.video.VideoFrameBathroom;
   import net.pluginmedia.bigandsmall.pages.garden.video.ButterflyHouseVideo;
   import net.pluginmedia.bigandsmall.pages.livingroom.BandGame;
   import net.pluginmedia.bigandsmall.pages.livingroom.DrawingGame;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFrameBlueFlower;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFrameFish;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFrameGreenBFly;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFrameOrangeBFly;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFramePurpleFlower;
   import net.pluginmedia.bigandsmall.pages.livingroom.videos.VideoFrameRedEggs;
   import net.pluginmedia.bigandsmall.ui.BigSmallButtonBar;
   import net.pluginmedia.bigandsmall.ui.BigSmallNavMenu;
   import net.pluginmedia.bigandsmall.ui.BigSmallNavMenuButton;
   import net.pluginmedia.brain.Brain3D;
   import net.pluginmedia.brain.buttons.*;
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.events.*;
   import net.pluginmedia.brain.core.loading.LoadProgressRequestInfo;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeterInfo;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.brain.pages.*;
   import net.pluginmedia.brain.ui.*;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.utils.KeyUtils;
   import net.pluginmedia.utils.PluginStats;
   import org.papervision3d.Papervision3D;
   
   public class BigAndSmall_Phase2 extends Brain3D
   {
      
      private static const BORDER:int = 30;
      
      private static const WIDTH:int = 768;
      
      private static const HEIGHT:int = 454;
      
      private static const configXMLPath:String = "xml/config.xml";
      
      private var globalAssets:GlobalAssets;
      
      private var pauseStateBMPData:BitmapData;
      
      private var livingRoomVideoPageA:BigAndSmallPage3D;
      
      private var livingRoomVideoPageB:BigAndSmallPage3D;
      
      private var livingRoomVideoPageC:BigAndSmallPage3D;
      
      private var livingRoomVideoPageD:BigAndSmallPage3D;
      
      private var livingRoomVideoPageE:BigAndSmallPage3D;
      
      private var livingRoomVideoPageF:BigAndSmallPage3D;
      
      private var navMenu:BigSmallNavMenu;
      
      private var frontOfHouse:FrontOfHouse;
      
      private var uiLayer:Sprite = new Sprite();
      
      private var gardenHubPage:BigAndSmallPage3D;
      
      private var landingPage:BigAndSmallPage3D;
      
      private var preBathroomPage:BigAndSmallPage3D;
      
      private var mysteriousWoods:MysteriousWoods;
      
      private var pauseStateBitmap:Bitmap;
      
      private var gardenVideo:BigAndSmallPage3D;
      
      private var toothBrushtacklePage:BigAndSmallPage3D;
      
      private var debug:Boolean = false;
      
      private var bigSmallButtonBar:BigSmallButtonBar;
      
      private var muteToggleButton:AssetToggleButton;
      
      private var preGardenPage:BigAndSmallPage3D;
      
      private var menuButton:BigSmallNavMenuButton;
      
      private var gardenTree:AppleTreeGame;
      
      private var configXML:XML;
      
      private var killed:Boolean = false;
      
      private var preloader:FrontGarden;
      
      private var frameSprite:Sprite;
      
      private var uiRect:Rectangle = new Rectangle(0,0,WIDTH,HEIGHT);
      
      private var stats:PluginStats;
      
      private var soundManagerOld:SoundManagerOld;
      
      private var bedRoomPage:BedRoom;
      
      private var killedPage:CriticalErrorPage;
      
      private var preloaderState:Boolean = false;
      
      private var bathroomVideoPageA:BigAndSmallPage3D;
      
      private var livingRoomPage:LivingRoom;
      
      private var stageColourClip:Shape;
      
      private var drawingGamePage:BigAndSmallPage3D;
      
      private var gardenVegPatch:VegPatchGame;
      
      private var configXMLLoader:URLLoader;
      
      private var navBar:ButtonBarHorizontal;
      
      private var bandGamePage:BigAndSmallPage3D;
      
      private var bathroomPage:BigAndSmallPage3D;
      
      public function BigAndSmall_Phase2()
      {
         KeyUtils.init(stage);
         super();
         loadConfig();
         soundManagerOld = new SoundManagerOld();
         SoundManager.createChannel(SoundChannelDefinitions.VOX);
      }
      
      private function togglePause() : void
      {
         pause(!_paused);
      }
      
      override public function pause(param1:Boolean = true) : void
      {
         super.pause(param1);
         pauseStateBMPData.fillRect(pauseStateBMPData.rect,16777215);
         pauseStateBMPData.draw(pageManager,null,null,null,null,true);
         pauseStateBitmap.visible = param1;
         pageManager.visible = !param1;
         uiLayer.visible = !param1;
         pageManager.pause(param1);
         broadcastManager.pause(param1);
         soundManagerOld.pause(param1);
         updateManager.pause(param1);
         loadManager.pause(param1);
         shareManager.pause(param1);
      }
      
      private function killPage(param1:Page3D) : void
      {
         trace(" KILL_PAGE event ::",param1.pageID);
         unregister(param1);
         param1 = null;
      }
      
      private function showKilledOverlay(param1:String = "") : void
      {
         killedPage = new CriticalErrorPage();
         uiLayer.addChild(killedPage);
         if(debug)
         {
            killedPage.message = param1;
         }
         else if(param1 == "" && configXML !== null)
         {
            killedPage.message = configXML.errorText.toString();
         }
      }
      
      public function get pageManager() : BigAndSmallPageManager3D
      {
         return _pageManager as BigAndSmallPageManager3D;
      }
      
      private function handleMenuButtonClicked(param1:MouseEvent) : void
      {
         if(!navMenu.summoned)
         {
            navMenu.summon();
            pause(true);
         }
      }
      
      private function beginGame() : void
      {
         menuButton.enabled = true;
         _pageManager.changePageByID(PageDefinitions.FRONTOFHOUSE);
      }
      
      private function handleCharChangeComplete(param1:Event = null) : void
      {
         bigSmallButtonBar.hideButtons(false);
      }
      
      public function changeCharacter(param1:String, param2:Boolean = false) : void
      {
         pageManager.setCharacterAspect(param1,param2);
         outputHelperText(pageManager.currentPage as BigAndSmallPage3D);
         bigSmallButtonBar.setSelectedButton(param1);
         navMenu.currentChar = param1;
      }
      
      override protected function setPageManager() : void
      {
         _pageManager = new BigAndSmallPageManager3D(shareManager,WIDTH,HEIGHT,false,false);
         pageManager.viewport.autoClipping = false;
         pageManager.viewport.autoCulling = true;
         pageManager.addEventListener(BrainEvent.ACTION,handleActionEvent);
         pageManager.addEventListener(BigAndSmallPageManager3D.CHARACTER_CHANGE_BEGINS,handleCharChangeBegins);
         pageManager.addEventListener(BigAndSmallPageManager3D.CHARACTER_CHANGE_COMPLETE,handleCharChangeComplete);
      }
      
      private function handleNavMenuClose(param1:Event) : void
      {
         pause(false);
      }
      
      private function handleStageClick(param1:MouseEvent) : void
      {
         if(param1.stageX > WIDTH - 5 && param1.stageY < HEIGHT - 5)
         {
            if(param1.shiftKey && param1.ctrlKey)
            {
               debugMode(!debug);
            }
         }
         if(param1.altKey)
         {
            togglePause();
         }
      }
      
      private function handleCharChangeBegins(param1:Event = null) : void
      {
         bigSmallButtonBar.hideButtons(true);
      }
      
      public function handleConfigXMLSecurityError(param1:SecurityErrorEvent) : void
      {
         BrainLogger.error("BigAndSmall_Phase1 :: Critical Error :: Cannot load config xml [SecurityErrorEvent]",param1.text);
      }
      
      private function handlePreloadStageBReady() : void
      {
         BigAndSmallMultiPageLoadProgressMeter(loaderProgress).removeBeebiesLogo();
         pageManager.changePageByID(PageDefinitions.FRONTOFHOUSE);
      }
      
      private function initPageTransitions() : void
      {
         var _loc1_:BigAndSmallCameraTransition = null;
         var _loc2_:BezierPath3D = null;
         var _loc3_:SceneChangeInfo = null;
         _loc2_ = new BezierPath3D(4,new BezierPoint3D(10,100,80));
         _loc1_ = new BigAndSmallCameraTransition(4,_loc2_);
         _loc1_.transitStepInc = 0.03;
         pageManager.setBezierTransitionPath(PageDefinitions.PRELOADER,PageDefinitions.FRONTOFHOUSE,CharacterDefinitions.ALL,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_C",0.18,0.68);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(0,170,100),new BezierPoint3D(300,170,230),new BezierPoint3D(310,470,-330),new BezierPoint3D(430,490,-530),new BezierPoint3D(430,490,-630),new BezierPoint3D(230,490,-530));
         _loc1_ = new BigAndSmallCameraTransition(7,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(0,170,0));
         _loc1_.addPoint3D(new BezierPoint3D(320,270,230));
         _loc1_.addPoint3D(new BezierPoint3D(340,470,-230));
         _loc1_.transitStepInc = 0.005;
         pageManager.setBezierTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LANDING,CharacterDefinitions.BIG,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_C",0.05,0.7);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(0,50,100),new BezierPoint3D(300,170,230),new BezierPoint3D(310,470,-330),new BezierPoint3D(430,490,-530),new BezierPoint3D(430,490,-630),new BezierPoint3D(230,490,-530));
         _loc1_ = new BigAndSmallCameraTransition(7,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(0,170,0));
         _loc1_.addPoint3D(new BezierPoint3D(320,270,230));
         _loc1_.addPoint3D(new BezierPoint3D(340,470,-230));
         _loc1_.transitStepInc = 0.005;
         pageManager.setBezierTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LANDING,CharacterDefinitions.SMALL,_loc1_);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_A,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_B,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_C,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_D,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_E,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_VIDEO_F,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_A,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_B,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_C,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_D,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_E,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_VIDEO_F,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_BANDGAME,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_BANDGAME,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_DRAWINGGAME,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM_DRAWINGGAME,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(-330,490,-530),new BezierPoint3D(0,490,-730));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_);
         _loc1_.addPoint3D(new BezierPoint3D(100,490,-430));
         _loc1_.addPoint3D(new BezierPoint3D(0,490,-330));
         _loc1_.transitStepInc = 0.01;
         pageManager.setBezierTransitionPath(PageDefinitions.LANDING,PageDefinitions.BEDROOM,CharacterDefinitions.ALL,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_C",0.05,0.8);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(0,400,200));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(340,470,-230));
         _loc1_.transitStepInc = 0.01;
         pageManager.setBezierTransitionPath(PageDefinitions.LANDING,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_C",0.08,0.85);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(230,490,-530),new BezierPoint3D(430,490,-630),new BezierPoint3D(430,490,-530),new BezierPoint3D(310,470,-330),new BezierPoint3D(300,170,230),new BezierPoint3D(0,170,100));
         _loc1_ = new BigAndSmallCameraTransition(7,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(250,490,-440));
         _loc1_.addPoint3D(new BezierPoint3D(100,490,-430));
         _loc1_.addPoint3D(new BezierPoint3D(340,470,-230));
         _loc1_.addPoint3D(new BezierPoint3D(320,270,230));
         _loc1_.addPoint3D(new BezierPoint3D(0,170,0));
         _loc1_.transitStepInc = 0.005;
         pageManager.setBezierTransitionPath(PageDefinitions.BEDROOM,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL,_loc1_);
         _loc2_ = new BezierPath3D(4,new BezierPoint3D(10,100,80));
         _loc1_ = new BigAndSmallCameraTransition(4,_loc2_);
         pageManager.setBezierTransitionPath(PageDefinitions.FRONTOFHOUSE,PageDefinitions.LIVINGROOM,CharacterDefinitions.BIG,_loc1_);
         _loc2_ = new BezierPath3D(4,new BezierPoint3D(40,150,150));
         _loc1_ = new BigAndSmallCameraTransition(4,_loc2_);
         _loc1_.addPoint3D(new BezierPoint3D(170,55,-250));
         pageManager.setBezierTransitionPath(PageDefinitions.FRONTOFHOUSE,PageDefinitions.LIVINGROOM,CharacterDefinitions.SMALL,_loc1_);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(-653,450,-928));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_);
         _loc1_.addPoint3D(new BezierPoint3D(-500,450,-500));
         _loc1_.transitStepInc = 0.03;
         pageManager.setBezierTransitionPath(PageDefinitions.PREBATHROOM,PageDefinitions.BATHROOM,CharacterDefinitions.ALL,_loc1_);
         pageManager.setLinearTransitionPath(PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,PageDefinitions.BATHROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.BEDROOM,PageDefinitions.PREBATHROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.PREBATHROOM,PageDefinitions.BEDROOM,CharacterDefinitions.ALL);
         _loc3_ = new SceneChangeInfo("Transition_C",0,1);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(1000,500,-1000));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(-200,500,-650));
         _loc1_.transitStepInc = 0.0001;
         pageManager.setBezierTransitionPath(PageDefinitions.BATHROOM,PageDefinitions.BEDROOM,CharacterDefinitions.ALL,_loc1_);
         pageManager.setLinearTransitionPath(PageDefinitions.LIVINGROOM,PageDefinitions.PREGARDEN,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.PREGARDEN,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL);
         _loc3_ = new SceneChangeInfo("Transition_D",0,1);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(1000,500,-1000));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(-200,500,-650));
         _loc1_.transitStepInc = 0.0001;
         pageManager.setBezierTransitionPath(PageDefinitions.PREGARDEN,PageDefinitions.GARDEN_HUB,CharacterDefinitions.ALL,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_C",0.1,0.9);
         _loc2_ = new BezierPath3D(7);
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.transitStepInc = 0.008;
         pageManager.setBezierTransitionPath(PageDefinitions.GARDEN_HUB,PageDefinitions.LIVINGROOM,CharacterDefinitions.ALL,_loc1_);
         pageManager.setLinearTransitionPath(PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_VIDEO_A,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.BATHROOM_VIDEO_A,PageDefinitions.BATHROOM,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_VEGPATCH,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_HUB,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_VIDEO,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_VIDEO,PageDefinitions.GARDEN_HUB,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_APPLETREE,CharacterDefinitions.ALL);
         pageManager.setLinearTransitionPath(PageDefinitions.GARDEN_APPLETREE,PageDefinitions.GARDEN_HUB,CharacterDefinitions.ALL);
         _loc3_ = new SceneChangeInfo("Transition_D",0.035,1);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(-5800,300,4000));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(-5000,350,3650));
         _loc1_.transitStepInc = 0.003;
         pageManager.setBezierTransitionPath(PageDefinitions.GARDEN_HUB,PageDefinitions.MYSTERIOUS_WOODS,CharacterDefinitions.ALL,_loc1_);
         _loc3_ = new SceneChangeInfo("Transition_D",0,1);
         _loc2_ = new BezierPath3D(7,new BezierPoint3D(-5800,300,4000));
         _loc1_ = new BigAndSmallCameraTransition(8,_loc2_,_loc3_);
         _loc1_.addPoint3D(new BezierPoint3D(-5000,350,3650));
         _loc1_.transitStepInc = 0.00001;
         pageManager.setBezierTransitionPath(PageDefinitions.MYSTERIOUS_WOODS,PageDefinitions.GARDEN_HUB,CharacterDefinitions.ALL,_loc1_);
         pageManager.setTransitionMusic(PageDefinitions.PRELOADER,PageDefinitions.FRONTOFHOUSE,"pl_tran_music");
         pageManager.setTransitionMusic(PageDefinitions.FRONTOFHOUSE,PageDefinitions.LIVINGROOM,"hf_tran_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_BANDGAME,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_DRAWINGGAME,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_A,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_B,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_C,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_D,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_E,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM_VIDEO_F,PageDefinitions.LIVINGROOM,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.GARDEN_HUB,PageDefinitions.MYSTERIOUS_WOODS,"mw_musictrans_intowoods");
         pageManager.setTransitionMusic(PageDefinitions.MYSTERIOUS_WOODS,PageDefinitions.GARDEN_HUB,"mw_musictrans_outwoods");
         pageManager.setTransitionMusic(PageDefinitions.GARDEN_VIDEO,PageDefinitions.GARDEN_HUB,"lr_trans_music");
         pageManager.setTransitionMusic(PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,"tt_trans_music1");
         pageManager.setTransitionMusic(PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,PageDefinitions.BATHROOM,"tt_trans_music2");
         pageManager.setTransitionMusic(PageDefinitions.BEDROOM,PageDefinitions.PREBATHROOM,"NONE");
         pageManager.setTransitionMusic(PageDefinitions.LIVINGROOM,PageDefinitions.PREGARDEN,"NONE");
      }
      
      private function handleMuteClicked(param1:MouseEvent) : void
      {
         SoundManagerOld.toggleMute();
      }
      
      private function initPages() : void
      {
         globalAssets = new GlobalAssets();
         register(globalAssets);
         globalAssets.addEventListener("GlobalAssetsReady",handleGlobalAssetsReady);
         frontOfHouse = new FrontOfHouse(pageManager,PageDefinitions.FRONTOFHOUSE);
         register(frontOfHouse);
         preloader = new FrontGarden(pageManager,PageDefinitions.PRELOADER,frontOfHouse);
         register(preloader);
         livingRoomPage = new LivingRoom(pageManager,PageDefinitions.LIVINGROOM);
         register(livingRoomPage);
         bandGamePage = new BandGame(pageManager,PageDefinitions.LIVINGROOM_BANDGAME,livingRoomPage);
         register(bandGamePage);
         drawingGamePage = new DrawingGame(pageManager,PageDefinitions.LIVINGROOM_DRAWINGGAME,livingRoomPage);
         register(drawingGamePage);
         livingRoomVideoPageA = new VideoFrameGreenBFly(pageManager,PageDefinitions.LIVINGROOM_VIDEO_A,livingRoomPage);
         livingRoomVideoPageA.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageA);
         livingRoomVideoPageB = new VideoFrameOrangeBFly(pageManager,PageDefinitions.LIVINGROOM_VIDEO_B,livingRoomPage);
         livingRoomVideoPageB.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageB);
         livingRoomVideoPageC = new VideoFrameFish(pageManager,PageDefinitions.LIVINGROOM_VIDEO_C,livingRoomPage);
         livingRoomVideoPageC.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageC);
         livingRoomVideoPageD = new VideoFramePurpleFlower(pageManager,PageDefinitions.LIVINGROOM_VIDEO_D,livingRoomPage);
         livingRoomVideoPageD.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageD);
         livingRoomVideoPageE = new VideoFrameRedEggs(pageManager,PageDefinitions.LIVINGROOM_VIDEO_E,livingRoomPage);
         livingRoomVideoPageE.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageE);
         livingRoomVideoPageF = new VideoFrameBlueFlower(pageManager,PageDefinitions.LIVINGROOM_VIDEO_F,livingRoomPage);
         livingRoomVideoPageF.helperTextNodeID = "LivingRoom.video";
         register(livingRoomVideoPageF);
         landingPage = new Landing(pageManager,PageDefinitions.LANDING);
         register(landingPage);
         bedRoomPage = new BedRoom(pageManager,PageDefinitions.BEDROOM);
         register(bedRoomPage);
         preBathroomPage = new PreBathroom(pageManager,PageDefinitions.PREBATHROOM);
         register(preBathroomPage);
         bathroomPage = new Bathroom(pageManager,PageDefinitions.BATHROOM);
         register(bathroomPage);
         bathroomVideoPageA = new VideoFrameBathroom(pageManager,PageDefinitions.BATHROOM_VIDEO_A,bathroomPage);
         bathroomVideoPageA.helperTextNodeID = "LivingRoom.video";
         register(bathroomVideoPageA);
         toothBrushtacklePage = new ToothBrushTackle(pageManager,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,bathroomPage);
         register(toothBrushtacklePage);
         preGardenPage = new PreGarden(pageManager,PageDefinitions.PREGARDEN);
         register(preGardenPage);
         gardenHubPage = new Garden(pageManager,PageDefinitions.GARDEN_HUB);
         register(gardenHubPage);
         gardenVegPatch = new VegPatchGame(pageManager,PageDefinitions.GARDEN_VEGPATCH);
         register(gardenVegPatch);
         gardenVideo = new ButterflyHouseVideo(pageManager,PageDefinitions.GARDEN_VIDEO,gardenHubPage);
         register(gardenVideo);
         gardenTree = new AppleTreeGame(pageManager,PageDefinitions.GARDEN_APPLETREE);
         register(gardenTree);
         mysteriousWoods = new MysteriousWoods(pageManager,PageDefinitions.MYSTERIOUS_WOODS,pageManager.transitionFX);
         register(mysteriousWoods);
      }
      
      private function debugMode(param1:Boolean) : void
      {
         if(param1)
         {
            if(stats === null)
            {
               stats = new PluginStats();
               stats.x = WIDTH - stats.width;
               uiLayer.addChild(stats);
            }
            else
            {
               stats.visible = true;
            }
            BrainLogger.isVerbose = true;
            Papervision3D.PAPERLOGGER.registerLogger(Papervision3D.PAPERLOGGER.traceLogger);
         }
         else
         {
            if(stats !== null)
            {
               stats.visible = false;
            }
            BrainLogger.isVerbose = false;
            Papervision3D.PAPERLOGGER.unregisterLogger(Papervision3D.PAPERLOGGER.traceLogger);
            if(frameSprite !== null)
            {
               frameSprite.visible = false;
            }
         }
         debug = param1;
         pageManager.debugMode(param1);
         OrbitCamera3D.debug = param1;
      }
      
      public function handleConfigXMLLoaded(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         configXML = XML(_loc2_.data);
         initApp();
      }
      
      private function initUI() : void
      {
         bigSmallButtonBar = new BigSmallButtonBar(uiRect);
         register(bigSmallButtonBar);
         uiLayer.addChild(bigSmallButtonBar);
         bigSmallButtonBar.hideButtons(true);
         muteToggleButton = new AssetToggleButton(new UIMuteButton());
         muteToggleButton.addEventListener(MouseEvent.CLICK,handleMuteClicked);
         muteToggleButton.x = 0;
         muteToggleButton.y = HEIGHT;
         muteToggleButton.setSelectedState(false);
         muteToggleButton.cacheAsBitmap = true;
         uiLayer.addChild(muteToggleButton);
         AccessibilityManager.addAccessibilityProperties(muteToggleButton,"Mute toggle","Toggle mute on/off",AccessibilityDefinitions.MUTE);
         menuButton = new BigSmallNavMenuButton();
         menuButton.enabled = false;
         menuButton.addEventListener(MouseEvent.CLICK,handleMenuButtonClicked);
         menuButton.y = HEIGHT - menuButton.height - 3;
         menuButton.x = 50;
         menuButton.cacheAsBitmap = true;
         uiLayer.addChild(menuButton);
         AccessibilityManager.addAccessibilityProperties(menuButton,"Menu","Show Menu",AccessibilityDefinitions.MENU);
         initDebugUI();
         pauseStateBMPData = new BitmapData(WIDTH,HEIGHT,true);
         pauseStateBitmap = new Bitmap(pauseStateBMPData,"auto",true);
         pauseStateBitmap.visible = _paused;
         addChild(pauseStateBitmap);
         navMenu = new BigSmallNavMenu(WIDTH,HEIGHT);
         navMenu.addEventListener(Event.CLOSE,handleNavMenuClose);
         navMenu.addEventListener(BrainEvent.ACTION,handleNavMenuAction);
         navMenu.banish(true);
         register(navMenu);
         addChild(navMenu);
      }
      
      private function setStageColour(param1:uint) : void
      {
         stageColourClip.graphics.beginFill(param1,1);
         stageColourClip.graphics.drawRect(0,0,WIDTH,HEIGHT);
      }
      
      private function handleNavMenuAction(param1:BrainEvent) : void
      {
         switch(param1.actionType)
         {
            case BrainEventType.GET_LOADPROGRESS:
               handleLoadProgressRequest(param1.data as LoadProgressRequestInfo);
         }
      }
      
      public function handleConfigXMLIOError(param1:IOErrorEvent) : void
      {
         BrainLogger.error("BigAndSmall_Phase1 :: Critical Error :: Cannot load config xml [IOErrorEvent]",param1.text);
      }
      
      override protected function handleActionEvent(param1:BrainEvent) : void
      {
         var _loc2_:String = null;
         super.handleActionEvent(param1);
         switch(param1.actionType)
         {
            case BrainEventType.TRANSITION:
               menuButton.enabled = false;
               bigSmallButtonBar.hideButtons(true);
               outputHelperText(param1.data as BigAndSmallPage3D);
               break;
            case BigAndSmallEventType.SET_STAGE_COLOUR:
               setStageColour(param1.data);
               break;
            case BigAndSmallEventType.TOGGLE_PAUSE:
               togglePause();
               break;
            case BigAndSmallEventType.MENU_CHANGE_PAGE:
               if(pageManager.getPageByID(param1.actionTarget) == pageManager.currentPage)
               {
                  return;
               }
               _loc2_ = param1.actionTarget;
               if(_loc2_ == PageDefinitions.GARDENREGION_POND)
               {
                  _loc2_ = PageDefinitions.GARDEN_HUB;
                  Garden(gardenHubPage).navRegion = Garden.NAVREGION_POND;
               }
               if(_loc2_ == PageDefinitions.GARDENREGION_VEGPATCH)
               {
                  _loc2_ = PageDefinitions.GARDEN_HUB;
                  Garden(gardenHubPage).navRegion = Garden.NAVREGION_VEGPATCH;
               }
               if(_loc2_ == PageDefinitions.LANDING && pageManager.currentPage.pageID == PageDefinitions.BEDROOM)
               {
                  return;
               }
               if(pageManager.currentPage.pageID == PageDefinitions.FRONTOFHOUSE && _loc2_ == PageDefinitions.LIVINGROOM)
               {
                  frontOfHouse.doorEntry();
               }
               changeCharacter(this.pageManager.characterIdent,true);
               pageManager.changePageByID(_loc2_);
               break;
            case BigAndSmallEventType.STAGE_QUALITY:
               pageManager.stage.quality = param1.actionTarget;
               break;
            case BigAndSmallEventType.CHANGE_CHARACTER:
               menuButton.enabled = false;
               changeCharacter(param1.actionTarget);
               break;
            case BigAndSmallEventType.CHANGE_CHARACTER_SNAP:
               changeCharacter(param1.actionTarget,true);
               break;
            case BigAndSmallEventType.SHOW_BS_BUTTONS:
               bigSmallButtonBar.hideButtons(false);
               break;
            case BigAndSmallEventType.HIDE_BS_BUTTONS:
               bigSmallButtonBar.hideButtons(true);
               break;
            case BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON:
               menuButton.enabled = true;
               break;
            case BigAndSmallEventType.HIDE_BS_NAVMENUBUTTON:
               menuButton.enabled = false;
               break;
            case BigAndSmallEventType.REFRESH_LIVEDISPLAYOBJECTS:
               pageManager.refreshDisplayList();
               break;
            case BrainEventType.KILL_APP:
               killed = true;
               if(debug)
               {
                  showKilledOverlay(param1.data.toString());
               }
               else
               {
                  showKilledOverlay();
               }
               break;
            case BrainEventType.KILL_PAGE:
               killPage(param1.data.page as Page3D);
               break;
            case BrainEventType.SOUND_TOGGLE_MUTE:
               SoundManagerOld.toggleMute();
         }
      }
      
      private function loadConfig() : void
      {
         configXMLLoader = new URLLoader();
         configXMLLoader.addEventListener(Event.COMPLETE,handleConfigXMLLoaded);
         configXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,handleConfigXMLIOError);
         configXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleConfigXMLSecurityError);
         configXMLLoader.load(new URLRequest(configXMLPath));
      }
      
      private function outputHelperText(param1:BigAndSmallPage3D) : void
      {
         var node:XMLList;
         var nodeid:String;
         var pageobj:BigAndSmallPage3D = param1;
         if(globalAssets.helperText === null)
         {
            BrainLogger.warning("outputHelperText :: helper text is not available");
            return;
         }
         if(pageobj === null)
         {
            BrainLogger.warning("outputHelperText :: page reference is null");
            return;
         }
         nodeid = pageobj.helperTextNodeID;
         node = globalAssets.helperText.node.(@id == nodeid);
         if(Boolean(node.hasOwnProperty("big")) && Boolean(node.hasOwnProperty("small")))
         {
            if(pageManager.characterIdent == CharacterDefinitions.BIG)
            {
               node = node.big;
            }
            else if(pageManager.characterIdent == CharacterDefinitions.SMALL)
            {
               node = node.small;
            }
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("outputHelperText",node.toString());
         }
         BrainLogger.out("Sourcing helperText for :: [",nodeid,"]",node);
      }
      
      override protected function initLoadProgressMeter() : void
      {
         loaderProgress = new BigAndSmallMultiPageLoadProgressMeter(WIDTH,HEIGHT,loadManager,_pageManager,Preloader);
      }
      
      private function handlePreloadStageAReady() : void
      {
         pageManager.changePageByID(PageDefinitions.PRELOADER);
         changeCharacter(CharacterDefinitions.SMALL,true);
         var _loc1_:Array = [PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_BANDGAME,PageDefinitions.LIVINGROOM_DRAWINGGAME,PageDefinitions.LIVINGROOM_VIDEO_A,PageDefinitions.LIVINGROOM_VIDEO_B,PageDefinitions.LIVINGROOM_VIDEO_C,PageDefinitions.LIVINGROOM_VIDEO_D,PageDefinitions.LIVINGROOM_VIDEO_E,PageDefinitions.LIVINGROOM_VIDEO_F,PageDefinitions.LANDING];
         loaderProgress.monitorPages(new MultiPageLoadProgressMeterInfo(_loc1_,handlePreloadStageBReady));
         BigAndSmallMultiPageLoadProgressMeter(loaderProgress).banishWallpaper();
      }
      
      private function initApp() : void
      {
         stageColourClip = new Shape();
         stage.addChild(stageColourClip);
         stage.setChildIndex(stageColourClip,0);
         addChild(uiLayer);
         XMLLocations.prefixURL = configXML.assetFolder.(@id == "xml").toString();
         DAELocations.prefixURL = configXML.assetFolder.(@id == "3d").toString();
         SWFLocations.prefixURL = configXML.assetFolder.(@id == "swf").toString();
         FLVLocations.prefixURL = configXML.assetFolder.(@id == "flv").toString();
         shareManager.addReference(new SharerInfo("VideoFileA",configXML.assetFile.(@id == "videoA")));
         shareManager.addReference(new SharerInfo("VideoFileB",configXML.assetFile.(@id == "videoB")));
         shareManager.addReference(new SharerInfo("VideoFileC",configXML.assetFile.(@id == "videoC")));
         shareManager.addReference(new SharerInfo("VideoFileD",configXML.assetFile.(@id == "videoD")));
         shareManager.addReference(new SharerInfo("VideoFileE",configXML.assetFile.(@id == "videoE")));
         shareManager.addReference(new SharerInfo("VideoFileF",configXML.assetFile.(@id == "videoF")));
         shareManager.addReference(new SharerInfo("VideoFileG",configXML.assetFile.(@id == "videoG")));
         shareManager.addReference(new SharerInfo("VideoFileH",configXML.assetFile.(@id == "videoH")));
         initUI();
         initPages();
         initPageTransitions();
         debugMode(false);
         loaderProgress.monitorPages(new MultiPageLoadProgressMeterInfo([PageDefinitions.PRELOADER,PageDefinitions.FRONTOFHOUSE],handlePreloadStageAReady));
      }
      
      private function handleGlobalAssetsReady(param1:Event) : void
      {
         globalAssets.removeEventListener("GlobalAssetsReady",handleGlobalAssetsReady);
         BrainLogger.out("handleGlobalAssetsReady!");
         outputHelperText(preloader);
      }
      
      private function initDebugUI() : void
      {
         this.stage.addEventListener(MouseEvent.CLICK,handleStageClick);
      }
   }
}

