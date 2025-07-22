package net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import gs.TweenMax;
   import gs.easing.Cubic;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.UIController3D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events.UIController3DEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events.UIController3DPlantEvent;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class PlantController3D extends DisplayObject3D
   {
      
      public static const DIRT_REMOVAL:String = "PlantController3D.DIRT_REMOVAL";
      
      public static const DIRT_PLANTING:String = "PlantController3D.DIRT_PLANTING";
      
      public static const SEED_PLANTED:String = "PlantController3D.SEED_PLANTED";
      
      private var rootAnimMov:MovieClip;
      
      private var removalAnimMat:SpriteParticleMaterial;
      
      public var farBackDarkMultiply:Number = 0.75;
      
      private var plantingAnimMov:MovieClip;
      
      private var plantingAnimSprite:PointSprite;
      
      public var growingPlants:Array = [];
      
      private var rootAnimSprite:PointSprite;
      
      private var removalAnimLayer:ViewportLayer;
      
      private var removalAnimMov:MovieClip;
      
      private var uiController3D:UIController3D;
      
      private var removalAnimSprite:PointSprite;
      
      public var interactionRadius:Number = 100;
      
      private var plantDict:Dictionary;
      
      public var viewportLayer:ViewportLayer;
      
      private var rootAnimMat:SpriteParticleMaterial;
      
      private var patchBack:Number = 308;
      
      private var patchFront:Number = -33;
      
      public var plantedPlants:Array = [];
      
      private var plantUprootInProgress:Boolean = false;
      
      private var plantingAnimLayer:ViewportLayer;
      
      private var plantingAnimMat:SpriteParticleMaterial;
      
      private var rootAnimLayer:ViewportLayer;
      
      public function PlantController3D()
      {
         super();
      }
      
      public function prepare() : void
      {
         var _loc1_:PlantSprite3D = null;
         for each(_loc1_ in plantedPlants)
         {
            _loc1_.activate();
         }
      }
      
      private function handlePlantingAnimComplete(param1:Event) : void
      {
         var _loc3_:PointSprite = null;
         var _loc4_:SpriteParticleMaterial = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ == plantingAnimMov)
         {
            _loc3_ = plantingAnimSprite;
            _loc4_ = plantingAnimMat;
         }
         else if(_loc2_ == removalAnimMov)
         {
            _loc3_ = removalAnimSprite;
            _loc4_ = removalAnimMat;
         }
         _loc2_.gotoAndStop(1);
         _loc4_.removeSprite();
         removeChild(_loc3_);
      }
      
      private function handleWaterCanDropped(param1:UIController3DEvent) : void
      {
         growingPlants = [];
      }
      
      public function init(param1:Dictionary, param2:MovieClip, param3:MovieClip, param4:MovieClip) : void
      {
         plantDict = param1;
         plantingAnimMov = param2;
         plantingAnimMov.stop();
         plantingAnimMat = new SpriteParticleMaterial(plantingAnimMov);
         plantingAnimSprite = new PointSprite(plantingAnimMat);
         plantingAnimMov.stop();
         plantingAnimLayer = this.viewportLayer.getChildLayer(plantingAnimSprite,true,true);
         removalAnimMov = param3;
         removalAnimMov.stop();
         removalAnimMat = new SpriteParticleMaterial(removalAnimMov);
         removalAnimSprite = new PointSprite(removalAnimMat);
         removalAnimMov.stop();
         removalAnimLayer = this.viewportLayer.getChildLayer(removalAnimSprite,true,true);
         rootAnimMov = param4;
         rootAnimMov.stop();
         rootAnimMat = new SpriteParticleMaterial(rootAnimMov);
         rootAnimSprite = new PointSprite(rootAnimMat);
         rootAnimMov.stop();
         rootAnimLayer = this.viewportLayer.getChildLayer(rootAnimSprite,true,true);
      }
      
      private function handleFruitAppear(param1:FruitAppearEvent) : void
      {
         dispatchEvent(new FruitAppearEvent(param1.plantSprite));
      }
      
      private function addUIController3dListeners(param1:UIController3D) : void
      {
         param1.addEventListener(UIController3DPlantEvent.SEED_PLANTED,handleSeedPlanted);
         param1.addEventListener(UIController3DEvent.WATER_DEPOSITED,handleWaterDeposited);
         param1.addEventListener(UIController3DEvent.WATERCAN_DROPPED,handleWaterCanDropped);
         param1.addEventListener(UIController3DEvent.HARVEST,handleHarvest);
      }
      
      private function handlePlantUprooted(param1:PlantSprite3D) : void
      {
         param1.removeEventListener(FruitAppearEvent.FRUIT_APPEAR,handleFruitAppear);
         TweenMax.to(param1,0.6,{
            "ease":Cubic.easeIn,
            "y":param1.y + 370,
            "onComplete":handlePlantRemoved,
            "onCompleteParams":[param1]
         });
         TweenMax.to(rootAnimSprite,0.6,{
            "ease":Cubic.easeIn,
            "y":param1.y + 370
         });
      }
      
      private function handleHarvest(param1:UIController3DEvent = null) : void
      {
         var _loc2_:PlantSprite3D = null;
         while(plantedPlants.length > 0)
         {
            _loc2_ = plantedPlants.shift() as PlantSprite3D;
         }
         plantedPlants = [];
      }
      
      public function setUIController3D(param1:UIController3D) : void
      {
         if(uiController3D)
         {
            removeUIController3dListeners(uiController3D);
         }
         uiController3D = param1;
         addUIController3dListeners(uiController3D);
      }
      
      private function handleWaterDeposited(param1:UIController3DEvent) : void
      {
         var _loc3_:PlantSprite3D = null;
         var _loc2_:Number3D = param1.uiPos;
         growingPlants = plantsInRangeOfPoint3D(_loc2_);
         for each(_loc3_ in growingPlants)
         {
            if(Boolean(_loc3_) && !_loc3_.growing)
            {
               _loc3_.grow();
            }
         }
      }
      
      private function spawnPlant(param1:Number3D, param2:String) : PlantSprite3D
      {
         var _loc3_:Class = plantDict[param2];
         var _loc4_:MovieClip = new _loc3_() as MovieClip;
         _loc4_.scaleX = (Math.round(Math.random()) - 0.5) * 2;
         var _loc5_:PlantSprite3D = new PlantSprite3D(_loc4_,SuperMath.random(0.62,0.78),param2);
         _loc5_.addEventListener(FruitAppearEvent.FRUIT_APPEAR,handleFruitAppear);
         var _loc6_:ViewportLayer = this.viewportLayer.getChildLayer(_loc5_,true,true);
         var _loc7_:Number = (param1.z - patchFront) / (patchBack - patchFront);
         var _loc8_:Number = 1 - _loc7_ * (1 - farBackDarkMultiply);
         _loc4_.transform.colorTransform = new ColorTransform(_loc8_,_loc8_,_loc8_);
         _loc5_.position = param1;
         addChild(_loc5_);
         return _loc5_;
      }
      
      private function handlePlantRemoved(param1:PlantSprite3D) : void
      {
         param1.uproot();
         removeChild(param1);
         removeChild(rootAnimSprite);
         rootAnimMat.removeSprite();
         rootAnimMov.gotoAndStop(1);
         plantedPlants.splice(plantedPlants.indexOf(param1),1);
         plantUprootInProgress = false;
      }
      
      public function get dirtyLayers() : Array
      {
         var _loc2_:PlantSprite3D = null;
         var _loc1_:Array = [];
         _loc1_ = _loc1_.concat(rootAnimLayer,plantingAnimLayer,removalAnimLayer);
         for each(_loc2_ in plantedPlants)
         {
            if(_loc2_.growing)
            {
               _loc1_.push(_loc2_.container);
            }
         }
         return _loc1_;
      }
      
      public function removePlant(param1:PlantSprite3D) : void
      {
         if(param1.uprooted || plantUprootInProgress)
         {
            return;
         }
         param1.uprooted = true;
         plantUprootInProgress = true;
         rootAnimSprite.position = param1.position;
         var _loc2_:Number = 1.1;
         var _loc3_:Number = 0.65;
         var _loc4_:Number = _loc2_ - _loc3_;
         rootAnimSprite.size = _loc3_ + param1.clip.currentFrame / param1.clip.totalFrames * _loc4_;
         rootAnimSprite.z -= 10;
         addChild(rootAnimSprite);
         rootAnimMov.play();
         TweenMax.to(param1,0.5,{
            "ease":Cubic.easeOut,
            "y":param1.y + 120,
            "onComplete":handlePlantUprooted,
            "onCompleteParams":[param1]
         });
         TweenMax.to(rootAnimSprite,0.5,{
            "ease":Cubic.easeOut,
            "y":param1.y + 120
         });
         kickDirt(param1.position,DIRT_REMOVAL);
      }
      
      public function update() : void
      {
      }
      
      private function handleSeedPlanted(param1:UIController3DPlantEvent) : void
      {
         var _loc2_:PlantSprite3D = spawnPlant(param1.seedPos,param1.plantType);
         plantedPlants.push(_loc2_);
         kickDirt(param1.seedPos,DIRT_PLANTING);
         dispatchEvent(new Event(SEED_PLANTED));
      }
      
      public function park() : void
      {
         var _loc1_:PlantSprite3D = null;
         for each(_loc1_ in plantedPlants)
         {
            _loc1_.deactivate();
         }
      }
      
      private function kickDirt(param1:Number3D, param2:String) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:PointSprite = null;
         if(param2 == DIRT_PLANTING)
         {
            _loc3_ = plantingAnimMov;
            _loc4_ = plantingAnimSprite;
         }
         else if(param2 == DIRT_REMOVAL)
         {
            _loc3_ = removalAnimMov;
            _loc4_ = removalAnimSprite;
         }
         _loc3_.addEventListener(Event.COMPLETE,handlePlantingAnimComplete);
         _loc3_.gotoAndPlay(1);
         _loc4_.position = param1;
         addChild(_loc4_);
      }
      
      private function removeUIController3dListeners(param1:UIController3D) : void
      {
         param1.removeEventListener(UIController3DPlantEvent.SEED_PLANTED,handleSeedPlanted);
         param1.removeEventListener(UIController3DEvent.WATER_DEPOSITED,handleWaterDeposited);
         param1.removeEventListener(UIController3DEvent.HARVEST,handleHarvest);
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function plantsInRangeOfPoint3D(param1:Number3D) : Array
      {
         var _loc3_:PlantSprite3D = null;
         var _loc2_:Array = [];
         for each(_loc3_ in plantedPlants)
         {
            if(_loc3_.position.x > param1.x - interactionRadius)
            {
               if(_loc3_.position.x < param1.x + interactionRadius)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      public function plantUnderDisplayObject(param1:DisplayObject) : PlantSprite3D
      {
         var _loc4_:PlantSprite3D = null;
         var _loc2_:Number = int.MAX_VALUE;
         var _loc3_:PlantSprite3D = null;
         for each(_loc4_ in plantedPlants)
         {
            if(Boolean(_loc4_.hitTestMovie(param1)) && _loc4_.z < _loc2_)
            {
               _loc3_ = _loc4_;
               _loc2_ = _loc4_.z;
            }
         }
         return _loc3_;
      }
   }
}

