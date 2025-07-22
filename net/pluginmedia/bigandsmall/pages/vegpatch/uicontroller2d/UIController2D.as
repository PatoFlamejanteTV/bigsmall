package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.events.UIController2DEvent;
   import net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.UIController3D;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.core.events.DragDropEvent;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   import net.pluginmedia.brain.managers.ClickStickManager;
   import net.pluginmedia.brain.managers.DragDropManager;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   import org.papervision3d.view.BasicView;
   
   public class UIController2D extends Sprite
   {
      
      public var dragCoords:Point = new Point();
      
      private var bigSeeds:Array;
      
      private var harvestButton:AssetButton;
      
      private var basicView:BasicView;
      
      private var currentDraggable:IDraggable;
      
      private var draggableWateringCan:SpawnDraggableWateringCan;
      
      private var prevUpdateCoords:Point;
      
      private var currentPOV:String;
      
      private var trowelSpawner:DraggableSpawner;
      
      private var backButtonPos:Point;
      
      private var dock:VegPatchGameDock;
      
      private var uiController3D:UIController3D;
      
      private var wateringCanSpawner:DraggableSpawner;
      
      private var smallSeeds:Array;
      
      private var clickStick:DragDropManager;
      
      private var backButton:AssetButton;
      
      private var draggableTrowel:SpawnDraggableTrowel;
      
      public function UIController2D(param1:BasicView, param2:Array, param3:Array, param4:DraggableSpawner, param5:DraggableSpawner)
      {
         super();
         basicView = param1;
         smallSeeds = param2;
         bigSeeds = param3;
         wateringCanSpawner = param4;
         trowelSpawner = param5;
         prevUpdateCoords = new Point();
         initClickStick();
      }
      
      private function handleDigAction(param1:Event) : void
      {
         dispatchEvent(new UIController2DEvent(UIController2DEvent.TROWEL_DIG_ACTION,param1.target as SpawnDraggable));
      }
      
      private function addDragDropListeners(param1:DragDropManager) : void
      {
         param1.addEventListener(DragDropEvent.PICK_UP,handlePickUp);
         param1.addEventListener(DragDropEvent.DROP,handleDrop);
      }
      
      private function addUIController3dListeners(param1:UIController3D) : void
      {
      }
      
      public function initClickStick() : void
      {
         var _loc1_:SeedSpawner = null;
         clickStick = new ClickStickManager(basicView.stage);
         for each(_loc1_ in smallSeeds)
         {
            clickStick.registerSpawner(_loc1_);
         }
         for each(_loc1_ in bigSeeds)
         {
            clickStick.registerSpawner(_loc1_);
         }
         clickStick.registerSpawner(wateringCanSpawner);
         clickStick.registerSpawner(trowelSpawner);
         addChild(clickStick);
         addDragDropListeners(clickStick);
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
      
      public function initBackButton(param1:AssetButton) : void
      {
         backButton = param1;
         backButtonPos = new Point(basicView.viewport.viewportWidth - 50,50);
         backButton.x = backButtonPos.x + 100;
         backButton.y = backButtonPos.y;
         addChild(backButton);
      }
      
      public function summonUI(param1:Number = 0.3) : void
      {
         backButton.x = backButtonPos.x;
         backButton.y = backButtonPos.y;
         TweenMax.from(backButton,param1,{"x":backButtonPos.x + 100});
         dock.summon(param1);
      }
      
      private function handleDrop(param1:DragDropEvent) : void
      {
         var _loc3_:SpawnDraggableWateringCan = null;
         var _loc2_:IDraggable = param1.draggable as IDraggable;
         if(_loc2_ is SpawnDraggableSeed)
         {
            dispatchEvent(new UIController2DEvent(UIController2DEvent.SEED_DROPPED,_loc2_));
            clickStick.killDraggable(_loc2_);
         }
         else if(_loc2_ is SpawnDraggableWateringCan)
         {
            _loc3_ = _loc2_ as SpawnDraggableWateringCan;
            _loc3_.visible = true;
            _loc3_.endWatering(true);
            _loc3_.snapToLoc(_loc3_.snapLoc.x,_loc3_.snapLoc.y,false,handleWaterCanReturnComplete,[_loc3_]);
            dispatchEvent(new UIController2DEvent(UIController2DEvent.WATERING_CAN_DROPPED,_loc2_));
         }
         else if(_loc2_ is SpawnDraggableTrowel)
         {
            draggableTrowel.snapToLoc(draggableTrowel.snapLoc.x,draggableTrowel.snapLoc.y,false,handleTrowelReturnComplete);
            dispatchEvent(new UIController2DEvent(UIController2DEvent.TROWEL_DROPPED,_loc2_));
         }
         currentDraggable = null;
      }
      
      private function handleTrowelReturnComplete() : void
      {
         draggableTrowel.removeEventListener(SpawnDraggableTrowel.DIG_ACTION,handleDigAction);
         draggableTrowel.parent.removeChild(draggableTrowel);
         draggableTrowel = null;
         dock.showTrowel();
      }
      
      public function update() : void
      {
         dragCoords.x = basicView.viewport.containerSprite.mouseX;
         dragCoords.y = basicView.viewport.containerSprite.mouseY;
         if(currentDraggable !== null)
         {
            if(dragCoords.x != prevUpdateCoords.x || dragCoords.y != prevUpdateCoords.y)
            {
               prevUpdateCoords.x = dragCoords.x;
               prevUpdateCoords.y = dragCoords.y;
               dispatchEvent(new UIController2DEvent(UIController2DEvent.DRAGGABLE_MOVED,currentDraggable));
            }
         }
      }
      
      private function removeUIController3dListeners(param1:UIController3D) : void
      {
      }
      
      public function banishUI(param1:Number = 0.3) : void
      {
         TweenMax.to(backButton,param1,{"x":backButtonPos.x + 100});
         dock.banish(param1);
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
         if(dock)
         {
            dock.setCharacter(currentPOV);
         }
      }
      
      public function initDock(param1:MovieClip) : void
      {
         dock = new VegPatchGameDock(param1,smallSeeds,bigSeeds,wateringCanSpawner,trowelSpawner);
         dock.x = basicView.viewport.viewportWidth >> 1;
         dock.y = basicView.viewport.viewportHeight;
         dock.setCharacter(currentPOV);
         addChild(dock);
         swapChildren(dock,clickStick);
      }
      
      private function handlePickUp(param1:DragDropEvent) : void
      {
         var _loc2_:IDraggable = param1.draggable as IDraggable;
         if(_loc2_ is SpawnDraggableSeed)
         {
            dispatchEvent(new UIController2DEvent(UIController2DEvent.SEED_PICKED_UP,_loc2_));
         }
         else if(_loc2_ is SpawnDraggableWateringCan)
         {
            draggableWateringCan = _loc2_ as SpawnDraggableWateringCan;
            dock.hideWateringCan();
            dispatchEvent(new UIController2DEvent(UIController2DEvent.WATERING_CAN_PICKED_UP,_loc2_));
         }
         else if(_loc2_ is SpawnDraggableTrowel)
         {
            draggableTrowel = _loc2_ as SpawnDraggableTrowel;
            draggableTrowel.addEventListener(SpawnDraggableTrowel.DIG_ACTION,handleDigAction);
            dock.hideTrowel();
            dispatchEvent(new UIController2DEvent(UIController2DEvent.TROWEL_PICKED_UP,_loc2_));
         }
         currentDraggable = param1.draggable as IDraggable;
      }
      
      private function handleWaterCanReturnComplete(param1:SpawnDraggableWateringCan) : void
      {
         param1.parent.removeChild(param1);
         draggableWateringCan = null;
         dock.showWateringCan();
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
         clickStick.killDragObject();
         dock.showTrowel();
         dock.showWateringCan();
      }
   }
}

