package net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions
{
   import flash.events.Event;
   
   public class SegmentTransitionEvent extends Event
   {
      
      public static var TRANSITION:String = "SegmentTransitionEvent.TRANSITION";
      
      public static var RETURN:String = "SegmentTransitionEvent.RETURN";
      
      public var path:String;
      
      public function SegmentTransitionEvent(param1:String, param2:String = null)
      {
         this.path = param2;
         super(param1);
      }
   }
}

