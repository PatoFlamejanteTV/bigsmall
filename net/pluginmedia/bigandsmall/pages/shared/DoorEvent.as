package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.events.Event;
   
   public class DoorEvent extends Event
   {
      
      public static var SHUT:String = "DoorEvent.SHUT";
      
      private var _shutVel:Number;
      
      public function DoorEvent(param1:String, param2:Number)
      {
         _shutVel = param2;
         super(param1);
      }
      
      public function get shutVel() : Number
      {
         return _shutVel;
      }
   }
}

