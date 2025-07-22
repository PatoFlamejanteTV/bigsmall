package net.pluginmedia.brain.managers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.easing.*;
   import net.pluginmedia.brain.core.events.DragDropEvent;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   import net.pluginmedia.brain.core.interfaces.IDropTarget;
   import net.pluginmedia.brain.ui.Draggable;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   
   public class DragDropManager extends Sprite
   {
      
      protected var activeDropTarget:IDropTarget = null;
      
      protected var draggables:Array = [];
      
      protected var dragDropAssoc:Object = {};
      
      protected var dropTargets:Array = [];
      
      protected var tweenSpeed:Number = 0.25;
      
      protected var dragSpawners:Array = [];
      
      protected var isTweening:Boolean = false;
      
      protected var dragDropManager:DragDropManager;
      
      protected var targetStage:Stage;
      
      protected var _dragObject:IDraggable = null;
      
      protected var dropMagnets:Array = [];
      
      public function DragDropManager(param1:Stage)
      {
         super();
         targetStage = param1;
         targetStage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseUp);
         targetStage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function registerDropMagnet(param1:IDropTarget) : void
      {
         dropMagnets.push(param1);
      }
      
      protected function handleDraggableMouseDown(param1:MouseEvent) : void
      {
         if(_dragObject === null && !isTweening)
         {
            doPickUp(param1.currentTarget as Draggable);
         }
      }
      
      public function registerSpawner(param1:DraggableSpawner) : void
      {
         addSpawnerListeners(param1 as EventDispatcher);
         dragSpawners.push(param1);
      }
      
      protected function doPickUp(param1:IDraggable) : void
      {
         if(_dragObject !== null || isTweening || !param1.canPickUp)
         {
            return;
         }
         _dragObject = param1;
         _dragObject.onPickUp();
         bringToFront(_dragObject as DisplayObject);
         dispatchEvent(new DragDropEvent(DragDropEvent.PICK_UP,_dragObject));
      }
      
      protected function handleStageMouseUp(param1:MouseEvent) : void
      {
         if(_dragObject !== null && !isTweening)
         {
            doDrop();
         }
      }
      
      protected function bringToFront(param1:DisplayObject) : void
      {
         if(this.contains(param1))
         {
            setChildIndex(param1,this.numChildren - 1);
         }
      }
      
      public function allDropTargetsDisabled() : Boolean
      {
         var _loc2_:IDropTarget = null;
         var _loc1_:int = 0;
         while(_loc1_ < dropTargets.length)
         {
            _loc2_ = dropTargets[_loc1_] as IDropTarget;
            if(_loc2_.enabled == true)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function killDraggable(param1:IDraggable) : void
      {
         if(this.contains(param1 as DisplayObject))
         {
            removeChild(param1 as DisplayObject);
         }
      }
      
      public function killDragObject() : void
      {
         trace("-> killDragObject",_dragObject);
         if(!_dragObject)
         {
            return;
         }
         killDraggable(_dragObject);
         isTweening = false;
         _dragObject = null;
      }
      
      public function allDropMagnetsDisabled() : Boolean
      {
         var _loc2_:IDropTarget = null;
         var _loc1_:int = 0;
         while(_loc1_ < dropMagnets.length)
         {
            _loc2_ = dropMagnets[_loc1_] as IDropTarget;
            if(_loc2_.enabled == true)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      protected function removeDraggableListeners(param1:EventDispatcher) : void
      {
         if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,handleDraggableMouseDown);
         }
      }
      
      protected function handleLeaveStage(param1:Event) : void
      {
         if(_dragObject !== null && !isTweening)
         {
            doDrop();
         }
      }
      
      protected function doDrop() : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc7_:Draggable = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:IDropTarget = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:IDropTarget = null;
         if(!_dragObject || !_dragObject.canDrop)
         {
            return;
         }
         var _loc1_:DisplayObject = _dragObject as DisplayObject;
         var _loc2_:IDropTarget = null;
         var _loc3_:Number = int.MAX_VALUE;
         if(activeDropTarget !== null)
         {
            _loc5_ = activeDropTarget as DisplayObject;
            dispatchEvent(new DragDropEvent(DragDropEvent.DROP_OVER,_dragObject,activeDropTarget,_loc2_));
            _dragObject.onPut();
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < dropMagnets.length)
            {
               _loc9_ = dropMagnets[_loc6_] as DisplayObject;
               _loc10_ = dropMagnets[_loc6_] as IDropTarget;
               if(_loc10_.enabled == true)
               {
                  _loc11_ = _loc9_.x - _loc1_.x;
                  _loc12_ = _loc9_.y - _loc1_.y;
                  _loc13_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
                  if(_loc13_ < _loc3_)
                  {
                     _loc2_ = _loc9_ as IDropTarget;
                     _loc3_ = _loc13_;
                  }
               }
               _loc6_++;
            }
            _loc7_ = _dragObject as Draggable;
            _loc8_ = _loc2_ as DisplayObject;
            dispatchEvent(new DragDropEvent(DragDropEvent.DROP,_dragObject,null,_loc2_));
            _dragObject.onDrop();
         }
         _dragObject = null;
         var _loc4_:Number = 0;
         while(_loc4_ < dropTargets.length)
         {
            _loc14_ = dropTargets[_loc4_] as IDropTarget;
            _loc14_.setOverState(false);
            _loc4_++;
         }
      }
      
      public function get dragObject() : IDraggable
      {
         return _dragObject;
      }
      
      public function registerDropTarget(param1:IDropTarget) : void
      {
         dropTargets.push(param1);
      }
      
      protected function handleDropTweenComplete() : void
      {
         killDragObject();
      }
      
      protected function handleSpawnerMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DraggableSpawner = param1.target as DraggableSpawner;
         if(!_loc2_.isEnabled)
         {
            return;
         }
         if(_dragObject === null && !isTweening)
         {
            doSpawn(param1.currentTarget as DraggableSpawner);
         }
      }
      
      public function dropCurrentObject() : void
      {
         if(!_dragObject)
         {
            return;
         }
         doDrop();
      }
      
      protected function doSpawn(param1:DraggableSpawner) : void
      {
         var _loc2_:SpawnDraggable = null;
         var _loc3_:Point = null;
         if(param1.spawnDataClass !== null)
         {
            _loc3_ = new Point(mouseX,mouseY);
            if(param1.canSpawn)
            {
               _loc2_ = param1.spawnDraggable(_loc3_.x,_loc3_.y);
            }
            else
            {
               _loc2_ = new SpawnDraggable(param1,param1.spawnDataClass,_loc3_.x,_loc3_.y,param1.value);
            }
            addChild(_loc2_ as DisplayObject);
            param1.onSpawn();
            doPickUp(_loc2_ as IDraggable);
            return;
         }
      }
      
      public function registerDraggable(param1:IDraggable) : void
      {
         addDraggableListeners(param1 as EventDispatcher);
         draggables.push(param1);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc4_:IDropTarget = null;
         activeDropTarget = null;
         if(_dragObject !== null && !isTweening)
         {
            _loc2_ = _dragObject as DisplayObject;
            _loc2_.x = mouseX;
            _loc2_.y = mouseY;
            _loc3_ = 0;
            while(_loc3_ < dropTargets.length)
            {
               _loc4_ = dropTargets[_loc3_] as IDropTarget;
               if(_loc4_.enabled == true)
               {
                  if(_loc2_.hitTestObject(dropTargets[_loc3_] as DisplayObject))
                  {
                     _loc4_.setOverState(true);
                     activeDropTarget = _loc4_;
                  }
                  else
                  {
                     _loc4_.setOverState(false);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      protected function addDraggableListeners(param1:EventDispatcher) : void
      {
         if(!param1.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,handleDraggableMouseDown);
         }
      }
      
      protected function removeSpawnerListeners(param1:EventDispatcher) : void
      {
         if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,handleSpawnerMouseDown);
         }
      }
      
      protected function addSpawnerListeners(param1:EventDispatcher) : void
      {
         if(!param1.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,handleSpawnerMouseDown);
         }
      }
   }
}

