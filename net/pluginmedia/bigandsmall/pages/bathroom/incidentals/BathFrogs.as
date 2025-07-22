package net.pluginmedia.bigandsmall.pages.bathroom.incidentals
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   
   public class BathFrogs extends Incidental
   {
      
      private var bigClips:Array;
      
      private var soundResponseDict:Dictionary = new Dictionary();
      
      private var showerCurtain:ShowerCurtain;
      
      private var frogSprite:PointSprite;
      
      private var render:Boolean = false;
      
      private var currentAnimSet:Array;
      
      private var nullAnim:Sprite = new Sprite();
      
      private var frogMat:MovieParticleMaterial;
      
      private var bigAnims:Array = [];
      
      private var smallClips:Array;
      
      private var currentAnim:AnimationOld;
      
      private var overSoundRef:String;
      
      private var smallAnims:Array = [];
      
      private var currentFrog:int = -1;
      
      public function BathFrogs(param1:String, param2:ShowerCurtain, param3:String)
      {
         super(param1);
         overSoundRef = param3;
         showerCurtain = param2;
         showerCurtain.curtain.visible = false;
         showerCurtain.lowPolyCurtain.visible = true;
         frogMat = new MovieParticleMaterial(nullAnim);
         frogMat.actualSize = true;
         frogSprite = new PointSprite(frogMat,0.65);
         addChild(frogSprite);
         setCharacter(currentPOV);
      }
      
      public function get doRender() : Boolean
      {
         return render;
      }
      
      override public function stop() : void
      {
         super.stop();
         showerCurtain.close();
         frogMat.animated = false;
      }
      
      private function incrementFrog() : void
      {
         var _loc1_:int = 0;
         if(currentAnim !== null)
         {
            if(currentAnim.isPlaying)
            {
               currentAnim.gotoAndStop(1);
            }
         }
         if(currentAnimSet.length == 1)
         {
            currentFrog = 0;
         }
         else
         {
            _loc1_ = Math.random() * currentAnimSet.length;
            _loc1_ = (currentFrog + 1) % currentAnimSet.length;
            currentFrog = _loc1_;
         }
         currentAnim = currentAnimSet[currentFrog];
         frogMat.movie = currentAnim;
         frogSprite.visible = true;
      }
      
      public function registerBigAnim(param1:MovieClip, param2:String = null) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:AnimationOld = new AnimationOld(param1);
         bigAnims.push(_loc3_);
         _loc3_.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         if(param2)
         {
            soundResponseDict[_loc3_] = param2;
         }
      }
      
      override public function rollover() : void
      {
         super.rollover();
         if(this.playing)
         {
            return;
         }
         showerCurtain.rollover();
         SoundManagerOld.playSound(overSoundRef);
      }
      
      private function endAnim() : void
      {
         stop();
         var _loc1_:String = soundResponseDict[currentAnim];
         if(_loc1_)
         {
            SoundManagerOld.playSound(_loc1_);
         }
         dispatchEvent(new Event("END_ANIM"));
      }
      
      public function registerSmallAnim(param1:MovieClip, param2:String = null) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:AnimationOld = new AnimationOld(param1);
         smallAnims.push(_loc3_);
         _loc3_.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         if(param2)
         {
            soundResponseDict[_loc3_] = param2;
         }
      }
      
      public function snapShut() : void
      {
         stop();
         showerCurtain.snapShut();
         update();
         frogSprite.visible = false;
         if(currentAnim)
         {
            currentAnim.stop();
         }
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
         showerCurtain.update(param1);
         render = playing || showerCurtain.active;
         if(!(showerCurtain.active || playing))
         {
            frogSprite.visible = false;
            if(currentAnim)
            {
               currentAnim.stop();
            }
         }
      }
      
      override public function setCharacter(param1:String) : void
      {
         super.setCharacter(param1);
         if(currentPOV == CharacterDefinitions.SMALL)
         {
            currentAnimSet = smallAnims;
         }
         else
         {
            currentAnimSet = bigAnims;
         }
      }
      
      override public function rollout() : void
      {
         showerCurtain.rollout();
      }
      
      private function handleAnimComplete(param1:Event = null) : void
      {
         endAnim();
      }
      
      override public function play() : void
      {
         super.play();
         incrementFrog();
         currentAnim.playOutLabel("frogs");
         showerCurtain.open();
         dispatchEvent(new Event("BEGIN_ANIM"));
      }
   }
}

