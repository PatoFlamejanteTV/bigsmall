package net.pluginmedia.bigandsmall.events
{
   import flash.events.Event;
   
   public class FlagDirtyLayersEvent extends Event
   {
      
      public static var DIRTY_LAYERS:String = "FlagDirtyLayersEvent.DIRTY_LAYER";
      
      public var dirtyLayers:Array = [];
      
      public function FlagDirtyLayersEvent(param1:String, param2:Array)
      {
         dirtyLayers = param2;
         super(param1);
      }
   }
}

