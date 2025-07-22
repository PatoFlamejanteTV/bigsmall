package net.pluginmedia.bigandsmall.core.animation
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   
   public class TransitionFX extends Sprite
   {
      
      protected var _isPlaying:Boolean = false;
      
      protected var _callback_onTransitComplete:Function = null;
      
      protected var userData:AnimationOld = null;
      
      protected var _callback_onTransitCompleteParams:Array = [];
      
      public function TransitionFX(param1:* = null)
      {
         super();
         if(param1 !== null)
         {
            setUserData(param1);
         }
      }
      
      protected function removeCompleteListener() : void
      {
         if(userData.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            userData.removeEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         }
      }
      
      protected function handleAnimComplete(param1:AnimationOldEvent) : void
      {
         removeCompleteListener();
         park(true);
         if(_callback_onTransitComplete !== null)
         {
            _callback_onTransitComplete.apply(null,_callback_onTransitCompleteParams);
         }
      }
      
      public function hide(param1:Boolean) : void
      {
         if(userData === null)
         {
            return;
         }
         if(!param1)
         {
            userData.visible = true;
            if(!contains(userData))
            {
               addChild(userData);
            }
         }
         else
         {
            userData.visible = false;
            if(contains(userData))
            {
               removeChild(userData);
            }
         }
      }
      
      protected function park(param1:Boolean = true) : void
      {
         _isPlaying = false;
         if(userData === null)
         {
            return;
         }
         hide(param1);
         userData.gotoAndStop(1);
      }
      
      public function set callback_onTransitComplete(param1:Function) : void
      {
         _callback_onTransitComplete = param1;
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      public function doTransitionIn(param1:Function = null, param2:Array = null, param3:Boolean = false, param4:Number = 1) : void
      {
         _isPlaying = true;
         hide(false);
         _callback_onTransitComplete = param1;
         _callback_onTransitCompleteParams = param2;
         attachCompleteListener();
         if(!param3)
         {
            userData.stepOutLabel("in",0,param3,param4);
         }
         else
         {
            userData.stepOutLabel("out",0,param3,param4);
         }
      }
      
      public function doTransitionOut(param1:Function = null, param2:Array = null, param3:Boolean = false, param4:Number = 1) : void
      {
         _isPlaying = true;
         hide(false);
         _callback_onTransitComplete = param1;
         _callback_onTransitCompleteParams = param2;
         attachCompleteListener();
         if(!param3)
         {
            userData.stepOutLabel("out",0,param3,param4);
         }
         else
         {
            userData.stepOutLabel("in",0,param3,param4);
         }
      }
      
      public function setUserData(param1:*) : void
      {
         userData = getConcreteUserData(param1);
         park();
      }
      
      protected function attachCompleteListener() : void
      {
         if(!userData.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            userData.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         }
      }
      
      public function getConcreteUserData(param1:*) : AnimationOld
      {
         if(param1 is AnimationOld)
         {
            return param1;
         }
         if(param1 is MovieClip)
         {
            return new AnimationOld(param1);
         }
         if(param1 is Class)
         {
            return new AnimationOld(new param1());
         }
         return null;
      }
   }
}

