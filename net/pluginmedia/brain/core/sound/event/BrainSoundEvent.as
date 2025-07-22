package net.pluginmedia.brain.core.sound.event
{
   import flash.events.Event;
   
   public class BrainSoundEvent extends Event
   {
      
      public static var PLAY:String = "BrainSoundEvent.PLAY";
      
      public static var STOP:String = "BrainSoundEvent.STOP";
      
      public static var PAUSE:String = "BrainSoundEvent.PAUSE";
      
      public static var RESUME:String = "BrainSoundEvent.RESUME";
      
      public function BrainSoundEvent(param1:String)
      {
         super(param1);
      }
   }
}

