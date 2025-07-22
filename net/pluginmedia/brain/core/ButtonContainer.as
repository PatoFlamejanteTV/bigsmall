package net.pluginmedia.brain.core
{
   import net.pluginmedia.brain.core.events.BrainEvent;
   
   public class ButtonContainer extends Broadcaster
   {
      
      protected var buttons:Array;
      
      public function ButtonContainer()
      {
         super();
         buttons = new Array();
      }
      
      public function addButton(param1:Button) : Button
      {
         buttons.push(param1);
         param1.addEventListener(BrainEvent.ACTION,handleAction);
         addChild(param1);
         return param1;
      }
      
      protected function handleAction(param1:BrainEvent) : void
      {
         broadcast(param1.actionType,param1.actionTarget,param1.data);
      }
   }
}

