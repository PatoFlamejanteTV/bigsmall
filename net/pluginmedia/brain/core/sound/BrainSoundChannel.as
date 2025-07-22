package net.pluginmedia.brain.core.sound
{
   import flash.events.Event;
   import net.pluginmedia.brain.core.sound.interfaces.IBrainSoundInstance;
   
   public class BrainSoundChannel
   {
      
      protected var _volume:Number = 1;
      
      protected var playingQueueSound:IBrainSoundInstance;
      
      protected var _paused:Boolean;
      
      private var queue:Array = [];
      
      protected var muted:Boolean = false;
      
      private var playingList:Array = [];
      
      public function BrainSoundChannel()
      {
         super();
      }
      
      protected function updateInstanceVolumes() : void
      {
         var _loc1_:IBrainSoundInstance = null;
         for each(_loc1_ in playingList)
         {
            _loc1_.channelVolume = _volume * int(!muted);
         }
         for each(_loc1_ in queue)
         {
            _loc1_.channelVolume = _volume * int(!muted);
         }
      }
      
      public function isBusy() : Boolean
      {
         return Boolean(playingList.length);
      }
      
      protected function removeQueuePlayListeners(param1:IBrainSoundInstance) : void
      {
         param1.removeEventListener(Event.COMPLETE,handleQueuePlaySoundComplete);
      }
      
      public function isQueueEmpty() : Boolean
      {
         return Boolean(queue.length);
      }
      
      protected function removePlayListeners(param1:IBrainSoundInstance) : void
      {
         param1.removeEventListener(Event.COMPLETE,handlePlaySoundComplete);
      }
      
      protected function addPlayListeners(param1:IBrainSoundInstance) : void
      {
         param1.addEventListener(Event.COMPLETE,handlePlaySoundComplete);
      }
      
      protected function handleQueuePlaySoundComplete(param1:Event) : void
      {
         playingQueueSound = null;
         var _loc2_:IBrainSoundInstance = param1.target as IBrainSoundInstance;
         removeQueuePlayListeners(_loc2_);
         removeFromPlayingList(_loc2_);
         playNextItemInQueue();
      }
      
      protected function addToPlayingList(param1:IBrainSoundInstance) : void
      {
         playingList.push(param1);
      }
      
      protected function playNextItemInQueue() : void
      {
         var _loc1_:IBrainSoundInstance = null;
         if(queue.length > 0)
         {
            _loc1_ = queue.shift();
            addQueuePlayListeners(_loc1_);
            _loc1_.channelVolume = _volume;
            _loc1_.play();
            addToPlayingList(_loc1_);
            playingQueueSound = _loc1_;
         }
      }
      
      protected function handlePlaySoundComplete(param1:Event) : void
      {
         var _loc2_:IBrainSoundInstance = param1.target as IBrainSoundInstance;
         removePlayListeners(_loc2_);
         removeFromPlayingList(_loc2_);
      }
      
      public function isPlayingQueue() : Boolean
      {
         return Boolean(playingQueueSound);
      }
      
      public function get queuedSounds() : Array
      {
         return playingList;
      }
      
      public function mute() : void
      {
         muted = true;
         updateInstanceVolumes();
      }
      
      protected function addQueuePlayListeners(param1:IBrainSoundInstance) : void
      {
         param1.addEventListener(Event.COMPLETE,handleQueuePlaySoundComplete);
      }
      
      protected function removeFromPlayingList(param1:IBrainSoundInstance) : void
      {
         var _loc2_:int = int(playingList.indexOf(param1));
         if(_loc2_ >= 0)
         {
            playingList.splice(_loc2_,1);
         }
      }
      
      public function isMuted() : Boolean
      {
         return muted;
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function resume() : void
      {
         var _loc1_:IBrainSoundInstance = null;
         _paused = false;
         for each(_loc1_ in playingList)
         {
            _loc1_.resume();
         }
      }
      
      public function unmute() : void
      {
         muted = false;
         updateInstanceVolumes();
      }
      
      public function set volume(param1:Number) : void
      {
         _volume = param1;
         updateInstanceVolumes();
      }
      
      public function pause() : void
      {
         var _loc1_:IBrainSoundInstance = null;
         _paused = true;
         for each(_loc1_ in playingList)
         {
            _loc1_.pause();
         }
      }
      
      public function get isPaused() : Boolean
      {
         return _paused;
      }
      
      public function removeSound(param1:String) : Array
      {
         var _loc2_:IBrainSoundInstance = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < queue.length)
         {
            _loc2_ = queue[_loc4_] as IBrainSoundInstance;
            if(_loc2_.id == param1)
            {
               _loc5_ = int(queue.indexOf(_loc2_));
               queue.splice(_loc5_,1);
               _loc4_--;
               _loc3_.push(_loc2_);
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < playingList.length)
         {
            _loc2_ = playingList[_loc4_] as IBrainSoundInstance;
            if(_loc2_.id == param1)
            {
               removeFromPlayingList(_loc2_);
               _loc4_--;
               if(_loc2_ == playingQueueSound)
               {
                  removeQueuePlayListeners(_loc2_);
                  playingQueueSound = null;
                  playNextItemInQueue();
               }
               else
               {
                  removePlayListeners(_loc2_);
               }
               _loc3_.push(_loc2_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function playSound(param1:IBrainSoundInstance) : void
      {
         addPlayListeners(param1);
         param1.channelVolume = _volume;
         param1.play();
         addToPlayingList(param1);
      }
      
      public function removeAll() : Array
      {
         var _loc1_:IBrainSoundInstance = null;
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         queue = [];
         _loc3_ = 0;
         while(_loc3_ < playingList.length)
         {
            _loc1_ = playingList[_loc3_] as IBrainSoundInstance;
            if(_loc1_ == playingQueueSound)
            {
               removeQueuePlayListeners(_loc1_);
            }
            else
            {
               removePlayListeners(_loc1_);
            }
            _loc2_.push(playingList.pop());
            _loc3_++;
         }
         playingQueueSound = null;
         return _loc2_;
      }
      
      public function queueSound(param1:IBrainSoundInstance) : void
      {
         queue.push(param1);
         if(!playingQueueSound)
         {
            playNextItemInQueue();
         }
      }
   }
}

