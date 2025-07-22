package net.pluginmedia.brain.core.sharing
{
   import net.pluginmedia.brain.core.interfaces.ISharer;
   
   public class ShareRequest
   {
      
      private var _autoDelete:Boolean;
      
      private var _id:String;
      
      private var _callback:Function;
      
      private var _sharer:ISharer;
      
      public function ShareRequest(param1:ISharer, param2:String, param3:Function = null, param4:Boolean = true)
      {
         super();
         _sharer = param1;
         _id = param2;
         _callback = param3;
         _autoDelete = param4;
      }
      
      public function get callback() : Function
      {
         return _callback;
      }
      
      public function get autoDelete() : Boolean
      {
         return _autoDelete;
      }
      
      public function get sharer() : ISharer
      {
         return _sharer;
      }
      
      public function get id() : String
      {
         return _id;
      }
   }
}

