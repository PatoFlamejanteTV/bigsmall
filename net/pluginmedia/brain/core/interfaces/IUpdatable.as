package net.pluginmedia.brain.core.interfaces
{
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   
   public interface IUpdatable
   {
      
      function update(param1:UpdateInfo = null) : void;
      
      function get active() : Boolean;
   }
}

