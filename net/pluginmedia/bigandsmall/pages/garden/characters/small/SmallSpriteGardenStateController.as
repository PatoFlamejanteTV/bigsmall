package net.pluginmedia.bigandsmall.pages.garden.characters.small
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.pluginmedia.bigandsmall.pages.garden.characters.IGardenCharacter;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class SmallSpriteGardenStateController extends DisplayObject3D implements IGardenCharacter
   {
      
      public static var STATE_RUN:String = "SmallSpriteGardenStateController.RUN";
      
      public static var STATE_JUMP:String = "SmallSpriteGardenStateController.JUMP";
      
      public static var STATE_NULL:String = "SmallSpriteGardenStateController.NULL";
      
      private var speakChannelRef:String;
      
      private var nextStateTimer:Timer;
      
      private var targetState:ISmallGardenState;
      
      private var currentState:ISmallGardenState;
      
      private var voxControllerLibrary:Dictionary = new Dictionary();
      
      private var stateRotationIndex:int = 0;
      
      public var stateRotations:Array = [STATE_JUMP,STATE_RUN];
      
      private var stateLibrary:Dictionary = new Dictionary();
      
      public var stateLabel:String = STATE_NULL;
      
      private var isPerformingStateChange:Boolean = false;
      
      public function SmallSpriteGardenStateController(param1:String)
      {
         speakChannelRef = param1;
         super();
         nextStateTimer = new Timer(2000);
         nextStateTimer.addEventListener(TimerEvent.TIMER,handleNextStateTimer);
      }
      
      private function currentStateOutroToTargetState(param1:ISmallGardenState = null) : void
      {
         targetState = param1;
         currentState.addEventListener(currentState.OUTRO_COMPLETE,handleOutroComplete);
         isPerformingStateChange = true;
         currentState.deactivate();
      }
      
      private function handleSyncComplete() : void
      {
         if(currentState)
         {
            currentState.mouthShapeToLabel(currentState.DEFAULTMOUTHLABEL);
            currentState.isTalking = false;
         }
      }
      
      private function killNextStateTimer() : void
      {
         nextStateTimer.reset();
         nextStateTimer.stop();
      }
      
      public function update() : void
      {
         if(currentState)
         {
            currentState.update();
         }
      }
      
      public function activate() : void
      {
         selectState(stateRotations[stateRotationIndex]);
      }
      
      private function handleControllerClipAdded(param1:Event) : void
      {
         var _loc4_:String = null;
         if(!currentState)
         {
            return;
         }
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = "MouthShape_";
         if(_loc2_.name.substr(0,_loc3_.length) == _loc3_)
         {
            _loc4_ = _loc2_.name.substr(_loc3_.length);
            currentState.mouthShapeToLabel(_loc4_);
         }
      }
      
      public function selectNextState() : void
      {
         stateRotationIndex = (stateRotationIndex + 1) % stateRotations.length;
         selectState(stateRotations[stateRotationIndex]);
      }
      
      public function get isTalking() : Boolean
      {
         return SoundManager.isChannelBusy(speakChannelRef);
      }
      
      private function handleOutroComplete(param1:Event) : void
      {
         currentState.removeEventListener(currentState.OUTRO_COMPLETE,handleOutroComplete);
         removeChild(currentState as DisplayObject3D);
         currentState.park();
         if(targetState != null)
         {
            currentState = targetState;
            addChild(currentState as DisplayObject3D);
            currentState.activate();
         }
         else
         {
            currentState = null;
         }
         targetState = null;
         isPerformingStateChange = false;
      }
      
      private function handleNextStateTimer(param1:TimerEvent) : void
      {
         killNextStateTimer();
         selectNextState();
      }
      
      public function prepare() : void
      {
      }
      
      public function speakLine(param1:String) : void
      {
         if(SoundManager.isChannelBusy(speakChannelRef) || !currentState || SoundManagerOld.channelOccupied(1))
         {
            return;
         }
         var _loc2_:MovieClip = voxControllerLibrary[param1];
         if(!_loc2_)
         {
            return;
         }
         SoundManager.playSyncAnimSound(_loc2_,param1,speakChannelRef,26,1,0,0,0,handleSyncComplete);
         currentState.isTalking = true;
      }
      
      private function handleStateExpired(param1:Event) : void
      {
         currentStateOutroToTargetState(null);
         nextStateTimer.start();
      }
      
      public function flushState() : void
      {
         if(isPerformingStateChange)
         {
            currentState.removeEventListener(currentState.OUTRO_COMPLETE,handleOutroComplete);
         }
         if(currentState)
         {
            currentState.park();
            removeChild(currentState as DisplayObject3D);
            currentState = null;
         }
      }
      
      public function registerState(param1:ISmallGardenState, param2:String) : void
      {
         stateLibrary[param2] = param1;
         addStateListeners(param1);
      }
      
      private function addStateListeners(param1:ISmallGardenState) : void
      {
         param1.addEventListener(SmallGardenStateBase.STATE_EXPIRED,handleStateExpired);
      }
      
      public function park() : void
      {
         stateRotationIndex = 0;
         if(currentState)
         {
            selectState(STATE_NULL);
         }
      }
      
      public function deactivate() : void
      {
         killNextStateTimer();
         targetState = null;
         if(Boolean(currentState) && !isPerformingStateChange)
         {
            currentState.deactivate();
         }
      }
      
      public function selectState(param1:String) : void
      {
         var _loc2_:ISmallGardenState = null;
         if(param1 == STATE_NULL)
         {
            flushState();
            stateLabel = STATE_NULL;
            return;
         }
         if(!isPerformingStateChange)
         {
            _loc2_ = stateLibrary[param1];
            if(!_loc2_)
            {
               return;
            }
            stateLabel = param1;
            if(!currentState)
            {
               currentState = _loc2_;
               addChild(currentState as DisplayObject3D);
               currentState.activate();
               targetState = null;
               return;
            }
            if(currentState !== _loc2_)
            {
               currentStateOutroToTargetState(_loc2_);
               return;
            }
            return;
         }
      }
      
      public function get dirtyLayer() : ViewportLayer
      {
         if(currentState)
         {
            return currentState.viewportLayer;
         }
         return null;
      }
      
      public function registerVox(param1:String, param2:MovieClip, param3:Sound) : void
      {
         SoundManager.quickRegisterSound(param1,param3,1);
         param2.stop();
         param2.addEventListener(Event.ADDED,handleControllerClipAdded);
         voxControllerLibrary[param1] = param2;
      }
   }
}

