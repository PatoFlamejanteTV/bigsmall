package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d
{
   import flash.display.Sprite;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   
   public class DragSeed3D extends PointSprite
   {
      
      public var fallVel:Number = 0;
      
      public var plantType:String;
      
      public var fallAcc:Number = 7.5;
      
      public var pSpriteMat:SpriteParticleMaterial;
      
      public var fallVect:Number3D = new Number3D();
      
      public function DragSeed3D(param1:PointSprite, param2:Sprite, param3:String, param4:Number = 0.7)
      {
         pSpriteMat = new SpriteParticleMaterial(param2);
         plantType = param3;
         super(pSpriteMat,param4);
      }
      
      public function dropped(param1:Number3D) : void
      {
         fallVect = Number3D.sub(this.position,param1);
         fallVect.normalize();
      }
      
      public function endFall() : void
      {
         fallVel = 0;
         removeSelf();
      }
      
      public function removeSelf() : void
      {
         this.visible = false;
         pSpriteMat.removeSprite();
      }
      
      public function updateFall() : void
      {
         fallVel += fallAcc;
         this.x -= fallVect.x * fallVel;
         this.y -= fallVect.y * fallVel;
         this.z -= fallVect.z * fallVel;
      }
   }
}

