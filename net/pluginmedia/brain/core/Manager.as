package net.pluginmedia.brain.core
{
   import flash.display.Sprite;
   import net.pluginmedia.brain.core.interfaces.IManager;
   
   public class Manager extends Sprite implements IManager
   {
      
      protected var _paused:Boolean = false;
      
      protected var registeredObjs:Array = [];
      
      public function Manager()
      {
         super();
      }
      
      public function register(param1:Object) : void
      {
         registeredObjs.push(param1);
      }
      
      public function get isPaused() : Boolean
      {
         return _paused;
      }
      
      public function unregister(param1:Object) : Boolean
      {
         var _loc2_:int = int(registeredObjs.indexOf(param1));
         if(_loc2_ > -1)
         {
            registeredObjs.splice(_loc2_,1);
            return true;
         }
         return false;
      }
      
      public function pause(param1:Boolean = true) : void
      {
         _paused = param1;
      }
   }
}

