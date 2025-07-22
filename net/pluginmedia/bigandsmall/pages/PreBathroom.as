package net.pluginmedia.bigandsmall.pages
{
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeterInfo;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class PreBathroom extends BigAndSmallPage3D
   {
      
      private var bedroomDoorLayer:ViewportLayer;
      
      private var dynamicLiveObjects:Array;
      
      private var roomContentDAE:DAEFixed;
      
      private var bathroomDoor3D:Door3D;
      
      private var roomContentLayer:ViewportLayer;
      
      private var liveObjectSet:Array;
      
      private var roomDAE:DAEFixed;
      
      private var roomLayer:ViewportLayer;
      
      private var backButton:AssetButton;
      
      private var videoFrameDAE:DAEFixed;
      
      public function PreBathroom(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = null;
         var _loc5_:OrbitCamera3D = null;
         liveObjectSet = [DO3DDefinitions.BEDROOM_ROOM,DO3DDefinitions.BEDROOM_BATHROOMDOOR,DO3DDefinitions.BEDROOM_OBJECTS];
         dynamicLiveObjects = liveObjectSet.concat();
         _loc4_ = new Number3D(-500,350,-495);
         _loc5_ = new OrbitCamera3D(44);
         _loc5_.rotationYMin = -103;
         _loc5_.rotationYMax = -89;
         _loc5_.radius = 150;
         _loc5_.rotationXMin = -12;
         _loc5_.rotationXMax = 0;
         _loc5_.orbitCentre.x = -200;
         _loc5_.orbitCentre.y = 447;
         _loc5_.orbitCentre.z = -570;
         var _loc6_:OrbitCamera3D = new OrbitCamera3D(38);
         _loc6_.rotationYMin = -97;
         _loc6_.rotationYMax = -83;
         _loc6_.radius = 194;
         _loc6_.rotationXMin = 10;
         _loc6_.rotationXMax = 18;
         _loc6_.orbitCentre.x = -240;
         _loc6_.orbitCentre.y = 547;
         _loc6_.orbitCentre.z = -600;
         super(param1,_loc4_,_loc6_,_loc5_,param2);
      }
      
      private function handleBackButtonClick(param1:BrainEvent) : void
      {
         broadcast(BrainEventType.HIDE_PRELOADER);
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(param1.actionType,param1.actionTarget);
      }
      
      override public function onShareableRegistration() : void
      {
         dispatchShareRequest(new ShareRequest(this,DO3DDefinitions.BEDROOM_BATHROOMDOOR,handleBathroomDoorShared));
         dispatchShareRequest(new ShareRequest(this,"GlobalAssets.BackButton",handleSetBackButton));
      }
      
      private function handleBackButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      override public function activate() : void
      {
         super.activate();
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         broadcast(BrainEventType.MULTIPAGE_LOADPROGRESS,null,new MultiPageLoadProgressMeterInfo([PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,PageDefinitions.BATHROOM_VIDEO_A],handleBathroomLoaded));
      }
      
      override public function transitionProgressOut(param1:Number) : void
      {
         if(param1 > 0.5 && dynamicLiveObjects.length > 0)
         {
            dynamicLiveObjects = [];
            dispatchEvent(new BrainEvent(BigAndSmallEventType.REFRESH_LIVEDISPLAYOBJECTS));
         }
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         return _loc1_.concat(dynamicLiveObjects);
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         broadcast(BrainEventType.PRIORITISE_LOADQUEUE,null,[PageDefinitions.BATHROOM,PageDefinitions.BATHROOM_TOOTHBRUSHTACKLE,PageDefinitions.BATHROOM_VIDEO_A]);
         broadcast(BigAndSmallEventType.SET_STAGE_COLOUR,null,0);
      }
      
      private function handleBathroomLoaded() : void
      {
         if(bathroomDoor3D)
         {
            bathroomDoor3D.openDoor();
         }
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.BATHROOM);
      }
      
      private function handleSetBackButton(param1:SharerInfo) : void
      {
         backButton = new AssetButton(param1.reference as Class,BrainEventType.CHANGE_PAGE,PageDefinitions.BEDROOM);
         backButton.scaleX = backButton.scaleY = 1;
         backButton.x = pageWidth - backButton.width - 45;
         backButton.y = pageHeight - backButton.height;
         backButton.addEventListener(BrainEvent.ACTION,handleBackButtonClick);
         backButton.addEventListener(MouseEvent.MOUSE_OVER,handleBackButtonOver);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Back to Bedroom",AccessibilityDefinitions.UIBUTTON);
         pageContainer2D.addChild(backButton);
      }
      
      private function handleBathroomDoorShared(param1:SharerInfo) : void
      {
         bathroomDoor3D = param1.reference as Door3D;
         bathroomDoor3D.rotYOnOver = 190;
         bathroomDoor3D.rotYOnOpen = 290;
      }
      
      override public function park() : void
      {
         dynamicLiveObjects = liveObjectSet.concat();
         if(bathroomDoor3D)
         {
            bathroomDoor3D.closeDoor(true);
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
      }
      
      override protected function build() : void
      {
         setReadyState();
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
         if(backButton)
         {
            backButton.tabEnabled = param1;
         }
      }
      
      override public function onRegistration() : void
      {
      }
   }
}

