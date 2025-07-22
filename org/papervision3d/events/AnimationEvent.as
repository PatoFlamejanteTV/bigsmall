package org.papervision3d.events
{
   import flash.events.Event;
   
   public class AnimationEvent extends Event
   {
      
      public static const ANIMATION_COMPLETE:String = "animationComplete";
      
      public static const ANIMATION_ERROR:String = "animationError";
      
      public static const ANIMATION_NEXT_FRAME:String = "animationNextFrame";
      
      public var message:String = "";
      
      public var totalFrames:uint;
      
      public var currentFrame:uint;
      
      public var dataObj:Object = null;
      
      public function AnimationEvent(param1:String, param2:uint, param3:uint, param4:String = "", param5:Object = null, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,param6,param7);
         this.currentFrame = param2;
         this.totalFrames = param3;
         this.message = param4;
         this.dataObj = param5;
      }
      
      override public function clone() : Event
      {
         return new AnimationEvent(type,currentFrame,totalFrames,message,dataObj,bubbles,cancelable);
      }
   }
}

