package net.pluginmedia.bigandsmall.pages
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.ScreenDepthDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.events.FlagDirtyLayersEvent;
   import net.pluginmedia.bigandsmall.pages.garden.GardenDAEController;
   import net.pluginmedia.bigandsmall.pages.garden.RailCamPositionManager;
   import net.pluginmedia.bigandsmall.pages.garden.characters.IGardenCharacter;
   import net.pluginmedia.bigandsmall.pages.garden.characters.big.BigLoungingController;
   import net.pluginmedia.bigandsmall.pages.garden.characters.small.ISmallGardenState;
   import net.pluginmedia.bigandsmall.pages.garden.characters.small.SmallGardenStateJumping;
   import net.pluginmedia.bigandsmall.pages.garden.characters.small.SmallGardenStateRunning;
   import net.pluginmedia.bigandsmall.pages.garden.characters.small.SmallSpriteGardenStateController;
   import net.pluginmedia.bigandsmall.pages.garden.parralax.GardenParallax;
   import net.pluginmedia.bigandsmall.pages.garden.pond.PondObjectManager;
   import net.pluginmedia.bigandsmall.pages.garden.pond.fish.PondFishManager;
   import net.pluginmedia.bigandsmall.pages.garden.pond.fish.ReflectingFish;
   import net.pluginmedia.bigandsmall.pages.garden.pond.frogs.PondFrogManager;
   import net.pluginmedia.bigandsmall.pages.garden.pond.frogs.ReflectingFrog;
   import net.pluginmedia.bigandsmall.pages.garden.pond.statics.ReflectingReeds;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.LowPolyVideo;
   import net.pluginmedia.bigandsmall.ui.StateablePointSpriteButton;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.sound.BrainCollectionSoundFactory;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   import net.pluginmedia.maths.SineOscillator;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.RailCamera;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Garden extends BigAndSmallPage3D
   {
      
      public static const NAVREGION_POND:int = 0;
      
      public static const NAVREGION_VEGPATCH:int = 1;
      
      public static var BIG_VOX_INTRO:String = "Garden.BIG_VOX_INTRO";
      
      public static var BIG_VOX_TIMEOUT_I:String = "Garden.BIG_VOX_TIMEOUT_I";
      
      public static var BIG_VOX_TIMEOUT_II:String = "Garden.BIG_VOX_TIMEOUT_II";
      
      public static var BIG_VOX_TIMEOUT_III:String = "Garden.BIG_VOX_TIMEOUT_III";
      
      public static var BIG_VOX_TIMEOUT_IV:String = "Garden.BIG_VOX_TIMEOUT_IV";
      
      public static var BIG_VOX_TIMEOUT_V:String = "Garden.BIG_VOX_TIMEOUT_V";
      
      public static var BIG_VOX_TIMEOUT_VI:String = "Garden.BIG_VOX_TIMEOUT_VI";
      
      public static var BIG_VOX_TIMEOUTS:Array = [BIG_VOX_TIMEOUT_I,BIG_VOX_TIMEOUT_II,BIG_VOX_TIMEOUT_III,BIG_VOX_TIMEOUT_IV,BIG_VOX_TIMEOUT_V,BIG_VOX_TIMEOUT_VI];
      
      public static var BIG_VOX_ROLLOVER_TOLIVINGROOM:String = "Garden.BIG_VOX_ROLLOVER_TOLIVINGROOM";
      
      public static var BIG_VOX_ROLLOVER_BFLYHOUSE:String = "Garden.BIG_VOX_ROLLOVER_BFLYHOUSE";
      
      public static var BIG_VOX_ROLLOVER_LILYPAD:String = "Garden.BIG_VOX_ROLLOVER_LILYPAD";
      
      public static var BIG_VOX_VICINITY_WOODS:String = "Garden.BIG_VOX_VICINITY_WOODS";
      
      public static var BIG_VOX_VICINITY_POND:String = "Garden.BIG_VOX_VICINITY_POND";
      
      public static var BIG_VOX_VICINITY_TREE:String = "Garden.BIG_VOX_VICINITY_TREE";
      
      public static var BIG_VOX_VICINITY_VEGPATCH:String = "Garden.BIG_VOX_VICINITY_VEGPATCH";
      
      public static var BIG_VOX_FROGRESPONSE_JUMPDIVELEFT:String = "Garden.BIG_VOX_FROGRESPONSE_JUMPDIVELEFT";
      
      public static var BIG_VOX_FROGRESPONSE_JUMPDIVERIGHT:String = "Garden.BIG_VOX_FROGRESPONSE_JUMPDIVERIGHT";
      
      public static var BIG_VOX_FROGRESPONSE_SIDEKICK:String = "Garden.BIG_VOX_FROGRESPONSE_SIDEKICK";
      
      public static var BIG_VOX_FROGRESPONSE_SPIN:String = "Garden.BIG_VOX_FROGRESPONSE_SPIN";
      
      public static var BIG_VOX_FROGRESPONSE_BOAT:String = "Garden.BIG_VOX_FROGRESPONSE_BOAT";
      
      public static var BIG_VOX_FROGRESPONSE_GENERIC_I:String = "Garden.BIG_VOX_FROGRESPONSE_GENERIC_I";
      
      public static var BIG_VOX_FROGRESPONSE_GENERIC_II:String = "Garden.BIG_VOX_FROGRESPONSE_GENERIC_II";
      
      public static var BIG_VOX_FROGRESPONSE_GENERIC_III:String = "Garden.BIG_VOX_FROGRESPONSE_GENERIC_III";
      
      public static var BIG_VOX_FROGRESPONSE_GENERIC_IV:String = "Garden.BIG_VOX_FROGRESPONSE_GENERIC_IV";
      
      public static var BIG_VOX_FROGRESPONSE_GENERICS:Array = [BIG_VOX_FROGRESPONSE_GENERIC_I,BIG_VOX_FROGRESPONSE_GENERIC_II,BIG_VOX_FROGRESPONSE_GENERIC_III,BIG_VOX_FROGRESPONSE_GENERIC_IV];
      
      public static var BIG_VOX_FISHRESPONSE_PUFFER:String = "Garden.BIG_VOX_FISHRESPONSE_PUFFER";
      
      public static var BIG_VOX_FISHRESPONSE_JUMPSPLASH:String = "Garden.BIG_VOX_FISHRESPONSE_JUMPSPLASH";
      
      public static var BIG_VOX_FISHRESPONSE_SPOUT:String = "Garden.BIG_VOX_FISHRESPONSE_SPOUT";
      
      public static var SMALL_VOX_INTRO:String = "Garden.SMALL_VOX_INTRO";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEBACK_I:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEBACK_I";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEBACK_II:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEBACK_II";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEBACK_III:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEBACK_III";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEBACKS:Array = [SMALL_VOX_TIMEOUT_HEDGEBACK_I,SMALL_VOX_TIMEOUT_HEDGEBACK_II,SMALL_VOX_TIMEOUT_HEDGEBACK_III];
      
      public static var SMALL_VOX_TIMEOUT_HEDGEFRONT_I:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEFRONT_I";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEFRONT_II:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEFRONT_II";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEFRONT_III:String = "Garden.SMALL_VOX_TIMEOUT_HEDGEFRONT_III";
      
      public static var SMALL_VOX_TIMEOUT_HEDGEFRONTS:Array = [SMALL_VOX_TIMEOUT_HEDGEFRONT_I,SMALL_VOX_TIMEOUT_HEDGEFRONT_II,SMALL_VOX_TIMEOUT_HEDGEFRONT_III];
      
      public static var SMALL_VOX_ROLLOVER_TOLIVINGROOM:String = "Garden.SMALL_VOX_ROLLOVER_TOLIVINGROOM";
      
      public static var SMALL_VOX_ROLLOVER_BFLYHOUSE:String = "Garden.SMALL_VOX_ROLLOVER_BFLYHOUSE";
      
      public static var SMALL_VOX_ROLLOVER_LILYPAD:String = "Garden.SMALL_VOX_ROLLOVER_LILYPAD";
      
      public static var SMALL_VOX_VICINITY_WOODS:String = "Garden.SMALL_VOX_VICINITY_WOODS";
      
      public static var SMALL_VOX_VICINITY_POND:String = "Garden.SMALL_VOX_VICINITY_POND";
      
      public static var SMALL_VOX_VICINITY_TREE:String = "Garden.SMALL_VOX_VICINITY_TREE";
      
      public static var SMALL_VOX_VICINITY_VEGPATCH:String = "Garden.SMALL_VOX_VICINITY_VEGPATCH";
      
      public static var SMALL_VOX_FROGRESPONSE_JUMPDIVELEFT:String = "Garden.SMALL_VOX_FROGRESPONSE_JUMPDIVELEFT";
      
      public static var SMALL_VOX_FROGRESPONSE_JUMPDIVERIGHT:String = "Garden.SMALL_VOX_FROGRESPONSE_JUMPDIVERIGHT";
      
      public static var SMALL_VOX_FROGRESPONSE_SIDEKICK:String = "Garden.SMALL_VOX_FROGRESPONSE_SIDEKICK";
      
      public static var SMALL_VOX_FROGRESPONSE_SPIN:String = "Garden.SMALL_VOX_FROGRESPONSE_SPIN";
      
      public static var SMALL_VOX_FROGRESPONSE_BOAT:String = "Garden.SMALL_VOX_FROGRESPONSE_BOAT";
      
      public static var SMALL_VOX_FROGRESPONSE_GENERIC_I:String = "Garden.SMALL_VOX_FROGRESPONSE_GENERIC_I";
      
      public static var SMALL_VOX_FROGRESPONSE_GENERIC_II:String = "Garden.SMALL_VOX_FROGRESPONSE_GENERIC_II";
      
      public static var SMALL_VOX_FROGRESPONSE_GENERIC_III:String = "Garden.SMALL_VOX_FROGRESPONSE_GENERIC_III";
      
      public static var SMALL_VOX_FROGRESPONSE_GENERIC_IV:String = "Garden.SMALL_VOX_FROGRESPONSE_GENERIC_IV";
      
      public static var SMALL_VOX_FROGRESPONSE_GENERICS:Array = [SMALL_VOX_FROGRESPONSE_GENERIC_I,SMALL_VOX_FROGRESPONSE_GENERIC_II,SMALL_VOX_FROGRESPONSE_GENERIC_III,SMALL_VOX_FROGRESPONSE_GENERIC_IV];
      
      public static var SMALL_VOX_FISHRESPONSE_PUFFER:String = "Garden.SMALL_VOX_FISHRESPONSE_PUFFER";
      
      public static var SMALL_VOX_FISHRESPONSE_JUMPSPLASH:String = "Garden.SMALL_VOX_FISHRESPONSE_JUMPSPLASH";
      
      public static var SMALL_VOX_FISHRESPONSE_SPOUT:String = "Garden.SMALL_VOX_FISHRESPONSE_SPOUT";
      
      public static var SFX_LILY_OVER:String = "Garden.SFX_LILY_OVER";
      
      public static var SFX_LILY_LIFT:String = "Garden.SFX_LILY_LIFT";
      
      public static var SFX_AMBIENCE_COUNTRY:String = "Garden.SFX_AMBIENCE_COUNTRY";
      
      public static var SFX_AMBIENCE_POND:String = "Garden.SFX_AMBIENCE_POND";
      
      public static var SFX_CAMTRACK_BIG:String = "Garden.SFX_CAMTRACK_BIG";
      
      public static var SFX_CAMTRACK_SMALL:String = "Garden.SFX_CAMTRACK_SMALL";
      
      private var ambCountry:IBrainSoundInstance;
      
      private var smallPositionRail:BezierPath3D;
      
      private var smallController:SmallSpriteGardenStateController;
      
      private var vegPatchAccessorOverFilters:Array;
      
      private var vegOuterFilter:GlowFilter = new GlowFilter(16777215,1,16,16,2,2);
      
      private var pondObjectMan:PondObjectManager;
      
      private var timeoutVoxTimer:Timer = new Timer(12500);
      
      private var smallTargetRail:BezierPath3D;
      
      private var doCamUpdate:Boolean = false;
      
      private var pondFishMan:PondFishManager;
      
      private var videoFrameLoPoly:LowPolyVideo;
      
      private var daeController:GardenDAEController;
      
      private var pondFrogMan:PondFrogManager;
      
      private var treeLayerButton:VPortLayerButton;
      
      private var garden_parallax:DisplayObject3D;
      
      private var scrollerArrowRight:Sprite;
      
      private var garden_dae:DAEFixed;
      
      private var toWoodsNav:StateablePointSpriteButton;
      
      private var vegPatchAccessorIsEnabled:Boolean = false;
      
      private var gardenDoor:Door3D;
      
      private var bigPositionRail:BezierPath3D;
      
      private var timeoutVoxTriggerable:Boolean = true;
      
      private var gardenDoorLayer:ViewportLayer;
      
      private var livingRoomDoorKnob:PointSprite;
      
      private var videoFrameLoPolyLayer:ViewportLayer;
      
      private var scrollerArrowLeft:Sprite;
      
      private var ambWalk:IBrainSoundInstance;
      
      private var bFlyHouseLayer:ViewportLayer;
      
      private var toLivingRoomNav:StateablePointSpriteButton;
      
      private var supportingCharacter:IGardenCharacter;
      
      private var livingRoomDoorKnobMat:SpriteParticleMaterial;
      
      private var railManager:RailCamPositionManager;
      
      private var bigController:BigLoungingController;
      
      private var preparedFromPage:String;
      
      private var vegInnerFilter:GlowFilter = new GlowFilter(16777215,1,16,16,2,2,true);
      
      private var ambPond:IBrainSoundInstance;
      
      private var lastTimeoutSoundTriggered:String;
      
      private var earthMound:DisplayObject3D;
      
      private var videoAccessor:VPortLayerButton;
      
      private var tObj:DisplayObject3D;
      
      private var earthMoundButton:VPortLayerButton;
      
      private var bigTargetRail:BezierPath3D;
      
      public var navRegion:int = -1;
      
      public function Garden(param1:BasicView, param2:String)
      {
         vegPatchAccessorOverFilters = [vegOuterFilter];
         timeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleTimeoutVoxTimer);
         var _loc3_:Number3D = new Number3D(-545,-7,-47);
         bigPositionRail = new BezierPath3D(3);
         bigPositionRail.autoPlaceControls = false;
         bigPositionRail.autoSpacePath = false;
         bigPositionRail.addPoint3D(new BezierPoint3D(-3607,184,-1193,new Number3D(-3970,220,-1110),new Number3D(-3530,184,-1213)));
         bigPositionRail.addPoint3D(new BezierPoint3D(-2948,155,-1174,new Number3D(-3167,146,-1196),new Number3D(-2716,165,-1150)));
         bigPositionRail.addPoint3D(new BezierPoint3D(-2184,249,-1050,new Number3D(-2436,219,-1102),new Number3D(-1956,276,-1004)));
         bigPositionRail.addPoint3D(new BezierPoint3D(-1374,288,-874,new Number3D(-1627,292,-934),new Number3D(-1127,293,-815)));
         bigPositionRail.addPoint3D(new BezierPoint3D(-731,306,-723,new Number3D(-807,302,-731),new Number3D(-730,300,-600)));
         bigPositionRail.reCalcSegments();
         bigTargetRail = new BezierPath3D(3);
         bigTargetRail.autoSpacePath = false;
         bigTargetRail.autoPlaceControls = false;
         bigTargetRail.addPoint3D(new BezierPoint3D(-3624,14,411,new Number3D(-3920,135,400),new Number3D(-3497,14,391)));
         bigTargetRail.addPoint3D(new BezierPoint3D(-3039,32,404,new Number3D(-3164,19,398),new Number3D(-2800,57,412)));
         bigTargetRail.addPoint3D(new BezierPoint3D(-2290,220,386,new Number3D(-2498,170,401),new Number3D(-2058,276,373)));
         bigTargetRail.addPoint3D(new BezierPoint3D(-1366,251,347,new Number3D(-1680,287,356),new Number3D(-1123,206,340)));
         bigTargetRail.addPoint3D(new BezierPoint3D(-632,144,308,new Number3D(-733,159,312),new Number3D(-530,180,200)));
         bigTargetRail.reCalcSegments();
         smallPositionRail = new BezierPath3D(9);
         smallPositionRail.autoPlaceControls = false;
         smallPositionRail.autoSpacePath = false;
         smallPositionRail.addPoint3D(new BezierPoint3D(-3832,-97,-416,new Number3D(-4115,-70,-300),new Number3D(-3643,-97,-482)));
         smallPositionRail.addPoint3D(new BezierPoint3D(-3136,-129,-441,new Number3D(-3323,-132,-480),new Number3D(-2884,-124,-389)));
         smallPositionRail.addPoint3D(new BezierPoint3D(-2410,-76,-182,new Number3D(-2698,-121,-214),new Number3D(-2091,-32,-147)));
         smallPositionRail.addPoint3D(new BezierPoint3D(-1460,89,-205,new Number3D(-1770,69,-202),new Number3D(-1179,102,-208)));
         smallPositionRail.addPoint3D(new BezierPoint3D(-625,64,-144,new Number3D(-660,64,-160),new Number3D(-630,64,-110)));
         smallPositionRail.reCalcSegments();
         smallTargetRail = new BezierPath3D(9);
         smallTargetRail.autoPlaceControls = false;
         smallTargetRail.autoSpacePath = false;
         smallTargetRail.addPoint3D(new BezierPoint3D(-3898,15,528,new Number3D(-4105,15,400),new Number3D(-3793,-11,509)));
         smallTargetRail.addPoint3D(new BezierPoint3D(-3121,-115,521,new Number3D(-3368,-111,497),new Number3D(-2899,-118,543)));
         smallTargetRail.addPoint3D(new BezierPoint3D(-2379,181,578,new Number3D(-2596,111,570),new Number3D(-2127,261,587)));
         smallTargetRail.addPoint3D(new BezierPoint3D(-1417,115,509,new Number3D(-1649,133,547),new Number3D(-1145,94,465)));
         smallTargetRail.addPoint3D(new BezierPoint3D(-440,142,405,new Number3D(-707,142,434),new Number3D(-550,95,35)));
         smallTargetRail.reCalcSegments();
         var _loc4_:RailCamera = new RailCamera(bigPositionRail,bigTargetRail);
         var _loc5_:RailCamera = new RailCamera(smallPositionRail,smallTargetRail);
         _loc4_.fov = 28;
         _loc5_.fov = 45;
         super(param1,_loc3_,_loc4_,_loc5_,param2);
         _autoUpdateCamera = false;
      }
      
      private function setActiveCharacter(param1:String) : void
      {
         if(!bigController || !smallController)
         {
            return;
         }
         if(param1 == CharacterDefinitions.SMALL)
         {
            smallController.park();
            bigController.prepare();
            supportingCharacter = bigController;
         }
         else if(param1 == CharacterDefinitions.BIG)
         {
            bigController.park();
            smallController.prepare();
            supportingCharacter = smallController;
         }
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
         SoundManager.registerSound(new BrainCollectionSoundFactory(param1,_loc3_));
      }
      
      private function updateCharacterState() : void
      {
         var _loc1_:ViewportLayer = null;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            smallController.update();
            _loc1_ = smallController.dirtyLayer;
            if(_loc1_)
            {
               this.flagDirtyLayer(_loc1_);
            }
         }
      }
      
      private function handleVideoAccessorOver(param1:Event) : void
      {
         if(timeoutVoxTriggerable)
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_ROLLOVER_BFLYHOUSE);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_ROLLOVER_BFLYHOUSE);
            }
            timeoutVoxTriggerable = false;
         }
      }
      
      private function disableVideoAccessor() : void
      {
         videoAccessor.setEnabledState(false);
      }
      
      private function handleVideoAccessorClick(param1:Event) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_VIDEO);
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         preparedFromPage = param1;
         daeController.overLayer.screenDepth = ScreenDepthDefinitions.GARDEN_OVERLAYER;
         daeController.dirtMoundContainerLyr.screenDepth = ScreenDepthDefinitions.GARDEN_VEGPATCHLAYER;
         hideDoorKnob();
         if(pondObjectMan)
         {
            pondObjectMan.prepare();
         }
         switch(param1)
         {
            case PageDefinitions.GARDEN_VIDEO:
               railManager.setCameraToPosition(0.2);
               break;
            case PageDefinitions.GARDEN_VEGPATCH:
               railManager.setCameraToPosition(0.85);
               break;
            case PageDefinitions.GARDEN_APPLETREE:
               railManager.setCameraToPosition(0.53);
               break;
            case PageDefinitions.MYSTERIOUS_WOODS:
               railManager.setCameraToPosition(0.05);
               break;
            case PageDefinitions.PREGARDEN:
               railManager.setCameraToPosition(0.95);
               break;
            default:
               railManager.setCameraToPosition(0);
         }
         if(navRegion > -1)
         {
            switch(navRegion)
            {
               case NAVREGION_POND:
                  railManager.setCameraToPosition(0.15);
                  break;
               case NAVREGION_VEGPATCH:
                  railManager.setCameraToPosition(0.865);
            }
            navRegion = -1;
         }
         setNavArrowsToCharacterState(this.currentPOV);
         if(currentPOV == CharacterDefinitions.BIG && Boolean(smallController))
         {
            smallController.prepare();
         }
         if(currentPOV == CharacterDefinitions.SMALL && Boolean(bigController))
         {
            bigController.prepare();
         }
      }
      
      override public function getTransitionOmitObjects() : Array
      {
         var _loc1_:Array = super.getTransitionOmitObjects();
         _loc1_.push(DO3DDefinitions.GARDEN_TOLIVINGROOM);
         return _loc1_;
      }
      
      private function enableVideoAccessor() : void
      {
         videoAccessor.setEnabledState(true);
      }
      
      private function handleScrollButtonMouseDown(param1:MouseEvent) : void
      {
         railManager.targetMoveRate = 0.02;
      }
      
      private function initPond() : void
      {
         var _loc7_:ReflectingFrog = null;
         var _loc8_:ReflectingFish = null;
         var _loc1_:BlurFilter = new BlurFilter(10,0);
         var _loc2_:ColorTransform = new ColorTransform(1,1,1,1,-30,-30,-30);
         pondObjectMan = new PondObjectManager(basicView,railManager,daeController,_loc1_,_loc2_);
         var _loc3_:DisplayObject3D = new DisplayObject3D();
         _loc3_.x = -2853;
         _loc3_.y = -276;
         _loc3_.z = 349;
         var _loc4_:ReflectingReeds = new ReflectingReeds(512,256,1,1,unPackAsset("PondHedge",false,BitmapData),daeController.abovePondLyr,daeController.beneathPondLyr,_loc1_,_loc2_,30);
         _loc4_.x = -15;
         _loc4_.y = 215;
         _loc4_.z = 410;
         _loc4_.scale = 2;
         _loc3_.addChild(_loc4_);
         var _loc5_:ReflectingReeds = new ReflectingReeds(256,256,1,1,unPackAsset("StaticReedA"),daeController.abovePondLyr,daeController.beneathPondLyr,_loc1_,_loc2_,15);
         _loc5_.x = 400;
         _loc5_.y = 135;
         _loc5_.z = 200;
         _loc5_.rotationY = 19.5;
         _loc3_.addChild(_loc5_);
         var _loc6_:ReflectingReeds = new ReflectingReeds(256,256,1,1,unPackAsset("StaticReedB"),daeController.abovePondLyr,daeController.beneathPondLyr,_loc1_,_loc2_,30);
         _loc6_.x = 320;
         _loc6_.y = 120;
         _loc6_.z = 315;
         _loc6_.rotationY = 19.5;
         _loc3_.addChild(_loc6_);
         pondObjectMan.staticContainer = _loc3_;
         registerLiveDO3D(DO3DDefinitions.GARDEN_STATICMANAGER,_loc3_);
         pondFrogMan = new PondFrogManager(daeController,_loc1_,_loc2_);
         pondFrogMan.addEventListener(PondFrogManager.NULL_ANIM_BEGINS,handleFrogNullAnim);
         pondFrogMan.addEventListener(PondFrogManager.ANIM_BEGINS,handleFrogAnimBegins);
         pondFrogMan.addEventListener(PondFrogManager.ANIM_COMPLETE,handleFrogAnimComplete);
         pondFrogMan.addEventListener(PondFrogManager.ROLLOVER_REEDS,handleReedsOver);
         positionDO3D(pondFrogMan,-2853,-276,378);
         _loc7_ = pondFrogMan.registerAnim("JUMPDIVELEFT",unPackAsset("Frog_A"),-380,58,-235,0,0,0.85);
         registerAccessibleInteractive(_loc7_.animLayer,"Interactive Frog","Tickle the Frog",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc7_ = pondFrogMan.registerAnim("JUMPDIVERIGHT",unPackAsset("Frog_B"),275,0,120,15,15);
         registerAccessibleInteractive(_loc7_.animLayer,"Interactive Frog","Tickle the Frog",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc7_ = pondFrogMan.registerAnim("SIDEKICK",unPackAsset("Frog_C"),-260,-20,225,-15,30);
         registerAccessibleInteractive(_loc7_.animLayer,"Interactive Frog","Tickle the Frog",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc7_ = pondFrogMan.registerAnim("SPIN",unPackAsset("Frog_D"),405,25,-175,5,30);
         registerAccessibleInteractive(_loc7_.animLayer,"Interactive Frog","Tickle the Frog",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc7_ = pondFrogMan.registerAnim("BOAT",unPackAsset("Frog_E"),-10,5,160,0,36);
         registerAccessibleInteractive(_loc7_.animLayer,"Interactive Frog","Tickle the Frog",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         registerLiveDO3D(DO3DDefinitions.GARDEN_FROGMANAGER,pondFrogMan);
         pondObjectMan.frogManager = pondFrogMan;
         SoundManager.quickRegisterSound(SFX_LILY_OVER,unPackAsset("LilyLift"));
         SoundManager.quickRegisterSound(SFX_LILY_LIFT,unPackAsset("LilyOver"));
         pondFishMan = new PondFishManager(daeController,_loc1_,_loc2_);
         pondFishMan.addEventListener(PondFishManager.ANIM_BEGINS,handleFishAnimBegins);
         pondFishMan.addEventListener(PondFishManager.ANIM_COMPLETE,handleFishAnimComplete);
         pondFishMan.addEventListener(ReflectingFish.ROLLOVER_LILYPAD,handleLilyPadOver);
         positionDO3D(pondFishMan,-2853,-276,378);
         _loc8_ = pondFishMan.registerAnim("SPOUT",unPackAsset("Fish_A_V"),unPackAsset("LilyPad"),SFX_LILY_OVER,SFX_LILY_LIFT,200,10,-75,-2,-120);
         registerAccessibleInteractive(_loc8_.animLayer,"Interactive Fish","Tickle the Fish",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc8_ = pondFishMan.registerAnim("PUFFER",unPackAsset("Fish_A_V2"),unPackAsset("LilyPad2"),SFX_LILY_OVER,SFX_LILY_LIFT,150,-5,105,0,20);
         registerAccessibleInteractive(_loc8_.animLayer,"Interactive Frog","Tickle the Fish",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         _loc8_ = pondFishMan.registerAnim("JUMPSPLASH",unPackAsset("Fish_A_V3"),unPackAsset("LilyPad3"),SFX_LILY_OVER,SFX_LILY_LIFT,150,-5,225,0,-140);
         registerAccessibleInteractive(_loc8_.animLayer,"Interactive Frog","Tickle the Fish",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         registerLiveDO3D(DO3DDefinitions.GARDEN_FISHMANAGER,pondFishMan);
         pondObjectMan.fishManager = pondFishMan;
         pondObjectMan.setCharacter(currentPOV);
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      private function initVegPatchAccessor() : void
      {
         daeController.dirtMoundContainerLyr.addEventListener(MouseEvent.CLICK,handleEarthMoundClicked);
         daeController.dirtMoundContainerLyr.addEventListener(MouseEvent.ROLL_OVER,handleEarthMoundOver);
         daeController.dirtMoundContainerLyr.addEventListener(MouseEvent.ROLL_OUT,handleEarthMoundOut);
         registerAccessibleInteractive(daeController.dirtMoundContainerLyr,"Enter the Vegetable Garden","Vegetable Garden",AccessibilityDefinitions.GARDEN_ACCESSOR);
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
         if(_loc3_)
         {
            this.renderStateIsDirty = true;
            if(param1 is BezierPoint3D)
            {
               bigPositionRail.reCalcSegments();
               bigTargetRail.reCalcSegments();
               smallPositionRail.reCalcSegments();
               smallTargetRail.reCalcSegments();
            }
         }
      }
      
      private function handleFishAnimComplete(param1:Event) : void
      {
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            bigController.speakLine("Garden.BIG_VOX_FISHRESPONSE_" + pondFishMan.currentFishKey);
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            smallController.speakLine("Garden.SMALL_VOX_FISHRESPONSE_" + pondFishMan.currentFishKey);
         }
      }
      
      private function initTreeAccessor() : void
      {
         treeLayerButton = new VPortLayerButton(daeController.treeLyr);
         treeLayerButton.addEventListener(MouseEvent.CLICK,handleTreeViewPortLayerClicked);
         treeLayerButton.addEventListener(MouseEvent.ROLL_OVER,handleTreeViewPortLayerOver);
         treeLayerButton.setEnabledState(_isLive);
         dispatchShareable("TreeLayerButton",treeLayerButton);
         registerAccessibleInteractive(daeController.treeLyr,"Play with the apple tree","Apple Tree",AccessibilityDefinitions.GARDEN_ACCESSOR);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("GARDENHUB.gardenDAE",DAELocations.garden,handleGardenDAELoaded);
         dispatchAssetRequest("GARDENHUB.SFX",SWFLocations.gardenSFX,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.VOX_BIG_I",SWFLocations.gardenVoxBigI,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.VOX_BIG_II",SWFLocations.gardenVoxBigII,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.VOX_SMALL_I",SWFLocations.gardenVoxSmallI,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.VOX_SMALL_II",SWFLocations.gardenVoxSmallII,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.LIB",SWFLocations.gardenLibrary,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.pondLibraryI",SWFLocations.gardenPondLibraryI,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.pondLibraryII",SWFLocations.gardenPondLibraryII,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.charSmall",SWFLocations.gardenLibrarySmall,assetLibLoaded);
         dispatchAssetRequest("GARDENHUB.charBig",SWFLocations.gardenLibraryBig,assetLibLoaded);
      }
      
      private function handleEarthMoundClicked(param1:MouseEvent) : void
      {
         if(vegPatchAccessorIsEnabled)
         {
            broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_VEGPATCH);
         }
      }
      
      private function handleFishAnimBegins(param1:Event) : void
      {
         resetVoxTimeoutTimer();
      }
      
      private function updateScrollArrows(param1:UpdateInfo = null) : void
      {
         if(railManager.camPosition == 0)
         {
            scrollerArrowLeft.filters = [];
            scrollerArrowLeft.visible = false;
         }
         else if(!scrollerArrowLeft.visible)
         {
            scrollerArrowLeft.visible = true;
         }
         if(railManager.camPosition == 1)
         {
            scrollerArrowRight.filters = [];
            scrollerArrowRight.visible = false;
         }
         else if(!scrollerArrowRight.visible)
         {
            scrollerArrowRight.visible = true;
         }
         if(railManager.isPanningLeft)
         {
            scrollerArrowLeft.filters = [new GlowFilter(16777215,1,10,10)];
         }
         else
         {
            scrollerArrowLeft.filters = [];
         }
         if(railManager.isPanningRight)
         {
            scrollerArrowRight.filters = [new GlowFilter(16777215,1,10,10)];
         }
         else
         {
            scrollerArrowRight.filters = [];
         }
      }
      
      private function handleLowPolyVideoDirty(param1:Event) : void
      {
         flagDirtyLayer(bFlyHouseLayer);
      }
      
      private function initVideo() : void
      {
         videoFrameLoPoly = new LowPolyVideo(unPackAsset("FlutterBy"),82,60);
         videoFrameLoPoly.animDelay = 3000;
         positionDO3D(videoFrameLoPoly,-2208,64,583);
         videoFrameLoPoly.rotationY = 40;
         videoFrameLoPoly.addEventListener(LowPolyVideo.DIRTY,handleLowPolyVideoDirty);
         registerLiveDO3D(DO3DDefinitions.GARDEN_LOPOLYVIDEOFRAME,videoFrameLoPoly);
         bFlyHouseLayer = daeController.butterflyHouseLyr;
         videoAccessor = new VPortLayerButton(bFlyHouseLayer);
         videoAccessor.addEventListener(MouseEvent.CLICK,handleVideoAccessorClick);
         videoAccessor.addEventListener(MouseEvent.ROLL_OVER,handleVideoAccessorOver);
         videoFrameLoPolyLayer = bFlyHouseLayer.getChildLayer(videoFrameLoPoly,true,true);
         registerAccessibleInteractive(bFlyHouseLayer,"Watch a video","Butterfly House",AccessibilityDefinitions.GARDEN_ACCESSOR);
      }
      
      override public function transitionProgressOut(param1:Number) : void
      {
         if(param1 < 0.5)
         {
            daeController.overLayer.screenDepth = 1;
            daeController.dirtMoundContainerLyr.screenDepth = 0;
            showDoorKnob();
         }
         else
         {
            daeController.overLayer.screenDepth = ScreenDepthDefinitions.GARDEN_OVERLAYER;
            daeController.dirtMoundContainerLyr.screenDepth = ScreenDepthDefinitions.GARDEN_VEGPATCHLAYER;
            hideDoorKnob();
         }
      }
      
      override public function updateCamera() : Boolean
      {
         if(doCamUpdate)
         {
            return railManager.update();
         }
         return false;
      }
      
      private function initDAE() : void
      {
         daeController = new GardenDAEController(basicView,garden_dae);
         dispatchShareable("Shareable.GardenDAEController",daeController);
         registerLiveDO3D(DO3DDefinitions.GARDEN_DAE,garden_dae);
      }
      
      private function handleTreeViewPortLayerOver(param1:MouseEvent) : void
      {
      }
      
      private function handleFrogNullAnim(param1:Event) : void
      {
      }
      
      private function handleDirtyLayersFlagged(param1:FlagDirtyLayersEvent) : void
      {
         var _loc2_:ViewportLayer = null;
         for each(_loc2_ in param1.dirtyLayers)
         {
            this.flagDirtyLayer(_loc2_);
         }
      }
      
      private function handleToWoodsClicked(param1:MouseEvent) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.MYSTERIOUS_WOODS);
      }
      
      override public function transitionProgressIn(param1:Number) : void
      {
         if(param1 < 0.5)
         {
            hideDoorKnob();
         }
         else
         {
            showDoorKnob();
         }
      }
      
      private function initNavArrowsAndDoor() : void
      {
         var _loc1_:DisplayObject3D = daeController.houseDoorMdl;
         livingRoomDoorKnobMat = new SpriteParticleMaterial(unPackAsset("DoorKnob"));
         livingRoomDoorKnob = new PointSprite(livingRoomDoorKnobMat,0.14);
         livingRoomDoorKnob.x = -5;
         livingRoomDoorKnob.y = 0.2;
         livingRoomDoorKnob.z = -6.8;
         _loc1_.addChild(livingRoomDoorKnob);
         toLivingRoomNav = new StateablePointSpriteButton();
         toLivingRoomNav.registerState(CharacterDefinitions.BIG,unPackAsset("ToLivingRoomBig"),11,216,30,0.85);
         toLivingRoomNav.registerState(CharacterDefinitions.SMALL,unPackAsset("ToLivingRoomSmall"),99,179,220,0.85);
         toLivingRoomNav.viewportLayer = daeController.houseLayer.getChildLayer(toLivingRoomNav,true,true);
         gardenDoorLayer = toLivingRoomNav.viewportLayer.getChildLayer(_loc1_,true,true);
         gardenDoorLayer.getChildLayer(livingRoomDoorKnob,true,true);
         toLivingRoomNav.addEventListener(MouseEvent.CLICK,handleToLivingRoomClicked);
         toLivingRoomNav.addEventListener(MouseEvent.ROLL_OVER,handleToLivingRoomOver);
         registerAccessibleInteractive(toLivingRoomNav.viewportLayer,"Enter the Living Room","Living Room",AccessibilityDefinitions.GARDEN_ACCESSOR);
         registerLiveDO3D(DO3DDefinitions.GARDEN_TOLIVINGROOM,toLivingRoomNav);
         toWoodsNav = new StateablePointSpriteButton();
         toWoodsNav.registerState(CharacterDefinitions.BIG,unPackAsset("ToWoodsBig"),-3340,177,-166,1);
         toWoodsNav.registerState(CharacterDefinitions.SMALL,unPackAsset("ToWoodsSmall"),-3430,41,140,1);
         toWoodsNav.viewportLayer = basicView.viewport.getChildLayer(toWoodsNav,true,true);
         toWoodsNav.addEventListener(MouseEvent.CLICK,handleToWoodsClicked);
         toWoodsNav.addEventListener(MouseEvent.ROLL_OVER,handleToWoodsOver);
         registerAccessibleInteractive(toWoodsNav.viewportLayer,"Enter the Mysterious Woods","Mysterious Woods",AccessibilityDefinitions.GARDEN_ACCESSOR);
         registerLiveDO3D(DO3DDefinitions.GARDEN_TOWOODS,toWoodsNav);
         toLivingRoomNav.selectState(currentPOV);
         toWoodsNav.selectState(currentPOV);
      }
      
      private function handleFrogAnimBegins(param1:Event) : void
      {
         resetVoxTimeoutTimer();
      }
      
      override public function deactivate() : void
      {
         doCamUpdate = false;
         disableVegPatchAccessor();
         if(toLivingRoomNav)
         {
            toLivingRoomNav.deactivate();
         }
         if(toWoodsNav)
         {
            toWoodsNav.deactivate();
         }
         if(supportingCharacter)
         {
            supportingCharacter.deactivate();
         }
         disableVideoAccessor();
         videoFrameLoPoly.deactivate();
         if(pondObjectMan)
         {
            pondObjectMan.deactivate();
         }
         endAmbience();
         if(treeLayerButton)
         {
            treeLayerButton.setEnabledState(false);
         }
         basicView.removeChild(pageContainer2D);
         timeoutVoxTimer.reset();
         timeoutVoxTimer.stop();
         SoundManager.stopChannel(SoundChannelDefinitions.VOX);
         super.deactivate();
      }
      
      private function showDoorKnob() : void
      {
         if(Boolean(livingRoomDoorKnob) && !livingRoomDoorKnob.visible)
         {
            livingRoomDoorKnob.visible = true;
         }
      }
      
      private function handleFrogAnimComplete(param1:Event) : void
      {
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            if(Math.random() < 0.6)
            {
               bigController.speakLine("Garden.BIG_VOX_FROGRESPONSE_" + pondFrogMan.currentFrogKey);
            }
            else
            {
               BIG_VOX_FROGRESPONSE_GENERICS.unshift(BIG_VOX_FROGRESPONSE_GENERICS.pop());
               bigController.speakLine(BIG_VOX_FROGRESPONSE_GENERICS[0]);
            }
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            if(Math.random() < 0.6)
            {
               smallController.speakLine("Garden.SMALL_VOX_FROGRESPONSE_" + pondFrogMan.currentFrogKey);
            }
            else
            {
               SMALL_VOX_FROGRESPONSE_GENERICS.unshift(SMALL_VOX_FROGRESPONSE_GENERICS.pop());
               smallController.speakLine(SMALL_VOX_FROGRESPONSE_GENERICS[0]);
            }
         }
      }
      
      private function beginAmbience() : void
      {
         ambCountry = SoundManager.playSound(SFX_AMBIENCE_COUNTRY,0,0,0,int.MAX_VALUE);
         ambPond = SoundManager.playSound(SFX_AMBIENCE_POND,0,0,0,int.MAX_VALUE);
      }
      
      private function handleTreeViewPortLayerClicked(param1:MouseEvent) : void
      {
         if(isLive)
         {
            broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_APPLETREE);
         }
      }
      
      private function initRailManager() : void
      {
         var _loc1_:Number = 110;
         var _loc2_:Number = 100;
         var _loc3_:Rectangle = new Rectangle(0,_loc1_,_loc2_,pageHeight - _loc1_);
         var _loc4_:Rectangle = new Rectangle(pageWidth - _loc2_,0,_loc2_,pageHeight - _loc1_);
         var _loc5_:Number = 0.5;
         scrollerArrowLeft = unPackAsset("ScrollArrow");
         scrollerArrowLeft.y = pageHeight / 2;
         scrollerArrowLeft.scaleX = scrollerArrowLeft.scaleY = _loc5_;
         scrollerArrowLeft.scaleX *= -1;
         scrollerArrowLeft.x = scrollerArrowLeft.width + 10;
         pageContainer2D.addChild(scrollerArrowLeft);
         scrollerArrowLeft.addEventListener(MouseEvent.MOUSE_DOWN,handleScrollButtonMouseDown);
         scrollerArrowLeft.buttonMode = true;
         scrollerArrowRight = unPackAsset("ScrollArrow");
         scrollerArrowRight.y = pageHeight / 2;
         scrollerArrowRight.scaleX = scrollerArrowRight.scaleY = _loc5_;
         scrollerArrowRight.x = pageWidth - (scrollerArrowRight.width + 10);
         pageContainer2D.addChild(scrollerArrowRight);
         scrollerArrowRight.addEventListener(MouseEvent.MOUSE_DOWN,handleScrollButtonMouseDown);
         scrollerArrowRight.buttonMode = true;
         railManager = new RailCamPositionManager(this.basicView,RailCamera(this.smallCam),_loc3_,RailCamera(this.bigCam),_loc4_);
         railManager.setCharacter(currentPOV);
         basicView.stage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseUp);
      }
      
      private function handleStageMouseUp(param1:MouseEvent) : void
      {
         railManager.targetMoveRate = 0.0055;
      }
      
      private function handleDoorAnimShut(param1:Event) : void
      {
         SoundManagerOld.playSound("hf_door_close");
      }
      
      private function resetVoxTimeoutTimer() : void
      {
         timeoutVoxTimer.reset();
         timeoutVoxTimer.start();
         timeoutVoxTriggerable = false;
      }
      
      private function handleLilyPadOver(param1:Event) : void
      {
         if(timeoutVoxTriggerable)
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_ROLLOVER_LILYPAD);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_ROLLOVER_LILYPAD);
            }
            timeoutVoxTriggerable = false;
         }
      }
      
      private function enableVegPatchAccessor() : void
      {
         vegPatchAccessorIsEnabled = true;
         if(daeController.dirtMoundLyr)
         {
            daeController.dirtMoundContainerLyr.buttonMode = true;
         }
      }
      
      private function handleEarthMoundOver(param1:MouseEvent) : void
      {
         if(vegPatchAccessorIsEnabled)
         {
            daeController.dirtMoundLyr.filters = vegPatchAccessorOverFilters;
         }
      }
      
      private function initCharacters() : void
      {
         initBig();
         initSmall();
      }
      
      private function handleEarthMoundOut(param1:MouseEvent) : void
      {
         daeController.dirtMoundLyr.filters = [];
      }
      
      private function handleToLivingRoomOut(param1:MouseEvent) : void
      {
      }
      
      private function handleDoorAnimProgress(param1:Event) : void
      {
         this.flagDirtyLayer(gardenDoorLayer);
      }
      
      private function updateAmbience() : void
      {
         if(ambCountry)
         {
            ambCountry.volume = railManager.camPosition * 1.35;
         }
         if(ambPond)
         {
            ambPond.volume = (1 - railManager.camPosition) * 0.5;
         }
      }
      
      private function handleGardenDAELoaded(param1:IAssetLoader) : void
      {
         garden_dae = param1.getContent() as DAEFixed;
         garden_dae.scale = 25;
         garden_dae.rotationY = 270;
      }
      
      private function hideDoorKnob() : void
      {
         if(Boolean(livingRoomDoorKnob) && livingRoomDoorKnob.visible)
         {
            livingRoomDoorKnob.visible = false;
            livingRoomDoorKnobMat.removeSprite();
         }
      }
      
      private function endAmbience() : void
      {
         SoundManager.stopSound(SFX_AMBIENCE_COUNTRY,1);
         SoundManager.stopSound(SFX_AMBIENCE_POND,1);
      }
      
      private function initDAECulling() : void
      {
         daeController.initCulling();
         var _loc1_:Rectangle = new Rectangle(-4000,-125,1300,830);
         daeController.addManualCullable(pondObjectMan.frogManager,_loc1_);
         daeController.addManualCullable(pondObjectMan.fishManager,_loc1_);
      }
      
      private function initParallax() : void
      {
         var _loc1_:MovieClip = unPackAsset("GardenParallax_Sky");
         var _loc2_:MovieClip = unPackAsset("GardenParallax_Hill_Front");
         var _loc3_:MovieClip = unPackAsset("GardenParallax_Hill_Mid");
         var _loc4_:MovieClip = unPackAsset("GardenParallax_Hill_Back");
         garden_parallax = new GardenParallax(_loc1_,_loc2_,_loc3_,_loc4_);
         garden_parallax.x = -1400;
         garden_parallax.y = -3008;
         garden_parallax.z = 8000;
         registerLiveDO3D(DO3DDefinitions.GARDEN_PARALLAX,garden_parallax);
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:ViewportLayer = null;
         var _loc3_:* = undefined;
         super.update(param1);
         if(param1.frameCount > 0 && !daeController.cullingInited)
         {
            initDAECulling();
         }
         else
         {
            daeController.update(basicView);
         }
         updateNavArrows(param1);
         updateAmbience();
         updateScrollArrows(param1);
         updateCharacterState();
         if(pondObjectMan)
         {
            pondObjectMan.update();
         }
         for each(_loc2_ in pondObjectMan.dirtyLayers)
         {
            this.flagDirtyLayer(_loc2_);
         }
         if(_isLive)
         {
            for each(_loc3_ in accessInteractiveObjs)
            {
               if(DisplayObject(_loc3_).width == 0 && Boolean(_loc3_.tabEnabled))
               {
                  _loc3_.tabEnabled = false;
               }
               else if(DisplayObject(_loc3_).width > 0 && !_loc3_.tabEnabled)
               {
                  _loc3_.tabEnabled = true;
               }
            }
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.GARDEN_DAE,DO3DDefinitions.GARDEN_VEG_PLANTCONTROLLER,DO3DDefinitions.GARDEN_TREE_APPLES,DO3DDefinitions.GARDEN_NON_INTERACTIVE_TREE_APPLES);
         return _loc1_;
      }
      
      private function handleReedsOver(param1:Event) : void
      {
      }
      
      private function initBig() : void
      {
         bigController = new BigLoungingController(SoundChannelDefinitions.VOX);
         bigController.setContent(unPackAsset("BigChairTurn"),unPackAsset("BigHead_IDLE"),-51,30);
         positionDO3D(bigController,-1388,60,747);
         registerLiveDO3D(DO3DDefinitions.GARDEN_BIG,bigController);
         var _loc1_:ViewportLayer = daeController.overLayer.getChildLayer(bigController,true,true);
         bigController.registerVoxHead(BIG_VOX_INTRO,unPackAsset("gdn_bg_smallyoumadeit"),unPackAsset("BigHead_VOX_INTRO"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_I,unPackAsset("gdn_bg_heysmall"),unPackAsset("BigHead_VOX_TIMEOUT_I"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_II,unPackAsset("gdn_bg_howdoesmy"),unPackAsset("BigHead_VOX_TIMEOUT_II"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_III,unPackAsset("gdn_bg_thisgarden"),unPackAsset("BigHead_VOX_TIMEOUT_III"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_IV,unPackAsset("gdn_bg_gardentime"),unPackAsset("BigHead_VOX_TIMEOUT_IV"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_V,unPackAsset("gdn_bg_smallyoucan"),unPackAsset("BigHead_VOX_TIMEOUT_V"));
         bigController.registerVoxHead(BIG_VOX_TIMEOUT_VI,unPackAsset("gdn_bg_smallthisbook"),unPackAsset("BigHead_VOX_TIMEOUT_VI"));
         bigController.registerVoxHead(BIG_VOX_ROLLOVER_TOLIVINGROOM,unPackAsset("gdn_bg_doyouwantto"),unPackAsset("BigHead_VOX_ROLLOVER_TOLIVINGROOM"));
         bigController.registerVoxHead(BIG_VOX_ROLLOVER_BFLYHOUSE,unPackAsset("but_bg_thebutterfliesare"),unPackAsset("BigHead_VOX_ROLLOVER_BFLYHOUSE"));
         bigController.registerVoxHead(BIG_VOX_ROLLOVER_LILYPAD,unPackAsset("pnd_bg_heysmallcan"),unPackAsset("BigHead_VOX_ROLLOVER_LILYPAD"));
         bigController.registerVoxHead(BIG_VOX_VICINITY_WOODS,unPackAsset("mw_bg_lookattheend"),unPackAsset("BigHead_VOX_VICINITY_WOODS"));
         bigController.registerVoxHead(BIG_VOX_VICINITY_POND,unPackAsset("pnd_bg_thatpond"),unPackAsset("BigHead_VOX_VICINITY_POND"));
         bigController.registerVoxHead(BIG_VOX_VICINITY_TREE,unPackAsset("apl_bg_doyouwanttopick"),unPackAsset("BigHead_VOX_VICINITY_TREE"));
         bigController.registerVoxHead(BIG_VOX_VICINITY_VEGPATCH,unPackAsset("veg_bg_thatstheveg"),unPackAsset("BigHead_VOX_VICINITY_VEGPATCH"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_JUMPDIVELEFT,unPackAsset("pnd_bg_wowifitried"),unPackAsset("BigHead_VOX_FROGRESPONSE_JUMPDIVELEFT"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_JUMPDIVERIGHT,unPackAsset("pnd_bg_wowthats"),unPackAsset("BigHead_VOX_FROGRESPONSE_JUMPDIVERIGHT"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_SIDEKICK,unPackAsset("pnd_bg_whatajump"),unPackAsset("BigHead_VOX_FROGRESPONSE_SIDEKICK"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_SPIN,unPackAsset("pnd_bg_tadastar"),unPackAsset("BigHead_VOX_FROGRESPONSE_SPIN"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_BOAT,unPackAsset("pnd_bg_ahhtwofrogs"),unPackAsset("BigHead_VOX_FROGRESPONSE_BOAT"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_GENERIC_I,unPackAsset("pnd_bg_ribbitreally"),unPackAsset("BigHead_VOX_FROGRESPONSE_GENERIC_I"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_GENERIC_II,unPackAsset("pnd_bg_heyfrogsiremember"),unPackAsset("BigHead_VOX_FROGRESPONSE_GENERIC_II"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_GENERIC_III,unPackAsset("pnd_bg_didyouseethat"),unPackAsset("BigHead_VOX_FROGRESPONSE_GENERIC_III"));
         bigController.registerVoxHead(BIG_VOX_FROGRESPONSE_GENERIC_IV,unPackAsset("pnd_bg_wowasaurusafrog"),unPackAsset("BigHead_VOX_FROGRESPONSE_GENERIC_IV"));
         bigController.registerVoxHead(BIG_VOX_FISHRESPONSE_PUFFER,unPackAsset("pnd_bg_okthatisno"),unPackAsset("BigHead_VOX_FISHRESPONSE_PUFFER"));
         bigController.registerVoxHead(BIG_VOX_FISHRESPONSE_JUMPSPLASH,unPackAsset("pnd_bg_wowasaurus"),unPackAsset("BigHead_VOX_FISHRESPONSE_JUMPSPLASH"));
         bigController.registerVoxHead(BIG_VOX_FISHRESPONSE_SPOUT,unPackAsset("pnd_bg_fishyouare"),unPackAsset("BigHead_VOX_FISHRESPONSE_SPOUT"));
      }
      
      private function setNavArrowsToCharacterState(param1:String) : void
      {
         if(toLivingRoomNav)
         {
            toLivingRoomNav.selectState(param1);
         }
      }
      
      private function updateNavArrows(param1:UpdateInfo = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = railManager.camPosition;
         var _loc4_:Number = 0.975;
         var _loc5_:Number = 0.925;
         if(_loc2_ > _loc4_)
         {
            _loc3_ = 1;
         }
         else if(_loc2_ < _loc4_ && _loc2_ > _loc5_)
         {
            _loc3_ = (_loc2_ - _loc5_) / (_loc4_ - _loc5_);
         }
         else
         {
            _loc3_ = 0;
         }
         toLivingRoomNav.setAlpha(_loc3_);
         var _loc6_:Number = 0.025;
         var _loc7_:Number = 0.075;
         if(_loc2_ < _loc6_)
         {
            _loc3_ = 1;
         }
         else if(_loc2_ < _loc7_ && _loc2_ > _loc6_)
         {
            _loc3_ = (_loc2_ - _loc7_) / (_loc6_ - _loc7_);
         }
         else
         {
            _loc3_ = 0;
         }
         toWoodsNav.setAlpha(_loc3_);
      }
      
      private function handleToLivingRoomOver(param1:MouseEvent) : void
      {
         if(timeoutVoxTriggerable)
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_ROLLOVER_TOLIVINGROOM);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_ROLLOVER_TOLIVINGROOM);
            }
            timeoutVoxTriggerable = false;
         }
      }
      
      private function initSmall() : void
      {
         smallController = new SmallSpriteGardenStateController(SoundChannelDefinitions.VOX);
         registerLiveDO3D(DO3DDefinitions.GARDENHUB_SMALLCONTROLLER,smallController);
         smallController.x = 500;
         smallController.y = 30;
         smallController.z = 75;
         var _loc1_:BezierPath3D = new BezierPath3D();
         _loc1_.autoPlaceControls = false;
         _loc1_.addPoint3D(new BezierPoint3D(-4027,147,1000,new Number3D(-3920,135,1000),new Number3D(-3957,107,1000)));
         _loc1_.addPoint3D(new BezierPoint3D(-3250,20,1000,new Number3D(-3667,-59,1000),new Number3D(-2867,92,1000)));
         _loc1_.addPoint3D(new BezierPoint3D(-2226,160,1000,new Number3D(-2706,176,1000),new Number3D(-1854,122,1000)));
         _loc1_.addPoint3D(new BezierPoint3D(-1095,72,1000,new Number3D(-1536,60,1000),new Number3D(-723,78,1000)));
         _loc1_.addPoint3D(new BezierPoint3D(-460,85,1000,new Number3D(-649,85,1000),new Number3D(-530,180,1000)));
         _loc1_.reCalcSegments();
         var _loc2_:SineOscillator = new SineOscillator(1,1,0);
         var _loc3_:ISmallGardenState = new SmallGardenStateRunning(_loc1_,_loc2_,unPackAsset("Small_RUN"));
         _loc3_.viewportLayer = daeController.beneathPondLyr.getChildLayer(DisplayObject3D(_loc3_),true);
         _loc3_.viewportLayer.forceDepth = true;
         _loc3_.viewportLayer.screenDepth = int.MAX_VALUE - 1;
         smallController.registerState(_loc3_,SmallSpriteGardenStateController.STATE_RUN);
         var _loc4_:ISmallGardenState = new SmallGardenStateJumping(new Number3D(-2280,-28,535),unPackAsset("Small_JUMP"));
         _loc4_.viewportLayer = daeController.overLayer.getChildLayer(DisplayObject3D(_loc4_),true);
         _loc4_.viewportLayer.forceDepth = true;
         _loc4_.viewportLayer.screenDepth = int.MIN_VALUE;
         smallController.registerState(_loc4_,SmallSpriteGardenStateController.STATE_JUMP);
         smallController.registerVox(SMALL_VOX_INTRO,unPackAsset("Small_VoxCtrl_INTRO"),unPackAsset("gdn_sm_whatdoyou"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEBACK_I,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEBACK_I"),unPackAsset("gdn_sm_maybeifi"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEBACK_II,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEBACK_II"),unPackAsset("gdn_sm_yayithink"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEBACK_III,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEBACK_III"),unPackAsset("gdn_sm_yeahgwelf"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEFRONT_I,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEFRONT_I"),unPackAsset("gdn_sm_thisisthegreatest"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEFRONT_II,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEFRONT_II"),unPackAsset("gdn_sm_gooncheck"));
         smallController.registerVox(SMALL_VOX_TIMEOUT_HEDGEFRONT_III,unPackAsset("Small_VoxCtrl_TIMEOUT_HEDGEFRONT_III"),unPackAsset("gdn_sm_wowthisplace"));
         smallController.registerVox(SMALL_VOX_ROLLOVER_TOLIVINGROOM,unPackAsset("Small_VoxCtrl_ROLLOVER_LIVINGROOMNAV"),unPackAsset("gdn_sm_ifyouwant"));
         smallController.registerVox(SMALL_VOX_ROLLOVER_LILYPAD,unPackAsset("Small_VoxCtrl_ROLLOVER_LILYPAD"),unPackAsset("pnd_sm_noneedto"));
         smallController.registerVox(SMALL_VOX_ROLLOVER_BFLYHOUSE,unPackAsset("Small_VoxCtrl_ROLLOVER_BUTTERFLYHOUSE"),unPackAsset("but_sm_aretherebutter"));
         smallController.registerVox(SMALL_VOX_VICINITY_POND,unPackAsset("Small_VoxCtrl_VICINITY_POND"),unPackAsset("pnd_sm_areyoufond"));
         smallController.registerVox(SMALL_VOX_VICINITY_TREE,unPackAsset("Small_VoxCtrl_VICINITY_TREE"),unPackAsset("apl_sm_youvegotto"));
         smallController.registerVox(SMALL_VOX_VICINITY_VEGPATCH,unPackAsset("Small_VoxCtrl_VICINITY_VEGPATCH"),unPackAsset("veg_sm_hmmlotsofmud"));
         smallController.registerVox(SMALL_VOX_VICINITY_WOODS,unPackAsset("Small_VoxCtrl_VICINITY_WOODS"),unPackAsset("mw_sm_yaybig"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_JUMPDIVELEFT,unPackAsset("Small_VoxCtrl_FROGRESPONSE_JUMPDIVELEFT"),unPackAsset("pnd_sm_thatwasthe"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_JUMPDIVERIGHT,unPackAsset("Small_VoxCtrl_FROGRESPONSE_JUMPDIVERIGHT"),unPackAsset("pnd_sm_amazing"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_SPIN,unPackAsset("Small_VoxCtrl_FROGRESPONSE_SPIN"),unPackAsset("pnd_sm_wowasaurusone"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_SIDEKICK,unPackAsset("Small_VoxCtrl_FROGRESPONSE_SIDEKICK"),unPackAsset("pnd_sm_howdidyou"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_BOAT,unPackAsset("Small_VoxCtrl_FROGRESPONSE_BOAT"),unPackAsset("pnd_sm_ionce"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_GENERIC_I,unPackAsset("Small_VoxCtrl_FROGRESPONSE_GENERIC_I"),unPackAsset("pnd_sm_ribbitreally"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_GENERIC_II,unPackAsset("Small_VoxCtrl_FROGRESPONSE_GENERIC_II"),unPackAsset("pnd_sm_wowasaurusafrog"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_GENERIC_III,unPackAsset("Small_VoxCtrl_FROGRESPONSE_GENERIC_III"),unPackAsset("pnd_sm_heyfrogsiremember"));
         smallController.registerVox(SMALL_VOX_FROGRESPONSE_GENERIC_IV,unPackAsset("Small_VoxCtrl_FROGRESPONSE_GENERIC_IV"),unPackAsset("pnd_sm_didyousee"));
         smallController.registerVox(SMALL_VOX_FISHRESPONSE_JUMPSPLASH,unPackAsset("Small_VoxCtrl_FISHRESPONSE_JUMPSPLASH"),unPackAsset("pnd_sm_maybeilltry"));
         smallController.registerVox(SMALL_VOX_FISHRESPONSE_SPOUT,unPackAsset("Small_VoxCtrl_FISHRESPONSE_SPOUT"),unPackAsset("pnd_sm_gofishgofish"));
         smallController.registerVox(SMALL_VOX_FISHRESPONSE_PUFFER,unPackAsset("Small_VoxCtrl_FISHRESPONSE_PUFFER"),unPackAsset("pnd_sm_wowthatsit"));
      }
      
      private function handleToLivingRoomClicked(param1:MouseEvent) : void
      {
         toLivingRoomNav.hide();
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM);
      }
      
      private function handleTimeoutVoxTimer(param1:TimerEvent) : void
      {
         var _loc7_:String = null;
         timeoutVoxTriggerable = true;
         var _loc2_:Number = 0.075;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0.16;
         var _loc5_:Number = 0.5;
         var _loc6_:Number = 0.85;
         if(Math.abs(railManager.camPosition - _loc3_) < _loc2_)
         {
            _loc7_ = "inVicinityWoods";
         }
         else if(Math.abs(railManager.camPosition - _loc4_) < _loc2_)
         {
            _loc7_ = "inVicinityPond";
         }
         else if(Math.abs(railManager.camPosition - _loc5_) < _loc2_)
         {
            _loc7_ = "inVicinityTree";
         }
         else if(Math.abs(railManager.camPosition - _loc6_) < _loc2_)
         {
            _loc7_ = "inVicinityVegPatch";
         }
         else
         {
            _loc7_ = "genericTimeout";
         }
         if(_loc7_ == lastTimeoutSoundTriggered)
         {
            _loc7_ = "genericTimeout";
         }
         if(_loc7_ == "genericTimeout")
         {
            if(SoundManager.isChannelBusy(SoundChannelDefinitions.VOX) || SoundManagerOld.channelOccupied(1))
            {
               return;
            }
            if(currentPOV == CharacterDefinitions.BIG)
            {
               if(smallController.stateLabel == SmallSpriteGardenStateController.STATE_NULL)
               {
                  return;
               }
               if(smallController.stateLabel == SmallSpriteGardenStateController.STATE_JUMP)
               {
                  SMALL_VOX_TIMEOUT_HEDGEFRONTS.unshift(SMALL_VOX_TIMEOUT_HEDGEFRONTS.pop());
                  smallController.speakLine(SMALL_VOX_TIMEOUT_HEDGEFRONTS[0]);
               }
               else if(smallController.stateLabel == SmallSpriteGardenStateController.STATE_RUN)
               {
                  SMALL_VOX_TIMEOUT_HEDGEBACKS.unshift(SMALL_VOX_TIMEOUT_HEDGEBACKS.pop());
                  smallController.speakLine(SMALL_VOX_TIMEOUT_HEDGEBACKS[0]);
               }
            }
            else if(currentPOV == CharacterDefinitions.SMALL)
            {
               BIG_VOX_TIMEOUTS.unshift(BIG_VOX_TIMEOUTS.pop());
               bigController.speakLine(BIG_VOX_TIMEOUTS[0]);
            }
         }
         else if(_loc7_ == "inVicinityWoods")
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_VICINITY_WOODS);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_VICINITY_WOODS);
            }
         }
         else if(_loc7_ == "inVicinityPond")
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_VICINITY_POND);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_VICINITY_POND);
            }
         }
         else if(_loc7_ == "inVicinityTree")
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_VICINITY_TREE);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_VICINITY_TREE);
            }
         }
         else if(_loc7_ == "inVicinityVegPatch")
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               bigController.speakLine(BIG_VOX_VICINITY_VEGPATCH);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               smallController.speakLine(SMALL_VOX_VICINITY_VEGPATCH);
            }
         }
         lastTimeoutSoundTriggered = _loc7_;
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(railManager)
         {
            railManager.setCharacter(param1);
         }
         if(toLivingRoomNav)
         {
            toLivingRoomNav.selectState(param1);
         }
         if(toWoodsNav)
         {
            toWoodsNav.selectState(param1);
         }
         if(pondObjectMan)
         {
            pondObjectMan.setCharacter(param1);
         }
         setActiveCharacter(param1);
      }
      
      private function handleToWoodsOver(param1:MouseEvent) : void
      {
      }
      
      override public function activate() : void
      {
         doCamUpdate = true;
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         enableVegPatchAccessor();
         if(toLivingRoomNav)
         {
            toLivingRoomNav.activate();
            toLivingRoomNav.selectState(currentPOV);
         }
         if(toWoodsNav)
         {
            toWoodsNav.activate();
            toWoodsNav.selectState(currentPOV);
         }
         if(supportingCharacter)
         {
            supportingCharacter.activate();
         }
         enableVideoAccessor();
         videoFrameLoPoly.activate();
         if(pondObjectMan)
         {
            pondObjectMan.activate();
         }
         if(treeLayerButton)
         {
            treeLayerButton.setEnabledState(true);
         }
         beginAmbience();
         basicView.addChild(pageContainer2D);
         if(preparedFromPage != PageDefinitions.MYSTERIOUS_WOODS)
         {
            if(preparedFromPage != PageDefinitions.GARDEN_VEGPATCH)
            {
               if(preparedFromPage != PageDefinitions.GARDEN_APPLETREE)
               {
                  if(preparedFromPage != PageDefinitions.GARDEN_VIDEO)
                  {
                     if(preparedFromPage != PageDefinitions.GARDEN_HUB)
                     {
                        if(currentPOV == CharacterDefinitions.SMALL)
                        {
                           bigController.speakLine(BIG_VOX_INTRO);
                        }
                        else if(currentPOV == CharacterDefinitions.BIG)
                        {
                           smallController.speakLine(SMALL_VOX_INTRO);
                        }
                     }
                  }
               }
            }
         }
         timeoutVoxTimer.start();
         super.activate();
         basicView.singleRender();
      }
      
      private function initAmbience() : void
      {
         SoundManager.quickRegisterSound(SFX_AMBIENCE_COUNTRY,unPackAsset("Ambience_Country"));
         SoundManager.quickRegisterSound(SFX_AMBIENCE_POND,unPackAsset("Ambience_Pond"));
      }
      
      override public function park() : void
      {
         super.park();
         preparedFromPage = null;
         if(pondObjectMan)
         {
            pondObjectMan.park();
         }
         if(smallController)
         {
            smallController.park();
         }
         if(bigController)
         {
            bigController.park();
         }
      }
      
      override public function collectionQueueEmpty() : void
      {
         initRailManager();
         initDAE();
         initVegPatchAccessor();
         initParallax();
         initCharacters();
         initVideo();
         initNavArrowsAndDoor();
         initPond();
         initTreeAccessor();
         initAmbience();
         setActiveCharacter(currentPOV);
         setReadyState();
      }
      
      private function disableVegPatchAccessor() : void
      {
         vegPatchAccessorIsEnabled = false;
         if(daeController.dirtMoundLyr)
         {
            daeController.dirtMoundContainerLyr.buttonMode = false;
            daeController.dirtMoundLyr.filters = [];
         }
      }
   }
}

