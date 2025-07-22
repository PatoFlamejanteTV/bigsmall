package net.pluginmedia.bigandsmall.core.mesh
{
   import flash.display.MovieClip;
   import net.pluginmedia.brain.core.animation.SuperMovieClip;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   
   public class CharacterAnimationPlane extends AnimationPlane
   {
      
      protected var labelCompletionCallback:Function;
      
      public var charAnim:SuperMovieClip;
      
      public function CharacterAnimationPlane(param1:MovieClip, param2:Number = 1, param3:Number = 1, param4:Boolean = false)
      {
         charAnim = new SuperMovieClip(param1);
         super(charAnim,param2,param3,2,2);
      }
      
      public function playLabel(param1:String, param2:int = 0, param3:int = 0, param4:Function = null) : void
      {
         if(_isPlaying)
         {
            stop();
         }
         labelCompletionCallback = param4;
         charAnim.playLabel(param1,param2,param3);
         _isPlaying = true;
         _dirtyMesh = true;
         onBeginPlaying();
         addLabelCompletionListener();
      }
      
      override protected function onEndPlaying() : void
      {
         removeLabelCompletionListener();
         super.onEndPlaying();
      }
      
      override protected function onBeginPlaying() : void
      {
         removeLabelCompletionListener();
         super.onBeginPlaying();
      }
      
      override protected function removeAllListeners() : void
      {
         super.removeAllListeners();
         removeLabelCompletionListener();
         labelCompletionCallback = null;
      }
      
      protected function addLabelCompletionListener() : void
      {
         charAnim.addEventListener(AnimationEvent.COMPLETE,handleLabelComplete);
      }
      
      protected function handleLabelComplete(param1:AnimationEvent) : void
      {
         stop();
         if(labelCompletionCallback is Function)
         {
            labelCompletionCallback();
         }
         labelCompletionCallback = null;
      }
      
      protected function removeLabelCompletionListener() : void
      {
         charAnim.removeEventListener(AnimationEvent.COMPLETE,handleLabelComplete);
      }
   }
}

