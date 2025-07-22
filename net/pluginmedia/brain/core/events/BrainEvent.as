package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   
   public class BrainEvent extends Event
   {
      
      public static var ACTION:String = "BrainEvent.Action";
      
      private var _actionTarget:String;
      
      private var _data:*;
      
      private var _actionType:String;
      
      public function BrainEvent(param1:String = null, param2:String = null, param3:* = null)
      {
         super(ACTION);
         _actionType = param1;
         _actionTarget = param2;
         _data = param3;
      }
      
      public function get actionType() : String
      {
         return _actionType;
      }
      
      public function get actionTarget() : String
      {
         return _actionTarget;
      }
      
      public function get data() : *
      {
         if(_data)
         {
            return _data;
         }
         return null;
      }
      
      override public function clone() : Event
      {
         return new BrainEvent(_actionType,_actionTarget,_data);
      }
   }
}

