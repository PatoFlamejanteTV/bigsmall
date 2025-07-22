package net.pluginmedia.bigandsmall.pages.bathroom.incidentals
{
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   
   public class ToiletFishPointSprite extends Incidental
   {
      
      private var mat:MovieParticleMaterial;
      
      private var currentAnim:AnimationOld;
      
      private var bigClip:MovieClip;
      
      private var bigAnim:AnimationOld;
      
      public var pointSprite:PointSprite;
      
      private var smallClip:MovieClip;
      
      private var smallAnim:AnimationOld;
      
      private var overSoundRef:String;
      
      public function ToiletFishPointSprite(param1:String, param2:MovieClip, param3:MovieClip, param4:String)
      {
         super(param1);
         overSoundRef = param4;
         mat = new MovieParticleMaterial(param2,true,false);
         mat.actualSize = true;
         smallClip = param2;
         smallAnim = new AnimationOld(smallClip);
         bigClip = param3;
         bigAnim = new AnimationOld(bigClip);
         currentAnim = smallAnim;
         var _loc5_:Number = 190 * 0.6;
         var _loc6_:Number = 170 * 0.6;
         pointSprite = new PointSprite(mat);
         pointSprite.visible = false;
         addChild(pointSprite,"ToiletFishPointSprite_PSprite");
      }
      
      private function removeAnimListener() : void
      {
         currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,currentAnimComplete);
      }
      
      private function currentAnimComplete(param1:AnimationOldEvent) : void
      {
         stop();
      }
      
      private function addAnimListener() : void
      {
         currentAnim.addEventListener(AnimationOldEvent.COMPLETE,currentAnimComplete);
      }
      
      override public function stop() : void
      {
         super.stop();
         pointSprite.visible = false;
         mat.animated = false;
         if(playing)
         {
            removeAnimListener();
         }
         currentAnim.gotoAndStop(1);
      }
      
      override public function handleClick() : void
      {
         if(!playing)
         {
            play();
         }
      }
      
      override public function setCharacter(param1:String) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         super.setCharacter(param1);
         stop();
         if(param1 == CharacterDefinitions.BIG)
         {
            _loc2_ = new Rectangle(-120,-122,190,170);
            mat.movie = bigClip;
            currentAnim = bigAnim;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            _loc3_ = new Rectangle(-120,-42,190,170);
            mat.movie = smallClip;
            currentAnim = smallAnim;
         }
      }
      
      override public function play() : void
      {
         super.play();
         mat.animated = true;
         pointSprite.visible = true;
         addAnimListener();
         currentAnim.playOutLabel("anim");
      }
      
      override public function rollover() : void
      {
         super.rollover();
         SoundManagerOld.playSound(overSoundRef);
      }
   }
}

