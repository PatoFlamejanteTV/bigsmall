package net.pluginmedia.brain.core.animation.events
{
   import flash.events.Event;
   
   public class AnimationEvent extends Event
   {
      
      public static var COMPLETE:String = "AnimationEvent.COMPLETE";
      
      public static var LOOP_COMPLETE:String = "AnimationEvent.LOOP_COMPLETE";
      
      public static var PROGRESS:String = "AnimationEvent.PROGRESS";
      
      public function AnimationEvent(param1:String)
      {
         super(param1);
      }
   }
}

