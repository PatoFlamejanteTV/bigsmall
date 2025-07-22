package net.pluginmedia.brain.core
{
   import flash.display.Graphics;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   public class Button extends Broadcaster
   {
      
      protected var _isSelected:Boolean = false;
      
      protected var _isDown:Boolean = false;
      
      protected var actionType:String;
      
      protected var actionObj:Object = {};
      
      protected var actionString:String;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _isOver:Boolean = false;
      
      public function Button(param1:String = null, param2:String = null, param3:Object = null)
      {
         super();
         actionType = param1;
         actionString = param2;
         actionObj = param3;
         buildView();
         setEnabledState(true);
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         broadcast(actionType,actionString,actionObj);
      }
      
      protected function addEventListeners() : void
      {
         if(!hasEventListener(MouseEvent.CLICK))
         {
            addEventListener(MouseEvent.CLICK,handleClick);
         }
         if(!hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         }
         if(!hasEventListener(MouseEvent.MOUSE_OVER))
         {
            addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(!hasEventListener(MouseEvent.MOUSE_OUT))
         {
            addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         }
         if(!hasEventListener(FocusEvent.FOCUS_IN))
         {
            addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         }
         if(!hasEventListener(FocusEvent.FOCUS_OUT))
         {
            addEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
         }
      }
      
      protected function setDownState(param1:Boolean = true) : void
      {
         _isDown = param1;
         updateVisualState();
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         setOverState(true);
      }
      
      public function setEnabledState(param1:Boolean = true) : void
      {
         _isEnabled = param1;
         if(param1)
         {
            addEventListeners();
            buttonMode = true;
         }
         else
         {
            removeEventListeners();
            buttonMode = false;
         }
         updateVisualState();
      }
      
      protected function handleFocusIn(param1:FocusEvent) : void
      {
         setOverState(true);
      }
      
      public function defaultState() : void
      {
         setSelectedState(false);
         setOverState(false);
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
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         setDownState(true);
      }
      
      public function get isSelected() : Boolean
      {
         return _isSelected;
      }
      
      protected function updateVisualState() : void
      {
         if(_isSelected)
         {
            if(_isEnabled)
            {
               if(!_isOver)
               {
                  alpha = 0.8;
               }
               else
               {
                  alpha = 1;
               }
            }
            else if(!_isOver)
            {
               alpha = 0.3;
            }
            else
            {
               alpha = 0.3;
            }
         }
         else if(_isEnabled)
         {
            if(!_isOver)
            {
               alpha = 0.8;
            }
            else
            {
               alpha = 1;
            }
         }
         else if(_isOver)
         {
            alpha = 0.3;
         }
      }
      
      protected function removeEventListeners() : void
      {
         if(hasEventListener(MouseEvent.CLICK))
         {
            removeEventListener(MouseEvent.CLICK,handleClick);
         }
         if(hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         }
         if(hasEventListener(MouseEvent.MOUSE_OVER))
         {
            removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(hasEventListener(MouseEvent.MOUSE_OUT))
         {
            removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         }
         if(hasEventListener(FocusEvent.FOCUS_IN))
         {
            removeEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         }
         if(hasEventListener(FocusEvent.FOCUS_OUT))
         {
            removeEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
         }
      }
      
      protected function handleFocusOut(param1:FocusEvent) : void
      {
         setOverState(false);
         setDownState(false);
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         setOverState(false);
         setDownState(false);
      }
      
      public function setSelectedState(param1:Boolean = true) : void
      {
         _isSelected = param1;
         updateVisualState();
      }
      
      public function get isEnabled() : Boolean
      {
         return _isEnabled;
      }
      
      protected function buildView() : void
      {
         var _loc1_:Graphics = this.graphics;
         _loc1_.beginFill(16711680,1);
         _loc1_.drawRect(0,0,200,50);
         _loc1_.endFill();
      }
   }
}

