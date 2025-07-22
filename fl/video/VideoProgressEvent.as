package fl.video
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class VideoProgressEvent extends ProgressEvent implements IVPEvent
   {
      
      public static const PROGRESS:String = "progress";
      
      private var _vp:uint;
      
      public function VideoProgressEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:uint = 0)
      {
         super(param1,param2,param3,param4,param5);
         _vp = param6;
      }
      
      override public function clone() : Event
      {
         return new VideoProgressEvent(type,bubbles,cancelable,bytesLoaded,bytesTotal,vp);
      }
      
      public function set vp(param1:uint) : void
      {
         _vp = param1;
      }
      
      public function get vp() : uint
      {
         return _vp;
      }
   }
}

