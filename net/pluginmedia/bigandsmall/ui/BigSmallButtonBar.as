package net.pluginmedia.bigandsmall.ui
{
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.ButtonContainer;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.loading.AssetRequest;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   
   public class BigSmallButtonBar extends ButtonContainer implements ILoadable
   {
      
      private var placeRect:Rectangle;
      
      private var _ioErrorAutoFail:Boolean = true;
      
      private var bigButton:BigSmallAssetButton;
      
      private var _percentageLoaded:Number;
      
      private var _loadFailed:Boolean = false;
      
      private var smallButton:BigSmallAssetButton;
      
      private var assetLibrary:AssetLoader = null;
      
      public function BigSmallButtonBar(param1:Rectangle)
      {
         super();
         placeRect = param1;
         x = placeRect.x;
         y = placeRect.y;
         build();
      }
      
      public function collectionQueueEmpty() : void
      {
         bigButton.setUserData(assetLibrary.getAssetByName("UIBigButton"));
         smallButton.setUserData(assetLibrary.getAssetByName("UISmallButton"));
      }
      
      public function get loadFailed() : Boolean
      {
         return _loadFailed;
      }
      
      public function receiveAsset(param1:IAssetLoader, param2:String) : void
      {
      }
      
      public function recieveUIAssets(param1:IAssetLoader) : void
      {
         assetLibrary = param1 as AssetLoader;
      }
      
      public function hideButtons(param1:Boolean = true) : void
      {
         smallButton.visible = !param1;
         bigButton.visible = !param1;
      }
      
      public function set unitLoaded(param1:Number) : void
      {
         _percentageLoaded = param1;
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
      
      public function get unitLoaded() : Number
      {
         return _percentageLoaded;
      }
      
      public function build() : void
      {
         bigButton = new BigSmallAssetButton(BigAndSmallEventType.CHANGE_CHARACTER,CharacterDefinitions.BIG);
         addButton(bigButton);
         AccessibilityManager.addAccessibilityProperties(bigButton,"Big","Play as Big",AccessibilityDefinitions.UIBUTTON);
         smallButton = new BigSmallAssetButton(BigAndSmallEventType.CHANGE_CHARACTER,CharacterDefinitions.SMALL);
         smallButton.x = placeRect.width;
         smallButton.y = placeRect.height;
         addButton(smallButton);
         AccessibilityManager.addAccessibilityProperties(smallButton,"Small","Play as Small",AccessibilityDefinitions.UIBUTTON);
      }
      
      public function setSelectedButton(param1:String) : void
      {
         bigButton.defaultState();
         smallButton.defaultState();
         switch(param1)
         {
            case CharacterDefinitions.SMALL:
               smallButton.setSelectedState(true);
               break;
            case CharacterDefinitions.BIG:
               bigButton.setSelectedState(true);
         }
      }
      
      protected function dispatchAssetRequest(param1:AssetRequest) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.ASSET_REQUEST,param1));
      }
      
      public function onRegistration() : void
      {
         var _loc1_:AssetRequest = new AssetRequest(this,"UI.assetLibrary",SWFLocations.uiLibrary,recieveUIAssets,null,true,true,10);
         dispatchAssetRequest(_loc1_);
      }
   }
}

