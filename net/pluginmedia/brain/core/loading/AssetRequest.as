package net.pluginmedia.brain.core.loading
{
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   
   public class AssetRequest
   {
      
      private var _priority:Number;
      
      private var _handle:String;
      
      private var _loadable:ILoadable;
      
      private var _callback:Function = null;
      
      private var _ioerrorcallback:Function = null;
      
      private var _url:String;
      
      private var _isUnique:Boolean;
      
      private var _autoStartQueue:Boolean;
      
      public function AssetRequest(param1:ILoadable, param2:String, param3:String, param4:Function = null, param5:Function = null, param6:Boolean = true, param7:Boolean = true, param8:Number = 0)
      {
         super();
         _autoStartQueue = param6;
         _isUnique = param7;
         _url = param3;
         _callback = param4;
         _ioerrorcallback = param5;
         _handle = param2;
         _loadable = param1;
         _priority = param8;
      }
      
      public function get loadable() : ILoadable
      {
         return _loadable;
      }
      
      public function get callback() : Function
      {
         return _callback;
      }
      
      public function doLoadedCallback(param1:IAssetLoader) : void
      {
         if(_callback !== null)
         {
            _callback(param1);
         }
      }
      
      public function get isUnique() : Boolean
      {
         return _isUnique;
      }
      
      public function get autoStartQueue() : Boolean
      {
         return _autoStartQueue;
      }
      
      public function get ioerrorcallback() : Function
      {
         return _ioerrorcallback;
      }
      
      public function get handle() : String
      {
         return _handle;
      }
      
      public function get priority() : Number
      {
         return _priority;
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      public function doIOErrorCallback(param1:IAssetLoader) : void
      {
         if(_ioerrorcallback !== null)
         {
            _ioerrorcallback(param1);
         }
      }
   }
}

import net.pluginmedia.brain.core.interfaces.ILoadable;

ILoadable;

