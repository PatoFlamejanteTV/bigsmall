package net.pluginmedia.brain.managers
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import net.pluginmedia.brain.core.events.DragDropEvent;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   import net.pluginmedia.brain.core.interfaces.IDropTarget;
   
   public class ClickStickManager extends DragDropManager
   {
      
      protected var dragStartPoint:Point;
      
      public var stickDistance:uint = 100;
      
      protected var stick:Boolean;
      
      protected var stuck:Boolean;
      
      public function ClickStickManager(param1:Stage)
      {
         super(param1);
      }
      
      override protected function doPickUp(param1:IDraggable) : void
      {
         if(_dragObject !== null || isTweening)
         {
            return;
         }
         _dragObject = param1;
         _dragObject.onPickUp();
         bringToFront(_dragObject as DisplayObject);
         dragStartPoint = new Point(mouseX,mouseY);
         stick = true;
         stuck = false;
         dispatchEvent(new DragDropEvent(DragDropEvent.PICK_UP,_dragObject));
      }
      
      override protected function handleStageMouseUp(param1:MouseEvent) : void
      {
         if(_dragObject !== null && !isTweening && stuck)
         {
            doDrop();
         }
         else if(stick && !stuck)
         {
            stuck = true;
         }
      }
      
      override protected function handleLeaveStage(param1:Event) : void
      {
         if(_dragObject !== null && !isTweening && stuck)
         {
            doDrop();
         }
         else if(stick && !stuck)
         {
            stuck = true;
         }
      }
      
      override protected function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:IDropTarget = null;
         activeDropTarget = null;
         if(_dragObject !== null && !isTweening)
         {
            if(!stuck)
            {
               _loc4_ = Math.sqrt(Math.pow(mouseX - dragStartPoint.x,2) + Math.pow(mouseY - dragStartPoint.y,2));
               if(_loc4_ > stickDistance)
               {
                  stick = false;
                  stuck = true;
               }
            }
            _loc2_ = _dragObject as DisplayObject;
            _loc2_.x = mouseX;
            _loc2_.y = mouseY;
            _loc3_ = 0;
            while(_loc3_ < dropTargets.length)
            {
               _loc5_ = dropTargets[_loc3_] as IDropTarget;
               if(_loc5_.enabled == true)
               {
                  if(_loc2_.hitTestObject(dropTargets[_loc3_] as DisplayObject))
                  {
                     _loc5_.setOverState(true);
                     activeDropTarget = _loc5_;
                  }
                  else
                  {
                     _loc5_.setOverState(false);
                  }
               }
               _loc3_++;
            }
         }
      }
   }
}

