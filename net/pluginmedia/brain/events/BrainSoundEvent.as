package net.pluginmedia.brain.events
{
   import flash.events.Event;
   
   public class BrainSoundEvent extends Event
   {
      
      public static const EVENT:String = "BrainSoundEvent.EVENT";
      
      public function BrainSoundEvent(param1:String)
      {
         super(param1);
      }
   }
}

