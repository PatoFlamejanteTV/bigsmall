package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.pluginmedia.brain.core.animation.UIAnimation;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   
   public class SpawnDraggableWateringCan extends SpawnDraggable
   {
      
      public var isWatering:Boolean = false;
      
      private var userDataUIAnim:UIAnimation;
      
      public function SpawnDraggableWateringCan(param1:DraggableSpawner, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         super(param1,param2,param3,param4,param5);
         removeChild(userData);
         userDataUIAnim = new UIAnimation(userData as MovieClip);
         addChild(userDataUIAnim);
      }
      
      override public function get canDrop() : Boolean
      {
         if(this.y > 350)
         {
            return true;
         }
         return false;
      }
      
      public function endWatering(param1:Boolean = false) : void
      {
         isWatering = false;
         if(!param1)
         {
            userDataUIAnim.stepLabel("watering",0,true);
         }
         else
         {
            userDataUIAnim.gotoAndStop(1);
         }
      }
      
      override protected function handleMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
      }
      
      public function beginWatering() : void
      {
         isWatering = true;
         userDataUIAnim.stepLabel("watering",0,false);
      }
      
      override public function onDrop() : void
      {
         this.visible = true;
         super.onDrop();
      }
   }
}

