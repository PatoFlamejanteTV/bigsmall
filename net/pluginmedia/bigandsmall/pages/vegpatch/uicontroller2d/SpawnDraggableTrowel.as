package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   
   public class SpawnDraggableTrowel extends SpawnDraggable
   {
      
      public static var DIG_ACTION:String = "SpawnDraggableTrowel.DIG_ACTION";
      
      public function SpawnDraggableTrowel(param1:DraggableSpawner, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function onDrop() : void
      {
         this.visible = true;
         super.onDrop();
      }
      
      override public function get canDrop() : Boolean
      {
         if(this.y > 350)
         {
            return true;
         }
         dispatchEvent(new Event(DIG_ACTION));
         return false;
      }
      
      override protected function handleMouseOver(param1:MouseEvent) : void
      {
      }
      
      public function doDigAnim() : void
      {
         MovieClip(userData).gotoAndPlay("digging");
      }
   }
}

