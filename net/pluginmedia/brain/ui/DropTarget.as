package net.pluginmedia.brain.ui
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import net.pluginmedia.brain.core.interfaces.IDropTarget;
   
   public class DropTarget extends Sprite implements IDropTarget
   {
      
      protected var _enabled:Boolean = true;
      
      protected var _value:String = "";
      
      protected var userData:Sprite;
      
      protected var _occupant:Draggable = null;
      
      public function DropTarget(param1:Class, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         super();
         x = param2;
         y = param3;
         _value = param4;
         userData = new param1();
         addChild(userData);
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      public function get value() : String
      {
         return _value;
      }
      
      public function setOverState(param1:Boolean) : void
      {
         if(param1)
         {
            filters = [new GlowFilter(255)];
         }
         else
         {
            filters = [];
         }
      }
   }
}

