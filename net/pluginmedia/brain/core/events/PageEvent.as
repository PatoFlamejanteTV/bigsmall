package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   
   public class PageEvent extends Event
   {
      
      public static var TRANSITION_READY:String = "PageEvent.TRANSITION_READY";
      
      public function PageEvent(param1:String = null)
      {
         if(!param1)
         {
            param1 = TRANSITION_READY;
         }
         super(param1);
      }
   }
}

