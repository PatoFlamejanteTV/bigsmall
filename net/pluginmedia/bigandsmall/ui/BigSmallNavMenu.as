package net.pluginmedia.bigandsmall.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.ButtonContainer;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.loading.AssetRequest;
   import net.pluginmedia.brain.core.loading.LoadProgressRequestInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   
   public class BigSmallNavMenu extends ButtonContainer implements ILoadable
   {
      
      private var pondButton:MenuAssetButton;
      
      private var _percentageLoaded:Number;
      
      private var _summoned:Boolean = false;
      
      private var bathroomButton:MenuAssetButton;
      
      private var assetLibrary:AssetLoader;
      
      private var bedroomButton:MenuAssetButton;
      
      private var inited:Boolean = false;
      
      private var woodsButton:MenuAssetButton;
      
      private var stageHeight:Number;
      
      private var bgBox:Sprite;
      
      private var closeButton:AssetButton;
      
      private var _ioErrorAutoFail:Boolean = true;
      
      private var livingroomButton:MenuAssetButton;
      
      private var _loadFailed:Boolean = false;
      
      private var stageWidth:Number;
      
      private var vegButton:MenuAssetButton;
      
      public var currentChar:String;
      
      private var buttonShadow:DropShadowFilter = new DropShadowFilter(5,45,0,0.4,5,5,1,1);
      
      public function BigSmallNavMenu(param1:Number, param2:Number)
      {
         super();
         stageWidth = param1;
         stageHeight = param2;
      }
      
      private function disableTab() : void
      {
         if(!inited)
         {
            return;
         }
         livingroomButton.tabEnabled = false;
         bedroomButton.tabEnabled = false;
         bathroomButton.tabEnabled = false;
         woodsButton.tabEnabled = false;
         pondButton.tabEnabled = false;
         vegButton.tabEnabled = false;
         closeButton.tabEnabled = false;
      }
      
      public function banish(param1:Boolean = false) : void
      {
         disableTab();
         _summoned = false;
         var _loc2_:Number = 0;
         var _loc3_:Number = stageHeight;
         if(bgBox)
         {
            _loc3_ -= bgBox.y;
         }
         if(param1)
         {
            this.x = _loc2_;
            this.y = _loc3_;
            visible = false;
         }
         else
         {
            TweenMax.to(this,0.4,{
               "x":_loc2_,
               "y":_loc3_,
               "overwrite":true,
               "onComplete":handleBanishComplete
            });
         }
         dispatchEvent(new Event(Event.CLOSE));
         removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function recieveUIAssets(param1:IAssetLoader) : void
      {
         assetLibrary = param1 as AssetLoader;
      }
      
      private function enableTab() : void
      {
         if(!inited)
         {
            return;
         }
         livingroomButton.tabEnabled = true;
         bedroomButton.tabEnabled = true;
         bathroomButton.tabEnabled = true;
         woodsButton.tabEnabled = true;
         pondButton.tabEnabled = true;
         vegButton.tabEnabled = true;
         closeButton.tabEnabled = true;
      }
      
      private function handleCloseButtonClick(param1:MouseEvent) : void
      {
         banish();
      }
      
      private function dispatchAssetRequest(param1:AssetRequest) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.ASSET_REQUEST,param1));
      }
      
      public function get unitLoaded() : Number
      {
         return _percentageLoaded;
      }
      
      private function initSkin() : void
      {
         bgBox = assetLibrary.getAssetByName("NavMenuBox");
         bgBox.x = bgBox.y = 0;
         addChild(bgBox);
         livingroomButton = new MenuAssetButton(assetLibrary.getAssetByName("IconLivingroom"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.LIVINGROOM);
         livingroomButton.filters = [buttonShadow];
         livingroomButton.x = 145;
         livingroomButton.y = 197;
         addButton(livingroomButton);
         AccessibilityManager.addAccessibilityProperties(livingroomButton,"Living Room","Visit the Living Room",AccessibilityDefinitions.UIBUTTON);
         bedroomButton = new MenuAssetButton(assetLibrary.getAssetByName("IconBedroom"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.LANDING);
         bedroomButton.filters = [buttonShadow];
         bedroomButton.x = 387;
         bedroomButton.y = 197;
         addButton(bedroomButton);
         AccessibilityManager.addAccessibilityProperties(bedroomButton,"Bedroom","Visit the Bedroom",AccessibilityDefinitions.UIBUTTON);
         bathroomButton = new MenuAssetButton(assetLibrary.getAssetByName("IconBathroom"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.BATHROOM);
         bathroomButton.filters = [buttonShadow];
         bathroomButton.x = 617;
         bathroomButton.y = 200;
         addButton(bathroomButton);
         AccessibilityManager.addAccessibilityProperties(bathroomButton,"Bathroom","Visit the Bathroom",AccessibilityDefinitions.UIBUTTON);
         woodsButton = new MenuAssetButton(assetLibrary.getAssetByName("IconWoods"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.MYSTERIOUS_WOODS);
         woodsButton.filters = [buttonShadow];
         woodsButton.x = 145;
         woodsButton.y = 406;
         addButton(woodsButton);
         AccessibilityManager.addAccessibilityProperties(woodsButton,"Mysterious Woods","Visit the Mysterious Woods",AccessibilityDefinitions.UIBUTTON);
         pondButton = new MenuAssetButton(assetLibrary.getAssetByName("IconPond"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.GARDENREGION_POND);
         pondButton.filters = [buttonShadow];
         pondButton.x = 385;
         pondButton.y = 400;
         addButton(pondButton);
         AccessibilityManager.addAccessibilityProperties(pondButton,"Pond","Visit the Pond",AccessibilityDefinitions.UIBUTTON);
         vegButton = new MenuAssetButton(assetLibrary.getAssetByName("IconVeg"),BigAndSmallEventType.MENU_CHANGE_PAGE,PageDefinitions.GARDENREGION_VEGPATCH);
         vegButton.filters = [buttonShadow];
         vegButton.x = 613;
         vegButton.y = 397;
         addButton(vegButton);
         AccessibilityManager.addAccessibilityProperties(vegButton,"Pond","Visit the Vegetable Garden",AccessibilityDefinitions.UIBUTTON);
         closeButton = new AssetButton(assetLibrary.getAssetByName("ButtonClose"));
         closeButton.scaleX = closeButton.scaleY = 0.75;
         closeButton.x = 715;
         closeButton.y = 14;
         addChild(closeButton);
         closeButton.addEventListener(MouseEvent.CLICK,handleCloseButtonClick);
         AccessibilityManager.addAccessibilityProperties(closeButton,"Close Menu","Close the Menu",AccessibilityDefinitions.UIBUTTON);
         inited = true;
         disableTab();
      }
      
      private function handleBanishComplete() : void
      {
         visible = false;
      }
      
      public function updateMemberLoadedStatus() : void
      {
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         if(!livingroomButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(livingroomButton.updateLoadProgress,[PageDefinitions.PRELOADER,PageDefinitions.LIVINGROOM,PageDefinitions.LIVINGROOM_BANDGAME,PageDefinitions.LIVINGROOM_DRAWINGGAME,PageDefinitions.LANDING]));
         }
         if(!bedroomButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(bedroomButton.updateLoadProgress,[PageDefinitions.BEDROOM,PageDefinitions.LANDING]));
         }
         if(!bathroomButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(bathroomButton.updateLoadProgress,[PageDefinitions.PREBATHROOM,PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE]));
         }
         if(!woodsButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(woodsButton.updateLoadProgress,[PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_APPLETREE,PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_VIDEO,PageDefinitions.MYSTERIOUS_WOODS]));
         }
         if(!pondButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(pondButton.updateLoadProgress,[PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_APPLETREE,PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_VIDEO,PageDefinitions.MYSTERIOUS_WOODS]));
         }
         if(!vegButton.pageLoaded)
         {
            broadcast(BrainEventType.GET_LOADPROGRESS,null,new LoadProgressRequestInfo(vegButton.updateLoadProgress,[PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_APPLETREE,PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_VIDEO,PageDefinitions.MYSTERIOUS_WOODS]));
         }
      }
      
      public function get loadFailed() : Boolean
      {
         return _loadFailed;
      }
      
      public function get summoned() : Boolean
      {
         return _summoned;
      }
      
      public function receiveAsset(param1:IAssetLoader, param2:String) : void
      {
      }
      
      public function set unitLoaded(param1:Number) : void
      {
         _percentageLoaded = param1;
      }
      
      public function onRegistration() : void
      {
         var _loc1_:AssetRequest = new AssetRequest(this,"NavMenu.assetLibrary",SWFLocations.navMenuLibrary,recieveUIAssets);
         dispatchAssetRequest(_loc1_);
      }
      
      public function summon(param1:Boolean = false) : void
      {
         visible = true;
         enableTab();
         _summoned = true;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(param1)
         {
            this.x = _loc2_;
            this.y = _loc3_;
         }
         else
         {
            TweenMax.to(this,0.6,{
               "x":_loc2_,
               "y":_loc3_,
               "overwrite":true
            });
         }
         addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function ioErrorCallback(param1:IOErrorEvent) : void
      {
         _loadFailed = true;
         if(_ioErrorAutoFail)
         {
            BrainLogger.out("dispatching kill request :: ",param1);
            broadcast(BrainEventType.KILL_APP,null,param1);
         }
      }
      
      public function collectionQueueEmpty() : void
      {
         initSkin();
      }
      
      override protected function handleAction(param1:BrainEvent) : void
      {
         if(!MenuAssetButton(param1.target).pageLoaded)
         {
            return;
         }
         banish();
         broadcast(param1.actionType,param1.actionTarget,param1.data);
      }
   }
}

