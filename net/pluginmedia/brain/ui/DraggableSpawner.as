package net.pluginmedia.brain.ui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DraggableSpawner extends Sprite
   {
      
      public var value:String = "";
      
      public var spawnDataClass:Class;
      
      protected var _isEnabled:Boolean = false;
      
      protected var userDataInst:MovieClip;
      
      protected var snapLoc:Point = new Point(0,0);
      
      public var overStateFilters:Array = [];
      
      public function DraggableSpawner(param1:Class, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         super();
         x = param3;
         y = param4;
         value = param5;
         spawnDataClass = param2;
         userDataInst = new param1();
         addChild(userDataInst);
         mouseChildren = false;
         setEnabledState(true);
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         setOverState(true);
      }
      
      public function onSpawn() : void
      {
         if(userDataInst !== null)
         {
            userDataInst.gotoAndPlay(1);
         }
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         setOverState(false);
      }
      
      protected function removeEventListeners() : void
      {
         this.buttonMode = false;
         if(hasEventListener(MouseEvent.MOUSE_OVER))
         {
            removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(hasEventListener(MouseEvent.MOUSE_OUT))
         {
            removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         }
      }
      
      public function setOverState(param1:Boolean) : void
      {
         if(param1)
         {
            filters = overStateFilters;
         }
         else
         {
            filters = [];
         }
      }
      
      public function get canSpawn() : Boolean
      {
         return false;
      }
      
      protected function addEventListeners() : void
      {
         this.buttonMode = true;
         if(!hasEventListener(MouseEvent.MOUSE_OVER))
         {
            addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(!hasEventListener(MouseEvent.MOUSE_OUT))
         {
            addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
         }
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
      
      public function get isEnabled() : Boolean
      {
         return _isEnabled;
      }
      
      public function spawnDraggable(param1:Number, param2:Number) : SpawnDraggable
      {
         return null;
      }
   }
}

