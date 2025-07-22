package net.pluginmedia.brain.core.interfaces
{
   public interface IManager
   {
      
      function get isPaused() : Boolean;
      
      function register(param1:Object) : void;
      
      function unregister(param1:Object) : Boolean;
      
      function pause(param1:Boolean = true) : void;
   }
}

