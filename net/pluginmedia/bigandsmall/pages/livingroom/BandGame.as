package net.pluginmedia.bigandsmall.pages.livingroom
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.livingroom.bandgame.BandPlayer;
   import net.pluginmedia.bigandsmall.pages.livingroom.bandgame.CharDraggableSpawner;
   import net.pluginmedia.bigandsmall.pages.livingroom.bandgame.InstrumentDraggableSpawner;
   import net.pluginmedia.bigandsmall.pages.livingroom.bandgame.LipSyncTimerManager;
   import net.pluginmedia.bigandsmall.pages.livingroom.bandgame.PlayerPointSprite;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.DragDropEvent;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   import net.pluginmedia.brain.core.interfaces.ISpawnDraggable;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.ClickStickManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.DropPoint;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.utils.KeyUtils;
   import net.pluginmedia.utils.SoundPlayer;
   import net.pluginmedia.utils.SuperSound;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BandGame extends BigAndSmallPage3D
   {
      
      private var loopTimer:Timer;
      
      private var voxCounter:int = 0;
      
      private var voxOn:Boolean = false;
      
      protected var _firstTime:Boolean = true;
      
      private var rubyDropPoint:DropPoint;
      
      private var rubySpawner:CharDraggableSpawner;
      
      private var bigSpawner:CharDraggableSpawner;
      
      private var rubyChar:PlayerPointSprite;
      
      private var voxOffset:Number = 0;
      
      public var parentPage:Page3D;
      
      private var voxLeadIn:Number = 0;
      
      private var smallSpawner:CharDraggableSpawner;
      
      private var nullDropPointA:DropPoint;
      
      private var nullDropPointB:DropPoint;
      
      private var nullDropPointC:DropPoint;
      
      private var nullDropPointD:DropPoint;
      
      private var nullDropPointE:DropPoint;
      
      private var backingBandPlayer:BandPlayer;
      
      private var rubySpawnYOffset:Number = 45;
      
      private var bigChar:PlayerPointSprite;
      
      private var smallVPL:ViewportLayer;
      
      private var drums:SuperSound;
      
      private var bigBandPlayer:BandPlayer;
      
      private var clarinetSpawner:InstrumentDraggableSpawner;
      
      private var smallDropPoint:DropPoint;
      
      private var clickStickManager:ClickStickManager;
      
      private var voxTimer:Timer;
      
      private var prevTime:uint;
      
      private var placeBig3D:Number3D;
      
      private var placeSmall3D:Number3D;
      
      private var placeRuby3D:Number3D;
      
      private var violinSpawner:InstrumentDraggableSpawner;
      
      private var voxBandPlayer:BandPlayer;
      
      private var rubyVPL:ViewportLayer;
      
      private var bigDropPoint:DropPoint;
      
      private var tubaSpawner:InstrumentDraggableSpawner;
      
      private var basicViewStage:Stage;
      
      private var loopLength:Number = 0;
      
      private var bigVPL:ViewportLayer;
      
      private var ukeSpawner:InstrumentDraggableSpawner;
      
      protected var lipSyncTimerLength:int = 12000;
      
      private var smallBandPlayer:BandPlayer;
      
      private var rubyBandPlayer:BandPlayer;
      
      private var backButton:AssetButton;
      
      private var trayBG:Sprite;
      
      private var smallChar:PlayerPointSprite;
      
      protected var lipSyncManager:LipSyncTimerManager;
      
      public function BandGame(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = null;
         var _loc5_:OrbitCamera3D = null;
         _loc4_ = new Number3D(-30,140,130);
         _loc5_ = new OrbitCamera3D();
         _loc5_.rotationYMin = 1;
         _loc5_.rotationYMax = -1;
         _loc5_.rotationXMin = 1;
         _loc5_.rotationXMax = -1;
         parentPage = param3;
         _loc5_.orbitCentre.x = -16;
         _loc5_.orbitCentre.y = 164;
         _loc5_.orbitCentre.z = 630;
         _loc5_.radius = 836;
         _loc5_.fov = 35.378472385999885;
         _loc5_.zoom = 40;
         _loc5_.focus = 17.793665504695117;
         super(param1,_loc4_,_loc5_,_loc5_,param2);
         _overrideRenderFlag = false;
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_BUTTONS));
      }
      
      override public function collectionQueueEmpty() : void
      {
         initStage();
         initSounds();
         setReadyState();
      }
      
      private function enableGame() : void
      {
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         violinSpawner.visible = true;
         ukeSpawner.visible = true;
         tubaSpawner.visible = true;
         clarinetSpawner.visible = true;
         backButton.visible = true;
         showChars(true);
         doAnimationsIn();
      }
      
      private function doAnimationsIn() : void
      {
         trayBG.y = pageHeight - trayBG.height;
         TweenMax.from(trayBG,0.5,{"y":pageHeight});
         bigChar.x = placeBig3D.x;
         bigChar.y = placeBig3D.y;
         smallChar.x = placeSmall3D.x;
         smallChar.y = placeSmall3D.y;
         rubyChar.x = placeRuby3D.x;
         rubyChar.y = placeRuby3D.y;
         TweenMax.from(bigChar,0.5,{"x":500});
         TweenMax.from(smallChar,0.5,{"x":-500});
         TweenMax.from(rubyChar,0.5,{
            "y":500,
            "onUpdate":dirtyRenderFlags
         });
         TweenMax.delayedCall(0.5,handleAnimInComplete);
      }
      
      private function spawnerLocationsTo3D() : void
      {
         bigSpawner.x = bigChar.screen.x + basicView.viewport.viewportWidth / 2;
         bigSpawner.y = bigChar.screen.y + basicView.viewport.viewportHeight / 2;
         bigDropPoint.x = bigSpawner.x;
         bigDropPoint.y = bigSpawner.y;
         smallSpawner.x = smallChar.screen.x + basicView.viewport.viewportWidth / 2;
         smallSpawner.y = smallChar.screen.y + basicView.viewport.viewportHeight / 2;
         smallDropPoint.x = smallSpawner.x;
         smallDropPoint.y = smallSpawner.y;
         rubySpawner.x = rubyChar.screen.x + basicView.viewport.viewportWidth / 2;
         rubySpawner.y = rubyChar.screen.y + basicView.viewport.viewportHeight / 2 - rubySpawnYOffset;
         rubyDropPoint.x = rubySpawner.x;
         rubyDropPoint.y = rubySpawner.y;
      }
      
      private function startInstrumentsPlaying(param1:TimerEvent = null) : void
      {
         BrainLogger.out("MUSIC STARTING!");
         backingBandPlayer.begin();
         bigBandPlayer.begin();
         smallBandPlayer.begin();
         rubyBandPlayer.begin();
         voxBandPlayer.begin();
         backingBandPlayer.chooseInstrument("BACKING");
         voxCounter = 0;
         voxTimer = new Timer(voxLeadIn);
         voxTimer.addEventListener(TimerEvent.TIMER,handleVoxTimer);
         voxTimer.start();
         drums.loopSound(int.MAX_VALUE,0);
         addEventListeners();
      }
      
      private function playBigIntroLipSync(param1:AnimationOldEvent) : void
      {
         smallChar.removeEventListener(AnimationOldEvent.COMPLETE,playBigIntroLipSync);
         bigChar.playLipSyncAnim("bd_big_intro_heylets");
         lipSyncManager.reset();
      }
      
      private function handleDrop(param1:DragDropEvent) : void
      {
         var _loc2_:SpawnDraggable = param1.draggable as SpawnDraggable;
         var _loc3_:String = param1.closestTarget.value;
         var _loc4_:String = _loc2_.value;
         BrainLogger.out("handleDrop :: ",_loc4_,_loc3_);
         var _loc5_:CharDraggableSpawner = null;
         var _loc6_:SuperSound = SoundPlayer.getSound("BACKING");
         switch(_loc3_)
         {
            case "BIG":
               _loc5_ = bigSpawner;
               _loc2_.snapToLoc(bigDropPoint.x,bigDropPoint.y,false,handleDropTweenComplete,[_loc2_,bigBandPlayer,_loc4_,bigSpawner]);
               break;
            case "SMALL":
               _loc5_ = smallSpawner;
               _loc2_.snapToLoc(smallDropPoint.x,smallDropPoint.y,false,handleDropTweenComplete,[_loc2_,smallBandPlayer,_loc4_,smallSpawner]);
               break;
            case "RUBY":
               _loc5_ = rubySpawner;
               _loc2_.snapToLoc(rubyDropPoint.x,rubyDropPoint.y,false,handleDropTweenComplete,[_loc2_,rubyBandPlayer,_loc4_,rubySpawner]);
               break;
            case "NULL":
               switch(_loc4_)
               {
                  case "VIOLIN":
                     _loc2_.snapToLoc(violinSpawner.x,violinSpawner.y,false,handleDropTweenComplete,[_loc2_]);
                     break;
                  case "UKE":
                     _loc2_.snapToLoc(ukeSpawner.x,ukeSpawner.y,false,handleDropTweenComplete,[_loc2_]);
                     break;
                  case "TUBA":
                     _loc2_.snapToLoc(tubaSpawner.x,tubaSpawner.y,false,handleDropTweenComplete,[_loc2_]);
                     break;
                  case "CLARINET":
                     _loc2_.snapToLoc(clarinetSpawner.x,clarinetSpawner.y,false,handleDropTweenComplete,[_loc2_]);
               }
         }
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("BandGame.swfAssetLibrary1",SWFLocations.bandGameLibrary1,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfAssetLibrary2",SWFLocations.bandGameLibrary2,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfAssetLibrary3",SWFLocations.bandGameLibrary3,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfSoundLibraryMisc",SWFLocations.bandGameTracksMisc,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfSoundLibraryTuba",SWFLocations.bandGameTracksTuba,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfSoundLibraryUke",SWFLocations.bandGameTracksUke,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfSoundLibraryClarinet",SWFLocations.bandGameTracksClarinet,assetLibLoaded);
         dispatchAssetRequest("BandGame.swfSoundLibraryViolin",SWFLocations.bandGameTracksViolin,assetLibLoaded);
      }
      
      private function updateAnims() : void
      {
         bigChar.doAnimation(bigSpawner.value);
         smallChar.doAnimation(smallSpawner.value);
         if(smallSpawner.value == "CLARINET")
         {
            smallChar.x = placeSmall3D.x - 20;
         }
         else
         {
            smallChar.x = placeSmall3D.x;
         }
         rubyChar.doAnimation(rubySpawner.value);
      }
      
      private function disableGame() : void
      {
         violinSpawner.visible = false;
         ukeSpawner.visible = false;
         tubaSpawner.visible = false;
         clarinetSpawner.visible = false;
         backButton.visible = false;
         end();
         doAnimationsOut();
      }
      
      private function dirtyRenderFlags() : void
      {
         this.flagDirtyLayer(bigVPL);
         this.flagDirtyLayer(smallVPL);
         this.flagDirtyLayer(rubyVPL);
      }
      
      override protected function build() : void
      {
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         disableGame();
      }
      
      private function removeEventListeners() : void
      {
         basicView.stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function getSpawnDataClassForInstrument(param1:String) : Object
      {
         var _loc2_:Object = {
            "dragUserData":null,
            "spawnerUserData":null
         };
         switch(param1)
         {
            case "VIOLIN":
               _loc2_.dragUserData = unPackAsset("Icon_Violin",true);
               _loc2_.spawnerUserData = unPackAsset("Icon_Violin_Shadowed",true);
               break;
            case "UKE":
               _loc2_.dragUserData = unPackAsset("Icon_Uke",true);
               _loc2_.spawnerUserData = unPackAsset("Icon_Uke_Shadowed",true);
               break;
            case "TUBA":
               _loc2_.dragUserData = unPackAsset("Icon_Tuba",true);
               _loc2_.spawnerUserData = unPackAsset("Icon_Tuba_Shadowed",true);
               break;
            case "CLARINET":
               _loc2_.dragUserData = unPackAsset("Icon_Clarinet",true);
               _loc2_.spawnerUserData = unPackAsset("Icon_Clarinet_Shadowed",true);
               break;
            case "NULL":
         }
         return _loc2_;
      }
      
      private function initSounds() : void
      {
         var _loc1_:Class = unPackAsset("BackingTrack",true);
         loopLength = new _loc1_().length;
         SoundManagerOld.registerSound(new BrainSoundOld("BACKING",_loc1_,new SoundInfoOld(0.8,0,int.MAX_VALUE,0,11)));
         voxLeadIn = loopLength;
         voxBandPlayer = new BandPlayer("VOX",0,0.35);
         voxBandPlayer.registerInstrument(unPackAsset("Vox",true),"VOX",0.5);
         backingBandPlayer = new BandPlayer("BACKING");
         backingBandPlayer.registerInstrument(unPackAsset("BackingTrack",true),"BACKING");
         drums = SoundPlayer.addSound("DRUMS",unPackAsset("Drums",true));
         drums.maxVolume = 0.25;
         bigBandPlayer = new BandPlayer("BIG",0.8);
         bigBandPlayer.registerInstrument(unPackAsset("Tuba1",true),"TUBA");
         bigBandPlayer.registerInstrument(unPackAsset("Violin3",true),"VIOLIN",0.9);
         bigBandPlayer.registerInstrument(unPackAsset("Uke3",true),"UKE",1.1);
         bigBandPlayer.registerInstrument(unPackAsset("Clarinet2",true),"CLARINET",0.8);
         smallBandPlayer = new BandPlayer("SMALL",-0.8);
         smallBandPlayer.registerInstrument(unPackAsset("Tuba2",true),"TUBA");
         smallBandPlayer.registerInstrument(unPackAsset("Violin1",true),"VIOLIN",0.9);
         smallBandPlayer.registerInstrument(unPackAsset("Uke2",true),"UKE");
         smallBandPlayer.registerInstrument(unPackAsset("Clarinet3",true),"CLARINET",0.8);
         rubyBandPlayer = new BandPlayer("RUBY");
         rubyBandPlayer.registerInstrument(unPackAsset("Tuba3",true),"TUBA");
         rubyBandPlayer.registerInstrument(unPackAsset("Violin2",true),"VIOLIN",0.9);
         rubyBandPlayer.registerInstrument(unPackAsset("Uke1",true),"UKE");
         rubyBandPlayer.registerInstrument(unPackAsset("Clarinet1",true),"CLARINET",0.8);
      }
      
      private function handleAnimOutComplete() : void
      {
         showChars(false);
         bigSpawner.value = "NULL";
         bigSpawner.spawnDataClass = null;
         smallSpawner.value = "NULL";
         smallSpawner.spawnDataClass = null;
         rubySpawner.value = "NULL";
         rubySpawner.spawnDataClass = null;
         updateAnims();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
      }
      
      private function doAnimationsOut() : void
      {
         var _loc1_:Number = 0.5;
         TweenMax.to(trayBG,_loc1_,{"y":pageHeight});
         TweenMax.to(bigChar,_loc1_,{"x":500});
         TweenMax.to(smallChar,_loc1_,{"x":-500});
         TweenMax.to(rubyChar,_loc1_,{"y":800});
         TweenMax.delayedCall(_loc1_ + 0.75,handleAnimOutComplete);
      }
      
      private function begin() : void
      {
         bigChar.begin();
         smallChar.begin();
         rubyChar.begin();
         startInstrumentsPlaying();
         _firstTime = false;
         smallChar.playLipSyncAnim("bd_sml_intro_blow");
         smallChar.addEventListener(AnimationOldEvent.COMPLETE,playBigIntroLipSync);
         lipSyncManager.start();
      }
      
      private function handleAnimInComplete() : void
      {
         begin();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = backingBandPlayer.currentInstrument.position % backingBandPlayer.currentInstrument.length / backingBandPlayer.currentInstrument.length;
         bigChar.stepFrameUnit(_loc2_);
         smallChar.stepFrameUnit(_loc2_);
         rubyChar.stepFrameUnit(_loc2_);
         if(KeyUtils.isDown(Keyboard.HOME) && KeyUtils.isDown(Keyboard.END))
         {
            drums.volume = 1;
         }
         else if(KeyUtils.isDown(Keyboard.PAGE_DOWN) && KeyUtils.isDown(Keyboard.PAGE_UP))
         {
            drums.volume = 0;
         }
         spawnerLocationsTo3D();
         dirtyRenderFlags();
      }
      
      private function addEventListeners() : void
      {
         basicView.stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      private function handleBackButtonClick(param1:BrainEvent) : void
      {
         broadcast(param1.actionType,param1.actionTarget);
      }
      
      private function handleDropTweenComplete(param1:IDraggable, param2:BandPlayer = null, param3:String = null, param4:DraggableSpawner = null) : void
      {
         if(param4 !== null)
         {
            param4.spawnDataClass = getSpawnDataClassForInstrument(param3).dragUserData;
            param4.setEnabledState(true);
            param4.value = param3;
         }
         clickStickManager.killDraggable(param1);
         if(param2 !== null && param3 !== null)
         {
            param2.chooseInstrument(param3);
            updateAnims();
            lipSyncManager.reset();
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(DO3DDefinitions.LIVINGROOM_FURNITURE);
         _loc1_.push(DO3DDefinitions.LIVINGROOM_PAPER);
         _loc1_.push(DO3DDefinitions.LIVINGROOM_ROOM);
         _loc1_.push(DO3DDefinitions.LIVINGROOM_WINDOW_A);
         return _loc1_.concat(this._do3dList);
      }
      
      private function initStage() : void
      {
         basicViewStage = basicView.stage;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         clickStickManager = new ClickStickManager(basicViewStage);
         clickStickManager.addEventListener(DragDropEvent.DROP,handleDrop);
         clickStickManager.addEventListener(DragDropEvent.PICK_UP,handlePickUp);
         placeBig3D = new Number3D(130,0,20);
         bigChar = new PlayerPointSprite(placeBig3D.x,placeBig3D.y,placeBig3D.z,0.47);
         bigChar.pushAnimState("NULL",unPackAsset("Big_Null") as MovieClip);
         bigChar.pushAnimState("TUBA",unPackAsset("Big_Tuba") as MovieClip);
         bigChar.pushAnimState("VIOLIN",unPackAsset("Big_Violin"));
         bigChar.pushAnimState("UKE",unPackAsset("Big_Uke"));
         bigChar.pushAnimState("CLARINET",unPackAsset("Big_Clarinet"));
         bigVPL = basicView.viewport.getChildLayer(bigChar,true,true);
         bigDropPoint = new DropPoint(unPackAsset("UDDropPoint",true),586,220,"BIG");
         pageContainer2D.addChild(bigDropPoint);
         clickStickManager.registerDropMagnet(bigDropPoint);
         placeSmall3D = new Number3D(-105,15,20);
         smallChar = new PlayerPointSprite(placeSmall3D.x,placeSmall3D.y,placeSmall3D.z,0.45);
         smallChar.pushAnimState("NULL",unPackAsset("Small_Null"));
         smallChar.pushAnimState("TUBA",unPackAsset("Small_Tuba"));
         smallChar.pushAnimState("VIOLIN",unPackAsset("Small_Violin"));
         smallChar.pushAnimState("UKE",unPackAsset("Small_Uke"));
         smallChar.pushAnimState("CLARINET",unPackAsset("Small_Clarinet"));
         smallVPL = basicView.viewport.getChildLayer(smallChar,true,true);
         smallDropPoint = new DropPoint(unPackAsset("UDDropPoint",true),151,206,"SMALL");
         pageContainer2D.addChild(smallDropPoint);
         clickStickManager.registerDropMagnet(smallDropPoint);
         placeRuby3D = new Number3D(0,50,40);
         rubyChar = new PlayerPointSprite(placeRuby3D.x,placeRuby3D.y,placeRuby3D.z,0.45);
         rubyChar.pushAnimState("NULL",unPackAsset("Ruby_Null"));
         rubyChar.pushAnimState("TUBA",unPackAsset("Ruby_Tuba"));
         rubyChar.pushAnimState("VIOLIN",unPackAsset("Ruby_Violin"));
         rubyChar.pushAnimState("UKE",unPackAsset("Ruby_Uke"));
         rubyChar.pushAnimState("CLARINET",unPackAsset("Ruby_Clarinet"));
         rubyVPL = basicView.viewport.getChildLayer(rubyChar,true,true);
         rubyDropPoint = new DropPoint(unPackAsset("UDDropPoint",true),374,99,"RUBY");
         pageContainer2D.addChild(rubyDropPoint);
         clickStickManager.registerDropMagnet(rubyDropPoint);
         bigChar.registerLipSyncAnim("bd_big_intro_heylets",unPackAsset("bd_big_intro_heylets"),-3,155);
         bigChar.registerLipSyncAnim("bd_big_intro_youcan",unPackAsset("bd_big_intro_youcan"),-3,155);
         bigChar.registerLipSyncAnim("bd_big_howbout",unPackAsset("bd_big_howbout"),0,155);
         smallChar.registerLipSyncAnim("bd_sml_intro_blow",unPackAsset("bd_sml_intro_blow"),-27,100);
         smallChar.registerLipSyncAnim("bd_sml_icanplay",unPackAsset("bd_sml_icanplay"),-27,100);
         lipSyncManager = new LipSyncTimerManager(lipSyncTimerLength);
         lipSyncManager.addLipSyncData(bigChar,"bd_big_howbout");
         lipSyncManager.addLipSyncData(smallChar,"bd_sml_icanplay");
         lipSyncManager.addLipSyncData(bigChar,"bd_big_intro_youcan");
         registerLiveDO3D(DO3DDefinitions.BANDPLAYER_BIG,bigChar);
         registerLiveDO3D(DO3DDefinitions.BANDPLAYER_SMALL,smallChar);
         registerLiveDO3D(DO3DDefinitions.BANDPLAYER_RUBY,rubyChar);
         bigSpawner = new CharDraggableSpawner(unPackAsset("UDDropTarget",true),null,bigDropPoint.x,bigDropPoint.y,"NULL");
         bigSpawner.setEnabledState(false);
         bigSpawner.scaleX = bigSpawner.scaleY = 1.5;
         pageContainer2D.addChild(bigSpawner);
         smallSpawner = new CharDraggableSpawner(unPackAsset("UDDropTarget",true),null,smallDropPoint.x,smallDropPoint.y,"NULL");
         smallSpawner.setEnabledState(false);
         pageContainer2D.addChild(smallSpawner);
         rubySpawner = new CharDraggableSpawner(unPackAsset("UDDropTarget",true),null,rubyDropPoint.x,rubyDropPoint.y,"NULL");
         rubySpawner.setEnabledState(false);
         pageContainer2D.addChild(rubySpawner);
         clickStickManager.registerSpawner(bigSpawner);
         clickStickManager.registerSpawner(smallSpawner);
         clickStickManager.registerSpawner(rubySpawner);
         trayBG = unPackAsset("TrayBG");
         trayBG.width = pageWidth;
         trayBG.y = pageHeight;
         trayBG.cacheAsBitmap = true;
         pageContainer2D.addChild(trayBG);
         _loc1_ = 136;
         _loc2_ = pageHeight - 85;
         var _loc3_:Number = 134.5;
         backButton = new AssetButton(unPackAsset("BackButton"),BrainEventType.CHANGE_PAGE,parentPage.pageID);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Back to the Living Room",AccessibilityDefinitions.BANDGAME_UI);
         backButton.addEventListener(BrainEvent.ACTION,handleBackButtonClick);
         pageContainer2D.addChild(backButton);
         var _loc4_:GlowFilter = new GlowFilter(16777215,1,4,4,5);
         var _loc5_:Object = getSpawnDataClassForInstrument("VIOLIN");
         violinSpawner = new InstrumentDraggableSpawner(_loc5_.spawnerUserData,_loc5_.dragUserData,_loc1_,_loc2_,"VIOLIN");
         violinSpawner.overStateFilters = [_loc4_];
         pageContainer2D.addChild(violinSpawner);
         _loc1_ += _loc3_;
         var _loc6_:Object = getSpawnDataClassForInstrument("UKE");
         ukeSpawner = new InstrumentDraggableSpawner(_loc6_.spawnerUserData,_loc6_.dragUserData,_loc1_,_loc2_,"UKE");
         ukeSpawner.overStateFilters = [_loc4_];
         pageContainer2D.addChild(ukeSpawner);
         _loc1_ += _loc3_;
         var _loc7_:Object = getSpawnDataClassForInstrument("TUBA");
         tubaSpawner = new InstrumentDraggableSpawner(_loc7_.spawnerUserData,_loc7_.dragUserData,_loc1_,_loc2_,"TUBA");
         tubaSpawner.overStateFilters = [_loc4_];
         pageContainer2D.addChild(tubaSpawner);
         _loc1_ += _loc3_;
         var _loc8_:Object = getSpawnDataClassForInstrument("CLARINET");
         clarinetSpawner = new InstrumentDraggableSpawner(_loc8_.spawnerUserData,_loc8_.dragUserData,_loc1_,_loc2_,"CLARINET");
         clarinetSpawner.overStateFilters = [_loc4_];
         pageContainer2D.addChild(clarinetSpawner);
         _loc1_ += _loc3_;
         backButton.x = _loc1_;
         backButton.y = pageHeight - 70;
         nullDropPointA = new DropPoint(unPackAsset("UDDropPoint",true),violinSpawner.x,violinSpawner.y,"NULL");
         clickStickManager.registerDropMagnet(nullDropPointA);
         nullDropPointB = new DropPoint(unPackAsset("UDDropPoint",true),ukeSpawner.x,ukeSpawner.y,"NULL");
         clickStickManager.registerDropMagnet(nullDropPointB);
         nullDropPointC = new DropPoint(unPackAsset("UDDropPoint",true),tubaSpawner.x,tubaSpawner.y,"NULL");
         clickStickManager.registerDropMagnet(nullDropPointC);
         nullDropPointD = new DropPoint(unPackAsset("UDDropPoint",true),clarinetSpawner.x,clarinetSpawner.y,"NULL");
         clickStickManager.registerDropMagnet(nullDropPointD);
         clickStickManager.registerSpawner(violinSpawner);
         clickStickManager.registerSpawner(ukeSpawner);
         clickStickManager.registerSpawner(tubaSpawner);
         clickStickManager.registerSpawner(clarinetSpawner);
         pageContainer2D.addChild(clickStickManager);
         updateAnims();
         showChars(false);
      }
      
      private function end() : void
      {
         voxBandPlayer.end();
         backingBandPlayer.end();
         smallBandPlayer.end();
         bigBandPlayer.end();
         rubyBandPlayer.end();
         smallChar.end();
         bigChar.end();
         rubyChar.end();
         voxTimer.reset();
         voxTimer.removeEventListener(TimerEvent.TIMER,handleVoxTimer);
         voxTimer = null;
         lipSyncManager.stop();
         drums.stopSound();
         removeEventListeners();
      }
      
      private function showChars(param1:Boolean) : void
      {
         bigChar.setVisible(param1);
         smallChar.setVisible(param1);
         rubyChar.setVisible(param1);
      }
      
      override public function park() : void
      {
         super.park();
      }
      
      private function handlePickUp(param1:DragDropEvent) : void
      {
         var _loc2_:ISpawnDraggable = null;
         var _loc3_:DraggableSpawner = null;
         if(param1.draggable is SpawnDraggable)
         {
            _loc2_ = param1.draggable as ISpawnDraggable;
            _loc3_ = _loc2_.parentSpawner;
            if(_loc3_ is CharDraggableSpawner)
            {
               _loc3_.setEnabledState(false);
            }
            if(_loc3_ == bigSpawner)
            {
               bigSpawner.value = "NULL";
               bigSpawner.spawnDataClass = null;
               bigBandPlayer.chooseInstrument("NULL");
            }
            else if(_loc3_ == smallSpawner)
            {
               smallSpawner.value = "NULL";
               smallSpawner.spawnDataClass = null;
               smallBandPlayer.chooseInstrument("NULL");
            }
            else if(_loc3_ == rubySpawner)
            {
               rubySpawner.value = "NULL";
               rubySpawner.spawnDataClass = null;
               rubyBandPlayer.chooseInstrument("NULL");
            }
         }
         updateAnims();
      }
      
      override public function activate() : void
      {
         super.activate();
         enableGame();
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
      }
      
      private function handleVoxTimer(param1:TimerEvent) : void
      {
         BrainLogger.out("handleVoxTimer");
         ++voxCounter;
         if(voxCounter % 3 == 0)
         {
            BrainLogger.out("vox on");
            voxOn = true;
            voxBandPlayer.chooseInstrument("VOX");
         }
         else if(voxOn)
         {
            BrainLogger.out("vox off");
            voxOn = false;
            voxBandPlayer.chooseInstrument("NULL");
         }
      }
   }
}

