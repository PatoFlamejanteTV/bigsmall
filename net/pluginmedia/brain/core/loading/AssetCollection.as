package net.pluginmedia.brain.core.loading
{
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   
   public class AssetCollection
   {
      
      private var _length:Number = 0;
      
      private var _unitLoaded:Number = 0;
      
      private var _assetLoaders:Dictionary = new Dictionary();
      
      private var _bytesLoaded:Number = 0;
      
      private var _bytesTotal:Number = 0;
      
      public function AssetCollection()
      {
         super();
      }
      
      public function set bytesLoaded(param1:Number) : void
      {
         _bytesLoaded = param1;
         _unitLoaded = _bytesLoaded / _bytesTotal;
      }
      
      public function set unitLoaded(param1:Number) : void
      {
         _unitLoaded = param1;
      }
      
      public function get length() : Number
      {
         return _length;
      }
      
      public function get isLoaded() : Boolean
      {
         var _loc2_:IAssetLoader = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in _assetLoaders)
         {
            if(!_loc2_.isLoaded)
            {
               return false;
            }
         }
         return _loc1_;
      }
      
      public function get unitLoaded() : Number
      {
         return _unitLoaded;
      }
      
      public function get bytesLoaded() : Number
      {
         return _bytesLoaded;
      }
      
      public function pushAsset(param1:IAssetLoader, param2:AssetRequest) : void
      {
         _assetLoaders[param2.handle] = param1;
         ++_length;
      }
      
      public function set bytesTotal(param1:Number) : void
      {
         _bytesTotal = param1;
         _unitLoaded = _bytesLoaded / _bytesTotal;
      }
      
      public function get bytesTotal() : Number
      {
         return _bytesTotal;
      }
      
      public function collectionLoadComplete() : Boolean
      {
         var _loc2_:IAssetLoader = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in _assetLoaders)
         {
            if(!_loc2_.isLoaded)
            {
               _loc1_ = false;
               break;
            }
         }
         return _loc1_;
      }
      
      public function get assetLoaders() : Dictionary
      {
         return _assetLoaders;
      }
   }
}

