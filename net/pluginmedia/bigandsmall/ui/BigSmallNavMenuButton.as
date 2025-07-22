package net.pluginmedia.bigandsmall.ui
{
   public class BigSmallNavMenuButton extends ButtonMenu
   {
      
      public function BigSmallNavMenuButton()
      {
         super();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         visible = param1;
      }
   }
}

