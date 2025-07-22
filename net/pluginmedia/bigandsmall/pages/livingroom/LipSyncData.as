package net.pluginmedia.bigandsmall.pages.livingroom
{
   import flash.display.MovieClip;
   
   public class LipSyncData
   {
      
      public var movie:MovieClip;
      
      public var soundRef:String;
      
      public var holdRepeat:Boolean = false;
      
      public var playCount:int = 0;
      
      public var maxPlayCount:int = -1;
      
      public function LipSyncData(param1:MovieClip, param2:String, param3:int = 1, param4:Boolean = false)
      {
         super();
         this.maxPlayCount = param3;
         this.movie = param1;
         this.soundRef = param2;
         this.holdRepeat = param4;
      }
   }
}

