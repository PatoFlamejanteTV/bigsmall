package net.pluginmedia.bigandsmall.ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.core.Button;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   
   public class BigSmallAssetButton extends Button
   {
      
      private var talkedSelectedOver:Boolean = false;
      
      private var talkedUnselectedOver:Boolean = false;
      
      private var _userData:AnimationOld = null;
      
      private var startX:int;
      
      private var occupiedAnimChannel:Boolean = false;
      
      private var counter:Number = 0;
      
      public function BigSmallAssetButton(param1:String = null, param2:String = null, param3:Object = null)
      {
         super(param1,param2,param3);
         this.mouseChildren = false;
      }
      
      override protected function handleClick(param1:MouseEvent) : void
      {
         if(!_isSelected)
         {
            broadcast(actionType,actionString,actionObj);
            unBindVoxChannel();
         }
         else if(!_userData.isPlaying && !SoundManagerOld.channelOccupied(1) && !SoundManager.isChannelBusy(SoundChannelDefinitions.VOX))
         {
            unCacheAsBitmap();
            _userData.playOutLabel("_inactive_over");
            bindVoxChannel();
         }
      }
      
      protected function bindVoxChannel() : void
      {
         if(!occupiedAnimChannel)
         {
            SoundManagerOld.selectChannel(1);
         }
         occupiedAnimChannel = true;
      }
      
      override protected function buildView() : void
      {
      }
      
      override protected function addEventListeners() : void
      {
         if(!hasEventListener(MouseEvent.CLICK))
         {
            addEventListener(MouseEvent.CLICK,handleClick);
         }
         if(!hasEventListener(MouseEvent.MOUSE_OVER))
         {
            addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(!hasEventListener(FocusEvent.FOCUS_IN))
         {
            addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         }
      }
      
      public function unCacheAsBitmap() : void
      {
         _userData.cacheAsBitmap = false;
         if(!_userData.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            _userData.addEventListener(AnimationOldEvent.COMPLETE,reCacheAsBitmap);
         }
      }
      
      override public function defaultState() : void
      {
         super.defaultState();
         if(_userData !== null)
         {
            _userData.gotoAndStop("_active");
         }
      }
      
      public function setUserData(param1:*) : void
      {
         var _loc2_:MovieClip = null;
         if(_userData !== null && this.contains(_userData))
         {
            removeChild(_userData);
         }
         if(param1 is MovieClip)
         {
            _userData = new AnimationOld(param1);
         }
         else if(param1 is Class)
         {
            _loc2_ = new param1() as MovieClip;
            _userData = new AnimationOld(_loc2_);
         }
         addChild(_userData);
         _userData.cacheAsBitmap = true;
         _userData.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
      }
      
      override protected function updateVisualState() : void
      {
         if(_userData === null)
         {
            return;
         }
         if(_isSelected)
         {
            if(_isEnabled)
            {
               if(!_isOver)
               {
                  _userData.gotoAndStop("_selected");
               }
               else if(!talkedSelectedOver)
               {
                  if(!_userData.isPlaying && !SoundManagerOld.channelOccupied(1) && !SoundManager.isChannelBusy(SoundChannelDefinitions.VOX))
                  {
                     unCacheAsBitmap();
                     _userData.playOutLabel("_inactive_over");
                     talkedSelectedOver = true;
                     bindVoxChannel();
                  }
               }
            }
            else if(!_isOver)
            {
               _userData.gotoAndStop("_selected");
            }
            else
            {
               _userData.gotoAndStop("_selected");
            }
         }
         else if(_isEnabled)
         {
            if(_isOver)
            {
               if(!talkedUnselectedOver && !SoundManagerOld.channelOccupied(1) && !SoundManager.isChannelBusy(SoundChannelDefinitions.VOX))
               {
                  unCacheAsBitmap();
                  _userData.playOutLabel("_talking");
                  talkedUnselectedOver = true;
                  bindVoxChannel();
               }
               else if(!_userData.isPlaying && !SoundManagerOld.channelOccupied(1) && !SoundManager.isChannelBusy(SoundChannelDefinitions.VOX))
               {
                  unCacheAsBitmap();
                  _userData.playOutLabel("_over");
                  bindVoxChannel();
               }
            }
         }
         else if(!_isOver)
         {
            _userData.gotoAndStop("_active");
         }
         else
         {
            _userData.gotoAndStop("_active");
         }
      }
      
      override protected function removeEventListeners() : void
      {
         if(hasEventListener(MouseEvent.CLICK))
         {
            removeEventListener(MouseEvent.CLICK,handleClick);
         }
         if(hasEventListener(MouseEvent.MOUSE_OVER))
         {
            removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
         }
         if(hasEventListener(FocusEvent.FOCUS_IN))
         {
            removeEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         }
      }
      
      public function reCacheAsBitmap(param1:Event = null) : void
      {
         _userData.cacheAsBitmap = true;
         if(_userData.hasEventListener(AnimationOldEvent.COMPLETE))
         {
            _userData.removeEventListener(AnimationOldEvent.COMPLETE,reCacheAsBitmap);
         }
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
         _isOver = false;
         _isDown = false;
      }
      
      private function handleAnimComplete(param1:AnimationOldEvent) : void
      {
         unBindVoxChannel();
      }
      
      public function enterFrame(param1:Event) : void
      {
         ++counter;
         if(!startX)
         {
            startX = x;
         }
         this.x = startX + Math.sin(counter * 0.1);
      }
      
      protected function unBindVoxChannel() : void
      {
         if(occupiedAnimChannel)
         {
            SoundManagerOld.unSelectChannel(1);
         }
         occupiedAnimChannel = false;
      }
   }
}

