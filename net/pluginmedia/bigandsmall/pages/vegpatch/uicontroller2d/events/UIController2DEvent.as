package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d.events
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   
   public class UIController2DEvent extends Event
   {
      
      public static const SEED_PICKED_UP:String = "seedPickedUp";
      
      public static const SEED_DROPPED:String = "seedDropped";
      
      public static const SEED_DESTROYED:String = "seedDestroyed";
      
      public static const TROWEL_PICKED_UP:String = "trowelPickedUp";
      
      public static const TROWEL_DROPPED:String = "trowelDropped";
      
      public static const TROWEL_DIG_ACTION:String = "trowelDigAction";
      
      public static const WATERING_CAN_PICKED_UP:String = "wateringCanPickedUp";
      
      public static const WATERING_CAN_DROPPED:String = "wateringCanDropped";
      
      public static const DRAGGABLE_MOVED:String = "draggableMoved";
      
      private var draggable:IDraggable;
      
      public function UIController2DEvent(param1:String, param2:IDraggable = null)
      {
         draggable = param2;
         super(param1);
      }
      
      public function get spawnDraggable() : IDraggable
      {
         return draggable;
      }
   }
}

