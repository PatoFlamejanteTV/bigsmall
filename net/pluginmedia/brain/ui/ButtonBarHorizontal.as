package net.pluginmedia.brain.ui
{
   import net.pluginmedia.brain.core.Button;
   import net.pluginmedia.brain.core.ButtonContainer;
   
   public class ButtonBarHorizontal extends ButtonContainer
   {
      
      private var placeX:Number;
      
      public var padding:Number;
      
      private var currentXPosition:Number;
      
      private var placeY:Number;
      
      public function ButtonBarHorizontal()
      {
         super();
         currentXPosition = 0;
         padding = 5;
         cacheAsBitmap = true;
      }
      
      override public function addButton(param1:Button) : Button
      {
         super.addButton(param1);
         param1.x = currentXPosition;
         currentXPosition += param1.width + padding;
         return param1;
      }
   }
}

