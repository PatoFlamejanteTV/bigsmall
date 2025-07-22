package net.pluginmedia.pv3d
{
   import flash.events.Event;
   
   public class DAELoadProgressEvent extends Event
   {
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public var bytesLoaded:Number;
      
      public var bytesTotal:Number;
      
      public var progress:Number;
      
      public function DAELoadProgressEvent(param1:String, param2:Number, param3:Number, param4:Number, param5:Boolean = false, param6:Boolean = false)
      {
         progress = param2;
         bytesLoaded = param4;
         bytesTotal = param3;
         super(param1,param5,param6);
      }
      
      override public function clone() : Event
      {
         return new DAELoadProgressEvent(type,progress,bytesTotal,bytesLoaded,bubbles,cancelable);
      }
   }
}

