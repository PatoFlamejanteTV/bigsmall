package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.pages.bathroom.Bubble;
   
   public class BubbleEvent extends Event
   {
      
      public static var BIRTH:String = "BubbleEvent.BIRTH";
      
      public static var DEATH:String = "BubbleEvent.DEATH";
      
      public static var CLONEBIRTH:String = "BubbleEvent.CLONEBIRTH";
      
      public var bubble:Bubble;
      
      public function BubbleEvent(param1:String, param2:Bubble)
      {
         bubble = param2;
         super(param1);
      }
   }
}

