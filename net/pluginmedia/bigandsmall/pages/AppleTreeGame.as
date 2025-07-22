package net.pluginmedia.bigandsmall.pages
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleParticle;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleTreeFloor;
   import net.pluginmedia.bigandsmall.pages.garden.tree.characters.AppleTreeBig;
   import net.pluginmedia.bigandsmall.pages.garden.tree.characters.AppleTreeSmall;
   import net.pluginmedia.bigandsmall.pages.garden.tree.events.AppleTreeEvent;
   import net.pluginmedia.bigandsmall.pages.garden.tree.managers.AppleParticleManager;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class AppleTreeGame extends BigAndSmallPage3D
   {
      
      public static var BIG_SPANK_REACTION_A:String = "AppleTreeGame.BIG_SPANK_REACTION_A";
      
      public static var BIG_SPANK_REACTION_B:String = "AppleTreeGame.BIG_SPANK_REACTION_B";
      
      public static var BIG_SPANK_REACTIONS:Array = [BIG_SPANK_REACTION_A,BIG_SPANK_REACTION_B];
      
      public static var BIG_VOX_INTRO:String = "AppleTreeGame.BIG_VOX_INTRO";
      
      public static var BIG_VOX_APPLEIMPACT_I:String = "AppleTreeGame.BIG_VOX_APPLEIMPACT_I";
      
      public static var BIG_VOX_APPLEIMPACT_II:String = "AppleTreeGame.BIG_VOX_APPLEIMPACT_II";
      
      public static var BIG_VOX_APPLEIMPACT_III:String = "AppleTreeGame.BIG_VOX_APPLEIMPACT_III";
      
      public static var BIG_VOX_APPLEIMPACTS:Array = [BIG_VOX_APPLEIMPACT_I,BIG_VOX_APPLEIMPACT_II,BIG_VOX_APPLEIMPACT_III];
      
      public static var BIG_VOX_TIMEOUT_I:String = "AppleTreeGame.BIG_VOX_TIMEOUT_I";
      
      public static var BIG_VOX_TIMEOUT_II:String = "AppleTreeGame.BIG_VOX_TIMEOUT_II";
      
      public static var BIG_VOX_TIMEOUTS:Array = [BIG_VOX_TIMEOUT_I,BIG_VOX_TIMEOUT_II];
      
      public static var BIG_VOX_COMPLETION_I:String = "AppleTreeGame.BIG_VOX_COMPLETION_I";
      
      public static var BIG_VOX_COMPLETION_II:String = "AppleTreeGame.BIG_VOX_COMPLETION_II";
      
      public static var BIG_VOX_COMPLETIONS:Array = [BIG_VOX_COMPLETION_I,BIG_VOX_COMPLETION_II];
      
      public static var SMALL_VOX_INTRO:String = "AppleTreeGame.SMALL_VOX_INTRO";
      
      public static var SMALL_VOX_APPLEIMPACT_I:String = "AppleTreeGame.SMALL_VOX_APPLEIMPACT_I";
      
      public static var SMALL_VOX_APPLEIMPACT_II:String = "AppleTreeGame.SMALL_VOX_APPLEIMPACT_II";
      
      public static var SMALL_VOX_APPLEIMPACT_III:String = "AppleTreeGame.SMALL_VOX_APPLEIMPACT_III";
      
      public static var SMALL_VOX_APPLEIMPACT_IV:String = "AppleTreeGame.SMALL_VOX_APPLEIMPACT_IV";
      
      public static var SMALL_VOX_APPLEIMPACTS:Array = [SMALL_VOX_APPLEIMPACT_I,SMALL_VOX_APPLEIMPACT_II,SMALL_VOX_APPLEIMPACT_III,SMALL_VOX_APPLEIMPACT_IV];
      
      public static var SMALL_VOX_TIMEOUT_I:String = "AppleTreeGame.SMALL_VOX_TIMEOUT_I";
      
      public static var SMALL_VOX_TIMEOUT_II:String = "AppleTreeGame.SMALL_VOX_TIMEOUT_II";
      
      public static var SMALL_VOX_TIMEOUTS:Array = [SMALL_VOX_TIMEOUT_I,SMALL_VOX_TIMEOUT_II];
      
      public static var SMALL_VOX_COMPLETION_I:String = "AppleTreeGame.SMALL_VOX_COMPLETION_I";
      
      public static var SMALL_VOX_COMPLETION_II:String = "AppleTreeGame.SMALL_VOX_COMPLETION_II";
      
      public static var SMALL_VOX_COMPLETIONS:Array = [SMALL_VOX_COMPLETION_I,SMALL_VOX_COMPLETION_II];
      
      private var big:AppleTreeBig;
      
      private var small:AppleTreeSmall;
      
      private var floor:AppleTreeFloor;
      
      private var backButtonPos:Point;
      
      private var appleManager:AppleParticleManager;
      
      private var timeoutVoxTimer:Timer;
      
      private var gameZ:Number = 500;
      
      private var activeState:Boolean = false;
      
      private var treeLayer:ViewportLayer;
      
      private var applesOnFloor:uint;
      
      private var staticAppleContainer:DisplayObject3D;
      
      private var timeoutVoxDelay:int = 12000;
      
      private var backButton:AssetButton;
      
      public function AppleTreeGame(param1:BasicView, param2:String)
      {
         var _loc3_:Number3D = new Number3D(-2236,270,128);
         var _loc4_:OrbitCamera3D = new OrbitCamera3D(28);
         _loc4_.target.position = new Number3D(-2236,348,-520);
         _loc4_.rotationYMin = -2.5;
         _loc4_.rotationYMax = 0;
         _loc4_.radius = 140;
         _loc4_.rotationXMin = 4.3;
         _loc4_.rotationXMax = 4.7;
         var _loc5_:OrbitCamera3D = new OrbitCamera3D(45);
         _loc5_.target.position = new Number3D(-2242,270,706);
         _loc5_.rotationYMin = 0.5;
         _loc5_.rotationYMax = 1.5;
         _loc5_.radius = 750;
         _loc5_.rotationXMin = -18.5;
         _loc5_.rotationXMax = -19.5;
         super(param1,_loc3_,_loc4_,_loc5_,param2);
         timeoutVoxTimer = new Timer(timeoutVoxDelay);
         timeoutVoxTimer.addEventListener(TimerEvent.TIMER,handleVoxTimeout);
      }
      
      private function handleBackButtonDown(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_HUB);
      }
      
      private function initApples() : void
      {
         var _loc4_:AppleParticle = null;
         var _loc5_:Number3D = null;
         var _loc6_:ViewportLayer = null;
         appleManager = new AppleParticleManager(basicView,this,floor,unPackAsset("AppleOver"),unPackAsset("AppleClick"),unPackAsset("AppleImpact_Ground"),unPackAsset("AppleImpact_Big"));
         appleManager.addEventListener(AppleTreeEvent.APPLE_HITS_BIG,handleAppleHitBig);
         appleManager.addEventListener(AppleTreeEvent.APPLE_IMPACTS_FLOOR,handleAppleImpactsFloor);
         appleManager.addEventListener(AppleTreeEvent.APPLE_FINDS_REST,handleAppleFindsRest);
         registerLiveDO3D(DO3DDefinitions.GARDEN_TREE_APPLES,appleManager);
         var _loc1_:Array = [];
         var _loc2_:Number = 40;
         _loc1_.push(new Number3D(-160,170,SuperMath.random(gameZ - _loc2_,gameZ + _loc2_)));
         _loc1_.push(new Number3D(-40,230,SuperMath.random(gameZ - _loc2_,gameZ + _loc2_)));
         _loc1_.push(new Number3D(100,220,SuperMath.random(gameZ - _loc2_,gameZ + _loc2_)));
         _loc1_.push(new Number3D(230,290,SuperMath.random(gameZ - _loc2_,gameZ + _loc2_)));
         _loc1_.push(new Number3D(300,240,SuperMath.random(gameZ - _loc2_,gameZ + _loc2_)));
         var _loc3_:int = 0;
         for each(_loc5_ in _loc1_)
         {
            _loc4_ = new AppleParticle(_loc3_ + 1,unPackAsset("TreeAppleChrome"),_loc5_.x,_loc5_.y,_loc5_.z);
            _loc4_.startPos = _loc5_;
            _loc4_.reset();
            _loc6_ = basicView.viewport.getChildLayer(_loc4_,true,true);
            _loc4_.viewportLayer = _loc6_;
            registerAccessibleInteractive(_loc4_.viewportLayer,"Interactive Apple","Pick the apple from the tree",AccessibilityDefinitions.GARDEN_INTERACTIVE);
            appleManager.addApple(_loc4_);
            _loc3_++;
         }
         staticAppleContainer = new DisplayObject3D();
         _loc1_ = [];
         _loc1_.push(new Number3D(380,370,480));
         _loc1_.push(new Number3D(-150,440,480));
         _loc1_.push(new Number3D(-580,290,580));
         _loc1_.push(new Number3D(-440,390,520));
         for each(_loc5_ in _loc1_)
         {
            _loc4_ = new AppleParticle(1,unPackAsset("TreeAppleChrome"));
            _loc4_.x = _loc5_.x;
            _loc4_.y = _loc5_.y;
            _loc4_.z = _loc5_.z;
            staticAppleContainer.addChild(_loc4_);
            if(treeLayer)
            {
               treeLayer.addDisplayObject3D(_loc4_,true);
            }
         }
         registerLiveDO3D(DO3DDefinitions.GARDEN_NON_INTERACTIVE_TREE_APPLES,staticAppleContainer);
         if(treeLayer)
         {
            appleManager.putApplesInSharedLayer(treeLayer);
         }
         resetGameStatus();
      }
      
      override public function activate() : void
      {
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         appleManager.activate();
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            big.activate();
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            small.activate();
         }
         SoundManager.stopChannel(SoundChannelDefinitions.VOX);
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            big.actLine(BIG_VOX_INTRO);
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            small.actLine(SMALL_VOX_INTRO);
         }
         broadcast(BigAndSmallEventType.SHOW_BS_BUTTONS);
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         backButton.x = backButtonPos.x;
         backButton.y = backButtonPos.y;
         TweenMax.from(backButton,0.3,{"y":backButtonPos.y + 120});
         registerAccessibleInteractive(backButton,"Back to the Garden","Return to the Garden",AccessibilityDefinitions.GARDEN_INTERACTIVE);
         resetVoxxerTimer(true);
         super.activate();
         activeState = true;
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         resetGameStatus();
         setCharacter(currentPOV);
         appleManager.prepare();
      }
      
      override public function getTransitionOmitObjects() : Array
      {
         var _loc1_:Array = super.getTransitionOmitObjects();
         _loc1_.push(DO3DDefinitions.APPLETREEGAME_BIG);
         return _loc1_;
      }
      
      private function initBackButton() : void
      {
         backButton = new AssetButton(unPackAsset("BackButton"));
         backButton.addEventListener(MouseEvent.CLICK,handleBackButtonDown);
         backButton.addEventListener(MouseEvent.ROLL_OVER,handleBackButtonOver);
         backButton.setEnabledState(true);
         backButton.scaleX = backButton.scaleY = 0.85;
         backButtonPos = new Point(pageWidth - 160,pageHeight - backButton.height / 2 - 10);
         backButton.x = backButtonPos.x;
         backButton.y = backButtonPos.y + 100;
         pageContainer2D.addChild(backButton);
      }
      
      private function handleAppleHitBig(param1:AppleTreeEvent) : void
      {
         BIG_SPANK_REACTIONS.unshift(BIG_SPANK_REACTIONS.pop());
         big.actLine(BIG_SPANK_REACTIONS[0],true);
         resetVoxxerTimer(true);
      }
      
      private function resetVoxxerTimer(param1:Boolean = false) : void
      {
         timeoutVoxTimer.reset();
         if(param1)
         {
            timeoutVoxTimer.start();
         }
         else
         {
            timeoutVoxTimer.stop();
         }
      }
      
      private function handleBackButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      private function receiveTreeLayer(param1:SharerInfo) : void
      {
         treeLayer = VPortLayerButton(param1.reference).viewportLayer;
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("AppleTreeGame.appleTreeGameLibCommon",SWFLocations.appleTreeGameLibCommon,assetLibLoaded);
         dispatchAssetRequest("AppleTreeGame.appleTreeGameLibSmall",SWFLocations.appleTreeGameSmall,assetLibLoaded);
         dispatchAssetRequest("AppleTreeGame.appleTreeGameLibBig",SWFLocations.appleTreeGameBig,assetLibLoaded);
         dispatchAssetRequest("AppleTreeGame.appleTreeGameVoxBig",SWFLocations.appleTreeGameVoxBig,assetLibLoaded);
         dispatchAssetRequest("AppleTreeGame.appleTreeGameVoxSmall",SWFLocations.appleTreeGameVoxSmall,assetLibLoaded);
         dispatchAssetRequest("AppleTreeGame.appleTreeGameSFX",SWFLocations.appleTreeGameSFX,assetLibLoaded);
         super.onRegistration();
      }
      
      public function resetGameStatus() : void
      {
         applesOnFloor = 0;
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         return super.getLiveVisibleDisplayObjects().concat(DO3DDefinitions.GARDEN_DAE,DO3DDefinitions.GARDEN_PARALLAX);
      }
      
      private function handleAppleImpactsFloor(param1:AppleTreeEvent) : void
      {
         if(!activeState)
         {
            return;
         }
         ++applesOnFloor;
         if(applesOnFloor >= 5)
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               BIG_VOX_COMPLETIONS.unshift(BIG_VOX_COMPLETIONS.pop());
               big.actLine(BIG_VOX_COMPLETIONS[0],false,callbackGameFinished);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               SMALL_VOX_COMPLETIONS.unshift(SMALL_VOX_COMPLETIONS.pop());
               small.actLine(SMALL_VOX_COMPLETIONS[0],false,callbackGameFinished);
            }
            resetVoxxerTimer(false);
         }
         else if(!param1.apple.hitbig)
         {
            if(currentPOV == CharacterDefinitions.SMALL)
            {
               BIG_VOX_APPLEIMPACTS.unshift(BIG_VOX_APPLEIMPACTS.pop());
               big.actLine(BIG_VOX_APPLEIMPACTS[0],false);
            }
            else if(currentPOV == CharacterDefinitions.BIG)
            {
               SMALL_VOX_APPLEIMPACTS.unshift(SMALL_VOX_APPLEIMPACTS.pop());
               small.actLine(SMALL_VOX_APPLEIMPACTS[0]);
            }
            resetVoxxerTimer(true);
         }
      }
      
      private function initSmall() : void
      {
         var _loc1_:MovieClip = unPackAsset("SmallRunLeft") as MovieClip;
         var _loc2_:MovieClip = unPackAsset("SmallRunRight") as MovieClip;
         var _loc3_:MovieClip = unPackAsset("SmallStill") as MovieClip;
         var _loc4_:MovieClip = unPackAsset("SmallPickUp") as MovieClip;
         var _loc5_:MovieClip = unPackAsset("SmallExit") as MovieClip;
         small = new AppleTreeSmall(SoundChannelDefinitions.VOX,floor,_loc3_,_loc1_,_loc2_,_loc4_,_loc5_);
         small.viewportLayer = basicView.viewport.getChildLayer(small,true,true);
         small.viewportLayer.forceDepth = true;
         small.viewportLayer.screenDepth = 5;
         small.hide();
         registerLiveDO3D(DO3DDefinitions.APPLETREEGAME_SMALL,small);
         small.registerVox(SMALL_VOX_INTRO,unPackAsset("Small_VoxCtrl_INTRO"),unPackAsset("apl_sm_woohooitsap"));
         small.registerVox(SMALL_VOX_APPLEIMPACT_I,unPackAsset("Small_VoxCtrl_APPLEIMPACT_I"),unPackAsset("apl_sm_fallingapple"));
         small.registerVox(SMALL_VOX_APPLEIMPACT_II,unPackAsset("Small_VoxCtrl_APPLEIMPACT_II"),unPackAsset("apl_sm_anotherone"));
         small.registerVox(SMALL_VOX_APPLEIMPACT_III,unPackAsset("Small_VoxCtrl_APPLEIMPACT_III"),unPackAsset("apl_sm_luckyus"));
         small.registerVox(SMALL_VOX_APPLEIMPACT_IV,unPackAsset("Small_VoxCtrl_APPLEIMPACT_IV"),unPackAsset("apl_sm_wohaha"));
         small.registerVox(SMALL_VOX_TIMEOUT_I,unPackAsset("Small_VoxCtrl_TIMEOUT_I"),unPackAsset("apl_sm_cmonitllbe"));
         small.registerVox(SMALL_VOX_TIMEOUT_II,unPackAsset("Small_VoxCtrl_TIMEOUT_II"),unPackAsset("apl_sm_okseethose"));
         small.registerVox(SMALL_VOX_COMPLETION_I,unPackAsset("Small_VoxCtrl_COMPLETION_I"),unPackAsset("apl_sm_yeahthatllbe"));
         small.registerVox(SMALL_VOX_COMPLETION_II,unPackAsset("Small_VoxCtrl_COMPLETION_II"),unPackAsset("apl_sm_woohoowearet"));
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         super.update(param1);
         appleManager.update(currentPOV == CharacterDefinitions.SMALL);
         if(currentPOV == CharacterDefinitions.BIG)
         {
            small.update();
            flagDirtyLayer(small.viewportLayer);
         }
         else if(currentPOV == CharacterDefinitions.SMALL)
         {
            big.update();
         }
      }
      
      private function handleVoxTimeout(param1:TimerEvent) : void
      {
         if(currentPOV == CharacterDefinitions.SMALL && !big.isTalking)
         {
            BIG_VOX_TIMEOUTS.unshift(BIG_VOX_TIMEOUTS.pop());
            big.actLine(BIG_VOX_TIMEOUTS[0],false);
         }
         else if(currentPOV == CharacterDefinitions.BIG && !small.isTalking)
         {
            SMALL_VOX_TIMEOUTS.unshift(SMALL_VOX_TIMEOUTS.pop());
            small.actLine(SMALL_VOX_TIMEOUTS[0]);
         }
         resetVoxxerTimer(true);
      }
      
      private function handleSmallDirty(param1:Event) : void
      {
         flagDirtyLayer(small.container);
      }
      
      private function initFloor() : void
      {
         var _loc1_:Array = [];
         _loc1_.push(new Number3D(-600,-470,gameZ));
         _loc1_.push(new Number3D(-400,-390,gameZ));
         _loc1_.push(new Number3D(-300,-330,gameZ));
         _loc1_.push(new Number3D(-150,-270,gameZ));
         _loc1_.push(new Number3D(-20,-235,gameZ));
         _loc1_.push(new Number3D(100,-225,gameZ));
         _loc1_.push(new Number3D(400,-225,gameZ));
         floor = new AppleTreeFloor(_loc1_,225,125,90);
      }
      
      private function initBig() : void
      {
         var _loc1_:MovieClip = MovieClip(unPackAsset("AppleTreeGame_BigSprite"));
         var _loc2_:MovieClip = MovieClip(unPackAsset("AppleTreeGame_BigHead_IDLE"));
         big = new AppleTreeBig(SoundChannelDefinitions.VOX);
         big.setContent(_loc1_,_loc2_);
         big.position = new Number3D(306,-217,580);
         var _loc3_:ViewportLayer = basicView.viewport.getChildLayer(big);
         _loc3_.forceDepth = true;
         _loc3_.screenDepth = 5;
         registerLiveDO3D(DO3DDefinitions.APPLETREEGAME_BIG,big);
         big.registerVoxBody(BIG_SPANK_REACTION_A,unPackAsset("apl_bg_owheytree"),unPackAsset("AppleTreeGame_BigSprite_SpankReact1"));
         big.registerVoxBody(BIG_SPANK_REACTION_B,unPackAsset("apl_bg_ooooeeouch"),unPackAsset("AppleTreeGame_BigSprite_SpankReact2"));
         big.registerVoxHead(BIG_VOX_INTRO,unPackAsset("apl_bg_seethose"),unPackAsset("BigHead_VOX_INTRO"));
         big.registerVoxHead(BIG_VOX_APPLEIMPACT_I,unPackAsset("apl_bg_wowthatwas"),unPackAsset("BigHead_VOX_APPLEIMPACT_I"));
         big.registerVoxHead(BIG_VOX_APPLEIMPACT_II,unPackAsset("apl_bg_woahwatch"),unPackAsset("BigHead_VOX_APPLEIMPACT_II"));
         big.registerVoxHead(BIG_VOX_APPLEIMPACT_III,unPackAsset("apl_bg_heysmallimtry"),unPackAsset("BigHead_VOX_APPLEIMPACT_III"));
         big.registerVoxHead(BIG_VOX_COMPLETION_I,unPackAsset("apl_bg_heysmallall"),unPackAsset("BigHead_VOX_COMPLETION_I"));
         big.registerVoxHead(BIG_VOX_COMPLETION_II,unPackAsset("apl_bg_thatsthelast"),unPackAsset("BigHead_VOX_COMPLETION_II"));
         big.registerVoxHead(BIG_VOX_TIMEOUT_I,unPackAsset("apl_bg_applecollectingis"),unPackAsset("BigHead_VOX_TIMEOUT_I"));
         big.registerVoxHead(BIG_VOX_TIMEOUT_II,unPackAsset("apl_bg_justthink"),unPackAsset("BigHead_VOX_TIMEOUT_II"));
      }
      
      private function handleAppleFindsRest(param1:AppleTreeEvent) : void
      {
         if(!activeState)
         {
            return;
         }
         if(currentPOV == CharacterDefinitions.BIG)
         {
            small.appleHitsFloor(param1.apple);
         }
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         resetGameStatus();
         if(Boolean(big) && Boolean(small))
         {
            if(currentPOV == CharacterDefinitions.BIG)
            {
               big.park();
               small.prepare();
            }
            else if(currentPOV == CharacterDefinitions.SMALL)
            {
               small.park();
               big.prepare();
            }
         }
      }
      
      private function callbackGameFinished() : void
      {
         dispatchEvent(new BrainEvent(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_HUB));
      }
      
      override public function park() : void
      {
         super.park();
         appleManager.park();
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            big.park();
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            small.park();
         }
         if(basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         if(treeLayer)
         {
            appleManager.putApplesInSharedLayer(treeLayer);
         }
      }
      
      override public function onShareableRegistration() : void
      {
         dispatchShareRequest(new ShareRequest(this,"TreeLayerButton",receiveTreeLayer));
      }
      
      override public function deactivate() : void
      {
         resetVoxxerTimer(false);
         appleManager.deactivate();
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            big.deactivate();
         }
         else if(currentPOV == CharacterDefinitions.BIG)
         {
            small.deactivate();
         }
         TweenMax.to(backButton,0.3,{"y":backButtonPos.y + 200});
         super.deactivate();
         activeState = false;
      }
      
      override public function collectionQueueEmpty() : void
      {
         initFloor();
         initSmall();
         initBig();
         initApples();
         initBackButton();
         if(treeLayer)
         {
            appleManager.putApplesInSharedLayer(treeLayer);
         }
         setReadyState();
      }
   }
}

