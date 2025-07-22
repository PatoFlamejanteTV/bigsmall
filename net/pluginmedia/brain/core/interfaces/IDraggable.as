package net.pluginmedia.brain.core.interfaces
{
   public interface IDraggable
   {
      
      function onPut() : void;
      
      function get value() : String;
      
      function onPickUp() : void;
      
      function get canPickUp() : Boolean;
      
      function onDrop() : void;
      
      function get canDrop() : Boolean;
   }
}

