package net.pluginmedia.bigandsmall.pages.livingroom.bandgame
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class PlayerLipSyncAnim extends Sprite
   {
      
      public var currentAnim:MovieClip;
      
      public var isPlaying:Boolean;
      
      public var animations:Object = {};
      
      public function PlayerLipSyncAnim()
      {
         super();
      }
      
      public function stopAnim() : void
      {
         if(!currentAnim)
         {
            return;
         }
         currentAnim.gotoAndStop(1);
         removeChild(currentAnim);
         removeEventListener(Event.ENTER_FRAME,enterFrame);
         currentAnim = null;
      }
      
      public function playAnim(param1:String) : MovieClip
      {
         if(currentAnim)
         {
            return null;
         }
         currentAnim = animations[param1];
         if(!currentAnim)
         {
            return null;
         }
         addChild(currentAnim);
         currentAnim.gotoAndPlay(1);
         addEventListener(Event.ENTER_FRAME,enterFrame);
         return currentAnim;
      }
      
      public function registerAnim(param1:String, param2:MovieClip) : void
      {
         if(!param2)
         {
            BrainLogger.out("ERROR :: PlayerLipSyncAnim received null asset for",param1);
         }
         else
         {
            animations[param1] = param2;
            param2.gotoAndStop(1);
         }
      }
      
      public function enterFrame(param1:Event) : void
      {
         if(currentAnim)
         {
            if(currentAnim.currentFrame == currentAnim.totalFrames - 1)
            {
               stopAnim();
               dispatchEvent(new AnimationOldEvent(AnimationOldEvent.COMPLETE));
            }
         }
         else
         {
            BrainLogger.out("ERROR :: PlayerLipSyncAnim. I don\'t seem to have an animation to keep track of. Weird.");
         }
      }
   }
}

