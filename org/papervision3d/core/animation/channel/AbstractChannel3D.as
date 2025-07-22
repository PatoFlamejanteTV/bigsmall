package org.papervision3d.core.animation.channel
{
   import org.papervision3d.core.animation.AnimationKeyFrame3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class AbstractChannel3D
   {
      
      public var endTime:Number;
      
      public var name:String;
      
      public var startTime:Number;
      
      public var target:DisplayObject3D;
      
      public var duration:Number;
      
      public var currentIndex:int;
      
      public var nextIndex:int;
      
      public var nextKeyFrame:AnimationKeyFrame3D;
      
      public var keyFrames:Array;
      
      public var currentTime:Number;
      
      public var currentKeyFrame:AnimationKeyFrame3D;
      
      public var frameDuration:Number;
      
      public var frameAlpha:Number;
      
      public function AbstractChannel3D(param1:DisplayObject3D, param2:String = null)
      {
         super();
         this.target = param1;
         this.name = param2;
         this.startTime = this.endTime = 0;
         this.keyFrames = new Array();
         this.currentKeyFrame = this.nextKeyFrame = null;
         this.currentIndex = this.nextIndex = -1;
         this.frameAlpha = 0;
      }
      
      public function updateToTime(param1:Number) : void
      {
         currentIndex = Math.floor((this.keyFrames.length - 1) * param1);
         currentIndex = currentIndex < this.keyFrames.length - 1 ? currentIndex : 0;
         nextIndex = currentIndex + 1;
         currentKeyFrame = this.keyFrames[currentIndex];
         nextKeyFrame = nextIndex < this.keyFrames.length ? this.keyFrames[nextIndex] : null;
         frameDuration = nextKeyFrame ? nextKeyFrame.time - currentKeyFrame.time : currentKeyFrame.time;
         currentTime = param1 * this.duration;
         frameAlpha = (currentTime - currentKeyFrame.time) / frameDuration;
         frameAlpha = frameAlpha < 0 ? 0 : frameAlpha;
         frameAlpha = frameAlpha > 1 ? 1 : frameAlpha;
      }
      
      public function updateToFrame(param1:uint) : void
      {
         if(!this.keyFrames.length)
         {
            return;
         }
         currentIndex = param1;
         currentIndex = currentIndex < this.keyFrames.length - 1 ? currentIndex : 0;
         nextIndex = currentIndex + 1;
         currentKeyFrame = this.keyFrames[currentIndex];
         nextKeyFrame = nextIndex < this.keyFrames.length ? this.keyFrames[nextIndex] : null;
         frameDuration = nextKeyFrame ? nextKeyFrame.time - currentKeyFrame.time : currentKeyFrame.time;
         frameAlpha = 0;
         currentTime = currentKeyFrame.time;
      }
      
      public function addKeyFrame(param1:AnimationKeyFrame3D) : AnimationKeyFrame3D
      {
         if(this.keyFrames.length)
         {
            this.startTime = Math.min(this.startTime,param1.time);
            this.endTime = Math.max(this.endTime,param1.time);
         }
         else
         {
            this.startTime = this.endTime = param1.time;
         }
         this.duration = this.endTime - this.startTime;
         this.keyFrames.push(param1);
         this.keyFrames.sortOn("time",Array.NUMERIC);
         return param1;
      }
   }
}

