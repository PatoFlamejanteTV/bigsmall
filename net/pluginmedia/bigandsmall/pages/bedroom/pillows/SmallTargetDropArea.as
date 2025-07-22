package net.pluginmedia.bigandsmall.pages.bedroom.pillows
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class SmallTargetDropArea extends Sprite
   {
      
      public function SmallTargetDropArea()
      {
         super();
         var _loc1_:Graphics = this.graphics;
         _loc1_.beginFill(0,0.4);
         _loc1_.drawEllipse(-40,-160,80,170);
         _loc1_.endFill();
      }
   }
}

