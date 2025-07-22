package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.bathroom.incidentals.ShowerCurtain;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.BathroomGameManager;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.BathroomGameManagerBigPOV;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.BathroomGameManagerSmallPOV;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.ToothpasteManager;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.ShareReferenceEvent;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
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
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class ToothBrushTackle extends BigAndSmallPage3D
   {
      
      private var rDirty:Boolean = false;
      
      private var container2DSmallPOV:Sprite;
      
      private var bigPOVSmallGameSprite:BigGameSmallSpriteTBTackle;
      
      private var smallGameCrosshair:MovieClip;
      
      private var accessClip:Sprite;
      
      private var splatSoundOnMod:int = 7;
      
      private var container2DBigPOV:Sprite;
      
      private var bigJiveSprite:PointSprite;
      
      private var smallBrushingSprite:PointSprite;
      
      private var bigGameManager:BathroomGameManagerBigPOV;
      
      private var bigArm:BigGameArmTBTackle;
      
      private var mirror:Mirror;
      
      protected var toothpasteLayer:ViewportLayer;
      
      private var sharedDock:BathroomGameProgress;
      
      private var smallAimingSprite:PointSprite;
      
      private var bathroomContent:DAEFixed;
      
      private var smallDoneSprite:PointSprite;
      
      private var showerCurtain:ShowerCurtain;
      
      private var smallGameCrosshair2:MovieClip;
      
      private var builtMirrorSnapshots:Boolean = false;
      
      private var smallFlyingSprite:PointSprite;
      
      private var bigPOVSmallSpriteLayer:ViewportLayer;
      
      private var smallSuccessSprite:PointSprite;
      
      protected var toothpasteManager:ToothpasteManager;
      
      private var smallGameManager:BathroomGameManagerSmallPOV;
      
      private var managerState:BathroomGameManager;
      
      private var splatEventCtr:int = 0;
      
      private var smallFailSprite:PointSprite;
      
      private var bathroomModel:DAEFixed;
      
      private var defaultBigCamPosVals:Number3D;
      
      public function ToothBrushTackle(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = null;
         var _loc5_:OrbitCamera3D = null;
         container2DBigPOV = new Sprite();
         container2DSmallPOV = new Sprite();
         defaultBigCamPosVals = new Number3D(-500,556,-742);
         accessClip = new Sprite();
         _loc4_ = new Number3D(-553,350,-728);
         _loc5_ = new OrbitCamera3D(50);
         _loc5_.rotationYMin = 172;
         _loc5_.rotationYMax = 176;
         _loc5_.radius = 135;
         _loc5_.rotationXMin = -23;
         _loc5_.rotationXMax = -18;
         _loc5_.orbitCentre.x = -528;
         _loc5_.orbitCentre.y = 473;
         _loc5_.orbitCentre.z = -688;
         var _loc6_:OrbitCamera3D = new OrbitCamera3D(33);
         _loc6_.rotationYMin = -190;
         _loc6_.rotationYMax = -189.5;
         _loc6_.radius = 184;
         _loc6_.zoom = 28.80000000000004;
         _loc6_.focus = 16.87971711295623;
         _loc6_.rotationXMin = 10;
         _loc6_.rotationXMax = 10.5;
         _loc6_.orbitCentre.x = defaultBigCamPosVals.x;
         _loc6_.orbitCentre.y = defaultBigCamPosVals.y;
         _loc6_.orbitCentre.z = defaultBigCamPosVals.z;
         super(param1,_loc4_,_loc6_,_loc5_,param2);
      }
      
      override public function activate() : void
      {
         super.activate();
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         rDirty = false;
         managerState.activate();
         toothpasteManager.refreshBoundingBoxes();
         basicView.addChild(pageContainer2D);
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
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
         mirror.registerLabelledData("TBTGAME_" + CharacterDefinitions.BIG,_loc2_,-4.25,-6.25,10.5);
         mirror.registerLabelledData("TBTGAME_" + CharacterDefinitions.SMALL,_loc3_,4.75,-20.25,10.5);
         builtMirrorSnapshots = true;
         mirror.selectLabelledData("TBTGAME_" + currentPOV,true);
      }
      
      private function handleRenderStateOn(param1:Event) : void
      {
         rDirty = true;
      }
      
      private function quickRegisterSound(param1:String, param2:int = 1, param3:Number = 1, param4:Number = 0, param5:int = 0, param6:Number = 0) : void
      {
         var _loc7_:SoundInfoOld = new SoundInfoOld(param3,param4,param5,param6,param2);
         SoundManagerOld.registerSound(new BrainSoundOld(param1,unPackAsset(param1),_loc7_));
      }
      
      public function handleShowerCurtainShared(param1:SharerInfo) : void
      {
         showerCurtain = param1.reference as ShowerCurtain;
      }
      
      public function handleBathroomShared(param1:SharerInfo) : void
      {
         bathroomModel = param1.reference as DAEFixed;
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         SoundManagerOld.stopSoundChannel(1);
         managerState.prepare();
         mirrorImageUpdate();
      }
      
      private function handleRenderStateOff(param1:Event) : void
      {
         rDirty = false;
      }
      
      override public function collectionQueueEmpty() : void
      {
         pageContainer2D.addChild(accessClip);
         accessClip.buttonMode = true;
         accessClip.graphics.beginFill(16711935,0);
         accessClip.graphics.drawCircle(0,0,0.5);
         accessClip.graphics.endFill();
         accessClip.x = pageWidth / 2;
         accessClip.y = pageHeight / 2;
         AccessibilityManager.addAccessibilityProperties(accessClip,"Game Input","Interact with the game",AccessibilityDefinitions.BATHROOM_INTERACTIVE);
         sharedDock = new BathroomGameProgress(basicView,unPackAsset("BathroomGameDock"),unPackAsset("BathroomGameProgressBar"),unPackAsset("GameExitButton"));
         pageContainer2D.addChild(sharedDock);
         toothpasteManager = new ToothpasteManager(unPackAsset("ToothpasteParticle1"),unPackAsset("ToothpasteSplats"),basicView);
         toothpasteLayer = basicView.viewport.getChildLayer(toothpasteManager,true);
         toothpasteLayer.forceDepth = true;
         toothpasteLayer.screenDepth = 1;
         toothpasteManager.initLayers(toothpasteLayer);
         registerLiveDO3D(DO3DDefinitions.BATHROOMGAME_TOOTHPASTEMANAGER,toothpasteManager);
         toothpasteManager.addCollisionObject(bathroomModel.getChildByName("floor",true),0.35);
         toothpasteManager.addCollisionObject(bathroomModel.getChildByName("leftwall",true),0.4);
         toothpasteManager.addCollisionObject(bathroomModel.getChildByName("backwall",true),0.4);
         toothpasteManager.addCollisionObject(bathroomModel.getChildByName("ceiling",true),0.4);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("toilet_back",true),0.65);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("sink_top",true),0.85);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("sinkbowl_inside",true),0.7);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("sinkbowl_outside",true),0.6);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("sink_plinth",true),1.1);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("toilet_front_outside",true),0.85);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("stand",true),0.75);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("bath_outside",true),0.4);
         toothpasteManager.addCollisionObject(bathroomContent.getChildByName("toiletseat",true),0.9);
         if(showerCurtain)
         {
            toothpasteManager.addCollisionObject(showerCurtain.lowPolyCurtain,0.5);
            toothpasteManager.addFadeChangeableCollisionObject(showerCurtain.curtain,"open","closed",0.5);
         }
         quickRegisterCollection("ToothpasteSplat",["bath_tooth_pastesplat1","bath_tooth_pastesplat3","bath_tooth_pastesplat4","bath_tooth_pastesplat5"]);
         quickRegisterSound("bath_tooth_smallbouncedown");
         quickRegisterSound("bath_tooth_smallbounceup");
         quickRegisterSound("bath_tooth_brushloop");
         quickRegisterSound("Bath_Big_thankssmall");
         quickRegisterSound("Bath_Small_woohoosohappyteethareclean");
         quickRegisterSound("Bath_Small_yaythatswhaticallclean");
         bigGameManager = new BathroomGameManagerBigPOV(this,container2DBigPOV,this.basicView,sharedDock,this.bigCam as OrbitCamera3D,pageWidth,pageHeight,toothpasteManager,"bath_tooth_brushloop");
         bigGameManager.addEventListener("GAME_EXIT",handleManagerExitIssued);
         bigGameManager.addEventListener(ShareReferenceEvent.SHARE_REFERENCE,handleShareRef);
         initBigGameAssets();
         smallGameManager = new BathroomGameManagerSmallPOV(this,container2DSmallPOV,this.basicView,sharedDock,toothpasteManager,"bath_tooth_brushloop");
         smallGameManager.addEventListener("GAME_EXIT",handleManagerExitIssued);
         smallGameManager.addEventListener(ShareReferenceEvent.SHARE_REFERENCE,handleShareRef);
         initSmallGameAssets();
         setCharacter(currentPOV);
         setReadyState();
      }
      
      private function handleManagerExitIssued(param1:Event) : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BATHROOM);
      }
      
      public function initBigGameAssets() : void
      {
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         bigArm = new BigGameArmTBTackle(unPackAsset("BigArm"));
         var _loc1_:MovieClip = unPackAsset("Small_PSprite_Action_Clockwise");
         var _loc2_:MovieClip = unPackAsset("Small_PSprite_Action_AntiClockwise");
         var _loc3_:MovieClip = unPackAsset("Small_PSprite_Brushed");
         var _loc4_:MovieClip = unPackAsset("Small_PSprite_BrushedRapid");
         var _loc5_:MovieClip = unPackAsset("Small_PSprite_Action_BVoxable");
         var _loc6_:MovieClip = unPackAsset("Small_PSprite_Action_Entry");
         var _loc7_:MovieClip = unPackAsset("Small_PSprite_Action_Exit");
         var _loc8_:MovieClip = unPackAsset("Small_PSprite_Action_RapidExit");
         bigPOVSmallGameSprite = new BigGameSmallSpriteTBTackle(_loc1_,_loc6_,_loc2_,_loc3_,_loc4_,_loc5_,_loc7_,_loc8_,new Number3D(0,0,1),this.position.clone(),0,-105,0.55);
         positionDO3D(bigPOVSmallGameSprite,112,119,-56);
         bigPOVSmallGameSprite.setBaseDepth(bigPOVSmallGameSprite.z);
         bigPOVSmallSpriteLayer = basicView.viewport.getChildLayer(bigPOVSmallGameSprite,true);
         bigPOVSmallSpriteLayer.forceDepth = true;
         bigPOVSmallSpriteLayer.screenDepth = 2;
         var _loc9_:Array = ["VoxCtrl_Small_CoughWalla","VoxCtrl_Small_JumpingBleeeuch","VoxCtrl_Small_AreYouSure"];
         var _loc10_:Array = ["VoxCtrl_Small_KeepPractising","VoxCtrl_Small_Missed"];
         for each(_loc11_ in _loc9_)
         {
            bigPOVSmallGameSprite.registerVoxController(_loc11_,unPackAsset(_loc11_));
         }
         for each(_loc12_ in _loc10_)
         {
            bigPOVSmallGameSprite.registerVoxController(_loc12_,unPackAsset(_loc12_));
         }
         bigPOVSmallGameSprite.splutterVoxableLabels = _loc9_;
         bigPOVSmallGameSprite.missedVoxableLabels = _loc10_;
         bigPOVSmallGameSprite.registerVoxController("VoxCtrl_Small_UhOhFoundToothpaste",unPackAsset("VoxCtrl_Small_UhOhFoundToothpaste"));
         bigPOVSmallGameSprite.registerVoxController("VoxCtrl_Small_AreYouReallyGoing",unPackAsset("VoxCtrl_Small_AreYouReallyGoing"));
         _loc13_ = ["bath_big_getbrushing","bath_big_cmonletsbrushsmallsteeth","bath_big_bettergetbrushing"];
         _loc14_ = ["bath_big_gettingcleaner","bath_big_tadabullseye","bath_big_gotya","bath_big_hehethatsitniceandminty","bath_big_heysmallgotyou","bath_big_heysmallgotyouagain"];
         _loc15_ = ["bath_big_yourjustlucky","bath_big_areweplayingagame","bath_big_bothermissedagain"];
         for each(_loc16_ in _loc13_)
         {
            quickRegisterSound(_loc16_,1);
         }
         for each(_loc16_ in _loc14_)
         {
            quickRegisterSound(_loc16_,1);
         }
         for each(_loc16_ in _loc15_)
         {
            quickRegisterSound(_loc16_,1);
         }
         quickRegisterSound("bath_big_haveagoattoothbrush",1);
         quickRegisterSound("bath_big_tadaididit",1);
         bigGameManager.setBigTimeoutVox(_loc13_);
         bigGameManager.setBigRewardVox(_loc14_);
         bigGameManager.setBigMissedVox(_loc15_);
         bigGameManager.addEventListener("RENDERSTATE_ON",handleRenderStateOn);
         bigGameManager.addEventListener("RENDERSTATE_OFF",handleRenderStateOff);
         if(!bigGameManager.setBigArm(bigArm))
         {
            throw new Error("ToothBrushTackle Error :: setBigArm failed initialise");
         }
         if(!bigGameManager.setSmallGameSprite(bigPOVSmallGameSprite,bigPOVSmallSpriteLayer))
         {
            throw new Error("ToothBrushTackle Error :: setSmallGameSprite failed initialise");
         }
         if(this.mirror)
         {
            bigGameManager.setMirror(this.mirror);
         }
         bigGameManager.setAccessClip(accessClip);
      }
      
      public function handleBathroomMirrorShared(param1:SharerInfo) : void
      {
         mirror = param1.reference as Mirror;
      }
      
      private function mirrorImageUpdate() : void
      {
         if(!mirror)
         {
            return;
         }
         if(mirror)
         {
            mirror.selectLabelledData("TBTGAME_" + currentPOV);
         }
         if(!builtMirrorSnapshots)
         {
            buildMirrorSnapshots();
         }
      }
      
      public function initSmallGameAssets() : void
      {
         var _loc1_:SpriteParticleMaterial = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:Dictionary = null;
         var _loc20_:Array = null;
         var _loc21_:ViewportLayer = null;
         var _loc22_:MovieClip = null;
         var _loc2_:MovieClip = unPackAsset("BigJiveComp");
         _loc1_ = new SpriteParticleMaterial(_loc2_);
         bigJiveSprite = new PointSprite(_loc1_,0.56);
         var _loc3_:MovieClip = unPackAsset("BigBrushedAnim");
         var _loc4_:MovieClip = unPackAsset("BigJiveLowComp");
         var _loc5_:MovieClip = unPackAsset("BigJiveLowCompBrushed");
         var _loc6_:MovieClip = unPackAsset("BigJiveHighToLowRight");
         var _loc7_:MovieClip = unPackAsset("BigJiveHighToLowLeft");
         var _loc8_:MovieClip = unPackAsset("BigExitAnim");
         _loc8_.stop();
         var _loc9_:MovieClip = unPackAsset("SmallAiming");
         _loc1_ = new SpriteParticleMaterial(_loc9_);
         smallAimingSprite = new PointSprite(_loc1_,0.6);
         var _loc10_:MovieClip = unPackAsset("SmallLeapingX");
         _loc1_ = new SpriteParticleMaterial(_loc10_);
         smallFlyingSprite = new PointSprite(_loc1_,0.6);
         var _loc11_:MovieClip = unPackAsset("SmallBrushingX");
         _loc1_ = new SpriteParticleMaterial(_loc11_);
         smallBrushingSprite = new PointSprite(_loc1_,0.6);
         var _loc12_:MovieClip = unPackAsset("SmallPratFallX");
         _loc1_ = new SpriteParticleMaterial(_loc12_);
         smallFailSprite = new PointSprite(_loc1_,0.6);
         var _loc13_:MovieClip = unPackAsset("SmallExit");
         _loc1_ = new SpriteParticleMaterial(_loc13_);
         smallDoneSprite = new PointSprite(_loc1_,0.6);
         var _loc14_:MovieClip = unPackAsset("SmallSuccessX");
         _loc1_ = new SpriteParticleMaterial(_loc14_);
         smallSuccessSprite = new PointSprite(_loc1_,0.6);
         smallGameCrosshair = unPackAsset("SmallGameCrossHair1");
         var _loc15_:Array = smallGameManager.lipSyncManager.smallLipSyncNames;
         var _loc16_:Dictionary = new Dictionary();
         for each(_loc17_ in _loc15_)
         {
            _loc22_ = unPackAsset(_loc17_);
            _loc22_.stop();
            _loc16_[_loc17_] = _loc22_;
         }
         _loc18_ = smallGameManager.lipSyncManager.bigLipSyncNames;
         _loc19_ = new Dictionary();
         for each(_loc17_ in _loc18_)
         {
            _loc22_ = unPackAsset(_loc17_);
            _loc22_.stop();
            _loc19_[_loc17_] = _loc22_;
         }
         _loc20_ = [];
         _loc20_.push(basicView.viewport.getChildLayer(bigJiveSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallAimingSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallFlyingSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallBrushingSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallSuccessSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallFailSprite));
         _loc20_.push(basicView.viewport.getChildLayer(smallDoneSprite));
         for each(_loc21_ in _loc20_)
         {
            _loc21_.forceDepth = true;
            _loc21_.screenDepth = 40;
         }
         bigJiveSprite.container.forceDepth = true;
         bigJiveSprite.container.screenDepth = 50;
         positionDO3D(bigJiveSprite,-30,118,-150);
         positionDO3D(smallAimingSprite,100,-10,-60);
         smallGameManager.setBigJive(_loc2_,bigJiveSprite);
         smallGameManager.setBigLowJive(_loc4_);
         smallGameManager.setBigBrushed(_loc3_);
         smallGameManager.setBigLowBrushed(_loc5_);
         smallGameManager.setBigHighLowRight(_loc6_);
         smallGameManager.setBigHighLowLeft(_loc7_);
         smallGameManager.setBigExit(_loc8_);
         smallGameManager.setAccessClip(accessClip);
         smallGameManager.setSmallAiming(_loc9_,smallAimingSprite);
         smallGameManager.setSmallFlying(_loc10_,smallFlyingSprite);
         smallGameManager.setSmallBrushing(_loc11_,smallBrushingSprite);
         smallGameManager.setSmallSuccess(_loc14_,smallSuccessSprite);
         smallGameManager.setSmallFail(_loc12_,smallFailSprite);
         smallGameManager.setSmallDone(_loc13_,smallDoneSprite);
         smallGameManager.setSmallLipSyncClips(_loc16_);
         smallGameManager.lipSyncManager.setBigLipSyncAnims(_loc19_);
         smallGameManager.setCrosshair(smallGameCrosshair);
         smallGameManager.setRoom(this);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.BATHROOM_ROOM);
         _loc1_.push(DO3DDefinitions.BATHROOM_WINDOW);
         _loc1_.push(DO3DDefinitions.BATHROOM_CONTENT);
         _loc1_.push(DO3DDefinitions.BATHROOM_TSEAT);
         _loc1_.push(DO3DDefinitions.BATHROOM_BUBBLEBATHBOTTLE);
         _loc1_.push(DO3DDefinitions.BATHROOM_SHOWERCURTAIN);
         _loc1_.push(DO3DDefinitions.BATHROOMGAME_TOOTHPASTEMANAGER);
         _loc1_.push(DO3DDefinitions.BATHROOM_LOPOLYVIDEOFRAME);
         _loc1_.push(DO3DDefinitions.BATHROOM_SINKTAPS);
         _loc1_.push(DO3DDefinitions.BATHROOM_SINKHANDLELEFT);
         _loc1_.push(DO3DDefinitions.BATHROOM_SINKHANDLERIGHT);
         return _loc1_.concat(managerState.getLiveVisibleDisplayObjects());
      }
      
      public function handleBathroomContentShared(param1:SharerInfo) : void
      {
         bathroomContent = param1.reference as DAEFixed;
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         if(!this.isLive)
         {
            return;
         }
         toothpasteLayer.screenDepth = currentPOV == CharacterDefinitions.BIG ? 1 : 41;
         if(Boolean(managerState) && managerState.active)
         {
            managerState.update(param1);
         }
         if(toothpasteManager.update())
         {
            flagDirtyLayer(toothpasteLayer);
         }
         if(mirror)
         {
            mirror.update();
         }
         if(rDirty)
         {
            this.renderStateIsDirty = true;
         }
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("Bathroom.GAMELIB_SHARED",SWFLocations.bathroomTBGameShared,assetLibLoaded);
         dispatchAssetRequest("Bathroom.GAMELIB_BIG",SWFLocations.bathroomTBGameBig,assetLibLoaded);
         dispatchAssetRequest("Bathroom.GAMELIB_BIG_VOX",SWFLocations.bathroomTBGameBigVox,assetLibLoaded);
         dispatchAssetRequest("Bathroom.GAMELIB_SMALL",SWFLocations.bathroomTBGameSmall,assetLibLoaded);
         dispatchAssetRequest("Bathroom.GAMELIB_SMALL_VOX",SWFLocations.bathroomTBGameSmallVox,assetLibLoaded);
         dispatchAssetRequest("Bathroom.GAMELIB_SMALL_VOX_BIG",SWFLocations.bathroomTBGameSmallVoxbig,assetLibLoaded);
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(pageContainer2D.contains(container2DSmallPOV))
         {
            pageContainer2D.removeChild(container2DSmallPOV);
         }
         if(pageContainer2D.contains(container2DBigPOV))
         {
            pageContainer2D.removeChild(container2DBigPOV);
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            managerState = bigGameManager;
            pageContainer2D.addChild(container2DBigPOV);
            _overrideRenderFlag = false;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            managerState = smallGameManager;
            _overrideRenderFlag = false;
            pageContainer2D.addChild(container2DSmallPOV);
         }
         if(sharedDock)
         {
            pageContainer2D.setChildIndex(sharedDock,pageContainer2D.numChildren - 1);
         }
         broadcast(BigAndSmallEventType.REFRESH_LIVEDISPLAYOBJECTS);
         if(Boolean(mirror) && isLive)
         {
            mirror.selectLabelledData("TBTGAME_" + param1);
         }
      }
      
      override protected function build() : void
      {
      }
      
      override public function park() : void
      {
         super.park();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         managerState.park();
      }
      
      private function quickRegisterCollection(param1:String, param2:Array, param3:int = -1) : void
      {
         var _loc5_:String = null;
         var _loc6_:SoundInfoOld = null;
         var _loc7_:BrainSoundOld = null;
         var _loc4_:BrainSoundCollectionOld = new BrainSoundCollectionOld(param1,new SoundInfoOld(1,0,0,0,param3));
         for each(_loc5_ in param2)
         {
            _loc6_ = new SoundInfoOld(1,0,0,0,param3);
            _loc7_ = new BrainSoundOld(_loc5_,this.unPackAsset(_loc5_,true),_loc6_);
            _loc4_.pushSound(_loc7_);
         }
         SoundManagerOld.registerSoundCollection(_loc4_);
      }
      
      override public function onShareableRegistration() : void
      {
         var _loc1_:ShareRequest = null;
         _loc1_ = new ShareRequest(this,DO3DDefinitions.BATHROOM_ROOM,handleBathroomShared);
         this.dispatchShareRequest(_loc1_);
         _loc1_ = new ShareRequest(this,"BathroomMirror",handleBathroomMirrorShared);
         this.dispatchShareRequest(_loc1_);
         _loc1_ = new ShareRequest(this,DO3DDefinitions.BATHROOM_SHOWERCURTAIN,handleShowerCurtainShared);
         this.dispatchShareRequest(_loc1_);
         _loc1_ = new ShareRequest(this,DO3DDefinitions.BATHROOM_CONTENT,handleBathroomContentShared);
         this.dispatchShareRequest(_loc1_);
      }
      
      override public function deactivate() : void
      {
         OrbitCamera3D(bigCam).orbitCentre.x = defaultBigCamPosVals.x;
         OrbitCamera3D(bigCam).orbitCentre.y = defaultBigCamPosVals.y;
         OrbitCamera3D(bigCam).orbitCentre.z = defaultBigCamPosVals.z;
         toothpasteManager.clearLayers();
         super.deactivate();
         managerState.deactivate();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
      }
      
      private function handleShareRef(param1:ShareReferenceEvent) : void
      {
         dispatchEvent(new ShareReferenceEvent(ShareReferenceEvent.SHARE_REFERENCE,param1.sharerInfo));
      }
   }
}

