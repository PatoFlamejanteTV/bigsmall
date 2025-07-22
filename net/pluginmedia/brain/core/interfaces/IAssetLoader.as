package net.pluginmedia.brain.core.interfaces
{
   import net.pluginmedia.brain.core.loading.AssetRequest;
   
   public interface IAssetLoader
   {
      
      function stopLoad() : void;
      
      function getBytesLoaded() : uint;
      
      function get resourcePath() : String;
      
      function getContent() : Object;
      
      function get handle() : String;
      
      function get percentLoaded() : Number;
      
      function addLoadableRequest(param1:AssetRequest) : void;
      
      function get isLoaded() : Boolean;
      
      function get uid() : uint;
      
      function get isLoading() : Boolean;
      
      function get assetRequests() : Array;
      
      function getBytesTotal() : uint;
      
      function startLoad() : void;
      
      function get isError() : Boolean;
   }
}

