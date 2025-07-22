package net.pluginmedia.bigandsmall.pages
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.animation.BigAndSmallCompTransitionFX;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.MysteriousWoodsCamera;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.MysteriousWoodsController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.MysteriousWoodsVoxController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.SegmentTransitionEvent;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.loading.DAEAssetLoader;
   import net.pluginmedia.brain.core.sound.BrainCollectionSoundFactory;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.pv3d.DAEFixed;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class MysteriousWoods extends BigAndSmallPage3D
   {
      
      public static const SFX_Ambience:String = "MysteriousWoods.SFX_Ambience";
      
      public static const SFX_ArrowOver:String = "MysteriousWoods.SFX_ArrowOver";
      
      public static const SFX_SegmentReturn:String = "MysteriousWoods.SFX_ReturnJunction";
      
      public static const SFX_Incidental:String = "MysteriousWoods.SFX_Incidental";
      
      public static const SFX_ToDance:String = "MysteriousWoods.SFX_ToDanceTransition";
      
      private var controller:MysteriousWoodsController;
      
      private var resources:ResourceController;
      
      private var transitionFX:BigAndSmallCompTransitionFX;
      
      public function MysteriousWoods(param1:BasicView, param2:String, param3:BigAndSmallCompTransitionFX)
      {
         var _loc4_:Number3D = new Number3D(-18000,0,8000);
         var _loc5_:MysteriousWoodsCamera = new MysteriousWoodsCamera();
         _loc5_.position = _loc4_;
         transitionFX = param3;
         super(param1,_loc4_,_loc5_,_loc5_,param2);
         _autoUpdateCamera = false;
         resources = new ResourceController();
      }
      
      private function handleIncidentalAppear(param1:Event) : void
      {
         SoundManager.playSound(SFX_Incidental);
      }
      
      private function handleDAELoaded_junction1(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.junctionDAE1 = _loc2_;
      }
      
      private function handleArrowOver(param1:Event) : void
      {
         SoundManager.playSound(SFX_ArrowOver);
      }
      
      override public function prepare(param1:String = null) : void
      {
         controller.prepare();
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SET_STAGE_COLOUR,null,7858676);
      }
      
      override public function onShareableRegistration() : void
      {
      }
      
      private function handleBrainEvent(param1:BrainEvent) : void
      {
         dispatchEvent(new BrainEvent(param1.actionType,param1.actionTarget,param1.data));
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:ViewportLayer = null;
         super.update(param1);
         for each(_loc2_ in controller.dirtyLayers)
         {
            this.flagDirtyLayer(_loc2_);
         }
      }
      
      private function handleDAELoaded_path1(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.pathDAE1 = _loc2_;
      }
      
      private function handleDAELoaded_path2(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.pathDAE2 = _loc2_;
      }
      
      private function handleDAELoaded_path3(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.pathDAE3 = _loc2_;
      }
      
      override public function activate() : void
      {
         super.activate();
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         controller.activate();
         beginAmbience();
      }
      
      private function init() : void
      {
         initResources();
         initVox();
         SoundManager.quickRegisterSound(SFX_Ambience,unPackAsset("SFX_Ambience"));
         SoundManager.quickRegisterSound(SFX_ArrowOver,unPackAsset("SFX_ArrowOver"));
         SoundManager.registerSound(new BrainCollectionSoundFactory(SFX_SegmentReturn,[unPackAsset("SFX_ReturnJunction_I"),unPackAsset("SFX_ReturnJunction_II"),unPackAsset("SFX_ReturnJunction_III")],1,1,BrainCollectionSoundFactory.PSUEDO_RANDOM));
         SoundManager.registerSound(new BrainCollectionSoundFactory(SFX_Incidental,[unPackAsset("SFX_Incidental_I"),unPackAsset("SFX_Incidental_II"),unPackAsset("SFX_Incidental_III"),unPackAsset("SFX_Incidental_IV")],1,1,BrainCollectionSoundFactory.PSUEDO_RANDOM));
         SoundManager.quickRegisterSound(SFX_ToDance,unPackAsset("ToDanceTransMusic"));
         controller = new MysteriousWoodsController(basicView,position,resources,CameraObject3D(smallCam),CameraObject3D(bigCam),transitionFX);
         controller.addEventListener(BrainEvent.ACTION,handleBrainEvent);
         controller.setCharacter(currentPOV);
         controller.addEventListener(SegmentTransitionEvent.RETURN,handleTransitionReturn);
         controller.addEventListener(MysteriousWoodsController.PROMPT_INCIDENTAL_ANIM,handleIncidentalAppear);
         controller.addEventListener(MysteriousWoodsController.PROMPT_ARROW_OVER,handleArrowOver);
         registerLiveDO3D(DO3DDefinitions.MYSTERIOUS_WOODS_SEGMENT_CONTROLLER,controller);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("MysteriousWoods.LibraryI",SWFLocations.mysteriousWoodsAssetsI,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.LibraryII",SWFLocations.mysteriousWoodsAssetsII,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.VOXBig",SWFLocations.mysteriousWoodsVoxBig,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.VOXSmall",SWFLocations.mysteriousWoodsVoxSmall,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.DanceLibrary",SWFLocations.mysteriousWoodsDance,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.SFX",SWFLocations.mysteriousWoodsSFX,assetLibLoaded);
         dispatchAssetRequest("MysteriousWoods.DAE_Path1",DAELocations.mWoods_Path1,handleDAELoaded_path1);
         dispatchAssetRequest("MysteriousWoods.DAE_Path2",DAELocations.mWoods_Path2,handleDAELoaded_path2);
         dispatchAssetRequest("MysteriousWoods.DAE_Path3",DAELocations.mWoods_Path3,handleDAELoaded_path3);
         dispatchAssetRequest("MysteriousWoods.DAE_Junction1",DAELocations.mWoods_Junction1,handleDAELoaded_junction1);
         dispatchAssetRequest("MysteriousWoods.DAE_Reward1",DAELocations.mWoods_Reward1,handleDAELoaded_Reward1);
         dispatchAssetRequest("MysteriousWoods.DAE_FinalSeg",DAELocations.mWoods_FinalSeg,handleDAELoaded_FinalSeg);
      }
      
      override public function updateCamera() : Boolean
      {
         return controller.updateCamera();
      }
      
      private function beginAmbience() : void
      {
         SoundManager.playSound(SFX_Ambience,4,0,0,int.MAX_VALUE);
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(controller)
         {
            controller.setCharacter(param1,_isLive);
         }
      }
      
      private function handleDAELoaded_Reward1(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.rewardDAE1 = _loc2_;
      }
      
      override public function park() : void
      {
         super.park();
         controller.park();
      }
      
      private function handleTransitionReturn(param1:Event) : void
      {
         SoundManager.playSound(SFX_SegmentReturn);
      }
      
      private function initVox() : void
      {
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.END_DANCE,unPackAsset("DanceMusic"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_ACTIVATE,unPackAsset("mw_sm_canyouseeme"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_ROLLOVER_ARROW,unPackAsset("mw_bg_greatan"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_CLICK_ARROW,unPackAsset("mw_bg_smallicant"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_JUNCTION_I,unPackAsset("mw_bg_nowwhichway"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_JUNCTION_II,unPackAsset("mw_bg_oktimeto"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_JUNCTION_III,unPackAsset("mw_bg_smallyoohoosome"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_JUNCTION_IV,unPackAsset("mw_bg_icanhearyouyour"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_I,unPackAsset("mw_sm_biigimhiding"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_II,unPackAsset("mw_sm_idontwant"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_III,unPackAsset("mw_sm_bigisthat"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_IV,unPackAsset("mw_sm_ohcomeon"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_V,unPackAsset("mw_sm_heybigihav"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_VI,unPackAsset("mw_sm_uhuhkeep"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_PROMPT_VII,unPackAsset("mw_sm_woohoogood"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_DEADEND_I,unPackAsset("mw_bg_smalljustpassed"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_DEADEND_II,unPackAsset("mw_bg_heymoleis"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_DEADEND_III,unPackAsset("mw_bg_molewhat"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_DEADEND_IV,unPackAsset("mw_bg_heyatelescope"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_COMPLETION_I,unPackAsset("mw_sm_foundmewoo"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.BIG_COMPLETION_II,unPackAsset("mw_sm_yeahyouare"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_ACTIVATE,unPackAsset("mw_bg_areyoucoming"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_ROLLOVER_ARROW,unPackAsset("mw_sm_biigiknow"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_CLICK_ARROW,unPackAsset("mw_sm_okbigim"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_JUNCTION_I,unPackAsset("mw_sm_okarrows"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_JUNCTION_II,unPackAsset("mw_sm_thiswayor"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_JUNCTION_III,unPackAsset("mw_sm_whichway"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_JUNCTION_IV,unPackAsset("mw_sm_twochoices"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_I,unPackAsset("mw_bg_smallhurry"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_II,unPackAsset("mw_bg_justkeepgoing"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_III,unPackAsset("mw_bg_icanhearyou"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_IV,unPackAsset("mw_bg_heysmallits"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_V,unPackAsset("mw_bg_heysmallstill"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_VI,unPackAsset("mw_bg_tadathatsthe"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_VII,unPackAsset("mw_bg_smallyoohoo"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_PROMPT_VIII,unPackAsset("mw_bg_heysmallitsbeen"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_DEADEND_I,unPackAsset("mw_sm_heymole"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_DEADEND_II,unPackAsset("mw_sm_molewow"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_DEADEND_III,unPackAsset("mw_sm_nosignof"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_DEADEND_IV,unPackAsset("mw_sm_areyousure"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_COMPLETION_I,unPackAsset("mw_bg_tadasmall"));
         SoundManager.quickRegisterSound(MysteriousWoodsVoxController.SMALL_COMPLETION_II,unPackAsset("mw_bg_tadasmallwe"));
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         controller.deactivate();
         killAmbience();
      }
      
      private function initResources() : void
      {
         var _loc4_:MovieClip = null;
         resources.addDecorationTexture(unPackAsset("StraightDecorationA1"),0);
         resources.addDecorationTexture(unPackAsset("StraightDecorationA2"),0);
         resources.addDecorationTexture(unPackAsset("StraightDecorationA3"),0);
         resources.addDecorationTexture(unPackAsset("StraightDecorationB1"),1);
         resources.addDecorationTexture(unPackAsset("StraightDecorationB2"),1);
         resources.addDecorationTexture(unPackAsset("StraightDecorationB3"),1);
         resources.addDecorationTexture(unPackAsset("StraightDecorationC1"),2);
         resources.addDecorationTexture(unPackAsset("StraightDecorationC2"),2);
         resources.addDecorationTexture(unPackAsset("StraightDecorationC3"),2);
         resources.forwardArrowBig = unPackAsset("ForwardArrowBig");
         resources.forwardArrowSmall = unPackAsset("ForwardArrowSmall");
         resources.leftArrowBig = unPackAsset("LeftArrowBig");
         resources.leftArrowSmall = unPackAsset("LeftArrowSmall");
         resources.rightArrowBig = unPackAsset("RightArrowBig");
         resources.rightArrowSmall = unPackAsset("RightArrowSmall");
         resources.addIncidentalAnim(unPackAsset("Incidental_Bird"));
         resources.addIncidentalAnim(unPackAsset("Incidental_Seeds"));
         resources.addIncidentalAnim(unPackAsset("Incidental_Butterfly"));
         resources.addIncidentalAnim(unPackAsset("Incidental_LadyBug"));
         resources.addIncidentalAnim(unPackAsset("Incidental_Leaves"));
         resources.pushBigEndClip(unPackAsset("GameEndClipBig_I"));
         resources.pushBigEndClip(unPackAsset("GameEndClipBig_II"));
         resources.pushSmallEndClip(unPackAsset("GameEndClipSmall_I"));
         resources.pushSmallEndClip(unPackAsset("GameEndClipSmall_II"));
         resources.endDanceClip = MovieClip(unPackAsset("BigAndSmallDance"));
         var _loc1_:MovieClip = MovieClip(unPackAsset("WoodsHedgeTile"));
         var _loc2_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height,false,16711422);
         _loc2_.draw(_loc1_);
         resources.tile = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = MovieClip(unPackAsset("MoleAnim" + _loc3_.toString()));
            _loc4_.gotoAndStop(1);
            resources.addRewardAnim(_loc4_);
            _loc3_++;
         }
      }
      
      private function handleDAELoaded_FinalSeg(param1:DAEAssetLoader) : void
      {
         var _loc2_:DAEFixed = param1.getContent() as DAEFixed;
         resources.finalSegDAE = _loc2_;
      }
      
      override public function collectionQueueEmpty() : void
      {
         init();
         setReadyState();
      }
      
      private function killAmbience() : void
      {
         SoundManager.stopSound(SFX_Ambience);
      }
   }
}

