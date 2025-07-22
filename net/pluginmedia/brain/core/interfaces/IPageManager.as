package net.pluginmedia.brain.core.interfaces
{
   import net.pluginmedia.brain.managers.ShareManager;
   
   public interface IPageManager
   {
      
      function setShareManager(param1:ShareManager) : void;
      
      function changePageByID(param1:String) : void;
      
      function get pageHeight() : Number;
      
      function get pageWidth() : Number;
      
      function set pageHeight(param1:Number) : void;
      
      function set pageWidth(param1:Number) : void;
      
      function getPageByID(param1:String) : IPage;
   }
}

