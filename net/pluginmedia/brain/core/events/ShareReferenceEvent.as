package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   
   public class ShareReferenceEvent extends Event
   {
      
      public static const SHARE_REFERENCE:String = "shareReference";
      
      public static const REMOVE_REFERENCE:String = "shareReference";
      
      private var _sharerInfo:SharerInfo;
      
      public function ShareReferenceEvent(param1:String, param2:SharerInfo)
      {
         _sharerInfo = param2;
         super(param1,false,false);
      }
      
      public function get sharerInfo() : SharerInfo
      {
         return _sharerInfo;
      }
   }
}

