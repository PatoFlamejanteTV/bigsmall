package net.pluginmedia.bigandsmall.core
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.loading.DAETextureLoadHelper;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.LoaderAssetPage3D;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.ShareReferenceEvent;
   import net.pluginmedia.brain.core.events.ShareRequestEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ISharer;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BigAndSmallPage3D extends LoaderAssetPage3D implements ISharer, IUpdatable
   {
      
      protected var pageLayer:ViewportLayer;
      
      protected var pageContainer2D:Sprite = new Sprite();
      
      protected var currentPOV:String;
      
      protected var _active:Boolean = false;
      
      protected var bigCam:ICameraUpdateable;
      
      protected var incidentalList:Array = new Array();
      
      protected var smallCam:ICameraUpdateable;
      
      protected var defaultCam:OrbitCamera3D = new OrbitCamera3D(45);
      
      protected var accessInteractiveObjs:Array = [];
      
      protected var daeLoadHelper:DAETextureLoadHelper = new DAETextureLoadHelper();
      
      protected var assetPacks:Array = [];
      
      public var alwaysSmoothed:Boolean = false;
      
      public var helperTextNodeID:String = null;
      
      public function BigAndSmallPage3D(param1:BasicView, param2:Number3D, param3:ICameraUpdateable, param4:ICameraUpdateable, param5:String)
      {
         bigCam = param3 as ICameraUpdateable;
         smallCam = param4 as ICameraUpdateable;
         defaultCam.radius = 50;
         defaultCam.orbitCentre.x = param2.x;
         defaultCam.orbitCentre.y = param2.y;
         defaultCam.orbitCentre.z = param2.z;
         _autoUpdateCamera = true;
         super(param1,param2,defaultCam,param5);
         helperTextNodeID = param5;
      }
      
      override public function destroy() : void
      {
         var _loc1_:AssetLoader = null;
         var _loc2_:Incidental = null;
         defaultCam = null;
         bigCam = null;
         smallCam = null;
         currentPOV = null;
         for each(_loc1_ in assetPacks)
         {
            _loc1_.unload();
         }
         assetPacks = null;
         for each(_loc2_ in incidentalList)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
         incidentalList = null;
         _active = false;
         while(pageContainer2D.numChildren > 0)
         {
            pageContainer2D.removeChild(pageContainer2D.getChildAt(0));
         }
         pageContainer2D = null;
         super.destroy();
      }
      
      public function get active() : Boolean
      {
         return _active;
      }
      
      override public function prepare(param1:String = null) : void
      {
         super.prepare(param1);
         _active = true;
         prepareIncidentals();
      }
      
      protected function selfDestruct() : void
      {
         broadcast(BrainEventType.KILL_PAGE,null,{"page":this});
      }
      
      public function disableIncidentals() : void
      {
         var _loc1_:Incidental = null;
         var _loc2_:int = 0;
         while(_loc2_ < incidentalList.length)
         {
            _loc1_ = incidentalList[_loc2_] as Incidental;
            _loc1_.stop();
            _loc1_.deactivate();
            _loc2_++;
         }
      }
      
      public function prepareIncidentals() : void
      {
         var _loc1_:Incidental = null;
         var _loc2_:int = 0;
         while(_loc2_ < incidentalList.length)
         {
            _loc1_ = incidentalList[_loc2_] as Incidental;
            _loc1_.prepare();
            _loc2_++;
         }
      }
      
      public function enableIncidentals() : void
      {
         var _loc1_:Incidental = null;
         var _loc2_:int = 0;
         while(_loc2_ < incidentalList.length)
         {
            _loc1_ = incidentalList[_loc2_] as Incidental;
            _loc1_.activate();
            _loc2_++;
         }
      }
      
      public function onShareableRegistration() : void
      {
      }
      
      override public function debugMode(param1:Boolean) : void
      {
         super.debugMode(param1);
      }
      
      protected function updateIncidentalsCharacter(param1:String) : void
      {
         var _loc2_:Incidental = null;
         var _loc3_:uint = 0;
         while(_loc3_ < incidentalList.length)
         {
            _loc2_ = incidentalList[_loc3_] as Incidental;
            _loc2_.setCharacter(param1);
            _loc3_++;
         }
      }
      
      public function receiveShareable(param1:SharerInfo) : void
      {
      }
      
      override protected function setReadyState() : void
      {
         tabEnableViewports(false);
         super.setReadyState();
      }
      
      protected function handleIncidentalRollover(param1:MouseEvent) : Incidental
      {
         return param1.target as Incidental;
      }
      
      public function onSoundManagerReg() : void
      {
      }
      
      public function setPauseState(param1:Boolean) : void
      {
         var _loc2_:Incidental = null;
         BrainLogger.out("BigAndSmallPage3D",pageID,"handling setPauseState",param1);
         var _loc3_:int = 0;
         while(_loc3_ < incidentalList.length)
         {
            _loc2_ = incidentalList[_loc3_] as Incidental;
            _loc2_.setPauseState(param1);
            _loc3_++;
         }
      }
      
      protected function unPackAsset(param1:String, param2:Boolean = false, param3:Class = null) : *
      {
         var _loc4_:AssetLoader = null;
         var _loc5_:* = null;
         var _loc6_:Number = 0;
         while(_loc6_ < assetPacks.length)
         {
            _loc4_ = assetPacks[_loc6_] as AssetLoader;
            if(param2)
            {
               _loc5_ = _loc4_.getAssetClassByName(param1);
            }
            else
            {
               _loc5_ = _loc4_.getAssetByName(param1,param3);
            }
            if(_loc5_ !== null)
            {
               return _loc5_;
            }
            _loc6_++;
         }
         BrainLogger.out("WARNING! Asset not found : ",param1);
         return null;
      }
      
      protected function handleIncidentalClick(param1:MouseEvent) : Incidental
      {
         return param1.target as Incidental;
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
      }
      
      public function parkIncidentals() : void
      {
         var _loc1_:Incidental = null;
         var _loc2_:int = 0;
         while(_loc2_ < incidentalList.length)
         {
            _loc1_ = incidentalList[_loc2_] as Incidental;
            _loc1_.park();
            _loc2_++;
         }
      }
      
      protected function dispatchShareRequest(param1:ShareRequest) : void
      {
         dispatchEvent(new ShareRequestEvent(ShareRequestEvent.SHARE_REQUEST,param1));
      }
      
      public function characterViewReady() : void
      {
      }
      
      public function updateCamera() : Boolean
      {
         return false;
      }
      
      protected function dispatchShareable(param1:String, param2:Object) : void
      {
         dispatchEvent(new ShareReferenceEvent(ShareReferenceEvent.SHARE_REFERENCE,new SharerInfo(param1,param2)));
      }
      
      protected function assetLibLoaded(param1:IAssetLoader) : void
      {
         assetPacks.push(param1);
      }
      
      protected function positionDO3D(param1:DisplayObject3D, param2:Number = 0, param3:Number = 0, param4:Number = 0) : void
      {
         param1.x = param2;
         param1.y = param3;
         param1.z = param4;
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
         switch(param1)
         {
            case CharacterDefinitions.BIG:
               _localCam = bigCam as CameraObject3D;
               break;
            case CharacterDefinitions.SMALL:
               _localCam = smallCam as CameraObject3D;
               break;
            default:
               _localCam = defaultCam;
         }
         updateIncidentalsCharacter(param1);
      }
      
      protected function registerAccessibleInteractive(param1:InteractiveObject, param2:String = "", param3:String = "", param4:Number = -1) : void
      {
         accessInteractiveObjs.push(param1);
         AccessibilityManager.addAccessibilityProperties(param1,param2,param3,param4);
      }
      
      override protected function registerLiveDO3D(param1:String, param2:DisplayObject3D) : void
      {
         super.registerLiveDO3D(param1,param2);
         this.dispatchShareable(param1,param2);
      }
      
      override protected function build() : void
      {
      }
      
      override public function park() : void
      {
         super.park();
         parkIncidentals();
         _active = false;
      }
      
      override public function activate() : void
      {
         super.activate();
         enableIncidentals();
         pageContainer2D.tabEnabled = true;
         tabEnableViewports(true);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         disableIncidentals();
         pageContainer2D.tabEnabled = false;
         tabEnableViewports(false);
      }
      
      protected function tabEnableViewports(param1:Boolean) : void
      {
         var interactiveobj:* = undefined;
         var bool:Boolean = param1;
         for each(interactiveobj in accessInteractiveObjs)
         {
            try
            {
               interactiveobj.tabEnabled = bool;
            }
            catch(e:Error)
            {
               trace("tabEnableViewports error ::",e);
            }
         }
      }
      
      public function addIncidental(param1:Incidental, param2:ViewportLayer = null) : void
      {
         var _loc3_:DisplayObject3D = null;
         if(!param2)
         {
            _loc3_ = param1 as DisplayObject3D;
            param2 = basicView.viewport.getChildLayer(_loc3_,true,true);
         }
         incidentalList.push(param1);
         param1.setCharacter(currentPOV);
         param1.setLayer(param2);
         param1.addEventListener(MouseEvent.CLICK,handleIncidentalClick);
         param1.addEventListener(MouseEvent.ROLL_OVER,handleIncidentalRollover);
         param1.deactivate();
      }
   }
}

