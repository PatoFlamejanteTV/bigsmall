package net.pluginmedia.bigandsmall.pages.garden.pond.fish
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.garden.GardenDAEController;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class PondFishManager extends DisplayObject3D
   {
      
      public static var ANIM_BEGINS:String = "PondFishManager.ANIM_BEGINS";
      
      public static var ANIM_COMPLETE:String = "PondFishManager.ANIM_COMPLETE";
      
      public static var LILYPAD_ROLLOVER:String = "PondFishManager.LILYPAD_ROLLOVER";
      
      private var reflBlur:BlurFilter;
      
      private var daeController:GardenDAEController;
      
      private var reflFishKeys:Array = [];
      
      private var cTransform:ColorTransform;
      
      private var dirtyFish:Array = [];
      
      public var reflectingFishes:Dictionary = new Dictionary();
      
      private var _isActive:Boolean = false;
      
      private var reflHeightOffset:Number = 15;
      
      public var currentLiveFish:ReflectingFish;
      
      public function PondFishManager(param1:GardenDAEController, param2:BlurFilter, param3:ColorTransform)
      {
         super();
         daeController = param1;
         reflBlur = param2;
         cTransform = param3;
      }
      
      public function activate() : void
      {
         var _loc1_:ReflectingFish = null;
         _isActive = true;
         for each(_loc1_ in reflectingFishes)
         {
            _loc1_.setLiveStatus();
         }
      }
      
      private function resetPlanes() : void
      {
         var _loc1_:ReflectingFish = null;
         for each(_loc1_ in reflectingFishes)
         {
            _loc1_.reset();
         }
      }
      
      public function update() : void
      {
         var _loc1_:ReflectingFish = null;
         for each(_loc1_ in reflectingFishes)
         {
            _loc1_.update();
         }
      }
      
      public function get isActive() : Boolean
      {
         return _isActive;
      }
      
      private function handleFishDirtyFlagOverride(param1:Event) : void
      {
         var _loc2_:ReflectingFish = param1.target as ReflectingFish;
         if(dirtyFish.indexOf(_loc2_) == -1)
         {
            dirtyFish.push(_loc2_);
         }
      }
      
      public function registerAnim(param1:String, param2:MovieClip, param3:MovieClip, param4:String, param5:String, param6:Number, param7:Number, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:Number = 0) : ReflectingFish
      {
         var _loc12_:ReflectingFish = new ReflectingFish(param2,param3,param4,param5,param6,param7,daeController.abovePondLyr,daeController.beneathPondLyr);
         _loc12_.x = param8;
         _loc12_.y = param9;
         _loc12_.z = param10;
         _loc12_.rotationY = param11;
         addReflectingFishListeners(_loc12_);
         addChild(_loc12_);
         reflectingFishes[param1] = _loc12_;
         reflFishKeys.push(param1);
         return _loc12_;
      }
      
      private function handleFishDirtyFlagOn(param1:Event) : void
      {
         var _loc2_:ReflectingFish = null;
         var _loc3_:ReflectingFish = null;
         currentLiveFish = param1.target as ReflectingFish;
         for each(_loc2_ in reflectingFishes)
         {
            if(_loc2_ != currentLiveFish)
            {
               _loc2_.unsetLiveStatus();
            }
         }
         _loc3_ = param1.target as ReflectingFish;
         if(dirtyFish.indexOf(_loc3_) == -1)
         {
            dirtyFish.push(_loc3_);
         }
         dispatchEvent(new Event(ANIM_BEGINS));
      }
      
      private function addReflectingFishListeners(param1:ReflectingFish) : void
      {
         param1.addEventListener(ReflectingFish.OVERRIDE_DIRTYFLAG,handleFishDirtyFlagOverride);
         param1.addEventListener(ReflectingFish.PLAYOUT_BEGINS,handleFishDirtyFlagOn);
         param1.addEventListener(ReflectingFish.PLAYOUT_ENDS,handleFishDirtyFlagOff);
         param1.addEventListener(ReflectingFish.ROLLOVER_LILYPAD,handleLilypadOver);
         param1.addEventListener(ReflectingFish.PLAYOUT_COMPLETE,handleLivePlaneAnimComplete);
      }
      
      private function removeReflectingFishListeners(param1:ReflectingFish) : void
      {
         param1.removeEventListener(ReflectingFish.OVERRIDE_DIRTYFLAG,handleFishDirtyFlagOverride);
         param1.removeEventListener(ReflectingFish.PLAYOUT_BEGINS,handleFishDirtyFlagOn);
         param1.removeEventListener(ReflectingFish.PLAYOUT_ENDS,handleFishDirtyFlagOff);
         param1.removeEventListener(ReflectingFish.ROLLOVER_LILYPAD,handleLilypadOver);
         param1.removeEventListener(ReflectingFish.PLAYOUT_COMPLETE,handleLivePlaneAnimComplete);
      }
      
      public function setCharacter(param1:String) : void
      {
         if(_isActive)
         {
            resetPlanes();
         }
      }
      
      public function park() : void
      {
         resetPlanes();
      }
      
      public function get currentFishKey() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         for each(_loc2_ in reflFishKeys)
         {
            if(reflectingFishes[_loc2_] == currentLiveFish)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         return _loc1_;
      }
      
      private function handleFishDirtyFlagOff(param1:Event) : void
      {
         var _loc2_:ReflectingFish = param1.target as ReflectingFish;
         var _loc3_:int = int(dirtyFish.indexOf(_loc2_));
         if(_loc3_ != -1)
         {
            dirtyFish.splice(_loc3_,1);
         }
      }
      
      public function deactivate() : void
      {
         _isActive = false;
         resetPlanes();
      }
      
      private function handleLilypadOver(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function getRandomLivePlane() : ReflectingFish
      {
         var _loc1_:int = SuperMath.random(0,reflFishKeys.length);
         var _loc2_:String = reflFishKeys[_loc1_];
         return reflectingFishes[_loc2_];
      }
      
      public function get dirtyLayers() : Array
      {
         var _loc2_:ReflectingFish = null;
         var _loc1_:Array = [];
         for each(_loc2_ in dirtyFish)
         {
            _loc1_.push(_loc2_.animLayer);
            _loc1_.push(_loc2_.reflLayer);
         }
         return _loc1_;
      }
      
      private function handleLivePlaneAnimComplete(param1:Event) : void
      {
         var _loc2_:ReflectingFish = null;
         dispatchEvent(new Event(ANIM_COMPLETE));
         for each(_loc2_ in reflectingFishes)
         {
            _loc2_.setLiveStatus();
         }
         currentLiveFish = null;
      }
   }
}

