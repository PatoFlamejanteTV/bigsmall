package net.pluginmedia.brain.core.loading
{
   public class LoadProgressRequestInfo
   {
      
      private var callBack:Function;
      
      private var pageList:Array;
      
      public function LoadProgressRequestInfo(param1:Function, param2:Array = null)
      {
         super();
         callBack = param1;
         pageList = param2;
      }
      
      public function get pages() : Array
      {
         return pageList;
      }
      
      public function get callback() : Function
      {
         return callBack;
      }
   }
}

