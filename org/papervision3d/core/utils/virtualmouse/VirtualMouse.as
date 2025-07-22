package org.papervision3d.core.utils.virtualmouse
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.papervision3d.core.log.PaperLogger;
   
   public class VirtualMouse extends EventDispatcher
   {
      
      public static const UPDATE:String = "update";
      
      private static var _mouseIsDown:Boolean = false;
      
      private var _container:Sprite;
      
      private var _stage:Stage;
      
      private var lastDownTarget:DisplayObject;
      
      private var target:InteractiveObject;
      
      private var updateMouseDown:Boolean = false;
      
      private var eventEvent:Class = VirtualMouseEvent;
      
      private var _lastEvent:Event;
      
      private var mouseEventEvent:Class = VirtualMouseMouseEvent;
      
      private var location:Point;
      
      private var delta:int = 0;
      
      private var disabledEvents:Object = new Object();
      
      private var ignoredInstances:Dictionary = new Dictionary(true);
      
      private var isLocked:Boolean = false;
      
      private var lastWithinStage:Boolean = true;
      
      private var lastLocation:Point;
      
      private var isDoubleClickEvent:Boolean = false;
      
      private var lastMouseDown:Boolean = false;
      
      private var ctrlKey:Boolean = false;
      
      private var altKey:Boolean = false;
      
      private var _useNativeEvents:Boolean = false;
      
      private var shiftKey:Boolean = false;
      
      public function VirtualMouse(param1:Stage = null, param2:Sprite = null, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.stage = param1;
         this.container = param2;
         location = new Point(param3,param4);
         lastLocation = location.clone();
         addEventListener(UPDATE,handleUpdate);
         update();
      }
      
      public function get mouseIsDown() : Boolean
      {
         return _mouseIsDown;
      }
      
      public function get container() : Sprite
      {
         return _container;
      }
      
      public function exitContainer() : void
      {
         if(!container)
         {
            return;
         }
         var _loc1_:Point = target.globalToLocal(location);
         if(!disabledEvents[MouseEvent.MOUSE_OUT])
         {
            _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            container.dispatchEvent(new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
            dispatchEvent(new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
         }
         if(!disabledEvents[MouseEvent.ROLL_OUT])
         {
            _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            container.dispatchEvent(new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
            dispatchEvent(new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
         }
         if(target != container)
         {
            if(!disabledEvents[MouseEvent.MOUSE_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
               dispatchEvent(new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
            }
            if(!disabledEvents[MouseEvent.ROLL_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
               dispatchEvent(new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta));
            }
         }
         target = _stage;
      }
      
      public function release() : void
      {
         updateMouseDown = true;
         _mouseIsDown = false;
         if(!isLocked)
         {
            update();
         }
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         altKey = param1.altKey;
         ctrlKey = param1.ctrlKey;
         shiftKey = param1.shiftKey;
      }
      
      public function click() : void
      {
         press();
         release();
      }
      
      public function disableEvent(param1:String) : void
      {
         disabledEvents[param1] = true;
      }
      
      public function set container(param1:Sprite) : void
      {
         _container = param1;
      }
      
      public function get lastEvent() : Event
      {
         return _lastEvent;
      }
      
      private function handleUpdate(param1:Event) : void
      {
         var _loc4_:InteractiveObject = null;
         var _loc5_:DisplayObject = null;
         var _loc9_:Boolean = false;
         if(!container)
         {
            return;
         }
         if(container.scrollRect)
         {
            PaperLogger.warning("The container that virtualMouse is trying to test against has a scrollRect defined, and may cause an issue with finding objects under a defined point.  Use MovieMaterial.rect to set a rectangle area instead");
         }
         var _loc2_:Point = new Point();
         _loc2_.x = container.x;
         _loc2_.y = container.y;
         container.x = container.y = 0;
         var _loc3_:Array = container.getObjectsUnderPoint(location);
         container.x = _loc2_.x;
         container.y = _loc2_.y;
         var _loc6_:int = int(_loc3_.length);
         while(_loc6_--)
         {
            _loc5_ = _loc3_[_loc6_];
            while(_loc5_)
            {
               if(ignoredInstances[_loc5_])
               {
                  _loc4_ = null;
                  break;
               }
               if(Boolean(_loc4_) && _loc5_ is SimpleButton)
               {
                  _loc4_ = null;
               }
               else if(Boolean(_loc4_) && !DisplayObjectContainer(_loc5_).mouseChildren)
               {
                  _loc4_ = null;
               }
               if(!_loc4_ && _loc5_ is InteractiveObject && InteractiveObject(_loc5_).mouseEnabled)
               {
                  _loc4_ = InteractiveObject(_loc5_);
               }
               _loc5_ = _loc5_.parent;
            }
            if(_loc4_)
            {
               break;
            }
         }
         if(!_loc4_)
         {
            _loc4_ = container;
         }
         var _loc7_:Point = target.globalToLocal(location);
         var _loc8_:Point = _loc4_.globalToLocal(location);
         if(lastLocation.x != location.x || lastLocation.y != location.y)
         {
            _loc9_ = false;
            if(stage)
            {
               _loc9_ = location.x >= 0 && location.y >= 0 && location.x <= stage.stageWidth && location.y <= stage.stageHeight;
            }
            if(!_loc9_ && lastWithinStage && !disabledEvents[Event.MOUSE_LEAVE])
            {
               _lastEvent = new eventEvent(Event.MOUSE_LEAVE,false,false);
               stage.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(_loc9_ && !disabledEvents[MouseEvent.MOUSE_MOVE])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_MOVE,true,false,_loc8_.x,_loc8_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               _loc4_.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            lastWithinStage = _loc9_;
         }
         if(_loc4_ != target)
         {
            if(!disabledEvents[MouseEvent.MOUSE_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc7_.x,_loc7_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.ROLL_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc7_.x,_loc7_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.MOUSE_OVER])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OVER,true,false,_loc8_.x,_loc8_.y,target,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               _loc4_.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.ROLL_OVER])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OVER,false,false,_loc8_.x,_loc8_.y,target,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               _loc4_.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
         }
         if(updateMouseDown)
         {
            if(_mouseIsDown)
            {
               if(!disabledEvents[MouseEvent.MOUSE_DOWN])
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_DOWN,true,false,_loc8_.x,_loc8_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  _loc4_.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               lastDownTarget = _loc4_;
               updateMouseDown = false;
            }
            else
            {
               if(!disabledEvents[MouseEvent.MOUSE_UP])
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_UP,true,false,_loc8_.x,_loc8_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  _loc4_.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               if(!disabledEvents[MouseEvent.CLICK] && _loc4_ == lastDownTarget)
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.CLICK,true,false,_loc8_.x,_loc8_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  _loc4_.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               lastDownTarget = null;
               updateMouseDown = false;
            }
         }
         if(isDoubleClickEvent && !disabledEvents[MouseEvent.DOUBLE_CLICK] && _loc4_.doubleClickEnabled)
         {
            _lastEvent = new mouseEventEvent(MouseEvent.DOUBLE_CLICK,true,false,_loc8_.x,_loc8_.y,_loc4_,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            _loc4_.dispatchEvent(_lastEvent);
            dispatchEvent(_lastEvent);
         }
         lastLocation = location.clone();
         lastMouseDown = _mouseIsDown;
         target = _loc4_;
      }
      
      public function getLocation() : Point
      {
         return location.clone();
      }
      
      public function lock() : void
      {
         isLocked = true;
      }
      
      public function get useNativeEvents() : Boolean
      {
         return _useNativeEvents;
      }
      
      public function setLocation(param1:*, param2:* = null) : void
      {
         var _loc3_:Point = null;
         if(param1 is Point)
         {
            _loc3_ = param1 as Point;
            location.x = _loc3_.x;
            location.y = _loc3_.y;
         }
         else
         {
            location.x = Number(param1);
            location.y = Number(param2);
         }
         if(!isLocked)
         {
            update();
         }
      }
      
      public function unignore(param1:DisplayObject) : void
      {
         if(param1 in ignoredInstances)
         {
            delete ignoredInstances[param1];
         }
      }
      
      public function doubleClick() : void
      {
         if(isLocked)
         {
            release();
         }
         else
         {
            click();
            press();
            isDoubleClickEvent = true;
            release();
            isDoubleClickEvent = false;
         }
      }
      
      public function update() : void
      {
         dispatchEvent(new Event(UPDATE,false,false));
      }
      
      public function unlock() : void
      {
         isLocked = false;
         update();
      }
      
      public function ignore(param1:DisplayObject) : void
      {
         ignoredInstances[param1] = true;
      }
      
      public function enableEvent(param1:String) : void
      {
         if(param1 in disabledEvents)
         {
            delete disabledEvents[param1];
         }
      }
      
      public function press() : void
      {
         updateMouseDown = true;
         _mouseIsDown = true;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function set useNativeEvents(param1:Boolean) : void
      {
         if(param1 == _useNativeEvents)
         {
            return;
         }
         _useNativeEvents = param1;
         if(_useNativeEvents)
         {
            eventEvent = VirtualMouseEvent;
            mouseEventEvent = VirtualMouseMouseEvent;
         }
         else
         {
            eventEvent = Event;
            mouseEventEvent = MouseEvent;
         }
      }
      
      public function set x(param1:Number) : void
      {
         location.x = param1;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function set y(param1:Number) : void
      {
         location.y = param1;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function get y() : Number
      {
         return location.y;
      }
      
      public function set stage(param1:Stage) : void
      {
         var _loc2_:Boolean = false;
         if(_stage)
         {
            _loc2_ = true;
            _stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
            _stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandler);
         }
         else
         {
            _loc2_ = false;
         }
         _stage = param1;
         if(_stage)
         {
            _stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
            _stage.addEventListener(KeyboardEvent.KEY_UP,keyHandler);
            target = _stage;
            if(!_loc2_)
            {
               update();
            }
         }
      }
      
      public function get stage() : Stage
      {
         return _stage;
      }
      
      public function get x() : Number
      {
         return location.x;
      }
   }
}

