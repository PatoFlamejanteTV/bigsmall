package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.events.MouseEvent;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   import net.pluginmedia.pv3d.PointSprite;
   
   public class SpawnDraggableSeed extends SpawnDraggable
   {
      
      public var pointSprite:PointSprite;
      
      public var plantType:String;
      
      public function SpawnDraggableSeed(param1:DraggableSpawner, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function handleMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
      }
   }
}

