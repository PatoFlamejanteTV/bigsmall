package net.pluginmedia.bigandsmall.pages.garden.tree
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import gs.TweenMax;
   import gs.easing.Elastic;
   import gs.easing.Quad;
   import net.pluginmedia.brain.core.animation.SuperMovieClip;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class AppleParticle extends PointSprite
   {
      
      public static var PICKED_UP:String = "AppleParticle.PICKED_UP";
      
      private var dispScale:Number;
      
      public var hitbig:Boolean = false;
      
      public var gravity:Number = 3.5;
      
      private var anim:SuperMovieClip;
      
      public var startPos:Number3D = Number3D.ZERO;
      
      public var rest:Boolean = false;
      
      private var clip:MovieClip;
      
      private var _viewportLayer:ViewportLayer;
      
      public var velocity:Number3D = Number3D.ZERO;
      
      private var uid:int = 1;
      
      public var hasDispatchedImpactEvent:Boolean = false;
      
      public var rotationalVelocity:Number = 0;
      
      private var spriteMat:SpriteParticleMaterial = new SpriteParticleMaterial(anim);
      
      public var onground:Boolean = false;
      
      public var released:Boolean = false;
      
      public function AppleParticle(param1:int, param2:MovieClip, param3:Number = 0, param4:Number = 0, param5:Number = 0)
      {
         clip = param2 as MovieClip;
         clip.mouseChildren = false;
         anim = new SuperMovieClip(clip);
         dispScale = clip.scaleX;
         super(spriteMat,0.55);
         this.uid = param1;
         reset(true);
      }
      
      public function shake() : void
      {
         if(clip.currentLabel == "still")
         {
            anim.playLabel("shake",0,0,handleShakeFinished);
         }
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      public function reset(param1:Boolean = false) : void
      {
         if(param1 || x == startPos.x && y == startPos.y && z == startPos.z)
         {
            x = startPos.x;
            y = startPos.y;
            z = startPos.z;
            rotationalVelocity = 0;
            clip.rotation = 0;
            velocity.reset(0,0,0);
            clip.visible = true;
            clip.gotoAndStop(1);
            released = false;
            hitbig = false;
            rest = false;
            onground = false;
            hasDispatchedImpactEvent = false;
            showGlow(0);
         }
         else
         {
            TweenMax.to(clip,0.25,{
               "delay":uid * 0.1,
               "scaleX":0,
               "scaleY":0,
               "ease":Quad.easeIn,
               "onComplete":shrinkComplete,
               "overwrite":true
            });
         }
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         _viewportLayer = param1;
         _viewportLayer.addEventListener(MouseEvent.ROLL_OVER,handleRollover);
         _viewportLayer.addEventListener(MouseEvent.MOUSE_OUT,handleRollout);
         _viewportLayer.addEventListener(MouseEvent.CLICK,handleAppleClicked);
         param1.buttonMode = true;
      }
      
      private function handleRollover(param1:MouseEvent = null) : void
      {
         if(!released)
         {
            shake();
            showGlow(16777215);
            dispatchEvent(param1);
         }
      }
      
      public function incrementRotation(param1:Number) : void
      {
         clip.rotation += param1;
      }
      
      private function shrinkComplete() : void
      {
         reset(true);
         TweenMax.to(clip,0.75,{
            "delay":uid * 0.1,
            "scaleX":dispScale,
            "scaleY":dispScale,
            "ease":Elastic.easeOut,
            "overwrite":true
         });
      }
      
      private function hideGlow() : void
      {
         clip.filters = [];
      }
      
      private function handleRollout(param1:MouseEvent = null) : void
      {
         if(!released)
         {
            showGlow(0);
         }
      }
      
      private function showGlow(param1:uint = 0) : void
      {
         clip.filters = [getStandardGlowFilter(param1)];
      }
      
      private function handleShakeFinished() : void
      {
         clip.gotoAndStop(1);
      }
      
      private function handleAppleClicked(param1:MouseEvent = null) : void
      {
         if(!released)
         {
            released = true;
            hideGlow();
            dispatchEvent(param1);
         }
      }
      
      private function getStandardGlowFilter(param1:uint) : GlowFilter
      {
         return new GlowFilter(param1,1,24,24);
      }
      
      public function pickedUp() : void
      {
         clip.visible = false;
         dispatchEvent(new Event(PICKED_UP));
      }
   }
}

