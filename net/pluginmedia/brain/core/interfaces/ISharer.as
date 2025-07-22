package net.pluginmedia.brain.core.interfaces
{
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   
   public interface ISharer
   {
      
      function onShareableRegistration() : void;
      
      function receiveShareable(param1:SharerInfo) : void;
   }
}

