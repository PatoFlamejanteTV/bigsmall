package net.pluginmedia.brain.core.interfaces
{
   import flash.events.IOErrorEvent;
   
   public interface ILoadable
   {
      
      function set unitLoaded(param1:Number) : void;
      
      function get loadFailed() : Boolean;
      
      function ioErrorCallback(param1:IOErrorEvent) : void;
      
      function onRegistration() : void;
      
      function get unitLoaded() : Number;
      
      function collectionQueueEmpty() : void;
      
      function receiveAsset(param1:IAssetLoader, param2:String) : void;
   }
}

