package net.pluginmedia.bigandsmall.core.animation
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class CompositeTransitionFX extends TransitionFX
   {
      
      protected var userDataPool:Dictionary = new Dictionary();
      
      public function CompositeTransitionFX(param1:* = null)
      {
         super(param1);
      }
      
      private function addUserData() : void
      {
         if(userData !== null)
         {
            addChild(userData);
         }
      }
      
      public function doNamedTransitionIn(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Number = 1) : void
      {
         _isPlaying = true;
         var _loc6_:AnimationOld = userDataPool[param1];
         if(_loc6_ !== null)
         {
            removeUserData();
            userData = _loc6_;
            addUserData();
            super.doTransitionIn(param2,param3,param4,param5);
         }
         else
         {
            BrainLogger.out("CompositeTransitionFX :: transition in WARNING :: cannot find named transition user data",param1);
         }
      }
      
      private function removeUserData() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in userDataPool)
         {
            if(this.contains(_loc1_))
            {
               removeChild(_loc1_);
            }
         }
      }
      
      public function setUserDataPool(param1:Dictionary) : void
      {
         userDataPool = param1;
      }
      
      public function doNamedTransitionOut(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Number = 1) : void
      {
         _isPlaying = true;
         var _loc6_:AnimationOld = userDataPool[param1];
         if(_loc6_ !== null)
         {
            removeUserData();
            userData = _loc6_;
            addUserData();
            super.doTransitionOut(param2,param3,param4,param5);
         }
         else
         {
            BrainLogger.out("CompositeTransitionFX :: transition out WARNING :: cannot find named transition user data",param1);
         }
      }
      
      public function registerUserData(param1:String, param2:*) : void
      {
         BrainLogger.out("CompositeTransitionFX :: registerUserData");
         var _loc3_:AnimationOld = this.getConcreteUserData(param2);
         if(_loc3_ !== null)
         {
            userDataPool[param1] = _loc3_;
         }
         else
         {
            BrainLogger.out("CompositeTransitionFX :: WARNING :: cannot get concrete user data for ref",param2);
         }
      }
   }
}

