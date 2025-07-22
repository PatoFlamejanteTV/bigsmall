package net.pluginmedia.bigandsmall.pages
{
   import flash.display.MovieClip;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DAELocations;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.bigandsmall.pages.shared.DoorEvent;
   import net.pluginmedia.bigandsmall.ui.VPortLayerComponent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.loading.DAEAssetLoader;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class FrontOfHouse extends BigAndSmallPage3D
   {
      
      private var fauxInteriorLayer:ViewportLayer;
      
      private var sDoorDae:DAEFixed;
      
      private var bigsDoorKnobMat:MovieParticleMaterial;
      
      private var floor:DAEFixed;
      
      private var doorsAnimatingLast:Number;
      
      private var smallsDoorKnobMat:MovieParticleMaterial;
      
      private var transStartTime:uint;
      
      private var bigsDoorLayer:ViewportLayer;
      
      private var smallsDoor:Door3D;
      
      private var floorLayer:ViewportLayer;
      
      private var frontOfHouse:DAEFixed;
      
      private var smallsDoorKnob:PointSprite;
      
      private var bDoorDae:DAEFixed;
      
      private var wallLayer:ViewportLayer;
      
      private var bigsDoor:Door3D;
      
      private var bigsDoorButton:VPortLayerComponent;
      
      private var bigsDoorKnob:PointSprite;
      
      private var doorsAnimating:Number = 0;
      
      private var voxTimerA:Timer;
      
      private var smallsDoorLayer:ViewportLayer;
      
      private var voxTimerB:Timer;
      
      private var smallsDoorButton:VPortLayerComponent;
      
      private var fauxInterior:Plane;
      
      private var assetLib:AssetLoader;
      
      private var entered:Boolean = false;
      
      public function FrontOfHouse(param1:BasicView, param2:String)
      {
         var _loc3_:Number3D = null;
         doorsAnimatingLast = doorsAnimating;
         _loc3_ = new Number3D(0,5,-285);
         var _loc4_:OrbitCamera3D = new OrbitCamera3D(70);
         _loc4_.rotationYMin = 1;
         _loc4_.rotationYMax = -1;
         _loc4_.radius = 1010;
         _loc4_.rotationXMin = 2;
         _loc4_.rotationXMax = 1;
         _loc4_.orbitCentre.x = _loc3_.x + 30;
         _loc4_.orbitCentre.y = _loc3_.y + 130;
         _loc4_.orbitCentre.z = 500;
         super(param1,_loc3_,_loc4_,_loc4_,param2);
      }
      
      private function handleDoorAnimBegins(param1:Event) : void
      {
         ++doorsAnimating;
      }
      
      private function handleVoxComplete(param1:String) : void
      {
         if(isActive)
         {
            SoundManagerOld.playSound(param1);
         }
      }
      
      private function handleDoorAnimShut(param1:DoorEvent) : void
      {
         var _loc2_:SoundInfoOld = new SoundInfoOld(1 - 1 / (Math.abs(param1.shutVel) + 1));
         SoundManagerOld.playSound("hf_door_close",_loc2_);
      }
      
      private function removeDoorListeners(param1:VPortLayerComponent, param2:Door3D) : void
      {
         param2.removeEventListener(Door3D.EV_ANIM_BEGIN,handleDoorAnimBegins);
         param2.removeEventListener(Door3D.EV_ANIM_END,handleDoorAnimEnds);
         param2.removeEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         param2.removeEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         param1.removeEventListener(MouseEvent.CLICK,handleDoorClicked);
         param1.removeEventListener(MouseEvent.ROLL_OVER,handleDoorOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,handleDoorOut);
         param1.setEnabledState(false);
      }
      
      private function receiveSWFAssets(param1:IAssetLoader) : void
      {
         assetLib = param1 as AssetLoader;
      }
      
      private function handleVoxTimerA(param1:TimerEvent) : void
      {
         voxTimerA.reset();
         SoundManagerOld.playSound("hf_sml_intro_youwantto");
      }
      
      private function handleVoxTimerB(param1:TimerEvent) : void
      {
         SoundManagerOld.playSound("hf_sml_time1_idluvto");
         voxTimerB.stop();
      }
      
      override protected function build() : void
      {
      }
      
      override public function collectionQueueEmpty() : void
      {
         initFauxInterior();
         initSounds();
         floorLayer = basicView.viewport.getChildLayer(floor,true);
         wallLayer = basicView.viewport.getChildLayer(frontOfHouse,true);
         wallLayer.screenDepth = 180;
         wallLayer.forceDepth = true;
         fauxInteriorLayer = basicView.viewport.getChildLayer(fauxInterior,true);
         fauxInterior.z = frontOfHouse.z + 15;
         fauxInterior.y += 140;
         initBigKnob(assetLib.getAssetByName("SmallDoorKnob"));
         initSmallKnob(assetLib.getAssetByName("BigDoorKnob"));
         smallsDoorLayer = basicView.viewport.getChildLayer(smallsDoor,true);
         smallsDoorButton = new VPortLayerComponent(smallsDoorLayer);
         AccessibilityManager.addAccessibilityProperties(smallsDoorLayer,"Small\'s door","Enter the house as Small",AccessibilityDefinitions.FRONTOFHOUSE_DOOR);
         bigsDoorLayer = basicView.viewport.getChildLayer(bigsDoor,true);
         bigsDoorButton = new VPortLayerComponent(bigsDoorLayer);
         AccessibilityManager.addAccessibilityProperties(bigsDoorLayer,"Big\'s door","Enter the house as Big",AccessibilityDefinitions.FRONTOFHOUSE_DOOR);
         var _loc1_:DisplayObject3D = floor.getChildByName("Still",true);
         var _loc2_:DisplayObject3D = floor.getChildByName("Grass1",true);
         var _loc3_:DisplayObject3D = floor.getChildByName("Grass",true);
         var _loc4_:DisplayObject3D = floor.getChildByName("SteppingStones",true);
         var _loc5_:ViewportLayer = basicView.viewport.getChildLayer(_loc2_,true);
         var _loc6_:ViewportLayer = _loc5_.getChildLayer(_loc4_,true);
         var _loc7_:ViewportLayer = basicView.viewport.getChildLayer(_loc1_,true);
         _loc7_.screenDepth = 179;
         _loc7_.forceDepth = true;
         var _loc8_:ViewportLayer = _loc7_.getChildLayer(_loc3_,true);
         registerLiveDO3D(DO3DDefinitions.FRONTOFHOUSE_WALL,frontOfHouse);
         registerLiveDO3D(DO3DDefinitions.FRONTOFHOUSE_DOOR_BIG,bigsDoor);
         registerLiveDO3D(DO3DDefinitions.FRONTOFHOUSE_DOOR_SMALL,smallsDoor);
         registerLiveDO3D(DO3DDefinitions.FRONTOFHOUSE_GARDEN,floor);
         registerLiveDO3D(DO3DDefinitions.FRONTOFHOUSE_FAUXINTERIOR,fauxInterior);
         setReadyState();
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
      }
      
      private function initSounds() : void
      {
         var _loc1_:SoundInfoOld = null;
         voxTimerA = new Timer(1000,1);
         voxTimerA.addEventListener(TimerEvent.TIMER,handleVoxTimerA);
         voxTimerB = new Timer(20000);
         voxTimerB.addEventListener(TimerEvent.TIMER,handleVoxTimerB);
         _loc1_ = new SoundInfoOld(0.05,0,int.MAX_VALUE);
         SoundManagerOld.registerSound(new BrainSoundOld("hf_bg",assetLib.getAssetClassByName("hf_bg"),_loc1_));
         _loc1_ = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         _loc1_.onCompleteFunc = handleVoxComplete;
         _loc1_.onCompleteParams = ["hf_big_intro_hithatbig"];
         SoundManagerOld.registerSound(new BrainSoundOld("hf_sml_intro_youwantto",assetLib.getAssetClassByName("hf_sml_intro_youwantto"),_loc1_));
         _loc1_ = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         _loc1_.onCompleteFunc = handleVoxComplete;
         _loc1_.onCompleteParams = ["hf_sml_intro2_igetthe"];
         SoundManagerOld.registerSound(new BrainSoundOld("hf_big_intro_hithatbig",assetLib.getAssetClassByName("hf_big_intro_hithatbig"),_loc1_));
         _loc1_ = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         _loc1_.onCompleteFunc = handleVoxComplete;
         _loc1_.onCompleteParams = ["hf_both_intro_getmoving"];
         SoundManagerOld.registerSound(new BrainSoundOld("hf_sml_intro2_igetthe",assetLib.getAssetClassByName("hf_sml_intro2_igetthe"),_loc1_));
         _loc1_ = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         SoundManagerOld.registerSound(new BrainSoundOld("hf_both_intro_getmoving",assetLib.getAssetClassByName("hf_both_intro_getmoving"),_loc1_));
         _loc1_ = new SoundInfoOld();
         _loc1_.targetChannel = 1;
         _loc1_.onConflictResponse = SoundInfoOld.CHANCONFLICT_SKIP;
         SoundManagerOld.registerSound(new BrainSoundOld("hf_sml_time1_idluvto",assetLib.getAssetClassByName("hf_sml_time1_idluvto"),_loc1_));
      }
      
      private function removeListeners() : void
      {
         removeDoorListeners(bigsDoorButton,bigsDoor);
         removeDoorListeners(smallsDoorButton,smallsDoor);
      }
      
      private function handleDoorOver(param1:MouseEvent) : void
      {
         var _loc2_:VPortLayerComponent = param1.target as VPortLayerComponent;
         if(_loc2_ === bigsDoorButton)
         {
            bigsDoor.setDoorModelOverState(true);
         }
         else
         {
            smallsDoor.setDoorModelOverState(true);
         }
      }
      
      private function addDoorListeners(param1:VPortLayerComponent, param2:Door3D) : void
      {
         param2.addEventListener(Door3D.EV_ANIM_BEGIN,handleDoorAnimBegins);
         param2.addEventListener(Door3D.EV_ANIM_END,handleDoorAnimEnds);
         param2.addEventListener(Door3D.EV_DOOR_OPENS,handleDoorAnimOpen);
         param2.addEventListener(DoorEvent.SHUT,handleDoorAnimShut);
         param1.addEventListener(MouseEvent.CLICK,handleDoorClicked);
         param1.addEventListener(MouseEvent.ROLL_OVER,handleDoorOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,handleDoorOut);
         param1.setEnabledState(true);
      }
      
      private function recieveFrontOfHouse(param1:IAssetLoader) : void
      {
         frontOfHouse = DAEFixed(DAEAssetLoader(param1).getContent());
         frontOfHouse.rotationY = 180;
         frontOfHouse.scale = 25;
      }
      
      private function initFauxInterior() : void
      {
         var _loc1_:Number = 500;
         var _loc2_:Number = 430;
         var _loc3_:MovieMaterial = new MovieMaterial(assetLib.getAssetByName("FauxInterior"));
         fauxInterior = new Plane(_loc3_,_loc1_,_loc2_);
      }
      
      override public function get dirtyLayers() : Array
      {
         if(doorsAnimating > 0 || doorsAnimatingLast != doorsAnimating)
         {
            if(!_renderStateIsDirty)
            {
               this.flagDirtyLayer(bigsDoorLayer);
               this.flagDirtyLayer(smallsDoorLayer);
            }
         }
         doorsAnimatingLast = doorsAnimating;
         return super.dirtyLayers;
      }
      
      private function handleDoorAnimOpen(param1:Event) : void
      {
         SoundManagerOld.playSound("door_over");
      }
      
      private function receiveBigsDoor(param1:IAssetLoader) : void
      {
         bDoorDae = DAEFixed(DAEAssetLoader(param1).getContent());
         bDoorDae.rotationY = 180;
         bDoorDae.x = 78;
         bDoorDae.scale = 25;
         bigsDoor = new Door3D(bDoorDae);
         bigsDoor.defaultRotY = 180;
         bigsDoor.rotYOnOver = 185;
         bigsDoor.rotYOnOpen = 295;
      }
      
      private function handleDoorAnimEnds(param1:Event) : void
      {
         --doorsAnimating;
      }
      
      private function addListeners() : void
      {
         addDoorListeners(bigsDoorButton,bigsDoor);
         addDoorListeners(smallsDoorButton,smallsDoor);
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("FrontOfHousePage.swfAssets",SWFLocations.frontOfHouseLibrary,receiveSWFAssets);
         dispatchAssetRequest("FrontOfHousePage.daeFrontOfHouse",DAELocations.frontOfHouse,recieveFrontOfHouse);
         dispatchAssetRequest("FrontOfHousePage.daeBigsDoor",DAELocations.frontOfHouseBigsDoor,receiveBigsDoor);
         dispatchAssetRequest("FrontOfHousePage.daeSmallsDoor",DAELocations.frontOfHouseSmallsDoor,receiveSmallsDoor);
         dispatchAssetRequest("FrontOfHousePage.daeFrontOfHouseFloor",DAELocations.frontOfHouseGrass,receiveFloor);
      }
      
      private function handleDoorClicked(param1:MouseEvent) : void
      {
         var _loc2_:VPortLayerComponent = param1.target as VPortLayerComponent;
         if(_loc2_ === bigsDoorButton)
         {
            broadcast(BigAndSmallEventType.CHANGE_CHARACTER_SNAP,CharacterDefinitions.BIG);
         }
         else
         {
            broadcast(BigAndSmallEventType.CHANGE_CHARACTER_SNAP,CharacterDefinitions.SMALL);
         }
         doorEntry();
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM);
      }
      
      public function removeInteriorLayer() : void
      {
         removeChild(fauxInterior);
      }
      
      private function initBigKnob(param1:MovieClip) : void
      {
         bigsDoorKnobMat = new MovieParticleMaterial(param1);
         bigsDoorKnob = new PointSprite(bigsDoorKnobMat,0.175);
         positionDO3D(bigsDoorKnob,5.6,4.9,0.2);
         bDoorDae.addChild(bigsDoorKnob);
      }
      
      private function receiveFloor(param1:IAssetLoader) : void
      {
         floor = DAEFixed(DAEAssetLoader(param1).getContent());
         floor.scale = 25;
         floor.rotationY = 180;
      }
      
      public function doorEntry() : void
      {
         if(entered)
         {
            switch(currentPOV)
            {
               case CharacterDefinitions.BIG:
                  smallsDoor.closeDoor();
                  bigsDoor.openDoor();
                  break;
               case CharacterDefinitions.SMALL:
                  bigsDoor.closeDoor();
                  smallsDoor.openDoor();
            }
            TweenMax.to(fauxInteriorLayer,0.75,{
               "alpha":0,
               "onComplete":removeInteriorLayer
            });
         }
      }
      
      private function initSmallKnob(param1:MovieClip) : void
      {
         smallsDoorKnobMat = new MovieParticleMaterial(param1);
         smallsDoorKnob = new PointSprite(smallsDoorKnobMat,0.135);
         positionDO3D(smallsDoorKnob,3.25,2.67,0.2);
         sDoorDae.addChild(smallsDoorKnob);
      }
      
      override public function park() : void
      {
         super.park();
         var _loc1_:uint = uint(getTimer() - transStartTime);
         BrainLogger.out("deltaTime for transition ::",_loc1_);
         if(_loc1_ > 2300)
         {
            basicView.stage.quality = StageQuality.MEDIUM;
         }
         selfDestruct();
      }
      
      override public function activate() : void
      {
         super.activate();
         addListeners();
         entered = true;
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         SoundManagerOld.playSound("hf_bg");
         voxTimerA.start();
         voxTimerB.start();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         voxTimerA.reset();
         voxTimerA.stop();
         voxTimerB.reset();
         voxTimerB.stop();
         SoundManagerOld.stopSound("hf_bg",1);
         SoundManagerOld.stopSoundChannel(1,1);
         removeListeners();
         transStartTime = getTimer();
         BrainLogger.out("starting performance timer ::",transStartTime);
      }
      
      private function handleDoorOut(param1:MouseEvent) : void
      {
         var _loc2_:VPortLayerComponent = param1.target as VPortLayerComponent;
         if(_loc2_ === bigsDoorButton)
         {
            bigsDoor.setDoorModelOverState(false);
         }
         else
         {
            smallsDoor.setDoorModelOverState(false);
         }
      }
      
      override public function destroy() : void
      {
         frontOfHouse.destroy();
         frontOfHouse = null;
         floor.destroy();
         floor = null;
         bDoorDae.destroy();
         bigsDoor = null;
         sDoorDae.destroy();
         smallsDoor = null;
         smallsDoorKnobMat.destroy();
         smallsDoorKnobMat = null;
         smallsDoorKnob = null;
         bigsDoorKnobMat.destroy();
         bigsDoorKnobMat = null;
         bigsDoorKnob = null;
         fauxInterior = null;
         bigsDoorButton = null;
         smallsDoorButton = null;
         assetLib.unload();
         assetLib = null;
         voxTimerA.removeEventListener(TimerEvent.TIMER,handleVoxTimerA);
         voxTimerA = null;
         voxTimerB.removeEventListener(TimerEvent.TIMER,handleVoxTimerB);
         voxTimerB = null;
         super.destroy();
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         smallsDoorLayer.tabEnabled = param1;
         bigsDoorLayer.tabEnabled = param1;
      }
      
      private function receiveSmallsDoor(param1:IAssetLoader) : void
      {
         sDoorDae = DAEFixed(DAEAssetLoader(param1).getContent());
         sDoorDae.rotationY = 180;
         sDoorDae.x = 200;
         sDoorDae.scale = 25;
         smallsDoor = new Door3D(sDoorDae);
         smallsDoor.defaultRotY = 180;
         smallsDoor.rotYOnOver = 185;
         smallsDoor.rotYOnOpen = 270;
      }
   }
}

