package net.pluginmedia.bigandsmall.ui
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import net.pluginmedia.brain.buttons.AssetButton;
   
   public class MenuAssetButton extends AssetButton
   {
      
      public var pageLoaded:Boolean = false;
      
      public var loadBar:MovieClip;
      
      public function MenuAssetButton(param1:*, param2:String = null, param3:String = null, param4:Object = null)
      {
         super(param1,param2,param3,actionObj);
         loadBar = displayObjectAsset["loadBar"] as MovieClip;
         loadBar.stop();
         displayAsset.gotoAndStop("_up");
         displayObjectAsset.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
      }
      
      override public function setEnabledState(param1:Boolean = true) : void
      {
         super.setEnabledState(param1);
         if(!param1)
         {
            removeLoadProgress();
         }
         displayAsset.gotoAndStop("_pending");
      }
      
      private function removeLoadProgress() : void
      {
         pageLoaded = true;
         displayObjectAsset.transform.colorTransform = new ColorTransform();
         loadBar.visible = false;
      }
      
      public function updateLoadProgress(param1:Number) : void
      {
         var _loc2_:int = int(param1 * 100 + 1);
         loadBar.gotoAndStop(_loc2_);
         if(_loc2_ >= 100)
         {
            removeLoadProgress();
         }
      }
      
      public function get displayAsset() : MovieClip
      {
         return displayObjectAsset as MovieClip;
      }
   }
}

