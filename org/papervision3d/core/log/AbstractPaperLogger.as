package org.papervision3d.core.log
{
   import org.papervision3d.core.log.event.PaperLoggerEvent;
   
   public class AbstractPaperLogger implements IPaperLogger
   {
      
      public function AbstractPaperLogger()
      {
         super();
      }
      
      public function registerWithPaperLogger(param1:PaperLogger) : void
      {
         param1.addEventListener(PaperLoggerEvent.TYPE_LOGEVENT,onLogEvent);
      }
      
      public function debug(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function warning(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function log(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function fatal(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function error(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      protected function onLogEvent(param1:PaperLoggerEvent) : void
      {
         var _loc2_:PaperLogVO = param1.paperLogVO;
         switch(_loc2_.level)
         {
            case LogLevel.LOG:
               log(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.INFO:
               info(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.ERROR:
               error(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.DEBUG:
               debug(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.WARNING:
               warning(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.FATAL:
               fatal(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            default:
               log(_loc2_.msg,_loc2_.object,_loc2_.arg);
         }
      }
      
      public function unregisterFromPaperLogger(param1:PaperLogger) : void
      {
         param1.removeEventListener(PaperLoggerEvent.TYPE_LOGEVENT,onLogEvent);
      }
      
      public function info(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
   }
}

