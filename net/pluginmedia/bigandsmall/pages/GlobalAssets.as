package net.pluginmedia.bigandsmall.pages
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.definitions.XMLLocations;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.brain.core.events.LoaderEvent;
   import net.pluginmedia.brain.core.events.ShareReferenceEvent;
   import net.pluginmedia.brain.core.interfaces.IAssetLoader;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.interfaces.ISharer;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import net.pluginmedia.brain.core.loading.AssetRequest;
   import net.pluginmedia.brain.core.loading.URLAssetLoader;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.sound.BrainSoundCollectionOld;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   
   public class GlobalAssets extends EventDispatcher implements ILoadable, ISharer
   {
      
      private var transitions:Dictionary = new Dictionary();
      
      private var backButtonClass:Class = null;
      
      private var _ioErrorAutoFail:Boolean = true;
      
      private var _percentageLoaded:Number = 0;
      
      private var _loadFailed:Boolean = false;
      
      public var helperText:XML;
      
      public function GlobalAssets()
      {
         super();
      }
      
      public function collectionQueueEmpty() : void
      {
         this.dispatchEvent(new Event("GlobalAssetsReady"));
      }
      
      public function onShareableRegistration() : void
      {
      }
      
      public function get loadFailed() : Boolean
      {
         return false;
      }
      
      public function set unitLoaded(param1:Number) : void
      {
         _percentageLoaded = param1;
      }
      
      public function receiveAsset(param1:IAssetLoader, param2:String) : void
      {
      }
      
      public function receiveShareable(param1:SharerInfo) : void
      {
      }
      
      private function dispatchShareable(param1:String, param2:Object) : void
      {
         dispatchEvent(new ShareReferenceEvent(ShareReferenceEvent.SHARE_REFERENCE,new SharerInfo(param1,param2)));
      }
      
      private function setupSound(param1:String, param2:AssetLoader, param3:int) : void
      {
         var _loc4_:SoundInfoOld = new SoundInfoOld(1,0,0,0,param3);
         _loc4_.onConflictResponse = SoundInfoOld.CHANCONFLICT_OVERRIDE;
         SoundManagerOld.registerSound(new BrainSoundOld(param1,param2.getAssetClassByName(param1),_loc4_));
      }
      
      public function transitionsLoaded(param1:IAssetLoader) : void
      {
         var _loc2_:AssetLoader = param1 as AssetLoader;
         if(_loc2_ === null)
         {
            BrainLogger.out("GlobalAssets :: WARNING :: transition loader asset error...");
            return;
         }
         transitions["Transition_A"] = new AnimationOld(_loc2_.getAssetByName("Transition_A"));
         transitions["Transition_B"] = new AnimationOld(_loc2_.getAssetByName("Transition_B"));
         transitions["Transition_C"] = new AnimationOld(_loc2_.getAssetByName("Transition_C"));
         transitions["Transition_D"] = new AnimationOld(_loc2_.getAssetByName("Transition_D"));
         transitions["Transition_E"] = new AnimationOld(_loc2_.getAssetByName("Transition_E"));
         dispatchShareable("GlobalAssets.TransitionFX",transitions);
      }
      
      public function buttonsLoaded(param1:IAssetLoader) : void
      {
         var _loc2_:AssetLoader = param1 as AssetLoader;
         if(_loc2_ === null)
         {
            BrainLogger.out("GlobalAssets :: WARNING :: button loader asset error...");
            return;
         }
         backButtonClass = _loc2_.getAssetClassByName("BackButton");
         dispatchShareable("GlobalAssets.BackButton",backButtonClass);
      }
      
      public function ioErrorCallback(param1:IOErrorEvent) : void
      {
         _loadFailed = true;
         if(_ioErrorAutoFail)
         {
            dispatchEvent(new BrainEvent(BrainEventType.KILL_APP,null,param1));
         }
      }
      
      private function dispatchAssetRequest(param1:AssetRequest) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.ASSET_REQUEST,param1));
      }
      
      public function soundsLoaded(param1:IAssetLoader) : void
      {
         var _loc3_:SoundInfoOld = null;
         var _loc2_:AssetLoader = param1 as AssetLoader;
         if(_loc2_ === null)
         {
            BrainLogger.out("GlobalAssets :: WARNING :: sound loader asset error...");
            return;
         }
         _loc3_ = new SoundInfoOld(1,0,0,0,2);
         _loc3_.onConflictResponse = SoundInfoOld.CHANCONFLICT_OVERRIDE;
         var _loc4_:BrainSoundCollectionOld = new BrainSoundCollectionOld("transitionMusic",_loc3_);
         _loc4_.pushSound(new BrainSoundOld("transitionMusic_A",_loc2_.getAssetByName("gn_trans_music1"),null));
         _loc4_.pushSound(new BrainSoundOld("transitionMusic_B",_loc2_.getAssetByName("gn_trans_music2"),null));
         _loc4_.pushSound(new BrainSoundOld("transitionMusic_C",_loc2_.getAssetByName("pl_tran_music"),null));
         _loc4_.pushSound(new BrainSoundOld("transitionMusic_D",_loc2_.getAssetByName("hf_tran_music"),null));
         SoundManagerOld.registerSoundCollection(_loc4_);
         setupSound("lr_trans_music",_loc2_,2);
         setupSound("pl_tran_music",_loc2_,2);
         setupSound("hf_tran_music",_loc2_,2);
         setupSound("lr_big_tosml_wipe",_loc2_,2);
         setupSound("lr_sml_tobig_wipe",_loc2_,2);
         setupSound("mw_musictrans_intowoods",_loc2_,2);
         setupSound("mw_musictrans_outwoods",_loc2_,2);
         setupSound("tt_trans_music1",_loc2_,2);
         setupSound("tt_trans_music2",_loc2_,2);
         setupSound("gn_arrow_click",_loc2_,-1);
         setupSound("gn_arrow_over",_loc2_,-1);
         setupSound("hf_door_close",_loc2_,-1);
         _loc3_ = new SoundInfoOld(1,0,0,0,-1);
         _loc3_.onConflictResponse = SoundInfoOld.CHANCONFLICT_OVERRIDE;
         _loc4_ = new BrainSoundCollectionOld("door_over",_loc3_);
         _loc4_.pushSound(new BrainSoundOld("hf_door_over",_loc2_.getAssetByName("hf_door_over"),null));
         _loc4_.pushSound(new BrainSoundOld("hf_door_calmer1",_loc2_.getAssetByName("hf_door_calmer1"),null));
         _loc4_.pushSound(new BrainSoundOld("hf_door_calmer2",_loc2_.getAssetByName("hf_door_calmer2"),null));
         _loc4_.pushSound(new BrainSoundOld("hf_door_calmer3",_loc2_.getAssetByName("hf_door_calmer3"),null));
         SoundManagerOld.registerSoundCollection(_loc4_);
      }
      
      public function helperXMLLoaded(param1:IAssetLoader) : void
      {
         var _loc2_:URLAssetLoader = param1 as URLAssetLoader;
         helperText = XML(_loc2_.data);
         dispatchShareable("GlobalAssets.HelperTextXML",helperText);
      }
      
      public function get unitLoaded() : Number
      {
         return _percentageLoaded;
      }
      
      public function onRegistration() : void
      {
         dispatchAssetRequest(new AssetRequest(this,"global.sounds",SWFLocations.globalSounds,soundsLoaded));
         dispatchAssetRequest(new AssetRequest(this,"global.helperXML",XMLLocations.helperXML,helperXMLLoaded));
         dispatchAssetRequest(new AssetRequest(this,"global.transitions",SWFLocations.globalTransitions,transitionsLoaded));
         dispatchAssetRequest(new AssetRequest(this,"global.buttons",SWFLocations.globalButtons,buttonsLoaded));
      }
   }
}

