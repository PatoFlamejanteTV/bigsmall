package net.pluginmedia.brain.core
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.loading.AssetRequest;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.view.BasicView;
   
   public class LoaderAssetPage3D extends Page3D implements ILoadable
   {
      
      protected var _loadFailed:Boolean = false;
      
      protected var _unitLoaded:Number;
      
      protected var _ioErrorAutoFail:Boolean = true;
      
      public function LoaderAssetPage3D(param1:BasicView, param2:Number3D, param3:CameraObject3D, param4:String, param5:Page3D = null)
      {
         super(param1,param2,param3,param4);
      }
      
      public function get loadFailed() : Boolean
      {
         return _loadFailed;
      }
      
      public function ioErrorCallback(param1:IOErrorEvent) : void
      {
         BrainLogger.out("page has recieved IOError from load manager, kill app : ",_ioErrorAutoFail);
         _loadFailed = true;
         if(_ioErrorAutoFail)
         {
            BrainLogger.out("dispatching kill request :: ",param1);
            broadcast(BrainEventType.KILL_APP,"",param1);
         }
      }
      
      public function get unitLoaded() : Number
      {
         return _unitLoaded;
      }
      
      protected function dispatchAssetRequest(param1:String, param2:String, param3:Function, param4:Function = null, param5:Boolean = true, param6:Boolean = true, param7:int = 1) : void
      {
         var _loc8_:AssetRequest = new AssetRequest(this,param1,param2,param3,param4,param5,param6,param7);
         dispatchEvent(new LoaderEvent(LoaderEvent.ASSET_REQUEST,_loc8_));
      }
      
      public function set unitLoaded(param1:Number) : void
      {
         _unitLoaded = param1;
      }
      
      public function receiveAsset(param1:IAssetLoader, param2:String) : void
      {
      }
      
      public function collectionQueueEmpty() : void
      {
      }
      
      override public function initialise() : void
      {
         super.initialise();
         dispatchEvent(new Event(LoaderEvent.DEMAND_ASSETS));
      }
      
      public function onRegistration() : void
      {
      }
   }
}

