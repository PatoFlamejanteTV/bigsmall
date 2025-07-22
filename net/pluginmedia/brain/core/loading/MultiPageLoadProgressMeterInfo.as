package net.pluginmedia.brain.core.loading
{
   public class MultiPageLoadProgressMeterInfo
   {
      
      protected var _callback:Function;
      
      protected var _collectionList:Array;
      
      public function MultiPageLoadProgressMeterInfo(param1:Array = null, param2:Function = null)
      {
         super();
         _callback = param2;
         _collectionList = param1;
      }
      
      public function set collectionList(param1:Array) : void
      {
         _collectionList = param1;
      }
      
      public function get collectionList() : Array
      {
         return _collectionList;
      }
      
      public function get onComplete() : Function
      {
         return _callback;
      }
   }
}

