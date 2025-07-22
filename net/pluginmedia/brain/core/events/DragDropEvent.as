package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   import net.pluginmedia.brain.core.interfaces.IDropTarget;
   
   public class DragDropEvent extends Event
   {
      
      public static var PICK_UP:String = "PICK_UP";
      
      public static var DROP_OVER:String = "DROP_OVER";
      
      public static var DROP:String = "DROP";
      
      private var _draggable:IDraggable;
      
      private var _closestTarget:IDropTarget;
      
      private var _dropTarget:IDropTarget;
      
      public function DragDropEvent(param1:String, param2:IDraggable, param3:IDropTarget = null, param4:IDropTarget = null)
      {
         super(param1);
         _draggable = param2;
         _dropTarget = param3;
         _closestTarget = param4;
      }
      
      public function get dropTarget() : IDropTarget
      {
         return _dropTarget;
      }
      
      public function get closestTarget() : IDropTarget
      {
         return _closestTarget;
      }
      
      public function get draggable() : IDraggable
      {
         return _draggable;
      }
   }
}

