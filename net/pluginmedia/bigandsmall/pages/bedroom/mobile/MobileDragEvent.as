package net.pluginmedia.bigandsmall.pages.bedroom.mobile
{
   import flash.events.Event;
   
   public class MobileDragEvent extends Event
   {
      
      public static var PROGRESS:String = "MobileDragEvent.PROGRESS";
      
      private var _stringLength:Number;
      
      private var _intersectX:Number;
      
      public function MobileDragEvent(param1:Number, param2:Number)
      {
         _stringLength = param1;
         _intersectX = param2;
         super(PROGRESS);
      }
      
      public function get stringLength() : Number
      {
         return _stringLength;
      }
      
      public function get intersectX() : Number
      {
         return _intersectX;
      }
      
      override public function clone() : Event
      {
         return new MobileDragEvent(_stringLength,_intersectX);
      }
   }
}

