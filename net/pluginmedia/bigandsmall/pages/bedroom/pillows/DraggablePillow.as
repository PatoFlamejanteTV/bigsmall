package net.pluginmedia.bigandsmall.pages.bedroom.pillows
{
   import net.pluginmedia.brain.ui.Draggable;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class DraggablePillow extends Draggable
   {
      
      public var pillowDragYMax:Number = -100;
      
      public var pillowDragXMax:Number = -100;
      
      public var pillowDragXMin:Number = 100;
      
      public var pillowDragYMin:Number = 100;
      
      private var defaultPillowLocation:Number3D;
      
      private var do3d:DisplayObject3D;
      
      public function DraggablePillow(param1:Class, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         super(param1,param2,param3,param4);
         userData.alpha = 0;
      }
      
      override public function setOverState(param1:Boolean) : void
      {
      }
      
      public function setPillowObject(param1:DisplayObject3D) : void
      {
         do3d = param1;
      }
      
      override public function onPut() : void
      {
         super.onPut();
         userData.visible = false;
      }
      
      public function reset() : void
      {
         userData.visible = true;
      }
      
      public function storeDefaultPillowLocation() : void
      {
         defaultPillowLocation = do3d.position;
      }
      
      override public function onPickUp() : void
      {
         super.onPickUp();
         userData.x = 0;
         userData.y = 0;
         userData.visible = true;
      }
      
      public function resetPillowToDefault() : void
      {
         do3d.copyPosition(defaultPillowLocation);
      }
   }
}

