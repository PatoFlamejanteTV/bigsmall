package net.pluginmedia.bigandsmall.pages.garden.parralax
{
   import flash.display.DisplayObject;
   import net.pluginmedia.pv3d.PointSprite;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class GardenParallax extends DisplayObject3D
   {
      
      private var sky:PointSprite;
      
      private var hillMid:PointSprite;
      
      private var hillFront:PointSprite;
      
      private var hillBack:PointSprite;
      
      public function GardenParallax(param1:DisplayObject, param2:DisplayObject, param3:DisplayObject, param4:DisplayObject)
      {
         super();
         sky = new PointSprite(new MovieParticleMaterial(param1,false,false),17);
         hillFront = new PointSprite(new MovieParticleMaterial(param2,true,false),5.75);
         sky.y = -500;
         sky.z = 7000;
         sky.x = 150;
         hillFront.z = -5000;
         hillFront.x = -200;
         hillFront.y = 2200;
         addChild(sky,"sky");
         addChild(hillFront,"hillFront");
      }
   }
}

