package net.pluginmedia.bigandsmall.pages.garden.pond
{
   public interface IControllablePondInteractive
   {
      
      function setLiveStatus(param1:Boolean = false) : void;
      
      function get isLive() : Boolean;
      
      function unsetLiveStatus() : void;
      
      function get dirtyRenderState() : Boolean;
      
      function reset() : void;
   }
}

