package net.pluginmedia.bigandsmall.ui
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import gs.TweenLite;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class StateablePointSprite extends DisplayObject3D
   {
      
      public static var STATE_NULL:String = "StateablePointSprite.STATE_NULL";
      
      protected var states:Dictionary = new Dictionary();
      
      protected var pSprite:PointSprite;
      
      public var fadeTime:Number = 0.9;
      
      protected var hiddenStateStr:String;
      
      protected var currentClip:MovieClip;
      
      protected var nullClip:MovieClip = new MovieClip();
      
      protected var currentStateStr:String;
      
      protected var spriteParticleMat:SpriteParticleMaterial;
      
      public function StateablePointSprite()
      {
         super();
         currentClip = nullClip;
         spriteParticleMat = new SpriteParticleMaterial(nullClip);
         pSprite = new PointSprite(spriteParticleMat);
         pSprite.x = 0;
         pSprite.y = 0;
         pSprite.z = 0;
         registerState(STATE_NULL,nullClip,0,0,0,1);
         selectState(STATE_NULL);
         addChild(pSprite);
      }
      
      public function fadeIn(param1:Boolean = false) : void
      {
         var _loc2_:StateablePointSpriteState = null;
         if(param1)
         {
            for each(_loc2_ in states)
            {
               TweenLite.killTweensOf(_loc2_.movie);
               _loc2_.movie.visible = true;
               _loc2_.movie.alpha = 1;
            }
         }
         else
         {
            fadeToAlpha(1);
         }
      }
      
      public function hide() : void
      {
         pSprite.visible = false;
         spriteParticleMat.removeSprite();
      }
      
      public function registerState(param1:String, param2:MovieClip, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 1) : void
      {
         param2.stop();
         states[param1] = new StateablePointSpriteState(param2,param3,param4,param5,param6);
      }
      
      protected function fadeToAlpha(param1:Number) : void
      {
         var _loc2_:StateablePointSpriteState = null;
         for each(_loc2_ in states)
         {
            TweenLite.killTweensOf(_loc2_.movie);
            if(param1 != 0 && !_loc2_.movie.visible)
            {
               _loc2_.movie.visible = true;
            }
            TweenLite.to(_loc2_.movie,fadeTime,{
               "alpha":param1,
               "onComplete":movieFadeComplete,
               "onCompleteParams":[_loc2_.movie]
            });
         }
      }
      
      public function fadeOut(param1:Boolean = false) : void
      {
         var _loc2_:StateablePointSpriteState = null;
         if(param1)
         {
            for each(_loc2_ in states)
            {
               TweenLite.killTweensOf(_loc2_.movie);
               _loc2_.movie.visible = false;
               _loc2_.movie.alpha = 0;
            }
         }
         else
         {
            fadeToAlpha(0);
         }
      }
      
      public function setAlpha(param1:Number) : void
      {
         var _loc2_:StateablePointSpriteState = null;
         for each(_loc2_ in states)
         {
            if(param1 != 0 && !_loc2_.movie.visible)
            {
               _loc2_.movie.visible = true;
            }
            if(param1 == 0 && _loc2_.movie.visible)
            {
               _loc2_.movie.visible = false;
               spriteParticleMat.removeSprite();
            }
            _loc2_.movie.alpha = param1;
         }
      }
      
      protected function movieFadeComplete(param1:MovieClip) : void
      {
         if(param1.alpha == 0)
         {
            param1.visible = false;
         }
      }
      
      public function selectState(param1:String) : void
      {
         var _loc2_:StateablePointSpriteState = states[param1];
         if(!_loc2_)
         {
            return;
         }
         currentStateStr = param1;
         subsumeState(_loc2_);
      }
      
      public function show() : void
      {
         pSprite.visible = true;
      }
      
      public function subsumeState(param1:StateablePointSpriteState) : void
      {
         currentClip = param1.movie;
         spriteParticleMat.movie = currentClip;
         x = param1.x;
         y = param1.y;
         z = param1.z;
         pSprite.size = param1.size;
      }
   }
}

