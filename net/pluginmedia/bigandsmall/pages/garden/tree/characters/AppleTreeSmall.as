package net.pluginmedia.bigandsmall.pages.garden.tree.characters
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleParticle;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleTreeFloor;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class AppleTreeSmall extends DisplayObject3D
   {
      
      public static const EV_REMOVE_APPLE:String = "removeSceneApple";
      
      public static const EV_ANIM_COMPLETE:String = "animComplete";
      
      public static const GAME_COMPLETE:String = "gameComplete";
      
      public var rightSprite:PointSprite;
      
      public var exitSprite:PointSprite;
      
      private var exiting:Boolean = false;
      
      public var pickUpSprite:PointSprite;
      
      private var floor:AppleTreeFloor;
      
      public var stillSprite:PointSprite;
      
      private var exitClip:MovieClip;
      
      private var speakChannelRef:String;
      
      private var rightClip:MovieClip;
      
      private var callbackOnVoxComplete:Function;
      
      private var pickUpClip:MovieClip;
      
      private var stillClip:MovieClip;
      
      private var promptQueue:Array = [];
      
      public var leftSprite:PointSprite;
      
      private var _isTalking:Boolean = false;
      
      private var promptQueueSize:int = 2;
      
      private var smallSprite:PointSprite;
      
      private var applesPickedUp:uint;
      
      private var sharedMat:SpriteParticleMaterial;
      
      private var defaultMouthShape:String = "a";
      
      public var viewportLayer:ViewportLayer;
      
      private var applesOnFloor:Array;
      
      private var currentMov:MovieClip;
      
      public var totalNumberOfApples:uint = 5;
      
      private var voxControllerLibrary:Dictionary = new Dictionary();
      
      private var destApple:AppleParticle;
      
      private var leftClip:MovieClip;
      
      public var runSpeed:Number = 10;
      
      private var destX:Number;
      
      public function AppleTreeSmall(param1:String, param2:AppleTreeFloor, param3:MovieClip, param4:MovieClip, param5:MovieClip, param6:MovieClip, param7:MovieClip)
      {
         super();
         speakChannelRef = param1;
         this.floor = param2;
         this.z = param2.z;
         stillClip = param3;
         stillClip.gotoAndStop(1);
         leftClip = param4;
         leftClip.gotoAndStop(1);
         rightClip = param5;
         rightClip.gotoAndStop(1);
         pickUpClip = param6;
         pickUpClip.stop();
         pickUpClip.addEventListener(EV_ANIM_COMPLETE,handlePickUpComplete);
         pickUpClip.addEventListener(EV_REMOVE_APPLE,handleRemoveSceneApple);
         exitClip = param7;
         exitClip.gotoAndStop(1);
         sharedMat = new SpriteParticleMaterial(new MovieClip());
         smallSprite = new PointSprite(sharedMat,0.7);
         addChild(smallSprite);
         reset();
      }
      
      public function prepare() : void
      {
         promptQueue = [];
      }
      
      private function updateApplesOnDisplay(param1:MovieClip) : void
      {
         var _loc3_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = 1;
         while(_loc2_ < 6)
         {
            _loc3_ = param1["apple" + _loc2_];
            if(_loc2_ > applesPickedUp)
            {
               _loc3_.visible = false;
            }
            else
            {
               _loc3_.visible = true;
            }
            _loc2_++;
         }
      }
      
      public function show() : void
      {
         addChild(smallSprite);
      }
      
      public function exit() : void
      {
         updateApplesOnDisplay(exitClip.apple_basket);
         exiting = true;
         if(currentMov != exitClip)
         {
            setSmallMatState(exitClip);
         }
      }
      
      private function setSmallMatState(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = sharedMat.movie as MovieClip;
         _loc2_.gotoAndStop(1);
         sharedMat.movie = currentMov = param1;
         param1.play();
      }
      
      private function handleControllerClipAdded(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = "MouthShape_";
         if(_loc2_.name.substr(0,_loc3_.length) == _loc3_)
         {
            _loc4_ = _loc2_.name.substr(_loc3_.length);
            mouthShapeToLabel(_loc4_);
         }
      }
      
      public function actLine(param1:String, param2:Boolean = false, param3:Function = null) : void
      {
         if(SoundManager.isChannelBusy(speakChannelRef) && !param2)
         {
            if(promptQueue.length >= promptQueueSize)
            {
               promptQueue.shift();
            }
            promptQueue.push({
               "label":param1,
               "callback":param3
            });
            return;
         }
         if(SoundManager.isChannelBusy(speakChannelRef))
         {
            SoundManager.stopChannel(speakChannelRef);
         }
         callbackOnVoxComplete = param3;
         var _loc4_:MovieClip = voxControllerLibrary[param1];
         if(!_loc4_)
         {
            return;
         }
         SoundManager.playSyncAnimSound(_loc4_,param1,speakChannelRef,25,1,0,0,0,handleSyncComplete);
         _isTalking = true;
      }
      
      private function handleRemoveSceneApple(param1:Event) : void
      {
         if(destApple)
         {
            destApple.pickedUp();
         }
      }
      
      public function registerVox(param1:String, param2:MovieClip, param3:Sound) : void
      {
         SoundManager.quickRegisterSound(param1,param3,1);
         param2.stop();
         param2.addEventListener(Event.ADDED,handleControllerClipAdded);
         voxControllerLibrary[param1] = param2;
      }
      
      private function handlePickUpComplete(param1:Event) : void
      {
         pickUpClip.stop();
         ++applesPickedUp;
         updateApplesDisplayed();
         destApple = null;
         stillClip.scaleX = pickUpClip.scaleX;
         setSmallMatState(stillClip);
         checkApplesOnFloor();
      }
      
      private function handleSyncComplete() : void
      {
         mouthShapeToLabel(defaultMouthShape);
         _isTalking = false;
         if(callbackOnVoxComplete is Function)
         {
            callbackOnVoxComplete.apply(this);
         }
         callbackOnVoxComplete = null;
      }
      
      public function get isTalking() : Boolean
      {
         return _isTalking;
      }
      
      public function mouthShapeToLabel(param1:String) : void
      {
         if(currentMov.mouth)
         {
            currentMov.mouth.gotoAndStop(param1);
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         if(exiting)
         {
            return;
         }
         if(!SoundManager.isChannelBusy(speakChannelRef) && promptQueue.length > 0)
         {
            _loc5_ = promptQueue.shift();
            actLine(_loc5_.label,false,_loc5_.callback);
         }
         if(destApple)
         {
            _loc2_ = destApple.x;
         }
         else
         {
            _loc2_ = destX;
         }
         if(_loc2_ == this.x && (destApple == null || currentMov == pickUpClip))
         {
            if(destApple == null && !exiting)
            {
               setSmallMatState(stillClip);
               return;
            }
            if(currentMov != stillClip)
            {
               return;
            }
            return;
         }
         var _loc3_:Number = this.x;
         if(param1)
         {
            _loc4_ = _loc2_;
         }
         else
         {
            _loc6_ = (_loc2_ - _loc3_) / runSpeed;
            _loc6_ = SuperMath.clamp(_loc6_,-1,1);
            _loc4_ = _loc3_ + runSpeed * _loc6_;
         }
         if(_loc4_ == _loc2_)
         {
            destX = _loc4_;
            if(destApple)
            {
               applesOnFloor.splice(applesOnFloor.indexOf(destApple),1);
               if(currentMov == leftClip)
               {
                  pickUpClip.scaleX = 1;
               }
               else
               {
                  pickUpClip.scaleX = -1;
               }
               setSmallMatState(pickUpClip);
               pickUpClip.gotoAndPlay(1);
            }
            else
            {
               checkApplesOnFloor();
            }
         }
         this.x = _loc4_;
         this.y = floor.getYFromX(_loc4_);
      }
      
      private function checkApplesOnFloor() : void
      {
         var _loc2_:AppleParticle = null;
         var _loc4_:AppleParticle = null;
         var _loc5_:Number = NaN;
         if(applesOnFloor.length <= 0)
         {
            return;
         }
         var _loc1_:Number = this.x;
         var _loc3_:Number = Number.MAX_VALUE;
         for each(_loc4_ in applesOnFloor)
         {
            _loc5_ = Math.abs(_loc1_ - _loc4_.x);
            if(_loc5_ < _loc3_)
            {
               _loc3_ = _loc5_;
               _loc2_ = _loc4_;
            }
         }
         if(_loc2_.x < this.x)
         {
            setSmallMatState(leftClip);
         }
         else
         {
            setSmallMatState(rightClip);
         }
         destApple = _loc2_;
      }
      
      public function reset() : void
      {
         applesOnFloor = [];
         setSmallMatState(rightClip);
         applesPickedUp = 0;
         exitClip.gotoAndStop(1);
         updateApplesDisplayed();
         exiting = false;
         destApple = null;
         this.x = -700;
         destX = 0;
         this.y = floor.getYFromX(this.x);
         update();
      }
      
      public function hide() : void
      {
         removeChild(smallSprite);
         removeMaterialSprite();
      }
      
      public function park() : void
      {
         hide();
      }
      
      public function removeMaterialSprite() : void
      {
         sharedMat.removeSprite();
      }
      
      public function appleHitsFloor(param1:AppleParticle) : void
      {
         applesOnFloor.push(param1);
         if(currentMov != pickUpClip)
         {
            checkApplesOnFloor();
         }
      }
      
      public function activate() : void
      {
         reset();
         show();
      }
      
      public function deactivate() : void
      {
         SoundManager.stopChannel(speakChannelRef);
         promptQueue = [];
         mouthShapeToLabel("a");
         exit();
      }
      
      private function updateApplesDisplayed() : void
      {
         updateApplesOnDisplay(leftClip.apple_basket);
         updateApplesOnDisplay(rightClip.apple_basket);
         updateApplesOnDisplay(stillClip.apple_basket);
         updateApplesOnDisplay(pickUpClip.apple_basket);
         updateApplesOnDisplay(exitClip.apple_basket);
      }
   }
}

