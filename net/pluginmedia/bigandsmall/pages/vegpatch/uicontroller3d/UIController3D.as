package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller.PlantController3D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller.PlantSprite3D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.SpawnDraggableSeed;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.SpawnDraggableTrowel;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.SpawnDraggableWateringCan;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.UIController2D;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.events.UIController2DEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events.UIController3DEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events.UIController3DPlantEvent;
   import net.pluginmedia.brain.core.interfaces.ISpawnDraggable;
   import net.pluginmedia.pv3d.materials.special.LineMaterial3D;
   import org.papervision3d.core.geom.Lines3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class UIController3D extends DisplayObject3D
   {
      
      private var uiPlaneXRot:Number = -10;
      
      private var wateringCan3D:WateringCan3D;
      
      private var uiPlaneProjection:Number3D = new Number3D();
      
      private var plantController3D:PlantController3D;
      
      private var gPlaneProjectionUnconstrained:Number3D;
      
      private var gPlaneProjectionLast:Number3D = new Number3D();
      
      private var uiConstraintRect:Rectangle = new Rectangle(-260,-40,552,350);
      
      private var trowel2D:SpawnDraggableTrowel;
      
      private var uiController2D:UIController2D;
      
      private var dragObjShadow:Shadow3D;
      
      private var camera:CameraObject3D;
      
      private var uiPlane:Plane3D;
      
      private var waterDepOffset:Number3D = new Number3D(-80,0,0);
      
      private var uiPlaneY:Number = -30;
      
      private var default3DObj:DisplayObject3D;
      
      private var lines3D:Lines3D;
      
      private var gPlaneProjectionWasConstrained:Boolean = false;
      
      private var worldOffset:Number3D = new Number3D();
      
      private var seedDict:Dictionary;
      
      public var viewportLayer:ViewportLayer;
      
      private var dragObject3D:DisplayObject3D;
      
      private var wateringCanClip:MovieClip;
      
      private var fallingSeeds:Array = [];
      
      private var gPlaneY:Number = -98;
      
      private var dragShadowClip:Sprite;
      
      private var gPlaneProjection:Number3D = new Number3D();
      
      private var planeOffsZ:Number = 75;
      
      public function UIController3D(param1:Number3D, param2:CameraObject3D, param3:Dictionary, param4:Sprite, param5:MovieClip)
      {
         gPlaneProjectionUnconstrained = gPlaneProjection.clone();
         super();
         worldOffset = param1;
         camera = param2;
         seedDict = param3;
         dragShadowClip = param4;
         wateringCanClip = param5;
         initUIIntersect();
      }
      
      private function dropSeed(param1:DragSeed3D) : void
      {
         if(!param1)
         {
            return;
         }
         param1.dropped(gPlaneProjection);
         fallingSeeds.push(param1);
      }
      
      private function initDragObjShadow() : void
      {
         dragObjShadow = new Shadow3D(dragShadowClip);
         dragObjShadow.hideSelf();
         addChild(dragObjShadow);
         this.viewportLayer.getChildLayer(dragObjShadow,true);
      }
      
      public function setUIController2D(param1:UIController2D) : void
      {
         if(uiController2D)
         {
            removeUIController2dListeners(uiController2D);
         }
         uiController2D = param1;
         addUIController2dListeners(uiController2D);
      }
      
      private function handleDragBegins(param1:UIController2DEvent) : void
      {
         if(!dragObjShadow)
         {
            initDragObjShadow();
         }
         if(param1.spawnDraggable is SpawnDraggableSeed)
         {
            pickUpSeed(SpawnDraggableSeed(param1.spawnDraggable));
         }
         else if(param1.spawnDraggable is SpawnDraggableWateringCan)
         {
            pickUpWateringCan();
         }
         else
         {
            pickUpDefault3DObj();
         }
      }
      
      private function removePlantController3dListeners(param1:PlantController3D) : void
      {
      }
      
      private function handleDigAction(param1:UIController2DEvent) : void
      {
         trowel2D = param1.spawnDraggable as SpawnDraggableTrowel;
         if(!trowel2D)
         {
            return;
         }
         var _loc2_:PlantSprite3D = plantController3D.plantUnderDisplayObject(trowel2D);
         if(_loc2_)
         {
            trowel2D.doDigAnim();
            plantController3D.removePlant(_loc2_);
         }
      }
      
      private function handleDragEnds(param1:UIController2DEvent) : void
      {
         if(!dragObject3D)
         {
            return;
         }
         dropObj3D(dragObject3D,param1.spawnDraggable as ISpawnDraggable);
      }
      
      public function getUICoords3D(param1:Number, param2:Number) : Number3D
      {
         var _loc3_:Number3D = new Number3D(worldOffset.x - camera.x,worldOffset.y - camera.y,worldOffset.z - camera.z);
         var _loc4_:Number3D = camera.unproject(param1,param2);
         _loc4_.plusEq(_loc3_);
         return uiPlane.getIntersectionLineNumbers(_loc3_,_loc4_);
      }
      
      private function pickUpWateringCan() : void
      {
         if(!wateringCan3D)
         {
            initWateringCan();
         }
         dragObject3D = wateringCan3D;
      }
      
      private function pickUpSeed(param1:SpawnDraggableSeed) : void
      {
         var _loc2_:DragSeed3D = factorySeed3D(param1.plantType);
         dragObject3D = _loc2_;
      }
      
      public function get isWatering() : Boolean
      {
         if(!wateringCan3D)
         {
            return false;
         }
         return wateringCan3D.isWatering;
      }
      
      private function initWateringCan() : void
      {
         wateringCan3D = new WateringCan3D(wateringCanClip);
      }
      
      public function update() : void
      {
         var _loc1_:Number3D = null;
         updateFallingSeeds();
         if(dragObject3D is WateringCan3D && wateringCan3D.isWatering)
         {
            _loc1_ = gPlaneProjectionUnconstrained.clone();
            _loc1_.plusEq(waterDepOffset);
            dispatchEvent(new UIController3DEvent(UIController3DEvent.WATER_DEPOSITED,_loc1_));
         }
      }
      
      private function factorySeed3D(param1:String) : DragSeed3D
      {
         var _loc5_:Sprite = null;
         var _loc2_:Class = seedDict[param1] as Class;
         var _loc3_:Sprite = new _loc2_();
         if(_loc3_)
         {
            if(_loc3_["shadow"])
            {
               _loc3_.removeChild(_loc3_["shadow"]);
            }
         }
         else
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(16711680,1);
            _loc5_.graphics.drawCircle(0,0,55);
            _loc3_ = _loc5_;
         }
         var _loc4_:DragSeed3D = new DragSeed3D(dragObjShadow,_loc3_,param1);
         addChild(_loc4_);
         this.viewportLayer.getChildLayer(_loc4_,true);
         return _loc4_;
      }
      
      public function updateUIIntersection(param1:Number, param2:Number) : void
      {
         var _loc3_:Number3D = getUICoords3D(param1,param2);
         gPlaneProjectionLast.copyFrom(gPlaneProjection);
         gPlaneProjectionUnconstrained.x = -_loc3_.x;
         gPlaneProjectionUnconstrained.y = gPlaneY;
         gPlaneProjectionUnconstrained.z = -_loc3_.z;
         gPlaneProjection.x = gPlaneProjectionUnconstrained.x;
         gPlaneProjection.y = gPlaneProjectionUnconstrained.y;
         gPlaneProjection.z = gPlaneProjectionUnconstrained.z;
         gPlaneProjectionWasConstrained = constrainNumber3DToRect(gPlaneProjection,uiConstraintRect);
         uiPlaneProjection.x = -_loc3_.x;
         uiPlaneProjection.y = -_loc3_.y;
         uiPlaneProjection.z = -_loc3_.z;
      }
      
      private function removeUIController2dListeners(param1:UIController2D) : void
      {
         param1.removeEventListener(UIController2DEvent.SEED_PICKED_UP,handleDragBegins);
         param1.removeEventListener(UIController2DEvent.SEED_DROPPED,handleDragEnds);
         param1.removeEventListener(UIController2DEvent.WATERING_CAN_PICKED_UP,handleDragBegins);
         param1.removeEventListener(UIController2DEvent.WATERING_CAN_DROPPED,handleDragEnds);
         param1.removeEventListener(UIController2DEvent.TROWEL_PICKED_UP,handleDragBegins);
         param1.removeEventListener(UIController2DEvent.TROWEL_DROPPED,handleDragEnds);
         param1.removeEventListener(UIController2DEvent.TROWEL_DIG_ACTION,handleDigAction);
         param1.removeEventListener(UIController2DEvent.DRAGGABLE_MOVED,handle2DDragUpdate);
      }
      
      private function handle2DDragUpdate(param1:UIController2DEvent) : void
      {
         var _loc4_:SpawnDraggableWateringCan = null;
         updateUIIntersection(uiController2D.dragCoords.x,uiController2D.dragCoords.y);
         if(!dragObject3D)
         {
            return;
         }
         dragObject3D.x = uiPlaneProjection.x;
         dragObject3D.y = uiPlaneProjection.y;
         dragObject3D.z = uiPlaneProjection.z;
         if(param1.spawnDraggable is SpawnDraggableWateringCan)
         {
            _loc4_ = param1.spawnDraggable as SpawnDraggableWateringCan;
            if(_loc4_.y < 350)
            {
               if(!wateringCan3D.isWatering)
               {
                  _loc4_.beginWatering();
                  wateringCan3D.beginWatering();
               }
            }
            else if(wateringCan3D.isWatering)
            {
               _loc4_.endWatering();
               wateringCan3D.endWatering();
            }
         }
         var _loc2_:DisplayObject = param1.spawnDraggable as DisplayObject;
         var _loc3_:Number = 4.5;
         _loc2_.scaleX = _loc2_.scaleY = 1 - (dragObject3D.z + 200) / (550 * _loc3_);
         if(gPlaneProjectionWasConstrained)
         {
            if(!dragObjShadow.isHidden)
            {
               dragObjShadow.hideSelf();
            }
         }
         else
         {
            if(dragObjShadow.isHidden)
            {
               dragObjShadow.showSelf();
            }
            dragObjShadow.x = gPlaneProjection.x;
            dragObjShadow.y = gPlaneProjection.y;
            dragObjShadow.z = gPlaneProjection.z;
         }
      }
      
      public function setPlantController3D(param1:PlantController3D) : void
      {
         if(plantController3D)
         {
            removePlantController3dListeners(plantController3D);
         }
         plantController3D = param1;
         addPlantController3dListeners(plantController3D);
      }
      
      private function pickUpDefault3DObj() : void
      {
         if(!default3DObj)
         {
            default3DObj = new DisplayObject3D();
            addChild(default3DObj);
         }
         dragObject3D = default3DObj;
      }
      
      public function get viewIsDirty() : Boolean
      {
         if(gPlaneProjectionLast.x != gPlaneProjectionUnconstrained.x || gPlaneProjectionLast.y != gPlaneProjectionUnconstrained.y || gPlaneProjectionLast.z != gPlaneProjectionUnconstrained.z)
         {
            return true;
         }
         if(fallingSeeds.length > 0)
         {
            return true;
         }
         return false;
      }
      
      private function updateFallingSeeds() : void
      {
         var _loc1_:DragSeed3D = null;
         for each(_loc1_ in fallingSeeds)
         {
            _loc1_.updateFall();
            if(_loc1_.y <= gPlaneY)
            {
               _loc1_.endFall();
               _loc1_.y = gPlaneY;
               if(_loc1_ === dragObject3D)
               {
                  dragObject3D = null;
               }
               fallingSeeds.splice(fallingSeeds.indexOf(_loc1_),1);
               removeChild(_loc1_);
               dispatchEvent(new UIController3DPlantEvent(UIController3DPlantEvent.SEED_PLANTED,_loc1_.position,_loc1_.plantType));
               dragObjShadow.hideSelf();
            }
         }
      }
      
      private function addPlantController3dListeners(param1:PlantController3D) : void
      {
      }
      
      private function initUIIntersect() : void
      {
         lines3D = new Lines3D(new LineMaterial3D(16777215,0.4));
         addChild(lines3D);
         uiPlane = new Plane3D();
         var _loc1_:Number3D = new Number3D(0,1,0);
         _loc1_.rotateX(uiPlaneXRot);
         var _loc2_:Number3D = new Number3D(0,-uiPlaneY,-planeOffsZ);
         uiPlane.setNormalAndPoint(_loc1_,_loc2_);
         uiPlane.d *= -1;
      }
      
      private function killCurrentDragObj() : void
      {
         if(!dragObject3D)
         {
            return;
         }
         if(dragObject3D is DragSeed3D)
         {
            DragSeed3D(dragObject3D).removeSelf();
         }
         else if(dragObject3D is WateringCan3D)
         {
            WateringCan3D(dragObject3D).endWatering();
            WateringCan3D(dragObject3D).removeSelf();
         }
         else if(dragObject3D is Trowel3D)
         {
            Trowel3D(dragObject3D).removeSelf();
         }
         dragObjShadow.hideSelf();
         dragObject3D = null;
      }
      
      private function constrainNumber3DToRect(param1:Number3D, param2:Rectangle) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1.x < param2.x)
         {
            param1.x = param2.x;
            _loc3_ = true;
         }
         else if(param1.x > param2.x + param2.width)
         {
            param1.x = param2.x + param2.width;
            _loc3_ = true;
         }
         if(param1.z < param2.y)
         {
            param1.z = param2.y;
            _loc3_ = true;
         }
         else if(param1.z > param2.y + param2.height)
         {
            param1.z = param2.y + param2.height;
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function activate() : void
      {
      }
      
      private function dropWateringCan() : void
      {
         wateringCan3D.dropped();
         dispatchEvent(new UIController3DEvent(UIController3DEvent.WATERCAN_DROPPED,gPlaneProjection));
      }
      
      private function dropObj3D(param1:DisplayObject3D, param2:ISpawnDraggable) : void
      {
         if(param1 is DragSeed3D)
         {
            dropSeed(param1 as DragSeed3D);
         }
         else if(param1 is WateringCan3D)
         {
            dropWateringCan();
         }
         dragObjShadow.hideSelf();
         dragObject3D = null;
      }
      
      public function deactivate() : void
      {
         var _loc1_:DragSeed3D = null;
         killCurrentDragObj();
         while(fallingSeeds.length > 0)
         {
            _loc1_ = fallingSeeds.pop();
            _loc1_.endFall();
            removeChild(_loc1_);
         }
         if(dragObjShadow)
         {
            dragObjShadow.x -= 900;
         }
      }
      
      private function addUIController2dListeners(param1:UIController2D) : void
      {
         param1.addEventListener(UIController2DEvent.SEED_PICKED_UP,handleDragBegins);
         param1.addEventListener(UIController2DEvent.SEED_DROPPED,handleDragEnds);
         param1.addEventListener(UIController2DEvent.WATERING_CAN_PICKED_UP,handleDragBegins);
         param1.addEventListener(UIController2DEvent.WATERING_CAN_DROPPED,handleDragEnds);
         param1.addEventListener(UIController2DEvent.TROWEL_PICKED_UP,handleDragBegins);
         param1.addEventListener(UIController2DEvent.TROWEL_DROPPED,handleDragEnds);
         param1.addEventListener(UIController2DEvent.TROWEL_DIG_ACTION,handleDigAction);
         param1.addEventListener(UIController2DEvent.DRAGGABLE_MOVED,handle2DDragUpdate);
      }
   }
}

