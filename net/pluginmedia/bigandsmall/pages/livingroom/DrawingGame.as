package net.pluginmedia.bigandsmall.pages.livingroom
{
   import com.as3dmod.ModifierStack;
   import com.as3dmod.modifiers.Bend;
   import com.as3dmod.plugins.pv3d.LibraryPv3d;
   import com.as3dmod.util.ModConstant;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Timer;
   import gs.TweenMax;
   import gs.easing.Expo;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.VPortLayerDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.livingroom.drawinggame.ColourTray;
   import net.pluginmedia.bigandsmall.pages.livingroom.drawinggame.DrawingState;
   import net.pluginmedia.bigandsmall.pages.livingroom.drawinggame.DrawingStateBig;
   import net.pluginmedia.bigandsmall.pages.livingroom.drawinggame.DrawingStateSmall;
   import net.pluginmedia.bigandsmall.pages.livingroom.drawinggame.Paper;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.IPage3D;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.events.BrainSoundStopEvent;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class DrawingGame extends BigAndSmallPage3D
   {
      
      private var backButton:AssetButton;
      
      private var paintPotBlue:ColourTray;
      
      private var bigIntroVoxDone:Boolean = false;
      
      private var paperFullThreshBig:int = 12;
      
      private var isPaperFull:Boolean = false;
      
      private var voxTimeoutCtr:Number = 0;
      
      private var paperModStack:ModifierStack;
      
      private var paperFullThresh:int = 0;
      
      public var parentPage:IPage3D;
      
      private var paintPotYellow:ColourTray;
      
      private var bigState:DrawingState;
      
      private var assetLib:AssetLoader;
      
      private var voxTimeout:Timer = new Timer(10000);
      
      private var paper:Paper;
      
      private var state:DrawingState;
      
      private var numPrints:int = 0;
      
      private var combinedPaperTexture:BitmapData;
      
      private var smallIntroVoxDone:Boolean = false;
      
      private var paperTextureSprite:Sprite;
      
      private var colourObjects:Array;
      
      private var newSheetButton:AssetButton;
      
      private var newPapSoundTimer:Timer = new Timer(5000,0);
      
      private var paperComp:CompDiscardedPaperPlane = null;
      
      private var toyBoxLayer:ViewportLayer;
      
      private var paperTextureBitmapData:BitmapData;
      
      private var smallState:DrawingState;
      
      private var newPapSoundTimeout:Boolean = true;
      
      private var paintedBitmapData:BitmapData;
      
      private var paperFullThreshSmall:int = 25;
      
      private var soundLib:AssetLoader;
      
      private var paintPotRed:ColourTray;
      
      private var paperBendA:Bend;
      
      private var paperBendB:Bend;
      
      public function DrawingGame(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = new Number3D(-35,61,0);
         var _loc5_:OrbitCamera3D = new OrbitCamera3D(45);
         _loc5_.rotationYMin = -2;
         _loc5_.rotationYMax = 2;
         _loc5_.radius = 120;
         _loc5_.rotationXMin = 80;
         _loc5_.rotationXMax = 70;
         _loc5_.orbitCentre.x = _loc4_.x;
         _loc5_.orbitCentre.y = _loc4_.y;
         _loc5_.orbitCentre.z = _loc4_.z;
         parentPage = param3;
         super(param1,_loc4_,_loc5_,_loc5_,param2);
      }
      
      override public function collectionQueueEmpty() : void
      {
         var _loc1_:MovieClip = MovieClip(assetLib.getAssetByName("BigArm"));
         bigState = new DrawingStateBig(basicView.viewport.containerSprite,assetLib.getAssetByName("BigStamp"),_loc1_);
         bigState.setTargetBitmap(paintedBitmapData);
         bigState.paintScoopStrRef = "lr_bg_hand_paintin";
         bigState.paintSplatStrRef = "drawgame_paintsplat_big";
         smallState = new DrawingStateSmall(basicView.viewport.containerSprite,assetLib.getAssetByName("SmallStamp"),assetLib.getAssetByName("SmallArm"));
         smallState.setTargetBitmap(paintedBitmapData);
         smallState.paintScoopStrRef = "lr_sml_hand_paintin";
         smallState.paintSplatStrRef = "drawgame_paintsplat_small";
         initSounds();
         paperTextureSprite = assetLib.getAssetByName("PaperTexture");
         var _loc2_:Number = 15;
         var _loc3_:Number = -18;
         newSheetButton = new AssetButton(assetLib.getAssetByName("NewSheetButton"));
         newSheetButton.x = pageWidth - newSheetButton.width - _loc3_;
         newSheetButton.y = newSheetButton.height / 2 + _loc2_;
         newSheetButton.addEventListener(MouseEvent.CLICK,handleNewSheetButtonClick);
         newSheetButton.addEventListener(MouseEvent.MOUSE_OVER,handleNewSheetButtonOver);
         newSheetButton.buttonMode = true;
         AccessibilityManager.addAccessibilityProperties(newSheetButton,"New Sheet","Start on a clean sheet of paper",AccessibilityDefinitions.DRAWINGGAME_UI);
         pageContainer2D.addChild(newSheetButton);
         backButton = new AssetButton(assetLib.getAssetByName("BackButton"),BrainEventType.CHANGE_PAGE,parentPage.pageID);
         backButton.x = pageWidth - backButton.width - _loc3_;
         backButton.y = newSheetButton.y + newSheetButton.height / 2 + _loc2_ + backButton.height / 2;
         backButton.addEventListener(BrainEvent.ACTION,handleBackButtonClick);
         backButton.addEventListener(MouseEvent.MOUSE_OVER,handleBackButtonOver);
         pageContainer2D.addChild(backButton);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Back to the Living Room",AccessibilityDefinitions.DRAWINGGAME_UI);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(512 / paperTextureSprite.width,512 / paperTextureSprite.height);
         paperTextureBitmapData.draw(paperTextureSprite,_loc4_);
         combinedPaperTexture.draw(paperTextureBitmapData);
         bigState.setColor(colourObjects[0]);
         smallState.setColor(colourObjects[0]);
         state = bigState;
         registerLiveDO3D(DO3DDefinitions.DRAWINGGAME_PAPER,paper);
         registerLiveDO3D(DO3DDefinitions.DRAWINGGAME_PAINTPOT_RED,paintPotRed);
         registerLiveDO3D(DO3DDefinitions.DRAWINGGAME_PAINTPOT_BLUE,paintPotBlue);
         registerLiveDO3D(DO3DDefinitions.DRAWINGGAME_PAINTPOT_YELLOW,paintPotYellow);
         setReadyState();
      }
      
      override public function activate() : void
      {
         BrainLogger.out("--- startDrawing");
         startDrawing();
         voxTimeout.start();
         voxTimeoutCtr = 0;
         newPapSoundTimer.start();
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
      }
      
      override public function prepare(param1:String = null) : void
      {
      }
      
      private function handleToyBoxLayerShared(param1:SharerInfo) : void
      {
         toyBoxLayer = param1.reference as ViewportLayer;
         var _loc2_:ViewportLayer = toyBoxLayer.getChildLayer(paper,true);
      }
      
      public function setDiscardedPaperCompRef(param1:CompDiscardedPaperPlane) : void
      {
         paperComp = param1;
      }
      
      private function handleNewPapSoundTimer(param1:TimerEvent) : void
      {
         newPapSoundTimeout = true;
      }
      
      private function handleNewSheetButtonClick(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("lr_hand_paperbuttonclick");
         newSheet();
         if(newPapSoundTimeout)
         {
            SoundManagerOld.playSound("lr_big_hand_paper");
            newPapSoundTimeout = false;
            newPapSoundTimer.reset();
            newPapSoundTimer.start();
         }
      }
      
      private function resetStartVoxTimer() : void
      {
         voxTimeout.reset();
         voxTimeout.start();
      }
      
      public function makeHandPrint(param1:RenderHitData) : void
      {
         state.drawHandPrint(param1.u,param1.v,paintedBitmapData);
         updatePaperBitmap();
         SoundManagerOld.playSound(state.paintSplatStrRef);
         ++numPrints;
         checkPaperFullVox();
         resetStartVoxTimer();
         _renderStateIsDirty = true;
      }
      
      public function TriangleMeshHitTest2D(param1:TriangleMesh3D, param2:Point, param3:RenderHitData = null) : RenderHitData
      {
         var _loc5_:RenderTriangle = null;
         if(!param3)
         {
            param3 = new RenderHitData();
         }
         else
         {
            param3.clear();
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.geometry.faces.length)
         {
            _loc5_ = Triangle3D(param1.geometry.faces[_loc4_]).getRenderListItem() as RenderTriangle;
            param3 = _loc5_.hitTestPoint2D(param2,param3);
            if(param3.hasHit)
            {
               return param3;
            }
            _loc4_++;
         }
         return param3;
      }
      
      public function get paperFull() : Boolean
      {
         if(numPrints >= paperFullThresh)
         {
            isPaperFull = true;
            return true;
         }
         return false;
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("DrawingGame.swfAssetLibrary",SWFLocations.drawingGameLibrary,handleAssetsLoaded);
         dispatchAssetRequest("DrawingGame.soundAssetLibrary",SWFLocations.drawingGameSounds,handleSoundsLoaded);
      }
      
      public function setState(param1:DrawingState) : void
      {
         if(state)
         {
            if(_isActive)
            {
               state.removeFromStage();
            }
            state.unSetState();
         }
         state = param1;
         state.setState();
         if(_isActive)
         {
            state.addToStage();
         }
      }
      
      public function startDrawing() : void
      {
         _isActive = true;
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         basicView.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         basicView.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
         if(currentPOV == CharacterDefinitions.BIG)
         {
            paperFullThresh = paperFullThreshBig;
            setState(bigState);
            if(!bigIntroVoxDone)
            {
               SoundManagerOld.playSound("lr_sml_hand_intro");
               bigIntroVoxDone = true;
            }
            else
            {
               SoundManagerOld.playSound("lr_sml_hand_switch");
            }
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            paperFullThresh = paperFullThreshSmall;
            setState(smallState);
            if(!smallIntroVoxDone)
            {
               SoundManagerOld.playSound("lr_big_hand_icould");
               smallIntroVoxDone = true;
            }
         }
         state.addToStage();
      }
      
      private function handleNewSheetButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("lr_hand_paperrollover");
      }
      
      override protected function build() : void
      {
         var _loc5_:ColourTray = null;
         combinedPaperTexture = new BitmapData(512,512,false,0);
         paperTextureBitmapData = new BitmapData(512,512,false,0);
         paintedBitmapData = new BitmapData(512,512,true,0);
         paper = new Paper(combinedPaperTexture,80,90,8,8);
         defaultPaperPos();
         paperModStack = new ModifierStack(new LibraryPv3d(),paper);
         paperBendA = new Bend(0,0);
         paperModStack.addModifier(paperBendA);
         paperBendA.bendAxis = ModConstant.Y;
         paperBendA.constraint = ModConstant.LEFT;
         paperBendB = new Bend(0,0);
         paperModStack.addModifier(paperBendB);
         paperBendB.bendAxis = ModConstant.X;
         paperBendB.constraint = ModConstant.LEFT;
         paintPotRed = new ColourTray(16711680,"red");
         paintPotYellow = new ColourTray(16776960,"yellow");
         paintPotBlue = new ColourTray(255,"blue");
         colourObjects = [paintPotRed,paintPotYellow,paintPotBlue];
         var _loc1_:ViewportLayer = basicView.viewport.getChildLayer(paintPotRed,true);
         var _loc2_:ViewportLayer = basicView.viewport.getChildLayer(paintPotBlue,true);
         var _loc3_:ViewportLayer = basicView.viewport.getChildLayer(paintPotYellow,true);
         var _loc4_:int = 0;
         while(_loc4_ < colourObjects.length)
         {
            _loc5_ = colourObjects[_loc4_] as ColourTray;
            _loc5_.x = this.x - (45 + _loc4_ * 5) + 35;
            _loc5_.y = this.y + 10 - 61;
            _loc5_.z = this.z - (_loc4_ * 30 - 35);
            _loc5_.rotationY = 11;
            _loc4_++;
         }
      }
      
      override public function onShareableRegistration() : void
      {
         var _loc1_:ShareRequest = new ShareRequest(this,DO3DDefinitions.LIVINGROOM_PAPER,handlePaperShared);
         this.dispatchShareRequest(_loc1_);
         var _loc2_:ShareRequest = new ShareRequest(this,VPortLayerDefinitions.LIVINGROOM_VPLAYER_TOYBOX,handleToyBoxLayerShared);
         this.dispatchShareRequest(_loc2_);
      }
      
      private function initSounds() : void
      {
         voxTimeout.addEventListener(TimerEvent.TIMER,handleVoxTimer);
         newPapSoundTimer.addEventListener(TimerEvent.TIMER,handleNewPapSoundTimer);
         SoundManagerOld.registerSound(new BrainSoundOld("lr_hand_paperbuttonclick",soundLib.getAssetClassByName("lr_hand_paperbuttonclick"),null));
         SoundManagerOld.registerSound(new BrainSoundOld("lr_hand_paperpageturn",soundLib.getAssetClassByName("lr_hand_paperpageturn"),null));
         SoundManagerOld.registerSound(new BrainSoundOld("lr_hand_paperrollover",soundLib.getAssetClassByName("lr_hand_paperrollover"),null));
         SoundManagerOld.registerSound(new BrainSoundOld("lr_big_hand_icould",soundLib.getAssetClassByName("lr_big_hand_icould"),new SoundInfoOld(1,0,0,0,1)));
         var _loc1_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_paper_full_small",new SoundInfoOld(1,0,0,0,1));
         _loc1_.pushSound(new BrainSoundOld("lr_big_hand_heythats",soundLib.getAssetClassByName("lr_big_hand_heythats"),null));
         _loc1_.pushSound(new BrainSoundOld("lr_big_hand_idontknow",soundLib.getAssetClassByName("lr_big_hand_idontknow"),null));
         SoundManagerOld.registerSoundCollection(_loc1_);
         var _loc2_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_timeout_small",new SoundInfoOld(1,0,0,0,1));
         _loc2_.pushSound(new BrainSoundOld("lr_sml_hand_hey_swap",soundLib.getAssetClassByName("lr_sml_hand_hey_swap"),null));
         _loc2_.pushSound(new BrainSoundOld("lr_sml_hand_goon",soundLib.getAssetClassByName("lr_sml_hand_goon"),null));
         SoundManagerOld.registerSoundCollection(_loc2_);
         SoundManagerOld.registerSound(new BrainSoundOld("lr_big_hand_youcan",soundLib.getAssetClassByName("lr_big_hand_youcan"),null));
         SoundManagerOld.registerSound(new BrainSoundOld("lr_sml_hand_intro",soundLib.getAssetClassByName("lr_sml_hand_intro"),new SoundInfoOld(1,0,0,0,1)));
         SoundManagerOld.registerSound(new BrainSoundOld("lr_sml_hand_switch",soundLib.getAssetClassByName("lr_sml_hand_switch"),new SoundInfoOld(1,0,0,0,1)));
         var _loc3_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_paper_full_big",new SoundInfoOld(1,0,0,0,1));
         _loc3_.pushSound(new BrainSoundOld("lr_sml_hand_reaction",soundLib.getAssetClassByName("lr_sml_hand_reaction"),null));
         _loc3_.pushSound(new BrainSoundOld("lr_sml_hand_react2",soundLib.getAssetClassByName("lr_sml_hand_react2"),null));
         _loc3_.pushSound(new BrainSoundOld("lr_sml_hand_woothat",soundLib.getAssetClassByName("lr_sml_hand_woothat"),null));
         _loc3_.pushSound(new BrainSoundOld("lr_big_hand_more",soundLib.getAssetClassByName("lr_big_hand_more"),null));
         SoundManagerOld.registerSoundCollection(_loc3_);
         var _loc4_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_timeout_big",new SoundInfoOld(1,0,0,0,1));
         _loc4_.pushSound(new BrainSoundOld("lr_big_hand_swap",soundLib.getAssetClassByName("lr_big_hand_swap"),null));
         _loc4_.pushSound(new BrainSoundOld("lr_big_hand_comeon",soundLib.getAssetClassByName("lr_big_hand_comeon"),null));
         SoundManagerOld.registerSoundCollection(_loc4_);
         SoundManagerOld.registerSound(new BrainSoundOld("lr_big_hand_paper",soundLib.getAssetClassByName("lr_big_hand_paper"),new SoundInfoOld(1,0,0,0,1)));
         var _loc5_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_paintsplat_big",null);
         _loc5_.pushSound(new BrainSoundOld("lr_big_hand_splat1",soundLib.getAssetClassByName("lr_big_hand_splat1"),null));
         _loc5_.pushSound(new BrainSoundOld("lr_big_hand_splat2",soundLib.getAssetClassByName("lr_big_hand_splat2"),null));
         _loc5_.pushSound(new BrainSoundOld("lr_big_hand_splat3",soundLib.getAssetClassByName("lr_big_hand_splat3"),null));
         _loc5_.pushSound(new BrainSoundOld("lr_big_hand_splat4",soundLib.getAssetClassByName("lr_big_hand_splat4"),null));
         SoundManagerOld.registerSoundCollection(_loc5_);
         SoundManagerOld.registerSound(new BrainSoundOld("lr_bg_hand_paintin",soundLib.getAssetClassByName("lr_bg_hand_paintin"),null));
         var _loc6_:BrainSoundCollectionOld = new BrainSoundCollectionOld("drawgame_paintsplat_small",null);
         _loc6_.pushSound(new BrainSoundOld("lr_small_hand_splat1",soundLib.getAssetClassByName("lr_small_hand_splat1"),null));
         _loc6_.pushSound(new BrainSoundOld("lr_small_hand_splat2",soundLib.getAssetClassByName("lr_small_hand_splat2"),null));
         _loc6_.pushSound(new BrainSoundOld("lr_small_hand_splat3",soundLib.getAssetClassByName("lr_small_hand_splat3"),null));
         _loc6_.pushSound(new BrainSoundOld("lr_small_hand_splat4",soundLib.getAssetClassByName("lr_small_hand_splat4"),null));
         SoundManagerOld.registerSoundCollection(_loc6_);
         SoundManagerOld.registerSound(new BrainSoundOld("lr_sml_hand_paintin",soundLib.getAssetClassByName("lr_sml_hand_paintin"),null));
      }
      
      public function updatePaperBitmap() : void
      {
         combinedPaperTexture.draw(paperTextureBitmapData);
         combinedPaperTexture.draw(paintedBitmapData,null,null,BlendMode.MULTIPLY);
      }
      
      override public function deactivate() : void
      {
         BrainLogger.out("--- stopDrawing");
         stopDrawing();
         voxTimeout.reset();
         newPapSoundTimer.reset();
         dispatchEvent(new BrainSoundStopEvent(0.25,null,1));
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
      }
      
      protected function defaultPaperPos() : void
      {
         paper.x = 20;
         paper.y = 0;
         paper.z = 0;
         paper.rotationX = 90;
         paper.rotationY = Math.random() * -6;
      }
      
      public function newSheet() : void
      {
         SoundManagerOld.playSound("lr_hand_paperpageturn");
         numPrints = 0;
         isPaperFull = false;
         resetStartVoxTimer();
         if(paperComp === null)
         {
            return;
         }
         TweenMax.to(paper,0.7,{
            "x":paper.x + 100,
            "y":paper.y,
            "z":paper.z,
            "rotationY":100,
            "ease":Expo.easeIn,
            "onUpdate":handlePaperTweenProgress,
            "onComplete":handlePaperTweenComplete
         });
         TweenMax.to(paperBendA,0.5,{"force":Math.random() * 0.5 + 0.2});
         TweenMax.to(paperBendB,0.5,{
            "force":Math.random() * 0.5 + 0.2,
            "onUpdate":handleBendTweenProgress,
            "onComplete":handleBendTweenProgress
         });
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         var _loc5_:ColourTray = null;
         var _loc2_:Point = new Point(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY);
         var _loc3_:RenderHitData = TriangleMeshHitTest2D(paper,_loc2_);
         if(_loc3_.hasHit)
         {
            state.stampAnim();
            makeHandPrint(_loc3_);
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < colourObjects.length)
         {
            _loc5_ = colourObjects[_loc4_] as ColourTray;
            _loc3_ = TriangleMeshHitTest2D(_loc5_,_loc2_,_loc3_);
            if(_loc3_.hasHit)
            {
               SoundManagerOld.playSound(state.paintScoopStrRef);
               resetStartVoxTimer();
               state.stampAnim();
               state.chooseColor(_loc5_);
               return;
            }
            _loc4_++;
         }
      }
      
      private function handleAssetsLoaded(param1:IAssetLoader) : void
      {
         assetLib = param1 as AssetLoader;
      }
      
      private function handleBendTweenProgress() : void
      {
         paperModStack.apply();
         _renderStateIsDirty = true;
      }
      
      private function handleSoundsLoaded(param1:IAssetLoader) : void
      {
         soundLib = param1 as AssetLoader;
      }
      
      public function stopDrawing() : void
      {
         _isActive = false;
         basicView.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         basicView.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
         state.removeFromStage();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:Point = null;
         var _loc3_:RenderHitData = null;
         state.moveMouse(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY,paper.screen.x,paper.screen.y);
         if(state.dripping)
         {
            _loc2_ = new Point(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY);
            _loc3_ = TriangleMeshHitTest2D(paper,_loc2_);
            state.drawDrips(_loc3_.u,_loc3_.v,paintedBitmapData);
            updatePaperBitmap();
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(DO3DDefinitions.LIVINGROOM_PAPER);
         _loc1_.push(DO3DDefinitions.LIVINGROOM_ROOM);
         _loc1_.push(DO3DDefinitions.LIVINGROOM_TOYBOX);
         return _loc1_.concat(this._do3dList);
      }
      
      private function handleBackButtonClick(param1:BrainEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(param1.actionType,param1.actionTarget);
      }
      
      private function checkPaperFullVox() : void
      {
         if(this.paperFull)
         {
            if(currentPOV == CharacterDefinitions.BIG)
            {
               SoundManagerOld.playSound("drawgame_paper_full_big");
            }
            else if(currentPOV == CharacterDefinitions.SMALL)
            {
               SoundManagerOld.playSound("drawgame_paper_full_small");
            }
            numPrints = 0;
         }
      }
      
      private function handleBackButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      private function handlePaperShared(param1:SharerInfo) : void
      {
         setDiscardedPaperCompRef(param1.reference as CompDiscardedPaperPlane);
      }
      
      private function handlePaperTweenProgress() : void
      {
         _renderStateIsDirty = true;
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(_isActive)
         {
            if(param1 == CharacterDefinitions.BIG)
            {
               paperFullThresh = paperFullThreshBig;
               setState(bigState);
            }
            else
            {
               paperFullThresh = paperFullThreshSmall;
               setState(smallState);
            }
         }
      }
      
      override public function park() : void
      {
      }
      
      private function handleVoxTimer(param1:TimerEvent) : void
      {
         if(isPaperFull && voxTimeoutCtr % 3 == 0)
         {
            SoundManagerOld.playSound("lr_big_hand_youcan");
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            SoundManagerOld.playSound("drawgame_timeout_small");
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            SoundManagerOld.playSound("drawgame_timeout_big");
         }
         ++voxTimeoutCtr;
         resetStartVoxTimer();
      }
      
      private function handlePaperTweenComplete() : void
      {
         paperBendA.force = 0;
         paperBendA.offset = 0;
         paperBendB.force = 0;
         paperBendB.offset = 0;
         defaultPaperPos();
         paperModStack.apply();
         var _loc1_:DiscardedPaperPlane = paperComp.getRandomTargetPlane();
         _loc1_.capture(combinedPaperTexture,0.39);
         paintedBitmapData.fillRect(paintedBitmapData.rect,0);
         combinedPaperTexture.draw(paperTextureBitmapData);
      }
   }
}

