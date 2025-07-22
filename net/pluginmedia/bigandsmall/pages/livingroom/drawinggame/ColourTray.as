package net.pluginmedia.bigandsmall.pages.livingroom.drawinggame
{
   import org.papervision3d.materials.ColorMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class ColourTray extends Plane
   {
      
      public var red:int;
      
      public var green:int;
      
      public var blue:int;
      
      public var label:String;
      
      public var colour:int;
      
      public function ColourTray(param1:int, param2:String = "")
      {
         this.colour = param1;
         this.label = param2;
         var _loc3_:ColorMaterial = new ColorMaterial(param1,0,true);
         _loc3_.doubleSided = true;
         super(_loc3_,28,28,1,1);
         red = param1 >> 16;
         green = (param1 & 0xFF00) >> 8;
         blue = param1 & 0xFF;
         rotationX = 90;
      }
   }
}

