package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.SegmentTransitionEvent;
   import net.pluginmedia.brain.core.animation.SuperMovieClip;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class DeadEndSegment extends AbstractSegment
   {
      
      protected var moleSprite:PointSprite;
      
      protected var anim:SuperMovieClip;
      
      protected var returnTimer:Timer;
      
      public function DeadEndSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:uint, param6:Boolean = false)
      {
         var _loc7_:MovieClip = param4.getRewardAnim(param5);
         _loc7_.addEventListener("doVox",handleDoVoxEvent);
         anim = new SuperMovieClip(_loc7_,true);
         super(param1,param2,param3,param4,1200,param6);
      }
      
      protected function handleExitEvent(param1:* = null) : void
      {
         dispatchEvent(new SegmentTransitionEvent(SegmentTransitionEvent.RETURN));
      }
      
      override public function park() : void
      {
         super.park();
         removeChild(moleSprite);
         SpriteParticleMaterial(moleSprite.material).removeSprite();
      }
      
      override public function prepare() : void
      {
         super.prepare();
         addChild(moleSprite);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         anim.removeEventListener(AnimationEvent.COMPLETE,handleExitEvent);
      }
      
      override public function activate() : void
      {
         super.activate();
         anim.addEventListener(AnimationEvent.COMPLETE,handleExitEvent);
         anim.playLabel("anim");
      }
      
      override protected function buildDisplay(param1:DAEFixed, param2:Boolean = false) : void
      {
         super.buildDisplay(param1,param2);
         moleSprite = new PointSprite(new SpriteParticleMaterial(anim));
         moleSprite.size = 0.6;
         moleSprite.z = segmentSize * 0.45;
         woodsLayer.addDisplayObject3D(moleSprite,true);
      }
      
      protected function handleDoVoxEvent(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
   }
}

