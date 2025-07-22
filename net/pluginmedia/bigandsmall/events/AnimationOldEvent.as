package net.pluginmedia.bigandsmall.events
{
   import flash.events.Event;
   
   public class AnimationOldEvent extends Event
   {
      
      public static var COMPLETE:String = "AnimationEvent.COMPLETE";
      
      public static var LOOP_COMPLETE:String = "AnimationEvent.LOOP_COMPLETE";
      
      public static var PROGRESS:String = "AnimationEvent.PROGRESS";
      
      public function AnimationOldEvent(param1:String)
      {
         super(param1);
      }
   }
}

