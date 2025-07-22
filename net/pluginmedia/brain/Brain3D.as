package net.pluginmedia.brain
{
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.loading.DAEAssetLoader;
   import net.pluginmedia.brain.managers.PageManager3D;
   
   public class Brain3D extends Brain
   {
      
      public function Brain3D()
      {
         super();
         loadManager.registerIAssetLoader(DAEAssetLoader,"DAELoaderAsset",["dae"]);
      }
      
      override public function register(param1:Object) : void
      {
         super.register(param1);
         if(_pageManager)
         {
            updateManager.moveToLastUpdatable(_pageManager as IUpdatable);
         }
      }
      
      override protected function setPageManager() : void
      {
         _pageManager = new PageManager3D(shareManager);
      }
   }
}

