package net.pluginmedia.bigandsmall.pages.garden.pond
{
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.garden.GardenDAEController;
   import net.pluginmedia.bigandsmall.pages.garden.RailCamPositionManager;
   import net.pluginmedia.bigandsmall.pages.garden.pond.fish.PondFishManager;
   import net.pluginmedia.bigandsmall.pages.garden.pond.frogs.PondFrogManager;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.Viewport3D;
   
   public class PondObjectManager extends EventDispatcher
   {
      
      private var reflBlur:BlurFilter;
      
      public var staticContainer:DisplayObjectContainer3D;
      
      public var daeController:GardenDAEController;
      
      private var cTransform:ColorTransform;
      
      public var mirrorPond:MirrorPond;
      
      public var currentPOV:String;
      
      private var madePondSnapshots:Boolean = false;
      
      private var _frogManager:PondFrogManager;
      
      public var basicView:BasicView;
      
      public var railManager:RailCamPositionManager;
      
      private var _fishManager:PondFishManager;
      
      public function PondObjectManager(param1:BasicView, param2:RailCamPositionManager, param3:GardenDAEController, param4:BlurFilter, param5:ColorTransform)
      {
         super();
         basicView = param1;
         railManager = param2;
         daeController = param3;
         reflBlur = param4;
         cTransform = param5;
      }
      
      public function get dirtyLayers() : Array
      {
         var _loc1_:Array = [];
         _loc1_ = _loc1_.concat(_frogManager.dirtyLayers);
         return _loc1_.concat(_fishManager.dirtyLayers);
      }
      
      private function takeReflectionSnapshot(param1:CameraObject3D, param2:Number = 800, param3:Number = 600, param4:Number = 0) : BitmapData
      {
         var _loc9_:Number = NaN;
         var _loc5_:BitmapData = new BitmapData(param2,param3,true,0);
         var _loc6_:Viewport3D = new Viewport3D(param2,param3);
         railManager.setCameraToPosition(0.12);
         var _loc7_:Number = param1.y;
         var _loc8_:Number = param1.target.y;
         _loc9_ = param4 - param1.y;
         var _loc10_:Number = param4 - param1.target.y;
         param1.y = param4 + _loc9_;
         param1.target.y = param4 + _loc9_;
         basicView.renderer.renderScene(basicView.scene,CameraObject3D(param1),_loc6_);
         param1.y = _loc7_;
         param1.target.y = _loc8_;
         var _loc11_:Matrix = new Matrix();
         _loc11_.scale(1,-1);
         _loc11_.translate(0,param3);
         _loc5_.draw(_loc6_,_loc11_);
         _loc5_.applyFilter(_loc5_,_loc5_.rect,new Point(),reflBlur);
         _loc5_.colorTransform(_loc5_.rect,cTransform);
         return _loc5_;
      }
      
      public function activate() : void
      {
         if(_fishManager)
         {
            _fishManager.activate();
         }
         if(_frogManager)
         {
            _frogManager.activate();
         }
      }
      
      public function prepare() : void
      {
         if(!madePondSnapshots)
         {
            initPondReflection();
         }
      }
      
      public function update() : void
      {
         if(_fishManager)
         {
            _fishManager.update();
         }
      }
      
      public function set frogManager(param1:PondFrogManager) : void
      {
         _frogManager = param1;
      }
      
      public function setCharacter(param1:String) : void
      {
         if(mirrorPond)
         {
            mirrorPond.selectSnapshot(param1);
         }
         this.currentPOV = param1;
         if(_fishManager)
         {
            _fishManager.setCharacter(param1);
         }
         if(_frogManager)
         {
            _frogManager.setCharacter(param1);
         }
      }
      
      public function get frogManager() : PondFrogManager
      {
         return _frogManager;
      }
      
      public function initPondReflection() : void
      {
         mirrorPond = new MirrorPond(daeController.pondMdl);
         var _loc1_:BitmapData = takeReflectionSnapshot(railManager.bigCam as CameraObject3D,800,600);
         mirrorPond.registerSnapshot(CharacterDefinitions.BIG,_loc1_,-31,16,12,2.7);
         var _loc2_:BitmapData = takeReflectionSnapshot(railManager.smallCam as CameraObject3D,1100,400);
         mirrorPond.registerSnapshot(CharacterDefinitions.SMALL,_loc2_,-31,-1,17,2.7);
         mirrorPond.selectSnapshot(this.currentPOV);
         madePondSnapshots = true;
      }
      
      public function park() : void
      {
         if(_fishManager)
         {
            _fishManager.park();
         }
         if(_frogManager)
         {
            _frogManager.park();
         }
      }
      
      public function deactivate() : void
      {
         if(_fishManager)
         {
            _fishManager.deactivate();
         }
         if(_frogManager)
         {
            _frogManager.deactivate();
         }
      }
      
      public function get fishManager() : PondFishManager
      {
         return _fishManager;
      }
      
      public function set fishManager(param1:PondFishManager) : void
      {
         _fishManager = param1;
      }
   }
}

