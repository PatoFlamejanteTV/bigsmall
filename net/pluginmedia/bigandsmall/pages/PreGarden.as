package net.pluginmedia.bigandsmall.pages
{
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.shared.Door3D;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
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
   
   public class PreGarden extends BigAndSmallPage3D
   {
      
      private var gardenDoor:Door3D;
      
      private var roomContentDAE:DAEFixed;
      
      private var gardenDoorLayer:ViewportLayer;
      
      private var roomContentLayer:ViewportLayer;
      
      private var liveObjectSet:Array;
      
      private var gardenILoadable:ILoadable;
      
      private var roomDAE:DAEFixed;
      
      private var leftTableFlowerLayer:ViewportLayer;
      
      private var roomLayer:ViewportLayer;
      
      private var backButton:AssetButton;
      
      public function PreGarden(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc4_:Number3D = null;
         var _loc5_:OrbitCamera3D = null;
         var _loc6_:OrbitCamera3D = null;
         liveObjectSet = [DO3DDefinitions.LIVINGROOM_FURNITURE,DO3DDefinitions.LIVINGROOM_GARDENDOOR,DO3DDefinitions.LIVINGROOM_ROOM,DO3DDefinitions.LIVINGROOM_TABLEFLOWERA];
         _loc4_ = new Number3D(-50,-100,600);
         _loc5_ = new OrbitCamera3D(44);
         _loc5_.orbitCentre.x = -300;
         _loc5_.orbitCentre.y = 130;
         _loc5_.orbitCentre.z = 58;
         _loc5_.radius = 204.99;
         _loc5_.fov = 49.26;
         _loc5_.zoom = 40;
         _loc5_.focus = 12.37;
         _loc5_.rotationYMin = -89;
         _loc5_.rotationYMax = -90;
         _loc5_.rotationXMin = -10;
         _loc5_.rotationXMax = -9;
         _loc6_ = new OrbitCamera3D(44);
         _loc6_.orbitCentre.x = -300;
         _loc6_.orbitCentre.y = 140;
         _loc6_.orbitCentre.z = 58;
         _loc6_.radius = 204.99;
         _loc6_.fov = 49.26;
         _loc6_.zoom = 40;
         _loc6_.focus = 12.37;
         _loc6_.rotationYMin = -85;
         _loc6_.rotationYMax = -86;
         _loc6_.rotationXMin = 10;
         _loc6_.rotationXMax = 9;
         super(param1,_loc4_,_loc6_,_loc5_,param2);
      }
      
      override public function onShareableRegistration() : void
      {
         dispatchShareRequest(new ShareRequest(this,DO3DDefinitions.LIVINGROOM_GARDENDOOR,handleGardenDoorShared));
         dispatchShareRequest(new ShareRequest(this,"LivingRoom.leftTableFlowerLayer",handleLeftTableFlowerShared));
         dispatchShareRequest(new ShareRequest(this,"GlobalAssets.BackButton",handleSetBackButton));
      }
      
      private function handleBackButtonOver(param1:MouseEvent) : void
      {
         SoundManagerOld.playSound("gn_arrow_over");
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         broadcast(BigAndSmallEventType.HIDE_BS_BUTTONS);
         if(Boolean(leftTableFlowerLayer) && currentPOV == CharacterDefinitions.BIG)
         {
            leftTableFlowerLayer.screenDepth = int.MIN_VALUE;
            leftTableFlowerLayer.forceDepth = true;
         }
         broadcast(BrainEventType.PRIORITISE_LOADQUEUE,null,[PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_VIDEO,PageDefinitions.GARDEN_APPLETREE,PageDefinitions.MYSTERIOUS_WOODS]);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         return _loc1_.concat(liveObjectSet);
      }
      
      override public function activate() : void
      {
         super.activate();
         if(!basicView.contains(pageContainer2D))
         {
            basicView.addChild(pageContainer2D);
         }
         if(Boolean(leftTableFlowerLayer) && currentPOV == CharacterDefinitions.BIG)
         {
            leftTableFlowerLayer.screenDepth = int.MIN_VALUE;
            leftTableFlowerLayer.forceDepth = true;
         }
         broadcast(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON);
         broadcast(BrainEventType.MULTIPAGE_LOADPROGRESS,null,new MultiPageLoadProgressMeterInfo([PageDefinitions.GARDEN_HUB,PageDefinitions.GARDEN_VEGPATCH,PageDefinitions.GARDEN_VIDEO,PageDefinitions.GARDEN_APPLETREE,PageDefinitions.MYSTERIOUS_WOODS],handleGardenLoaded));
      }
      
      private function handleGardenDoorShared(param1:SharerInfo) : void
      {
         gardenDoor = param1.reference as Door3D;
         gardenDoor.defaultRotY = 0;
         gardenDoor.rotYOnOver = 10;
         gardenDoor.rotYOnOpen = -80;
      }
      
      private function handleBackButtonClick(param1:BrainEvent) : void
      {
         broadcast(BrainEventType.HIDE_PRELOADER);
         SoundManagerOld.playSound("gn_arrow_click");
         broadcast(param1.actionType,param1.actionTarget);
      }
      
      private function handleSetBackButton(param1:SharerInfo) : void
      {
         backButton = new AssetButton(param1.reference as Class,BrainEventType.CHANGE_PAGE,PageDefinitions.LIVINGROOM);
         backButton.scaleX = backButton.scaleY = 1;
         backButton.x = pageWidth - backButton.width - 45;
         backButton.y = pageHeight - backButton.height;
         backButton.addEventListener(BrainEvent.ACTION,handleBackButtonClick);
         backButton.addEventListener(MouseEvent.MOUSE_OVER,handleBackButtonOver);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Back to LivingRoom",AccessibilityDefinitions.UIBUTTON);
         pageContainer2D.addChild(backButton);
      }
      
      private function handleLeftTableFlowerShared(param1:SharerInfo) : void
      {
         leftTableFlowerLayer = param1.reference as ViewportLayer;
         leftTableFlowerLayer.screenDepth = int.MIN_VALUE;
      }
      
      private function handleGardenLoaded() : void
      {
         broadcast(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_HUB);
      }
      
      override public function park() : void
      {
         if(gardenDoor)
         {
            gardenDoor.closeDoor(true);
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         if(Boolean(leftTableFlowerLayer) && currentPOV == CharacterDefinitions.BIG)
         {
            leftTableFlowerLayer.forceDepth = false;
         }
      }
      
      override protected function build() : void
      {
         setReadyState();
      }
      
      override public function onRegistration() : void
      {
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         super.tabEnableViewports(param1);
         if(backButton)
         {
            backButton.tabEnabled = param1;
         }
      }
   }
}

