package net.pluginmedia.bigandsmall.pages.garden.pond.frogs
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.garden.GardenDAEController;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class PondFrogManager extends DisplayObject3D
   {
      
      public static var NULL_ANIM_BEGINS:String = "PondFrogManager.NULL_ANIM_BEGINS";
      
      public static var ANIM_BEGINS:String = "PondFrogManager.ANIM_BEGINS";
      
      public static var ANIM_COMPLETE:String = "PondFrogManager.ANIM_COMPLETE";
      
      public static var ROLLOVER_REEDS:String = "PondFrogManager.ROLLOVER_REEDS";
      
      private var reflBlur:BlurFilter;
      
      public var prevLiveFrog:ReflectingFrog;
      
      private var daeController:GardenDAEController;
      
      public var currentLiveFrog:ReflectingFrog;
      
      public var reflectingFrogs:Dictionary = new Dictionary();
      
      private var cTransform:ColorTransform;
      
      private var reflFrogKeys:Array = [];
      
      private var dirtyFrogs:Array = [];
      
      private var currentPOV:String;
      
      private var _isActive:Boolean = false;
      
      private var reflHeightOffset:Number = 0;
      
      public function PondFrogManager(param1:GardenDAEController, param2:BlurFilter, param3:ColorTransform)
      {
         super();
         daeController = param1;
         reflBlur = param2;
         cTransform = param3;
      }
      
      public function activate() : void
      {
         _isActive = true;
         chooseRandomLivePlane();
      }
      
      private function removeLivePlaneListeners(param1:ReflectingFrog) : void
      {
         param1.removeEventListener(ReflectingFrog.PLAYOUT_COMPLETE,handleLivePlaneAnimComplete);
      }
      
      private function resetPlanes() : void
      {
         var _loc1_:ReflectingFrog = null;
         for each(_loc1_ in reflectingFrogs)
         {
            _loc1_.reset();
         }
      }
      
      public function setLivePlane(param1:ReflectingFrog) : void
      {
         unsetLivePlane();
         currentLiveFrog = param1;
         prevLiveFrog = currentLiveFrog;
         addLivePlaneListeners(currentLiveFrog);
         currentLiveFrog.setLiveStatus();
      }
      
      private function addReflectingFrogListeners(param1:ReflectingFrog) : void
      {
         param1.addEventListener(ReflectingFrog.PLAYOUT_BEGINS,handleFrogPlayoutBegins);
         param1.addEventListener(ReflectingFrog.NULL_PLAYOUT_BEGINS,handleFrogNullPlayoutBegins);
         param1.addEventListener(MouseEvent.ROLL_OVER,handleFrogOver);
         param1.addEventListener(ReflectingFrog.DIRTYFLAG_ON,handleFrogDirtyFlagOn);
         param1.addEventListener(ReflectingFrog.DIRTYFLAG_OFF,handleFrogDirtyFlagOff);
      }
      
      public function get isActive() : Boolean
      {
         return _isActive;
      }
      
      private function handleFrogPlayoutBegins(param1:Event) : void
      {
         dispatchEvent(new Event(ANIM_BEGINS));
         var _loc2_:ReflectingFrog = param1.target as ReflectingFrog;
         if(dirtyFrogs.indexOf(_loc2_) == -1)
         {
            dirtyFrogs.push(_loc2_);
         }
      }
      
      public function registerAnim(param1:String, param2:MovieClip, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 1) : ReflectingFrog
      {
         var _loc9_:ReflectingFrog = new ReflectingFrog(param2,daeController.abovePondLyr,daeController.beneathPondLyr);
         _loc9_.x = param3;
         _loc9_.y = param4;
         _loc9_.z = param5;
         _loc9_.rotationY = param6;
         _loc9_.scale = param8;
         _loc9_.yOffset = param7;
         addChild(_loc9_);
         addReflectingFrogListeners(_loc9_);
         reflectingFrogs[param1] = _loc9_;
         reflFrogKeys.push(param1);
         return _loc9_;
      }
      
      private function addLivePlaneListeners(param1:ReflectingFrog) : void
      {
         param1.addEventListener(ReflectingFrog.PLAYOUT_COMPLETE,handleLivePlaneAnimComplete);
      }
      
      private function handleFrogNullPlayoutBegins(param1:Event) : void
      {
         dispatchEvent(new Event(NULL_ANIM_BEGINS));
      }
      
      private function removeReflectingFrogListeners(param1:ReflectingFrog) : void
      {
         param1.removeEventListener(ReflectingFrog.PLAYOUT_BEGINS,handleFrogPlayoutBegins);
         param1.removeEventListener(ReflectingFrog.NULL_PLAYOUT_BEGINS,handleFrogNullPlayoutBegins);
         param1.removeEventListener(MouseEvent.ROLL_OVER,handleFrogOver);
         param1.removeEventListener(ReflectingFrog.DIRTYFLAG_ON,handleFrogDirtyFlagOn);
         param1.removeEventListener(ReflectingFrog.DIRTYFLAG_OFF,handleFrogDirtyFlagOff);
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
         unsetLivePlane();
         resetPlanes();
      }
      
      public function get currentFrogKey() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         for each(_loc2_ in reflFrogKeys)
         {
            if(reflectingFrogs[_loc2_] == currentLiveFrog)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         return _loc1_;
      }
      
      public function park() : void
      {
         unsetLivePlane();
         resetPlanes();
      }
      
      public function unsetLivePlane() : void
      {
         if(currentLiveFrog)
         {
            currentLiveFrog.unsetLiveStatus();
            removeLivePlaneListeners(currentLiveFrog);
            currentLiveFrog = null;
         }
      }
      
      public function deactivate() : void
      {
         _isActive = false;
      }
      
      public function chooseRandomLivePlane() : void
      {
         var _loc1_:ReflectingFrog = getRandomLivePlane();
         if(reflFrogKeys.length > 1)
         {
            while(_loc1_ === prevLiveFrog)
            {
               _loc1_ = getRandomLivePlane();
            }
         }
         setLivePlane(_loc1_);
      }
      
      private function handleFrogOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLLOVER_REEDS));
      }
      
      private function getRandomLivePlane() : ReflectingFrog
      {
         var _loc1_:int = SuperMath.random(0,reflFrogKeys.length);
         var _loc2_:String = reflFrogKeys[_loc1_];
         return reflectingFrogs[_loc2_];
      }
      
      public function get dirtyLayers() : Array
      {
         var _loc2_:ReflectingFrog = null;
         var _loc1_:Array = [];
         for each(_loc2_ in dirtyFrogs)
         {
            _loc1_.push(_loc2_.animLayer);
            _loc1_.push(_loc2_.reflLayer);
         }
         return _loc1_;
      }
      
      private function handleFrogDirtyFlagOff(param1:Event) : void
      {
         var _loc2_:ReflectingFrog = param1.target as ReflectingFrog;
         var _loc3_:int = int(dirtyFrogs.indexOf(_loc2_));
         if(_loc3_ != -1)
         {
            dirtyFrogs.splice(_loc3_,1);
         }
      }
      
      private function handleFrogDirtyFlagOn(param1:Event) : void
      {
         var _loc2_:ReflectingFrog = param1.target as ReflectingFrog;
         if(dirtyFrogs.indexOf(_loc2_) == -1)
         {
            dirtyFrogs.push(_loc2_);
         }
      }
      
      private function handleLivePlaneAnimComplete(param1:Event) : void
      {
         dispatchEvent(new Event(ANIM_COMPLETE));
         chooseRandomLivePlane();
      }
   }
}

