package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d.events
{
   import flash.events.Event;
   import org.papervision3d.core.math.Number3D;
   
   public class UIController3DPlantEvent extends Event
   {
      
      public static const SEED_PLANTED:String = "SeedControllerEvent.SEED_PLANTED";
      
      public var seedPos:Number3D = new Number3D();
      
      public var plantType:String;
      
      public function UIController3DPlantEvent(param1:String, param2:Number3D, param3:String)
      {
         seedPos = param2;
         plantType = param3;
         super(param1);
      }
   }
}

