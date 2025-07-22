package net.pluginmedia.brain.core.loading
{
   public class AssetLoaderInfo
   {
      
      private var filetypes:Array;
      
      private var stringID:String;
      
      private var loaderAsset:Class;
      
      public function AssetLoaderInfo(param1:Class, param2:String, param3:Array)
      {
         super();
         if(!param1 is Class)
         {
            throw new Error("IAssetLoaderInfo :: IAssetLoaderInfo supplied cannot be instantiated");
         }
         loaderAsset = param1;
         stringID = param2;
         filetypes = param3;
      }
      
      public function get fileTypes() : Array
      {
         return filetypes;
      }
      
      public function get IAssetLoader() : Class
      {
         return loaderAsset;
      }
      
      public function get id() : String
      {
         return stringID;
      }
   }
}

