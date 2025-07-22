package net.pluginmedia.brain.core.interfaces
{
   public interface IDropTarget
   {
      
      function get enabled() : Boolean;
      
      function get value() : String;
      
      function set enabled(param1:Boolean) : void;
      
      function setOverState(param1:Boolean) : void;
   }
}

