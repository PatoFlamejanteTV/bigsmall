package net.pluginmedia.bigandsmall.pages.garden.characters.small
{
   import flash.events.IEventDispatcher;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public interface ISmallGardenState extends IEventDispatcher
   {
      
      function update() : void;
      
      function park() : void;
      
      function get viewportLayer() : ViewportLayer;
      
      function get isTalking() : Boolean;
      
      function get OUTRO_COMPLETE() : String;
      
      function get DEFAULTMOUTHLABEL() : String;
      
      function deactivate() : void;
      
      function set viewportLayer(param1:ViewportLayer) : void;
      
      function set isTalking(param1:Boolean) : void;
      
      function activate() : void;
      
      function mouthShapeToLabel(param1:String) : void;
   }
}

