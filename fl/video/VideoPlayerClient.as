package fl.video
{
   use namespace flvplayback_internal;
   
   public dynamic class VideoPlayerClient
   {
      
      protected var _owner:VideoPlayer;
      
      protected var gotMetadata:Boolean;
      
      public function VideoPlayerClient(param1:VideoPlayer)
      {
         super();
         _owner = param1;
         gotMetadata = false;
      }
      
      public function get ready() : Boolean
      {
         return gotMetadata;
      }
      
      public function onMetaData(param1:Object, ... rest) : void
      {
         param1.duration;
         param1.width;
         param1.height;
         _owner.flvplayback_internal::onMetaData(param1);
         gotMetadata = true;
      }
      
      public function get owner() : VideoPlayer
      {
         return _owner;
      }
      
      public function onCuePoint(param1:Object, ... rest) : void
      {
         param1.name;
         param1.time;
         param1.type;
         _owner.flvplayback_internal::onCuePoint(param1);
      }
   }
}

