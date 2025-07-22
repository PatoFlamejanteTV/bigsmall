package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.geom.BezierSegment3D;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.PointSpriteMovieUpdater;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ThrowableBedroomObject extends DisplayObject3D
   {
      
      public static const FLIGHT_COMPLETE:String = "flightComplete";
      
      public static const FLIGHT_PROGRESS:String = "flightProgress";
      
      private var throwableMat:SpriteParticleMaterial;
      
      private var _animation:AnimationOld;
      
      private var currentFlightLength:uint;
      
      public var _onFloorSprite:PointSpriteMovieUpdater;
      
      private var _returnPath:BezierSegment3D;
      
      public var throwableObject:PointSprite;
      
      private var _onBed:Boolean;
      
      private var _onFloorClip:MovieClip;
      
      private var reversePath:Boolean;
      
      private var _bouncing:Boolean;
      
      private var _onFloor:Boolean;
      
      private var _clip:MovieClip;
      
      private var _visible:Boolean = true;
      
      private var _flying:Boolean;
      
      private var flyProgress:uint;
      
      private var _returning:Boolean;
      
      private var flyingClipLength:uint;
      
      private var _onFloorMat:SpriteParticleMaterial;
      
      private var _flightPath:BezierSegment3D;
      
      private var _bouncePath:BezierSegment3D;
      
      private var bouncingClipLength:uint = 12;
      
      public function ThrowableBedroomObject(param1:*, param2:*, param3:BezierSegment3D, param4:BezierSegment3D, param5:BezierSegment3D)
      {
         super();
         setFloorData(param1);
         setUserData(param2);
         _flightPath = param3;
         _bouncePath = param4;
         _returnPath = param5;
         _flying = false;
         _bouncing = false;
         _onBed = false;
         _onFloor = true;
         flyingClipLength = _animation.getLengthOfLabel("fly and hit");
         throwableMat = new SpriteParticleMaterial(_clip);
         throwableObject = new PointSprite(throwableMat);
         addChild(_onFloorSprite);
         addChild(throwableObject);
         positionFloorSprite();
         moveObject(0);
      }
      
      protected function positionFloorSprite() : void
      {
         var _loc1_:Number3D = _flightPath.getNumber3DAtT(0);
         _onFloorSprite.x = _loc1_.x;
         _onFloorSprite.y = _loc1_.y;
         _onFloorSprite.z = _loc1_.z;
      }
      
      protected function onImpactComplete(param1:AnimationOldEvent) : void
      {
         _animation.removeEventListener(AnimationOldEvent.COMPLETE,onImpactComplete);
         _animation.gotoAndStop(1);
      }
      
      protected function setUserData(param1:*) : void
      {
         if(param1 !== null)
         {
            _animation = getConcreteUserData(param1);
            _clip = _animation.subjectClip;
            park();
            return;
         }
         throw new Error("ThrowableBedroomObject :: setUserData :: null userdata passed into constructor");
      }
      
      protected function setFlying() : void
      {
         _flying = true;
         _bouncing = false;
         _returning = false;
      }
      
      protected function setFloorData(param1:*) : void
      {
         if(param1 !== null)
         {
            _onFloorClip = getConcreteUserData(param1).subjectClip;
            _onFloorMat = new SpriteParticleMaterial(_onFloorClip);
            _onFloorSprite = new PointSpriteMovieUpdater(_onFloorMat,-32.835,-0.084);
            return;
         }
         throw new Error("ThrowableBedroomObject :: setUserData :: null pointsprite data passed into constructor");
      }
      
      protected function stopFly() : void
      {
         if(_returning)
         {
            setPillowsOnStage(true,false);
         }
         else
         {
            setPillowsOnStage(false,true);
         }
         if(_flying)
         {
            _flying = false;
            _bouncing = true;
            _onBed = true;
            startFly();
            dispatchEvent(new Event(FLIGHT_COMPLETE));
            return;
         }
         if(_bouncing)
         {
            _bouncing = false;
            _onBed = true;
            _animation.gotoAndStop("on big");
         }
         else if(_returning)
         {
            _returning = false;
            _onFloor = true;
            _onBed = false;
         }
         _flying = false;
         _clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         dispatchEvent(new Event(FLIGHT_COMPLETE));
      }
      
      public function get onBed() : Boolean
      {
         return _onBed;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.visible = param1;
         if(!param1)
         {
            setPillowsOnStage(false,false);
         }
         else if(!onBed)
         {
            setPillowsOnStage(true,false);
         }
      }
      
      protected function startFly() : void
      {
         flyProgress = 0;
         _clip.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         if(!_bouncing)
         {
            _animation.playOutLabel("fly and hit");
            currentFlightLength = flyingClipLength;
         }
         else
         {
            currentFlightLength = bouncingClipLength;
         }
         setPillowsOnStage(false,true);
         moveObject(0);
         dispatchEvent(new Event(FLIGHT_PROGRESS));
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         ++flyProgress;
         if(flyProgress <= currentFlightLength)
         {
            _loc2_ = flyProgress / currentFlightLength;
            moveObject(_loc2_);
            dispatchEvent(new Event(FLIGHT_PROGRESS));
         }
         else
         {
            stopFly();
         }
      }
      
      protected function getConcreteUserData(param1:*) : AnimationOld
      {
         if(param1 is AnimationOld)
         {
            return param1;
         }
         if(param1 is MovieClip)
         {
            return new AnimationOld(param1);
         }
         if(param1 is Class)
         {
            return new AnimationOld(new param1());
         }
         return null;
      }
      
      protected function setBouncing() : void
      {
         _flying = false;
         _bouncing = true;
         _returning = false;
      }
      
      public function reset() : void
      {
         moveObject(0);
         _flying = false;
         _onFloor = false;
         _returning = true;
         _onBed = false;
         setPillowsOnStage(true,false);
      }
      
      public function flyToBed() : void
      {
         setFlying();
         _onFloor = false;
         startFly();
         _onFloorMat.removeSprite();
         setPillowsOnStage(false,true);
      }
      
      protected function setPillowsOnStage(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(_children[_onFloorSprite] == undefined)
            {
               addChild(_onFloorSprite);
            }
            _onFloorSprite.visible = true;
         }
         else
         {
            if(_children[_onFloorSprite] != undefined)
            {
               removeChild(_onFloorSprite);
            }
            _onFloorSprite.visible = false;
            _onFloorMat.removeSprite();
         }
         if(param2)
         {
            if(_children[throwableObject] == undefined)
            {
               addChild(throwableObject);
            }
            throwableObject.visible = true;
         }
         else
         {
            if(_children[throwableObject] != undefined)
            {
               removeChild(throwableObject);
            }
            throwableObject.visible = false;
            throwableMat.removeSprite();
         }
      }
      
      public function flyOffBed() : void
      {
         setReturning();
         _onFloor = false;
         _onBed = false;
         startFly();
      }
      
      public function park() : void
      {
         _animation.gotoAndStop(1);
      }
      
      public function get onFloor() : Boolean
      {
         return _onFloor;
      }
      
      protected function setReturning() : void
      {
         _flying = false;
         _bouncing = false;
         _returning = true;
      }
      
      protected function moveObject(param1:Number) : void
      {
         var _loc2_:Number3D = _flightPath.getNumber3DAtT(param1);
         if(_bouncing)
         {
            _loc2_ = _bouncePath.getNumber3DAtT(param1);
         }
         else if(_returning)
         {
            _loc2_ = _returnPath.getNumber3DAtT(param1);
         }
         else
         {
            _loc2_ = _flightPath.getNumber3DAtT(param1);
         }
         throwableObject.x = _loc2_.x;
         throwableObject.y = _loc2_.y;
         throwableObject.z = _loc2_.z;
      }
   }
}

