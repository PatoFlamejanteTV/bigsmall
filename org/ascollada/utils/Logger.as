package org.ascollada.utils
{
   public class Logger
   {
      
      public static var VERBOSE:Boolean = false;
      
      public function Logger()
      {
         super();
      }
      
      public static function debug(param1:String) : void
      {
         if(VERBOSE)
         {
            trace(param1);
         }
      }
      
      public static function error(param1:String) : void
      {
         trace(param1);
      }
      
      public static function fatal(param1:String) : void
      {
         trace(param1);
      }
      
      public static function log(param1:String) : void
      {
         if(VERBOSE)
         {
            trace(param1);
         }
      }
      
      public static function info(param1:String) : void
      {
         if(VERBOSE)
         {
            trace(param1);
         }
      }
   }
}

