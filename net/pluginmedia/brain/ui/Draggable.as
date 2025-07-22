package net.pluginmedia.brain.ui
{
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.easing.Elastic;
   import net.pluginmedia.brain.core.interfaces.IDraggable;
   
   public class Draggable extends Sprite implements IDraggable
   {
      
      protected var _isEnabled:Boolean = false;
      
      protected var _hasFocus:Boolean = false;
      
      protected var userData:Sprite;
      
      protected var _snapLoc:Point = new Point(0,0);
      
      protected var _value:String = "";
      
      protected var _isDragging:Boolean = false;
      
      public function Draggable(param1:Class, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         super();
         x = param2;
         y = param3;
         _value = param4;
         storeDefaultLoc();
         if(param1 !== null)
         {
            userData = new param1();
            userData.mouseChildren = false;
            addChild(userData);
            setEnabledState(true);
            return;
         }
         throw new Error("Draggable :: cannot be instantiated with null userdata");
      }
      
      public function storeDefaultLoc() : void
      {
         _snapLoc.x = x;
         _snapLoc.y = y;
      }
      
      public function snapToDefaultLoc(param1:Boolean = false) : void
      {
         var _loc2_:Number = 0.5;
         if(param1)
         {
            _loc2_ = 0;
         }
         TweenMax.to(this,_loc2_,{
            "x":_snapLoc.x,
            "y":_snapLoc.y,
            "ease":Elastic.easeOut,
            "overwrite":true
         });
      }
      
      protected function addEventListeners() : void
      {
         this.buttonMode = true;
         userData.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         userData.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         this.addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         this.addEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
      }
      
      public function snapToLoc(param1:Number, param2:Number, param3:Boolean = false, param4:Function = null, param5:Array = null) : void
      {
         if(param3)
         {
            this.x = param1;
            this.y = param2;
            if(param4 !== null)
            {
               param4();
            }
         }
         else
         {
            TweenMax.to(this,0.5,{
               "x":param1,
               "y":param2,
               "ease":Elastic.easeOut,
               "overwrite":true,
               "onComplete":param4,
               "onCompleteParams":param5
            });
         }
      }
      
      public function get value() : String
      {
         return _value;
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         setOverState(true);
      }
      
      public function setEnabledState(param1:Boolean) : void
      {
         _isEnabled = param1;
         if(param1)
         {
            addEventListeners();
         }
         else
         {
            removeEventListeners();
         }
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         setOverState(false);
      }
      
      public function get snapLoc() : Point
      {
         return _snapLoc;
      }
      
      public function get isDragging() : Boolean
      {
         return _isDragging;
      }
      
      public function setOverState(param1:Boolean) : void
      {
         if(param1)
         {
            userData.filters = [new GlowFilter(16777215)];
         }
         else
         {
            userData.filters = [];
         }
      }
      
      protected function handleFocusIn(param1:FocusEvent) : void
      {
         _hasFocus = true;
      }
      
      public function get hasFocus() : Boolean
      {
         return _hasFocus;
      }
      
      public function get canDrop() : Boolean
      {
         return true;
      }
      
      public function onPickUp() : void
      {
         _isDragging = true;
      }
      
      protected function handleFocusOut(param1:FocusEvent) : void
      {
         _hasFocus = false;
      }
      
      protected function removeEventListeners() : void
      {
         this.buttonMode = false;
         userData.removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         userData.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         this.removeEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         this.removeEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
      }
      
      public function onDrop() : void
      {
         _isDragging = false;
      }
      
      public function onPut() : void
      {
         _isDragging = false;
      }
      
      public function get canPickUp() : Boolean
      {
         return true;
      }
      
      public function get isEnabled() : Boolean
      {
         return _isEnabled;
      }
   }
}

