package net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller
{
   import flash.events.Event;
   
   public class FruitAppearEvent extends Event
   {
      
      public static const FRUIT_APPEAR:String = "FruitAppear";
      
      public var plantSprite:PlantSprite3D;
      
      public function FruitAppearEvent(param1:PlantSprite3D)
      {
         plantSprite = param1;
         super(FRUIT_APPEAR);
      }
      
      override public function clone() : Event
      {
         return new FruitAppearEvent(plantSprite);
      }
   }
}

