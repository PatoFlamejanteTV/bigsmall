package net.pluginmedia.bigandsmall.pages.bedroom.teddy
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.geom.BezierSegment3D;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ThrowableFreakyAssTeddy extends DisplayObject3D
   {
      
      public static const FLIGHT_COMPLETE:String = "flightComplete";
      
      public static const FLIGHT_PROGRESS:String = "flightProgress";
      
      private var throwableMat:SpriteParticleMaterial;
      
      private var _animation:AnimationOld;
      
      private var currentFlightLength:uint;
      
      private var _returnPath:BezierSegment3D;
      
      public var throwableObject:PointSprite;
      
      private var _onBed:Boolean;
      
      private var _bouncing:Boolean;
      
      private var reversePath:Boolean;
      
      private var _onFloor:Boolean;
      
      private var _clip:MovieClip;
      
      private var _flying:Boolean;
      
      private var _returning:Boolean;
      
      private var flyProgress:uint;
      
      private var _visible:Boolean = true;
      
      private var flyingClipLength:uint;
      
      private var _flightPath:BezierSegment3D;
      
      private var _bouncePath:BezierSegment3D;
      
      private var bouncingClipLength:uint = 12;
      
      public function ThrowableFreakyAssTeddy(param1:*, param2:BezierSegment3D, param3:BezierSegment3D, param4:BezierSegment3D)
      {
         super();
         setUserData(param1);
         _flightPath = param2;
         _bouncePath = param3;
         _returnPath = param4;
         _flying = false;
         _bouncing = false;
         _onBed = false;
         _onFloor = true;
         flyingClipLength = _animation.getLengthOfLabel("fly and hit");
         throwableMat = new SpriteParticleMaterial(_clip);
         throwableObject = new PointSprite(throwableMat);
         setPillowOnStage(true);
         positionFloorSprite();
         moveObject(0);
      }
      
      protected function positionFloorSprite() : void
      {
         var _loc1_:Number3D = _flightPath.getNumber3DAtT(0);
         throwableObject.x = _loc1_.x;
         throwableObject.y = _loc1_.y;
         throwableObject.z = _loc1_.z;
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
      
      protected function stopFly() : void
      {
         if(_flying)
         {
            _flying = false;
            _bouncing = true;
            startFly();
            dispatchEvent(new Event(FLIGHT_COMPLETE));
            return;
         }
         if(_bouncing)
         {
            _bouncing = false;
            _onBed = true;
            _animation.gotoAndStop("start");
         }
         else if(_returning)
         {
            _returning = false;
            _onFloor = true;
            _onBed = false;
            _animation.gotoAndStop("start");
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
            throwableMat.removeSprite();
            setPillowOnStage(false);
         }
         else if(!onBed)
         {
            setPillowOnStage(true);
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
         setPillowOnStage(true);
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
      
      public function reset() : void
      {
         _returning = false;
         _flying = false;
         _bouncing = false;
         _onBed = false;
         moveObject(0);
         setPillowOnStage(true);
      }
      
      public function flyToBed() : void
      {
         _flying = true;
         _onFloor = false;
         _returning = false;
         startFly();
         setPillowOnStage(true);
      }
      
      public function flyOffBed() : void
      {
         _returning = true;
         _flying = false;
         _bouncing = false;
         _onBed = false;
         startFly();
      }
      
      public function park() : void
      {
         _animation.gotoAndStop(1);
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
      
      public function get onFloor() : Boolean
      {
         return _onFloor;
      }
      
      protected function setPillowOnStage(param1:Boolean) : void
      {
         if(param1)
         {
            if(_children[throwableObject] == undefined)
            {
               addChild(throwableObject);
            }
         }
         else if(_children[throwableObject] != undefined)
         {
            removeChild(throwableObject);
         }
      }
   }
}

