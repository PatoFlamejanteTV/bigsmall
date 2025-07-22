package net.pluginmedia.bigandsmall.pages.garden.characters.small
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.SuperMovieClip;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class SmallGardenStateBase extends PointSprite implements ISmallGardenState
   {
      
      public static var STATE_EXPIRED:String = "SmallGardenStateBase.STATE_EXPIRED";
      
      protected var _vpl:ViewportLayer;
      
      protected var stateExpired:Boolean = false;
      
      protected var mat:SpriteParticleMaterial;
      
      protected var _isTalking:Boolean = false;
      
      protected var movie:SuperMovieClip;
      
      public function SmallGardenStateBase(param1:Number3D, param2:MovieClip, param3:Number = 1)
      {
         movie = new SuperMovieClip(param2);
         mat = new SpriteParticleMaterial(param2);
         super(mat,param3);
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         park();
      }
      
      public function mouthShapeToLabel(param1:String) : void
      {
         if(movie.subjectClip.mouth)
         {
            movie.subjectClip.mouth.gotoAndStop(param1);
         }
      }
      
      public function update() : void
      {
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _vpl;
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         _vpl = param1;
      }
      
      public function set isTalking(param1:Boolean) : void
      {
         _isTalking = param1;
      }
      
      public function get OUTRO_COMPLETE() : String
      {
         return "SmallGardenStateBase.OUTRO_COMPLETE";
      }
      
      public function park() : void
      {
         mouthShapeToLabel(DEFAULTMOUTHLABEL);
         stateExpired = false;
         movie.stop();
         this.visible = false;
         mat.removeSprite();
      }
      
      public function get isTalking() : Boolean
      {
         return _isTalking;
      }
      
      public function get DEFAULTMOUTHLABEL() : String
      {
         return "a";
      }
      
      protected function stateExpires() : void
      {
         stateExpired = true;
         dispatchEvent(new Event(STATE_EXPIRED));
      }
      
      public function activate() : void
      {
         stateExpired = false;
         this.visible = true;
         movie.play();
         update();
      }
      
      public function deactivate() : void
      {
         dispatchEvent(new Event(OUTRO_COMPLETE));
      }
   }
}

