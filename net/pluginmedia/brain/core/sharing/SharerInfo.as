package net.pluginmedia.brain.core.sharing
{
   public class SharerInfo
   {
      
      private var _id:String;
      
      private var _reference:Object;
      
      public function SharerInfo(param1:String, param2:Object)
      {
         super();
         _id = param1;
         _reference = param2;
      }
      
      public function get reference() : Object
      {
         return _reference;
      }
      
      public function get id() : String
      {
         return _id;
      }
   }
}

