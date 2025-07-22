package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d
{
   import flash.display.DisplayObject;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class Shadow3D extends PointSprite
   {
      
      private var pSpriteMat:SpriteParticleMaterial;
      
      public function Shadow3D(param1:DisplayObject, param2:Number = 0.7)
      {
         pSpriteMat = new SpriteParticleMaterial(param1);
         super(pSpriteMat,param2);
      }
      
      public function get isHidden() : Boolean
      {
         return !this.visible;
      }
      
      public function showSelf() : void
      {
         this.visible = true;
      }
      
      public function hideSelf() : void
      {
         this.visible = false;
         pSpriteMat.removeSprite();
      }
   }
}

