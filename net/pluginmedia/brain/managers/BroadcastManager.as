package net.pluginmedia.brain.managers
{
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.events.BrainEvent;
   
   public class BroadcastManager extends Manager
   {
      
      private var pageManager:PageManager;
      
      public function BroadcastManager()
      {
         super();
      }
      
      override public function register(param1:Object) : void
      {
         super.register(param1);
         param1.addEventListener(BrainEvent.ACTION,handleAction);
      }
      
      private function handleAction(param1:BrainEvent) : void
      {
         if(!_paused)
         {
            dispatchEvent(new BrainEvent(param1.actionType,param1.actionTarget,param1.data));
         }
      }
      
      override public function unregister(param1:Object) : Boolean
      {
         param1.removeEventListener(BrainEvent.ACTION,handleAction);
         return super.unregister(param1);
      }
      
      public function registerPageManager(param1:PageManager) : void
      {
         pageManager = param1;
      }
   }
}

