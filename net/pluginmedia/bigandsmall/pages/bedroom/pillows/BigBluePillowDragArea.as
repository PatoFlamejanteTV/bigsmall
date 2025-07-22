package net.pluginmedia.bigandsmall.pages.bedroom.pillows
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class BigBluePillowDragArea extends Sprite
   {
      
      public function BigBluePillowDragArea()
      {
         super();
         var _loc1_:Graphics = this.graphics;
         _loc1_.beginFill(0,0.4);
         _loc1_.drawCircle(0,0,65);
         _loc1_.endFill();
      }
   }
}

