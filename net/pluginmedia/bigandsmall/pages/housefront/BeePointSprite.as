package net.pluginmedia.bigandsmall.pages.housefront
{
   import flash.display.MovieClip;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BeePointSprite extends PointSprite
   {
      
      private var flipped:Boolean = false;
      
      private var ray:Number3D = new Number3D();
      
      private var pointSpriteMat:SpriteParticleMaterial;
      
      private var clip:MovieClip;
      
      private var anim:AnimationOld = new AnimationOld(clip);
      
      private var viewportLayer:ViewportLayer;
      
      private var basicView:BasicView;
      
      private var worldOffs:Number3D = new Number3D();
      
      private var maxVel:Number = 60;
      
      public var planeObj:Plane3D;
      
      private var vel:Number3D = new Number3D();
      
      public function BeePointSprite(param1:BasicView, param2:MovieClip, param3:Plane3D, param4:Number3D, param5:Number = 1)
      {
         basicView = param1;
         worldOffs = param4;
         clip = param2;
         pointSpriteMat = new SpriteParticleMaterial(anim);
         pointSpriteMat.smooth = true;
         anim.mouseEnabled = false;
         super(pointSpriteMat,param5);
         planeObj = param3;
      }
      
      private function getMPlaneCoords() : Number3D
      {
         ray = basicView.camera.unproject(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY);
         ray = Number3D.add(ray,basicView.camera.position);
         var _loc1_:Number3D = planeObj.getIntersectionLineNumbers(basicView.camera.position,ray);
         _loc1_.minusEq(worldOffs);
         return _loc1_;
      }
      
      public function updateAttraction() : void
      {
         clip.play();
         var _loc1_:Number3D = getMPlaneCoords();
         _loc1_.multiplyEq(Math.random() * 0.35);
         var _loc2_:Number = (_loc1_.x - this.x) * 0.1;
         var _loc3_:Number = (_loc1_.y - this.y) * 0.1;
         var _loc4_:Number = (_loc1_.z - this.z) * 0.1;
         if(_loc1_.x > 0 && !flipped || _loc1_.x < 0 && flipped)
         {
            clip.scaleX *= -1;
            flipped = !flipped;
         }
         vel.x += _loc2_;
         vel.y += _loc3_;
         vel.z += _loc4_;
         vel.x = Math.min(vel.x,maxVel);
         vel.x = Math.max(vel.x,-maxVel);
         vel.y = Math.min(vel.y,maxVel);
         vel.y = Math.max(vel.y,-maxVel);
         vel.z = Math.min(vel.z,maxVel);
         vel.z = Math.max(vel.z,-maxVel);
         this.x += vel.x;
         this.y += vel.y;
         this.z += vel.z;
         vel.multiplyEq(0.95);
      }
   }
}

