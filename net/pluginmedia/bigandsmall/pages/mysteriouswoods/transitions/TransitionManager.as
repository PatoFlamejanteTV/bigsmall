package net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.AbstractSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.PathSegment;
   import net.pluginmedia.maths.SineOscillator;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.utils.Easing;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   
   public class TransitionManager extends EventDispatcher
   {
      
      public static var TRANSITION_BEGINS:String = "TransitionManager.TRANSITION_BEGIN";
      
      public static var TRANSITION_ENDS:String = "TransitionManager.TRANSITION_COMPLETE";
      
      public var pageOffset:Number3D = Number3D.ZERO;
      
      private var transitionQueue:Array = [];
      
      private var smallBobVert:SineOscillator = new SineOscillator(10,55,0);
      
      private var bigBobHorz:SineOscillator = new SineOscillator(25,5,0);
      
      private var smallCamTargOffs:Number = 0.174;
      
      private var currentCamTargOffs:Number = 0;
      
      private var bigYOffs:Number = 410;
      
      private var bobWaveVert:SineOscillator = smallBobVert;
      
      private var progressTic:Number = 0;
      
      private var smallBobHorz:SineOscillator = new SineOscillator(8,25,0);
      
      public var camera:CameraObject3D;
      
      private var bigBobVert:SineOscillator = new SineOscillator(50,10,0);
      
      private var baseStepInc:Number = 0.025;
      
      private var currentPOV:String;
      
      private var _currentTransition:TransitionObject = null;
      
      public var yOffset:Number = 0;
      
      private var bigCamTargOffs:Number = -0.125;
      
      private var smallYOffs:Number = 210;
      
      private var bobWaveHorz:SineOscillator = smallBobHorz;
      
      public function TransitionManager(param1:CameraObject3D)
      {
         super();
         camera = param1;
         camera.y = yOffset;
      }
      
      public function doTransition(param1:PathSegment, param2:String, param3:Number = 1) : void
      {
         var _loc4_:AbstractSegment = param1.getTargetSegmentOfPath(param2);
         if(!param1 || !_loc4_)
         {
            return;
         }
         param1.deactivate();
         _loc4_.prepare();
         var _loc5_:TransitionObject = new TransitionObject(param1,param2,_loc4_);
         _loc5_.transStepInc = baseStepInc * param3;
         _loc5_.pathSegment = param1;
         _loc5_.reverse = false;
         _loc5_.sourceOrientation = param1.orientation;
         _loc5_.targetOrientation = _loc4_.orientation;
         transitionQueue.push(_loc5_);
         _currentTransition = _loc5_;
         dispatchEvent(new Event(TRANSITION_BEGINS));
      }
      
      public function update() : Boolean
      {
         if(_currentTransition)
         {
            stepTransition();
            return true;
         }
         return false;
      }
      
      public function doReverseTransition(param1:AbstractSegment, param2:String, param3:Number = 1) : void
      {
         var _loc4_:PathSegment = param1.previousSegment;
         if(!param1 || !_loc4_)
         {
            return;
         }
         param1.deactivate();
         _loc4_.prepare();
         var _loc5_:TransitionObject = new TransitionObject(param1,param2,_loc4_);
         _loc5_.transStepInc = baseStepInc * param3;
         _loc5_.pathSegment = _loc4_;
         _loc5_.reverse = true;
         _loc5_.sourceOrientation = param1.orientation;
         _loc5_.targetOrientation = _loc4_.orientation;
         transitionQueue.push(_loc5_);
         _currentTransition = _loc5_;
         dispatchEvent(new Event(TRANSITION_BEGINS));
      }
      
      public function updateCameraTarget(param1:Number) : void
      {
         var _loc2_:Matrix3D = Matrix3D.rotationY(-param1 * SuperMath.DEGREES_TO_RADS);
         var _loc3_:Number3D = new Number3D(0,0,100);
         Matrix3D.rotateAxis(_loc2_,_loc3_);
         camera.target.position = Number3D.add(camera.position,_loc3_);
         camera.target.y += currentCamTargOffs;
      }
      
      private function stepTransition() : void
      {
         progressTic += _currentTransition.transStepInc;
         var _loc1_:Number = Easing.easeOut(progressTic,0,1);
         _loc1_ = _currentTransition.reverse ? 1 - _loc1_ : _loc1_;
         _loc1_ = _loc1_ < 0 ? 0 : _loc1_;
         var _loc2_:Number3D = _currentTransition.pathSegment.getPositionOnPathAtTime(_currentTransition.pathKey,_loc1_);
         _loc2_.plusEq(pageOffset);
         _loc2_.y += yOffset;
         camera.position = _loc2_;
         var _loc3_:Number = _currentTransition.sourceOrientation + (_currentTransition.targetOrientation - _currentTransition.sourceOrientation) * (_currentTransition.reverse ? 1 - _loc1_ : _loc1_);
         camera.rotationY = _loc3_;
         updateCameraTarget(_loc3_);
         if(progressTic >= 1)
         {
            endTransition();
         }
      }
      
      public function purgeTransition(param1:TransitionObject) : void
      {
         var _loc2_:int = int(transitionQueue.indexOf(param1));
         if(_loc2_ > -1)
         {
            transitionQueue.splice(_loc2_,1);
         }
         if(_currentTransition == param1)
         {
            _currentTransition = null;
         }
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
         if(currentPOV == CharacterDefinitions.BIG)
         {
            camera.fov = 60;
            yOffset = bigYOffs;
            currentCamTargOffs = bigCamTargOffs;
         }
         else
         {
            camera.fov = 60;
            yOffset = smallYOffs;
            currentCamTargOffs = smallCamTargOffs;
         }
         camera.y = yOffset;
      }
      
      public function get currentTransition() : TransitionObject
      {
         return _currentTransition;
      }
      
      public function snapToSegment(param1:AbstractSegment, param2:Boolean = false) : void
      {
         camera.position = Number3D.add(param1.position,pageOffset);
         camera.y += yOffset;
         updateCameraTarget(param1.orientation);
         if(param2)
         {
            param1.prepare();
            param1.activate();
         }
      }
      
      private function endTransition() : void
      {
         camera.position = Number3D.add(_currentTransition.targetSegment.position,pageOffset);
         camera.y += yOffset;
         camera.rotationY = _currentTransition.targetOrientation;
         updateCameraTarget(_currentTransition.targetOrientation);
         _currentTransition.sourceSegment.park();
         _currentTransition.targetSegment.activate();
         dispatchEvent(new Event(TRANSITION_ENDS));
         purgeTransition(_currentTransition);
         progressTic = 0;
      }
      
      public function get isTransiting() : Boolean
      {
         if(_currentTransition)
         {
            return true;
         }
         return false;
      }
   }
}

