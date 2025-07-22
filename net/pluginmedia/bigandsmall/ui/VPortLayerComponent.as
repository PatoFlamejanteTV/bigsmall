package net.pluginmedia.bigandsmall.ui
{
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class VPortLayerComponent extends EventDispatcher
   {
      
      protected var _hasFocus:Boolean = false;
      
      protected var _viewportLayer:ViewportLayer;
      
      public var onClick:Function = null;
      
      protected var _isOver:Boolean = false;
      
      protected var _isEnabled:Boolean = false;
      
      public function VPortLayerComponent(param1:ViewportLayer)
      {
         super();
         _viewportLayer = param1;
         addEventListeners(_viewportLayer);
         setEnabledState(false);
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         if(onClick !== null)
         {
            onClick();
         }
         dispatchEvent(param1);
      }
      
      protected function addEventListeners(param1:ViewportLayer) : void
      {
         param1.addEventListener(MouseEvent.CLICK,handleClick);
         param1.addEventListener(MouseEvent.MOUSE_UP,handleMUp);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,handleMDown);
         param1.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         param1.addEventListener(MouseEvent.ROLL_OVER,handleRollOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,handleRollOut);
         param1.addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         param1.addEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
      }
      
      protected function handleRollOut(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(false);
         dispatchEvent(param1);
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(true);
         dispatchEvent(param1);
      }
      
      protected function handleFocusIn(param1:FocusEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(true);
         _hasFocus = true;
         dispatchEvent(param1);
      }
      
      public function set tabEnabled(param1:Boolean) : void
      {
         _viewportLayer.tabEnabled = param1;
      }
      
      public function setEnabledState(param1:Boolean = true) : void
      {
         _isEnabled = param1;
         if(_isOver)
         {
            _isOver = false;
         }
         _viewportLayer.buttonMode = _isEnabled;
         updateVisualState();
      }
      
      protected function setOverState(param1:Boolean = true) : void
      {
         _isOver = param1;
         updateVisualState();
      }
      
      public function get isOver() : Boolean
      {
         return _isOver;
      }
      
      protected function handleMUp(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         dispatchEvent(param1);
      }
      
      public function get hasFocus() : Boolean
      {
         return _hasFocus;
      }
      
      protected function handleMDown(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         dispatchEvent(param1);
      }
      
      protected function updateVisualState() : void
      {
         if(_isEnabled)
         {
            if(!_isOver)
            {
               setHighlight(false);
            }
            else
            {
               setHighlight(true);
            }
         }
         else if(!_isOver)
         {
            setHighlight(false);
         }
         else
         {
            setHighlight(false);
         }
      }
      
      public function get tabEnabled() : Boolean
      {
         return _viewportLayer.tabEnabled;
      }
      
      protected function handleFocusOut(param1:FocusEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(false);
         _hasFocus = false;
         dispatchEvent(param1);
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(false);
         dispatchEvent(param1);
      }
      
      protected function setHighlight(param1:Boolean) : void
      {
         if(param1)
         {
         }
      }
      
      public function get isEnabled() : Boolean
      {
         return _isEnabled;
      }
      
      protected function removeEventListeners(param1:ViewportLayer) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,handleClick);
         param1.removeEventListener(MouseEvent.MOUSE_UP,handleMUp);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,handleMDown);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         param1.removeEventListener(MouseEvent.ROLL_OVER,handleRollOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,handleRollOut);
         param1.removeEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         param1.removeEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
      }
      
      protected function handleRollOver(param1:MouseEvent) : void
      {
         if(!_isEnabled)
         {
            return;
         }
         setOverState(true);
         dispatchEvent(param1);
      }
   }
}

