package net.pluginmedia.brain.core.events
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.loading.AssetRequest;
   
   public class LoaderEvent extends Event
   {
      
      public static var ASSET_REQUEST:String = "assetRequest";
      
      public static var PROGRESS:String = "loaderAssetProgress";
      
      public static var DEMAND_ASSETS:String = "demandAssets";
      
      private var _assetLoaderInfo:AssetRequest;
      
      public function LoaderEvent(param1:String, param2:AssetRequest)
      {
         super(param1);
         _assetLoaderInfo = param2;
      }
      
      public function get assetLoaderInfo() : AssetRequest
      {
         return _assetLoaderInfo;
      }
   }
}

