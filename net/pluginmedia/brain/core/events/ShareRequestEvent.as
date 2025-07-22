package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   
   public class ShareRequestEvent extends Event
   {
      
      public static const SHARE_REQUEST:String = "shareRequest";
      
      public static const REMOVE_REQUEST:String = "shareRequest";
      
      private var _shareRequest:ShareRequest;
      
      public function ShareRequestEvent(param1:String, param2:ShareRequest)
      {
         _shareRequest = param2;
         super(param1,false,false);
      }
      
      public function get shareRequest() : ShareRequest
      {
         return _shareRequest;
      }
   }
}

