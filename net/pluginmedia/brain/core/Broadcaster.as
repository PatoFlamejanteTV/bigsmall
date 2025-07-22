package net.pluginmedia.brain.core
{
   import flash.display.Sprite;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.interfaces.IBroadcaster;
   
   public class Broadcaster extends Sprite implements IBroadcaster
   {
      
      public function Broadcaster()
      {
         super();
      }
      
      public function broadcast(param1:String = null, param2:String = null, param3:* = null) : void
      {
         BrainLogger.out("Broadcaster : dispatch BrainEvent");
         dispatchEvent(new BrainEvent(param1,param2,param3));
      }
   }
}

