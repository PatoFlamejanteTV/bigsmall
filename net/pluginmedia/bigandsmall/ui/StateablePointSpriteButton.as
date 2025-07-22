package net.pluginmedia.bigandsmall.ui
{
   import flash.events.MouseEvent;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class StateablePointSpriteButton extends StateablePointSprite
   {
      
      private var _viewportLayer:ViewportLayer;
      
      private var _isActive:Boolean = false;
      
      public function StateablePointSpriteButton()
      {
         super();
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(!_isActive)
         {
            return;
         }
         currentClip.gotoAndStop("_active");
         dispatchEvent(param1);
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         if(!_isActive)
         {
            return;
         }
         currentClip.gotoAndStop("_down");
         dispatchEvent(param1);
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         if(!_isActive)
         {
            return;
         }
         currentClip.gotoAndStop("_active");
         dispatchEvent(param1);
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(!_isActive)
         {
            return;
         }
         currentClip.gotoAndStop("_over");
         dispatchEvent(param1);
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(!_isActive)
         {
            return;
         }
         currentClip.gotoAndStop("_active");
         dispatchEvent(param1);
      }
      
      public function deactivate() : void
      {
         _isActive = false;
         hide();
      }
      
      private function removeViewportListeners() : void
      {
         _viewportLayer.removeEventListener(MouseEvent.ROLL_OVER,handleMouseOver);
         _viewportLayer.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
         _viewportLayer.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         _viewportLayer.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
         _viewportLayer.removeEventListener(MouseEvent.CLICK,handleMouseClick);
         _viewportLayer.buttonMode = false;
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         if(_viewportLayer)
         {
            removeViewportListeners();
         }
         _viewportLayer = param1;
         addViewportListeners();
      }
      
      override public function subsumeState(param1:StateablePointSpriteState) : void
      {
         super.subsumeState(param1);
         currentClip.gotoAndStop("_active");
      }
      
      private function addViewportListeners() : void
      {
         _viewportLayer.addEventListener(MouseEvent.ROLL_OVER,handleMouseOver);
         _viewportLayer.addEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
         _viewportLayer.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         _viewportLayer.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
         _viewportLayer.addEventListener(MouseEvent.CLICK,handleMouseClick);
         _viewportLayer.buttonMode = true;
         _viewportLayer.mouseChildren = false;
      }
      
      public function activate() : void
      {
         _isActive = true;
         show();
      }
   }
}

