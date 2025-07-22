package net.pluginmedia.bigandsmall.core
{
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.core.animation.BigAndSmallCompTransitionFX;
   import net.pluginmedia.bigandsmall.core.camera.BigAndSmallCameraTransition;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.interfaces.IPage;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.PageManager3D;
   import net.pluginmedia.brain.managers.ShareManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.pv3d.cameras.RailCamera;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import net.pluginmedia.pv3d.materials.special.LineMaterial3D;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.core.geom.Lines3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.PaperPlane;
   import org.papervision3d.objects.primitives.Sphere;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public final class BigAndSmallPageManager3D extends PageManager3D
   {
      
      public static var CHARACTER_CHANGE_BEGINS:String = "BigAndSmallPageManager3D.CHARACTER_CHANGE_BEGINS";
      
      public static var CHARACTER_CHANGE_MIDPOINT:String = "BigAndSmallPageManager3D.CHARACTER_CHANGE_MIDPOINT";
      
      public static var CHARACTER_CHANGE_COMPLETE:String = "BigAndSmallPageManager3D.CHARACTER_CHANGE_COMPLETE";
      
      private var useCameraTransition:BigAndSmallCameraTransition = null;
      
      protected var debugCamDistance:Number = 3000;
      
      private var sceneChangeDueTrigger:Boolean = false;
      
      protected var debugCameraTargetMarker:Sphere;
      
      private var freeCamera:CameraObject3D;
      
      protected var debugCameraMarker:PaperPlane;
      
      private var linearTransitionPaths:Object = {};
      
      protected var topDownCam:Camera3D;
      
      private var bezierTransitionPaths:Object = {};
      
      private var _transitionFX:BigAndSmallCompTransitionFX;
      
      private var inputX:Number = 0;
      
      private var inputY:Number = 0;
      
      private var transitionMusic:Object = {};
      
      private var isCharacterTransition:Boolean = false;
      
      private var denyRenderFlag:Boolean = false;
      
      private var _characterIdent:String;
      
      private var currentDisplayObjectList:Array = [];
      
      private var t:Number = 0;
      
      public function BigAndSmallPageManager3D(param1:ShareManager, param2:int = 640, param3:int = 480, param4:Boolean = true, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      private function arrayDifference(param1:Array, param2:Array) : Array
      {
         var _loc4_:* = undefined;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            if(param2.indexOf(_loc4_) == -1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private function updateDisplayList(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc6_:Page3D = null;
         var _loc7_:DisplayObject3D = null;
         var _loc2_:SharerInfo = null;
         var _loc3_:DisplayObject3D = null;
         var _loc4_:Array = [];
         for each(_loc5_ in param1)
         {
            if(shareManager.referenceExists(_loc5_))
            {
               _loc2_ = shareManager.getReference(_loc5_);
               _loc3_ = _loc2_.reference as DisplayObject3D;
            }
            else
            {
               BrainLogger.out("updateDisplayList :: Warning - could not get object by reference from share manager",_loc5_);
               _loc3_ = null;
            }
            if(!sceneContains(_loc3_) && _loc3_ !== null)
            {
               if(_loc3_.userData)
               {
                  if(_loc3_.userData.data.page3D)
                  {
                     _loc6_ = _loc3_.userData.data.page3D as Page3D;
                  }
               }
               if(!_loc6_)
               {
                  BrainLogger.warning("OOOPS can\'t find parent page!!!",_loc3_,_loc3_.userData,_loc3_.name);
               }
               else
               {
                  _loc6_.addChild(_loc3_);
                  BrainLogger.out("ADDING ",_loc3_.name,"to page",_loc6_,_loc6_.visible);
               }
            }
            _loc4_.push(_loc3_);
         }
         for each(_loc6_ in registeredObjs)
         {
            for each(_loc7_ in _loc6_.children)
            {
               if(_loc4_.indexOf(_loc7_) == -1 && _loc7_ != lines3D)
               {
                  _loc6_.removeChild(_loc7_);
                  removeSpriteFromDO3D(_loc7_);
               }
            }
         }
         currentDisplayObjectList = param1.concat();
      }
      
      override protected function transitionPages(param1:Page3D, param2:Page3D) : void
      {
         var _loc15_:SceneChangeInfo = null;
         var _loc16_:BezierPath3D = null;
         var _loc17_:BigAndSmallCameraTransition = null;
         var _loc18_:ViewportLayer = null;
         BrainLogger.highlight("transitionPages :: ",param1,param2);
         isTransiting = true;
         param1.isLive = false;
         refreshDisplayList();
         if(param1 === param2)
         {
            param2.prepare(param1.pageID);
            setCamera(param2.localCam as CameraObject3D);
            param2.activate();
            param2.isLive = true;
            param2.renderStateIsDirty = true;
            isTransiting = false;
            return;
         }
         param1.deactivate();
         param2.prepare(param1.pageID);
         var _loc3_:CameraObject3D = param1.localCam as CameraObject3D;
         var _loc4_:CameraObject3D = param2.localCam as CameraObject3D;
         var _loc5_:BigAndSmallCameraTransition = getBezierTransitionPath(param1,param2,_characterIdent);
         if(!_loc5_)
         {
            _loc5_ = getLinearTransitionPath(param1,param2,_characterIdent);
         }
         if(_loc5_)
         {
            useCameraTransition = _loc5_.duplicate() as BigAndSmallCameraTransition;
         }
         else
         {
            _loc15_ = new SceneChangeInfo("Transition_C",0,1);
            _loc16_ = new BezierPath3D(4);
            _loc17_ = new BigAndSmallCameraTransition(4,_loc16_,_loc15_);
            _loc17_.transitStepInc = 0.01;
            useCameraTransition = _loc17_;
         }
         if(useCameraTransition.sceneChangeInfo)
         {
            sceneChangeDueTrigger = true;
         }
         else
         {
            sceneChangeDueTrigger = false;
         }
         var _loc6_:BezierPoint3D = new BezierPoint3D(_loc3_.x,_loc3_.y,_loc3_.z);
         useCameraTransition.points.unshift(_loc6_);
         useCameraTransition.points.push(new BezierPoint3D(0,0,0));
         useCameraTransition.reCalcSegments();
         var _loc7_:BezierPoint3D = new BezierPoint3D(_loc3_.target.x,_loc3_.target.y,_loc3_.target.z);
         useCameraTransition.cameraTargetPath.points.unshift(_loc7_);
         useCameraTransition.cameraTargetPath.points.push(new BezierPoint3D(0,0,0));
         var _loc8_:Array = useCameraTransition.cameraTargetPath.points;
         var _loc9_:BezierPoint3D = _loc8_[_loc8_.length - 1];
         var _loc10_:DisplayObject3D = param2.localCam.target;
         _loc9_.x = _loc10_.x;
         _loc9_.y = _loc10_.y;
         _loc9_.z = _loc10_.z;
         useCameraTransition.cameraTargetPath.reCalcSegments();
         freeCamera.copyTransform(param1.localCam);
         freeCamera.copyPosition(param1.localCam);
         freeCamera.target.copyPosition(_loc3_.target);
         freeCamera.zoom = param1.localCam.zoom;
         freeCamera.focus = param1.localCam.focus;
         setCamera(freeCamera);
         var _loc11_:String = param1.pageID + "_to_" + param2.pageID;
         var _loc12_:String = transitionMusic[_loc11_];
         if((Boolean(_loc12_)) && _loc12_ != "NONE")
         {
            SoundManagerOld.playSound(transitionMusic[_loc11_]);
         }
         else if(_loc12_ != "NONE")
         {
            SoundManagerOld.playSound("transitionMusic");
         }
         t = useCameraTransition.transitStepInc;
         if(param2.autoUpdateCamera)
         {
            ICameraUpdateable(_loc4_).updatePosition(inputX,inputY);
         }
         var _loc13_:Array = useCameraTransition.points;
         var _loc14_:BezierPoint3D = useCameraTransition.points[_loc13_.length - 1];
         _loc14_.x = _loc4_.x;
         _loc14_.y = _loc4_.y;
         _loc14_.z = _loc4_.z;
         useCameraTransition.reCalcSegments(-2);
         clearPaths();
         if(_debugMode)
         {
            setCamera(topDownCam);
            _loc18_ = null;
            if(!debugCameraMarker)
            {
               debugCameraMarker = new PaperPlane(new WireframeMaterial(65535),0.25);
               _loc18_ = viewport.getChildLayer(debugCameraMarker,true,true);
               _loc18_.forceDepth = true;
               _loc18_.screenDepth = 0;
            }
            if(!debugCameraTargetMarker)
            {
               debugCameraTargetMarker = new Sphere(null,10);
               _loc18_ = viewport.getChildLayer(debugCameraTargetMarker,true,true);
               _loc18_.forceDepth = true;
               _loc18_.screenDepth = 0;
            }
            scene.addChild(debugCameraMarker);
            scene.addChild(debugCameraTargetMarker);
         }
      }
      
      override protected function init3D() : void
      {
         var _loc1_:LineMaterial3D = new LineMaterial3D(16777215,1);
         lines3D = new Lines3D(_loc1_,"debug lines");
         viewport.getChildLayer(lines3D,true,true).screenDepth = 0;
         freeCamera = new Camera3D(45);
         freeCamera.target = DisplayObject3D.ZERO;
         topDownCam = new Camera3D(75);
      }
      
      public function setTransitionMusic(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = param1 + "_to_" + param2;
         transitionMusic[_loc4_] = param3;
      }
      
      private function handleCharTransitionOutComplete() : void
      {
         isCharacterTransition = false;
         this.viewport.cacheAsBitmap = false;
         _currentPage.activate();
         dispatchEvent(new Event(CHARACTER_CHANGE_COMPLETE));
      }
      
      private function getLinearTransitionPath(param1:Page3D, param2:Page3D, param3:String) : BigAndSmallCameraTransition
      {
         var _loc4_:BigAndSmallCameraTransition = null;
         var _loc5_:String = param1.pageID + "_to_" + param2.pageID + "_character_" + param3;
         _loc4_ = linearTransitionPaths[_loc5_] as BigAndSmallCameraTransition;
         if(!_loc4_)
         {
            _loc5_ = param1.pageID + "_to_" + param2.pageID + "_character_" + CharacterDefinitions.ALL;
            _loc4_ = linearTransitionPaths[_loc5_] as BigAndSmallCameraTransition;
         }
         return _loc4_;
      }
      
      private function transitionSceneChangeOut() : void
      {
         t = useCameraTransition.sceneChangeInfo.changeAtT2;
         _transitionFX.doNamedTransitionOut(useCameraTransition.sceneChangeInfo.useTransition,null,null,false,3);
         BrainLogger.highlight("transitionSceneChange OUT");
      }
      
      private function handleSceneTransitionInComplete() : void
      {
         transitionSceneChangeOut();
      }
      
      private function renderScene() : void
      {
         singleRender();
      }
      
      public function setCharacterAspect(param1:String, param2:Boolean = false) : void
      {
         _characterIdent = param1;
         if(_transitionFX === null)
         {
            param2 = true;
         }
         dispatchEvent(new Event(CHARACTER_CHANGE_BEGINS));
         if(!param2)
         {
            isCharacterTransition = true;
            setChildIndex(_transitionFX,this.numChildren - 1);
            _currentPage.deactivate();
            _transitionFX.doCharacterTransitionIn(_characterIdent,handleCharTransitionInComplete);
            this.viewport.cacheAsBitmap = true;
            if(param1 === CharacterDefinitions.BIG)
            {
               SoundManagerOld.playSound("lr_sml_tobig_wipe");
            }
            else if(param1 === CharacterDefinitions.SMALL)
            {
               SoundManagerOld.playSound("lr_big_tosml_wipe");
            }
         }
         else
         {
            doCharacterSwitch();
         }
      }
      
      public function setLinearTransitionPath(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = param1 + "_to_" + param2 + "_character_" + param3;
         var _loc5_:BezierPath3D = new BezierPath3D(4);
         var _loc6_:BigAndSmallCameraTransition = new BigAndSmallCameraTransition(4,_loc5_);
         linearTransitionPaths[_loc4_] = _loc6_;
      }
      
      public function refreshDisplayList() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(this.isTransiting)
         {
            _loc1_ = _currentPage.getLiveVisibleDisplayObjects().concat(_nextPage.getLiveVisibleDisplayObjects());
            _loc2_ = _currentPage.getTransitionOmitObjects().concat(_nextPage.getTransitionOmitObjects());
         }
         else
         {
            _loc1_ = _currentPage.getLiveVisibleDisplayObjects();
         }
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = int(_loc1_.indexOf(_loc3_));
            if(_loc4_ > -1)
            {
               _loc1_.splice(_loc4_,1);
            }
         }
         updateDisplayList(_loc1_);
      }
      
      private function transitionProgress(param1:Number) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:Array = null;
         var _loc10_:BezierPoint3D = null;
         var _loc11_:Array = null;
         var _loc12_:DisplayObject3D = null;
         var _loc13_:BezierPoint3D = null;
         var _loc14_:Number3D = null;
         var _loc2_:Camera3D = _nextPage.localCam as Camera3D;
         var _loc3_:Camera3D = _currentPage.localCam as Camera3D;
         if(_nextPage.autoUpdateCamera)
         {
            _loc8_ = ICameraUpdateable(_loc2_).updatePosition(inputX,inputY);
            if(_loc8_)
            {
               _loc9_ = useCameraTransition.points;
               _loc10_ = useCameraTransition.points[_loc9_.length - 1];
               _loc10_.x = _loc2_.x;
               _loc10_.y = _loc2_.y;
               _loc10_.z = _loc2_.z;
               useCameraTransition.reCalcSegments(-2);
               _loc11_ = useCameraTransition.cameraTargetPath.points;
               _loc12_ = CameraObject3D(_nextPage.localCam).target;
               _loc13_ = _loc11_[_loc11_.length - 1];
               if(_loc12_.x != _loc13_.x || _loc12_.y != _loc13_.y || _loc12_.z != _loc13_.z)
               {
                  _loc13_.x = _loc12_.x;
                  _loc13_.y = _loc12_.y;
                  _loc13_.z = _loc12_.z;
                  useCameraTransition.cameraTargetPath.reCalcSegments();
               }
            }
         }
         var _loc4_:Number3D = useCameraTransition.getNumber3DAtT(param1);
         if(_loc4_ !== null)
         {
            freeCamera.x = _loc4_.x;
            freeCamera.y = _loc4_.y;
            freeCamera.z = _loc4_.z;
            topDownCam.x = freeCamera.x;
            topDownCam.y = freeCamera.y + debugCamDistance;
            topDownCam.z = freeCamera.z;
            topDownCam.rotationX = 90;
         }
         var _loc5_:BezierPath3D = useCameraTransition.cameraTargetPath;
         if(_loc5_ !== null)
         {
            _loc14_ = _loc5_.getNumber3DAtT(param1);
            if(_loc14_ !== null)
            {
               freeCamera.target.x = _loc14_.x;
               freeCamera.target.y = _loc14_.y;
               freeCamera.target.z = _loc14_.z;
               if(_debugMode)
               {
                  debugCameraMarker.copyPosition(freeCamera);
                  debugCameraTargetMarker.copyPosition(freeCamera.target);
                  debugCameraMarker.lookAt(debugCameraTargetMarker);
               }
            }
         }
         var _loc6_:Number = _loc3_.zoom + (_loc2_.zoom - _loc3_.zoom) * param1;
         freeCamera.zoom = _loc6_;
         var _loc7_:Number = _loc3_.focus + (_loc2_.focus - _loc3_.focus) * param1;
         freeCamera.focus = _loc7_;
         currentPage.transitionProgressOut(param1);
         nextPage.transitionProgressIn(param1);
      }
      
      public function unsmoothDirtyLayerObjects(param1:Array) : void
      {
         var _loc3_:ViewportLayer = null;
         var _loc4_:DisplayObject3D = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(_loc3_ != null)
            {
               _loc2_ = _loc2_.concat(_loc3_.getLayerObjects());
            }
         }
         for each(_loc4_ in _loc2_)
         {
            smoothMaterials(_loc4_,false);
         }
      }
      
      private function doCharacterSwitch() : void
      {
         var _loc1_:BigAndSmallPage3D = null;
         for each(_loc1_ in registeredObjs)
         {
            if(_loc1_)
            {
               _loc1_.setCharacter(_characterIdent);
            }
         }
         if(!isTransiting && _currentPage !== null)
         {
            setCamera(_currentPage.localCam);
            if(currentPage.autoUpdateCamera && _camera is ICameraUpdateable)
            {
               ICameraUpdateable(_camera).updatePosition(inputX,inputY,1);
            }
         }
         for each(_loc1_ in registeredObjs)
         {
            if(_loc1_)
            {
               _loc1_.characterViewReady();
            }
         }
         dispatchEvent(new Event(CHARACTER_CHANGE_MIDPOINT));
      }
      
      private function smoothAndRender() : Boolean
      {
         if(!smoothed)
         {
            smoothAllMaterials(true);
            singleRender();
            return true;
         }
         return false;
      }
      
      public function get characterIdent() : String
      {
         return _characterIdent;
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc4_:Array = null;
         var _loc2_:BigAndSmallPage3D = _currentPage as BigAndSmallPage3D;
         if(denyRenderFlag || isCharacterTransition)
         {
            return;
         }
         inputX = viewport.mouseX / viewport.viewportWidth;
         inputY = viewport.mouseY / viewport.viewportHeight;
         var _loc3_:Boolean = false;
         if(_loc2_ !== null)
         {
            if(_loc2_.autoUpdateCamera)
            {
               if(_camera is ICameraUpdateable && !isTransiting)
               {
                  _loc3_ = ICameraUpdateable(_camera).updatePosition(inputX,inputY);
               }
            }
            else if(!isTransiting)
            {
               _loc3_ = _loc2_.updateCamera();
            }
         }
         if(isTransiting && useCameraTransition !== null)
         {
            if(t < 0.9999)
            {
               transitionProgress(t);
               t += useCameraTransition.transitStepInc;
               if(sceneChangeDueTrigger)
               {
                  if(t > useCameraTransition.sceneChangeInfo.changeAtT1)
                  {
                     transitionSceneChangeIn();
                  }
               }
            }
            else
            {
               transitionDone();
            }
            _loc3_ = true;
         }
         if(_currentPage !== null)
         {
            if(_loc2_.overrideRenderFlag || _loc2_.renderStateIsDirty)
            {
               _loc3_ = true;
               _loc2_.cleanRenderState();
            }
         }
         if(_loc3_)
         {
            if(_loc2_ !== null && _loc2_.alwaysSmoothed)
            {
               if(!smoothed)
               {
                  smoothAllMaterials(true);
               }
            }
            else if(smoothed)
            {
               smoothAllMaterials(false);
            }
            renderScene();
         }
         else if(_currentPage !== null)
         {
            _loc4_ = _currentPage.dirtyLayers;
            if(_loc4_.length > 0)
            {
               if(!smoothAndRender())
               {
                  unsmoothDirtyLayerObjects(_loc4_);
                  renderLayers(_loc4_);
               }
               _currentPage.cleanLayers();
            }
            else
            {
               smoothAndRender();
            }
         }
         else
         {
            smoothAndRender();
         }
      }
      
      private function getBezierTransitionPath(param1:Page3D, param2:Page3D, param3:String) : BigAndSmallCameraTransition
      {
         var _loc4_:BigAndSmallCameraTransition = null;
         var _loc5_:String = param1.pageID + "_to_" + param2.pageID + "_character_" + param3;
         _loc4_ = bezierTransitionPaths[_loc5_] as BigAndSmallCameraTransition;
         if(!_loc4_)
         {
            _loc5_ = param1.pageID + "_to_" + param2.pageID + "_character_" + CharacterDefinitions.ALL;
            _loc4_ = bezierTransitionPaths[_loc5_] as BigAndSmallCameraTransition;
         }
         return _loc4_;
      }
      
      public function debugCameraModeOn() : void
      {
         topDownCam.x = _currentPage.localCam.x;
         topDownCam.y = _currentPage.localCam.y + debugCamDistance;
         topDownCam.z = _currentPage.localCam.z;
         topDownCam.rotationX = 90;
         setCamera(topDownCam);
         singleRender();
      }
      
      public function setBezierTransitionPath(param1:String, param2:String, param3:String, param4:BigAndSmallCameraTransition) : void
      {
         var _loc5_:String = param1 + "_to_" + param2 + "_character_" + param3;
         bezierTransitionPaths[_loc5_] = param4;
      }
      
      public function debugCameraModeOff() : void
      {
         setCamera(_currentPage.localCam as Camera3D);
         singleRender();
      }
      
      public function get transitionFX() : BigAndSmallCompTransitionFX
      {
         return _transitionFX;
      }
      
      override protected function init2D() : void
      {
         super.init2D();
         _transitionFX = new BigAndSmallCompTransitionFX();
         addChild(_transitionFX);
         _transitionFX.x = this.pageWidth / 2;
         _transitionFX.y = this.pageHeight / 2;
         shareManager.register(_transitionFX);
      }
      
      private function transitionSceneChangeIn() : void
      {
         sceneChangeDueTrigger = false;
         _transitionFX.doNamedTransitionIn(useCameraTransition.sceneChangeInfo.useTransition,handleSceneTransitionInComplete,null,false,3);
         BrainLogger.highlight("transitionSceneChange IN");
      }
      
      private function handleCharTransitionInComplete() : void
      {
         doCharacterSwitch();
         singleRender();
         _transitionFX.doCharacterTransitionOut(_characterIdent,handleCharTransitionOutComplete);
      }
      
      override public function pause(param1:Boolean = true) : void
      {
         var _loc2_:IPage = null;
         BrainLogger.out("BigAndSmallPageManager3D handling setPauseState",param1);
         super.pause(param1);
         for each(_loc2_ in registeredObjs)
         {
            if(_loc2_ is BigAndSmallPage3D)
            {
               BigAndSmallPage3D(_loc2_).setPauseState(param1);
            }
         }
      }
      
      private function transitionDone() : void
      {
         var _loc1_:Array = _nextPage.getLiveVisibleDisplayObjects();
         updateDisplayList(_loc1_);
         transitionProgress(1);
         t = 0;
         var _loc2_:Page3D = _currentPage;
         _currentPage = _nextPage;
         var _loc3_:Camera3D = _currentPage.localCam as Camera3D;
         if(!_loc3_ is RailCamera && _loc3_ is OrbitCamera3D)
         {
            OrbitCamera3D(_loc3_).updateRadial();
         }
         setCamera(_loc3_);
         _currentPage.activate();
         _currentPage.isLive = true;
         _loc2_.park();
         compressionManager.squash(_loc2_);
         _nextPage = null;
         isTransiting = false;
         useCameraTransition.destroy();
         useCameraTransition = null;
         if(_debugMode)
         {
            scene.removeChild(debugCameraMarker);
            scene.removeChild(debugCameraTargetMarker);
         }
         clearPaths();
      }
      
      private function renderLayers(param1:Array) : void
      {
         renderer.renderLayers(scene,camera,viewport,param1);
      }
      
      public function removeSpriteFromDO3D(param1:DisplayObject3D) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1.children)
         {
            removeSpriteFromDO3D(param1.children[_loc2_]);
         }
         if(param1.material is SpriteParticleMaterial)
         {
            SpriteParticleMaterial(param1.material).removeSprite();
         }
      }
   }
}

