package net.pluginmedia.brain.core.interfaces
{
   public interface IPage
   {
      
      function get isTransitionReady() : Boolean;
      
      function prepare(param1:String = null) : void;
      
      function get pageID() : String;
      
      function set pageHeight(param1:Number) : void;
      
      function set pageWidth(param1:Number) : void;
      
      function park() : void;
      
      function activate() : void;
      
      function deactivate() : void;
      
      function get pageHeight() : Number;
      
      function get pageWidth() : Number;
      
      function destroy() : void;
      
      function initialise() : void;
   }
}

