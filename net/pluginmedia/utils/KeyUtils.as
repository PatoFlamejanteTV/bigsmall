package net.pluginmedia.utils
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class KeyUtils
   {
      
      public static var stage:Stage;
      
      public static var keysDown:Array = new Array();
      
      public static var initialised:Boolean = false;
      
      public static var keyDownCallbacks:Dictionary = new Dictionary(false);
      
      public function KeyUtils()
      {
         super();
      }
      
      public static function addKeyDownCallback(param1:Function) : void
      {
         keyDownCallbacks[param1] = true;
      }
      
      public static function keyDownHandler(param1:KeyboardEvent) : void
      {
         var key:* = undefined;
         var callBack:Function = null;
         var event:KeyboardEvent = param1;
         var rapidFire:Boolean = false;
         if(keysDown[event.keyCode] == true)
         {
            rapidFire = true;
         }
         keysDown[event.keyCode] = true;
         for(key in keyDownCallbacks)
         {
            if(key is Function)
            {
               callBack = key as Function;
               try
               {
                  callBack(event.charCode,event.clone(),rapidFire);
               }
               catch(e:Error)
               {
                  callBack(event.charCode,event.clone());
               }
            }
         }
      }
      
      public static function init(param1:Stage) : void
      {
         if(initialised)
         {
            throw new Error("KeyUtils needs to be initialised before use!");
         }
         stage = param1;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         initialised = true;
      }
      
      public static function isDown(param1:int) : Boolean
      {
         if(!initialised)
         {
            return false;
         }
         return keysDown[param1];
      }
      
      public static function keyUpHandler(param1:KeyboardEvent) : void
      {
         keysDown[param1.keyCode] = false;
      }
   }
}

