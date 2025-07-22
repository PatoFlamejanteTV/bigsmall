package net.pluginmedia.bigandsmall.pages
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class CriticalErrorPage extends Sprite
   {
      
      private var errorPane:ErrorPane;
      
      private var errorTextField:TextField;
      
      public function CriticalErrorPage()
      {
         super();
         errorPane = new ErrorPane();
         addChild(errorPane);
         this.filters = [new DropShadowFilter(5,45,0,0.3,1,1)];
      }
      
      public function set message(param1:String) : void
      {
         var msg:String = param1;
         try
         {
            TextField(errorPane.errorTextField).htmlText = msg;
         }
         catch(e:Error)
         {
            BrainLogger.error("CriticalErrorPage :: set message :: could not access output text field");
         }
      }
   }
}

