package net.pluginmedia.bigandsmall.pages.livingroom.characters
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import gs.TweenMax;
   import gs.easing.Linear;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.interfaces.ICharacter;
   import net.pluginmedia.bigandsmall.pages.livingroom.LipSyncData;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   
   public class SmallRunLivingRoom extends CompanionCharacter implements ICharacter
   {
      
      public static const PARKED:int = -1;
      
      public static const ANIM_IN:int = 0;
      
      public static const ANIM_PRE_IDLE:int = 1;
      
      public static const IDLE:int = 2;
      
      public static const ANIM_PRE_OUT:int = 3;
      
      public static const ANIM_OUT:int = 4;
      
      public static const ANIM_VOX:int = 5;
      
      private var animIdle:AnimationOld;
      
      private var animIn:AnimationOld;
      
      private var state:int = -1;
      
      private var presenceTimer:Timer = new Timer(8000);
      
      private var animPreOut:AnimationOld;
      
      public var idlePosition:Number3D = new Number3D(0,0,0);
      
      public var enterPosition:Number3D = new Number3D(0,0,0);
      
      private var animVoxStates:Dictionary = new Dictionary();
      
      private var sprite:PointSprite;
      
      private var animPreIdle:AnimationOld;
      
      public var isTalkable:Boolean = false;
      
      private var mat:SpriteParticleMaterial;
      
      public var exitPosition:Number3D = new Number3D(0,0,0);
      
      public var queuedVox:String = null;
      
      private var animOut:AnimationOld;
      
      public function SmallRunLivingRoom(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:MovieClip)
      {
         super();
         presenceTimer.addEventListener(TimerEvent.TIMER,handlePresenceTimer);
         animIn = new AnimationOld(param1);
         animPreIdle = new AnimationOld(param2);
         animPreIdle.addEventListener(AnimationOldEvent.COMPLETE,seqPreIdleDone);
         animIdle = new AnimationOld(param3);
         animPreOut = new AnimationOld(param4);
         animPreOut.addEventListener(AnimationOldEvent.COMPLETE,seqPreOutDone);
         animOut = new AnimationOld(param5);
         mat = new SpriteParticleMaterial(animIn);
         sprite = new PointSprite(mat);
         sprite.visible = false;
         addChild(sprite);
      }
      
      private function seqRunInFinished() : void
      {
         state = ANIM_PRE_IDLE;
         setSpriteAnim(animPreIdle);
         stopAnimating(animIn);
         animPreIdle.playToFrame(animPreIdle.totalFrames);
         BrainLogger.out("-> SmallLivingRoom -> seqRunInFinished -> do preIdle... ");
      }
      
      override public function prepare() : void
      {
      }
      
      public function toVoxState() : void
      {
         state = ANIM_VOX;
      }
      
      private function seqPreOutDone(param1:Event = null) : void
      {
         state = ANIM_OUT;
         setSpriteAnim(animOut);
         stopAnimating(animPreOut);
         animOut.play();
         TweenMax.to(this,1.5,{
            "x":exitPosition.x,
            "y":exitPosition.y,
            "z":exitPosition.z,
            "onComplete":seqExitFinished,
            "onUpdate":handleAnimOnProgress,
            "ease":Linear.easeNone
         });
      }
      
      override public function showSyncedMovie(param1:MovieClip) : void
      {
         if(param1 !== null)
         {
            param1.gotoAndStop(1);
            mat.movie = param1;
         }
         else
         {
            BrainLogger.out("SmallRunLivingRoom :: WARNING :: setBodyRef cannot source reference :",param1);
         }
      }
      
      private function seqExitFinished() : void
      {
         state = PARKED;
         stopAnimating(animOut);
         sprite.visible = false;
         mat.removeSprite();
      }
      
      override public function talkingFinished() : void
      {
         super.talkingFinished();
         state = IDLE;
         seqPreIdleDone();
         presenceTimer.reset();
      }
      
      private function handlePresenceTimer(param1:TimerEvent) : void
      {
         if(state == PARKED)
         {
            summon();
         }
         else if(state == IDLE)
         {
            unSummon();
         }
      }
      
      override public function playVoiceOver(param1:String, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         var _loc4_:LipSyncData = null;
         BrainLogger.out("SmallRunLivingRoom :: ATTEMPT VOX " + voiceOverData[param1],param1);
         if(playedLabels.indexOf(param1) !== -1 && !param3)
         {
            BrainLogger.out("SmallRunLivingRoom :: VOX DENIED [REPEAT REQUEST] ");
            return false;
         }
         if(state == IDLE)
         {
            _loc4_ = voiceOverData[param1];
            if(_loc4_ === null)
            {
               BrainLogger.out("SmallLivingRoom :: playVoiceOver :: Could not source lip sync data opbject for requested label; " + param1);
               return false;
            }
            if(_loc4_.playCount < _loc4_.maxPlayCount || _loc4_.maxPlayCount == 0 || param3)
            {
               if(SoundManagerOld.playSyncedSound(_loc4_.soundRef,_loc4_.movie,1,talkingFinished,25))
               {
                  isTalking = true;
                  state = ANIM_VOX;
                  showSyncedMovie(_loc4_.movie);
                  if(_loc4_.holdRepeat)
                  {
                     playedLabels.push(param1);
                  }
                  if(_loc4_.maxPlayCount > 0)
                  {
                     ++_loc4_.playCount;
                  }
                  presenceTimer.reset();
               }
            }
            return true;
         }
         if(state == PARKED)
         {
            summon(param1);
         }
         else if(param2)
         {
            queuedVox = param1;
         }
         return false;
      }
      
      public function unSummon() : void
      {
         state = ANIM_PRE_OUT;
         this.x = idlePosition.x;
         this.y = idlePosition.y;
         this.z = idlePosition.z;
         setSpriteAnim(animPreOut);
         animPreOut.playToFrame(animPreOut.totalFrames);
         isTalkable = false;
      }
      
      private function seqPreIdleDone(param1:Event = null) : void
      {
         state = IDLE;
         setSpriteAnim(animIdle);
         stopAnimating(animPreIdle);
         animIdle.play();
         isTalkable = true;
         if(queuedVox !== null)
         {
            playVoiceOver(queuedVox);
            queuedVox = null;
         }
      }
      
      public function toIdleState() : void
      {
         mat.movie = animIdle;
         state = IDLE;
      }
      
      private function handleAnimOnProgress() : void
      {
         dispatchEvent(new Event("TweenProgress"));
      }
      
      public function talkerBodyProgress(param1:Number) : void
      {
         var _loc2_:MovieClip = mat.movie as MovieClip;
         var _loc3_:int = param1 / 1000 * _loc2_.stage.frameRate;
         _loc2_.gotoAndStop(_loc3_);
      }
      
      override public function park() : void
      {
         super.park();
         sprite.visible = false;
         mat.removeSprite();
      }
      
      public function summon(param1:String = null) : void
      {
         if(param1 !== null)
         {
            queuedVox = param1;
         }
         state = ANIM_IN;
         sprite.visible = true;
         this.x = enterPosition.x;
         this.y = enterPosition.y;
         this.z = enterPosition.z;
         setSpriteAnim(animIn);
         animIn.play();
         TweenMax.to(this,1.5,{
            "x":idlePosition.x,
            "y":idlePosition.y,
            "z":idlePosition.z,
            "onComplete":seqRunInFinished,
            "onUpdate":handleAnimOnProgress,
            "ease":Linear.easeNone
         });
      }
      
      override public function activate() : void
      {
         super.activate();
         summon();
         presenceTimer.start();
         sprite.visible = true;
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         seqPreOutDone();
         presenceTimer.reset();
      }
      
      private function setSpriteAnim(param1:AnimationOld) : void
      {
         param1.gotoAndStop(1);
         mat.movie = param1;
      }
      
      private function stopAnimating(param1:AnimationOld) : void
      {
         param1.gotoAndStop(param1.totalFrames);
      }
   }
}

