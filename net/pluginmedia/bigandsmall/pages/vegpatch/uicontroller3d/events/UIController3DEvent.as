package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events
{
   import flash.events.Event;
   import org.papervision3d.core.math.Number3D;
   
   public class UIController3DEvent extends Event
   {
      
      public static const HARVEST:String = "SeedControllerEvent.HARVEST";
      
      public static const WATER_DEPOSITED:String = "SeedControllerEvent.WATER_DEPOSITED";
      
      public static const WATERCAN_DROPPED:String = "SeedControllerEvent.WATERCAN_DROPPED";
      
      public var uiPos:Number3D = new Number3D();
      
      public function UIController3DEvent(param1:String, param2:Number3D)
      {
         uiPos = param2;
         super(param1);
      }
   }
}

