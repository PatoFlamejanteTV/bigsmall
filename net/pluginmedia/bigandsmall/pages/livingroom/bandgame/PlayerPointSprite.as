package net.pluginmedia.bigandsmall.pages.livingroom.bandgame
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class PlayerPointSprite extends PointSprite
   {
      
      public var isAnimating:Boolean = false;
      
      public var currentState:MovieClip;
      
      public var frameStep:Number = 1;
      
      protected var fps:Number = 25;
      
      protected var charMat:SpriteParticleMaterial;
      
      protected var fixedFrameTotal:Number;
      
      public var isTalking:Boolean;
      
      protected var sampleLength:Number = 19.2;
      
      protected var animStates:Dictionary = new Dictionary();
      
      public var nullAnim:MovieClip;
      
      public var lipSyncAnim:PlayerLipSyncAnim;
      
      public function PlayerPointSprite(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:MovieClip = null)
      {
         fixedFrameTotal = Math.round(sampleLength * fps);
         var _loc6_:MovieClip = new MovieClip();
         charMat = new SpriteParticleMaterial(_loc6_);
         super(charMat);
         x = param1;
         y = param2;
         z = param3;
         this.size = param4;
         lipSyncAnim = new PlayerLipSyncAnim();
      }
      
      public function begin() : void
      {
         resetAnims();
         currentState = null;
         isTalking = false;
         isAnimating = true;
      }
      
      public function resetAnims() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in animStates)
         {
            _loc1_.gotoAndStop(1);
         }
      }
      
      public function playLipSyncAnim(param1:String) : Boolean
      {
         if(Boolean(currentState) && currentState != nullAnim)
         {
            return false;
         }
         charMat.movie = lipSyncAnim;
         lipSyncAnim.playAnim(param1);
         isTalking = true;
         lipSyncAnim.addEventListener(AnimationOldEvent.COMPLETE,handleLipSyncComplete);
         return true;
      }
      
      public function pushAnimState(param1:String, param2:MovieClip) : void
      {
         animStates[param1] = param2 as MovieClip;
         if(param1.indexOf("NULL") != -1)
         {
            nullAnim = param2 as MovieClip;
         }
      }
      
      public function get width() : Number
      {
         return charMat.movie.width;
      }
      
      public function registerLipSyncAnim(param1:String, param2:MovieClip, param3:Number = 0, param4:Number = 0) : void
      {
         lipSyncAnim.registerAnim(param1,param2);
         param2.x = param3;
         param2.y = param4;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.container.visible = param1;
         if(!param1)
         {
            charMat.removeSprite();
         }
      }
      
      public function end() : void
      {
         resetAnims();
         if(isTalking)
         {
            stopLipSync();
         }
         isAnimating = false;
      }
      
      public function stepFrameUnit(param1:Number) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Number = 1;
         for each(_loc4_ in animStates)
         {
            _loc3_ = Math.round(param1 * fixedFrameTotal) + 1;
            _loc4_.gotoAndStop(_loc3_);
         }
      }
      
      public function get height() : Number
      {
         return charMat.movie.height;
      }
      
      public function handleLipSyncComplete(param1:AnimationOldEvent) : void
      {
         stopLipSync();
         charMat.movie = nullAnim;
      }
      
      public function doAnimation(param1:String) : void
      {
         var _loc2_:MovieClip = animStates[param1];
         if(_loc2_ is MovieClip)
         {
            if(isTalking && _loc2_ == nullAnim)
            {
               return;
            }
            if(_loc2_ != currentState)
            {
               if(isTalking)
               {
                  stopLipSync();
               }
               charMat.movie = animStates[param1];
               currentState = animStates[param1];
            }
         }
         else
         {
            BrainLogger.out("PlayerPointSprite :: doAnimation :: Warning - could not find a registered movie clip reference for ",param1);
         }
      }
      
      public function stopLipSync() : void
      {
         lipSyncAnim.stopAnim();
         dispatchEvent(new AnimationOldEvent(AnimationOldEvent.COMPLETE));
         lipSyncAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleLipSyncComplete);
         isTalking = false;
         charMat.movie = nullAnim;
      }
      
      public function get isPlayingNullAnim() : Boolean
      {
         BrainLogger.out("ISPLAYINGNULLANIM",currentState);
         return !currentState || currentState == nullAnim;
      }
   }
}

