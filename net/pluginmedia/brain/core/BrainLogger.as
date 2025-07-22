package net.pluginmedia.brain.core
{
   import flash.utils.getTimer;
   
   public class BrainLogger
   {
      
      public static var isVerbose:Boolean = true;
      
      public static var timeStamp:Boolean = false;
      
      public function BrainLogger()
      {
         super();
      }
      
      public static function fatal(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [fatal] :: ",rest.join(" "));
         }
      }
      
      public static function error(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [error] :: ",rest.join(" "));
         }
      }
      
      public static function log(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [log] :: ",rest.join(" "));
         }
      }
      
      public static function getStamp() : String
      {
         var _loc1_:* = "";
         if(timeStamp)
         {
            _loc1_ = "@ " + String(int(getTimer() / 1000 * 1000) / 1000) + " sec";
         }
         return _loc1_;
      }
      
      public static function info(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [info] :: ",rest.join(" "));
         }
      }
      
      public static function debug(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [debug] :: ",rest.join(" "));
         }
      }
      
      public static function highlight(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," ----------> ",rest.join(" "),"<----------");
         }
      }
      
      public static function out(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp(),rest.join(" "));
         }
      }
      
      public static function warning(... rest) : void
      {
         if(isVerbose)
         {
            trace(getStamp()," -> [warning] :: ",rest.join(" "));
         }
      }
   }
}

