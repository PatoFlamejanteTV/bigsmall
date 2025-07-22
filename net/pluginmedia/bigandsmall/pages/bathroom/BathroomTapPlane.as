package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class BathroomTapPlane extends Plane
   {
      
      private var bigMat:MovieMaterial;
      
      private var smallMat:MovieMaterial;
      
      private var currentPOV:String;
      
      public function BathroomTapPlane(param1:DisplayObject, param2:DisplayObject, param3:Rectangle = null, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0)
      {
         smallMat = new MovieMaterial(param1,true,false,false,param3);
         bigMat = new MovieMaterial(param2,true,false,false,param3);
         super(bigMat,param4,param5,param6,param7);
      }
      
      public function setCharacter(param1:String) : void
      {
         if(param1 == currentPOV)
         {
            return;
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            this.material = bigMat;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            this.material = smallMat;
         }
         currentPOV = param1;
      }
   }
}

