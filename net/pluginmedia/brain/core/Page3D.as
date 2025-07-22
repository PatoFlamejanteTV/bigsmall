package net.pluginmedia.brain.core
{
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.PageEvent;
   import net.pluginmedia.brain.core.interfaces.IBroadcaster;
   import net.pluginmedia.brain.core.interfaces.IPage3D;
   import org.papervision3d.core.data.UserData;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Cube;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Page3D extends DisplayObject3D implements IPage3D, IBroadcaster
   {
      
      protected var _do3dList:Array = [];
      
      protected var _pageID:String;
      
      protected var basicView:BasicView;
      
      protected var _debugMode:Boolean = false;
      
      protected var debugCube:Cube;
      
      protected var _overrideRenderFlag:Boolean = false;
      
      protected var _isActive:Boolean = false;
      
      protected var _pageHeight:Number = 480;
      
      protected var _localCam:CameraObject3D;
      
      protected var _isTransitionReady:Boolean = false;
      
      protected var _renderStateIsDirty:Boolean = false;
      
      protected var _do3dListOmitTransit:Array = [];
      
      protected var _isLive:Boolean = false;
      
      protected var _dirtyLayers:Array = [];
      
      protected var _pageWidth:Number = 640;
      
      protected var _autoUpdateCamera:Boolean = true;
      
      public function Page3D(param1:BasicView, param2:Number3D, param3:CameraObject3D, param4:String)
      {
         super();
         this.name = param4;
         basicView = param1;
         _localCam = param3;
         _pageID = param4;
         x = param2.x;
         y = param2.y;
         z = param2.z;
         build();
      }
      
      public function getTransitionOmitObjects() : Array
      {
         return _do3dListOmitTransit;
      }
      
      protected function registerLiveDO3D(param1:String, param2:DisplayObject3D) : void
      {
         param2.name = param1;
         param2.userData = new UserData({"page3D":this});
         _do3dList.push(param1);
      }
      
      public function set isLive(param1:Boolean) : void
      {
         _isLive = param1;
      }
      
      public function prepare(param1:String = null) : void
      {
      }
      
      protected function build() : void
      {
         debugCube = getDebugCube();
         addChild(debugCube);
         setReadyState();
      }
      
      protected function getDebugCube() : Cube
      {
         var _loc1_:MaterialsList = new MaterialsList();
         var _loc2_:WireframeMaterial = new WireframeMaterial(16711680,100,1);
         _loc1_.addMaterial(_loc2_,"all");
         var _loc3_:Number = 50;
         return new Cube(_loc1_,_loc3_,_loc3_,_loc3_,2,2,2,1);
      }
      
      public function get overrideRenderFlag() : Boolean
      {
         return _overrideRenderFlag;
      }
      
      public function debugMode(param1:Boolean) : void
      {
         _debugMode = param1;
      }
      
      public function cleanRenderState() : void
      {
         _renderStateIsDirty = false;
      }
      
      public function get do3dList() : Array
      {
         return _do3dList;
      }
      
      public function get autoUpdateCamera() : Boolean
      {
         return _autoUpdateCamera;
      }
      
      public function get pageID() : String
      {
         return _pageID;
      }
      
      public function get pageHeight() : Number
      {
         return _pageHeight;
      }
      
      public function flagDirtyLayer(param1:ViewportLayer) : Boolean
      {
         if(_dirtyLayers.indexOf(param1) !== -1)
         {
            return false;
         }
         _dirtyLayers.push(param1);
         return true;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         _pageHeight = param1;
      }
      
      public function get dirtyLayers() : Array
      {
         return _dirtyLayers;
      }
      
      public function get isLive() : Boolean
      {
         return _isLive;
      }
      
      public function initialise() : void
      {
      }
      
      public function get renderStateIsDirty() : Boolean
      {
         return _renderStateIsDirty;
      }
      
      protected function setReadyState() : void
      {
         _isTransitionReady = true;
         dispatchEvent(new PageEvent(PageEvent.TRANSITION_READY));
      }
      
      public function get isTransitionReady() : Boolean
      {
         return _isTransitionReady;
      }
      
      public function broadcast(param1:String = null, param2:String = null, param3:* = null) : void
      {
         dispatchEvent(new BrainEvent(param1,param2,param3));
      }
      
      public function getLiveVisibleDisplayObjects() : Array
      {
         return _do3dList;
      }
      
      public function transitionProgressOut(param1:Number) : void
      {
      }
      
      public function get isActive() : Boolean
      {
         return _isActive;
      }
      
      public function doesLayerContain(param1:ViewportLayer, param2:ViewportLayer) : Boolean
      {
         var _loc3_:int = 0;
         if(param1.childLayers.indexOf(param2) != -1)
         {
            return true;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.childLayers.length)
         {
            if(doesLayerContain(param1.childLayers[_loc3_],param2))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function set renderStateIsDirty(param1:Boolean) : void
      {
         _renderStateIsDirty = param1;
      }
      
      public function get localCam() : CameraObject3D
      {
         return _localCam;
      }
      
      public function transitionProgressIn(param1:Number) : void
      {
      }
      
      public function cleanLayers() : void
      {
         _dirtyLayers = [];
      }
      
      override public function toString() : String
      {
         return "Page3D :: " + _pageID + " [" + this.x + ", " + this.y + ", " + this.z + "]";
      }
      
      public function set pageWidth(param1:Number) : void
      {
         _pageWidth = param1;
      }
      
      public function activate() : void
      {
         _isActive = true;
      }
      
      public function deactivate() : void
      {
         _isActive = false;
      }
      
      public function get pageWidth() : Number
      {
         return _pageWidth;
      }
      
      public function park() : void
      {
      }
      
      public function destroy() : void
      {
         _isTransitionReady = false;
         _isActive = false;
         _isLive = false;
         _overrideRenderFlag = false;
         _renderStateIsDirty = false;
         debugCube = null;
         _localCam = null;
         _do3dList = null;
         _do3dListOmitTransit = null;
         _dirtyLayers = null;
      }
   }
}

