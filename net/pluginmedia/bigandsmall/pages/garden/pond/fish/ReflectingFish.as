package net.pluginmedia.bigandsmall.pages.garden.pond.fish
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.mesh.AnimationPlane;
   import net.pluginmedia.bigandsmall.core.mesh.CharacterAnimationPlane;
   import net.pluginmedia.bigandsmall.core.mesh.ReflectionPlane;
   import net.pluginmedia.bigandsmall.pages.garden.pond.IControllablePondInteractive;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class ReflectingFish extends ReflectionPlane implements IControllablePondInteractive
   {
      
      public static var ROLLOVER_LILYPAD:String = "FishAnimationComposite.ROLLOVER_LILYPAD";
      
      public static var PLAYOUT_COMPLETE:String = "FishAnimationComposite.PLAYOUT_COMPLETE";
      
      public static var OVERRIDE_DIRTYFLAG:String = "FishAnimationComposite.OVERRIDE_DIRTYFLAG";
      
      public static var PLAYOUT_BEGINS:String = "FishAnimationComposite.PLAYOUT_BEGINS";
      
      public static var PLAYOUT_ENDS:String = "FishAnimationComposite.PLAYOUT_ENDS";
      
      public var animLayer:ViewportLayer;
      
      private var sfxLiftPad:String;
      
      protected var _viewportLayer:ViewportLayer;
      
      protected var _isLive:Boolean = false;
      
      private var sfxOverPad:String;
      
      private var _dirtyFlagOn:Boolean = false;
      
      public var reflLayer:ViewportLayer;
      
      public var lilyPlane:LilyPadPlane;
      
      public function ReflectingFish(param1:MovieClip, param2:MovieClip, param3:String, param4:String, param5:Number = 150, param6:Number = 0, param7:ViewportLayer = null, param8:ViewportLayer = null)
      {
         super(new CharacterAnimationPlane(param1));
         sfxOverPad = param3;
         sfxLiftPad = param4;
         lilyPlane = new LilyPadPlane(param2,param5,param5,2,4,param6);
         lilyPlane.addEventListener(LilyPadPlane.DID_UPDATE_MESH,handleLilyPadUpdate);
         addChild(lilyPlane);
         animLayer = param7.getChildLayer(animationPlane,true,true);
         animLayer.getChildLayer(lilyPlane,true,true);
         viewportLayer = animLayer;
         reflLayer = param8.getChildLayer(reflectionPlane,true,true);
         addFishCompListeners();
      }
      
      protected function handleVPLOut(param1:MouseEvent) : void
      {
         if(!animationPlane.isPlaying)
         {
            lilyPlane.curlFtarg = 0;
         }
      }
      
      public function update() : void
      {
         lilyPlane.update();
      }
      
      protected function handleLilyPadUpdate(param1:Event) : void
      {
         dispatchEvent(new Event(OVERRIDE_DIRTYFLAG));
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      public function unsetLiveStatus() : void
      {
         _isLive = false;
         lilyPlane.reset();
         animationPlane.gotoAndStop(1);
      }
      
      protected function removeVPLListeners() : void
      {
         _viewportLayer.removeEventListener(MouseEvent.CLICK,handleVPLClick);
         _viewportLayer.removeEventListener(MouseEvent.ROLL_OVER,handleVPLOver);
         _viewportLayer.removeEventListener(MouseEvent.ROLL_OUT,handleVPLOut);
         _viewportLayer.buttonMode = false;
      }
      
      protected function removeFishCompListeners() : void
      {
         removeEventListener(LilyPadPlane.DID_UPDATE_MESH,handleLilyPadMeshUpdate);
         animationPlane.removeEventListener(AnimationPlane.DID_BEGIN_PLAYING,handleFishUpdateAdded);
         animationPlane.removeEventListener(AnimationPlane.DID_END_PLAYING,handleFishUpdateRemoved);
      }
      
      protected function addFishCompListeners() : void
      {
         addEventListener(LilyPadPlane.DID_UPDATE_MESH,handleLilyPadMeshUpdate);
         animationPlane.addEventListener(AnimationPlane.DID_BEGIN_PLAYING,handleFishUpdateAdded);
         animationPlane.addEventListener(AnimationPlane.DID_END_PLAYING,handleFishUpdateRemoved);
      }
      
      public function setLiveStatus(param1:Boolean = false) : void
      {
         _isLive = true;
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         if(_viewportLayer)
         {
            removeVPLListeners();
         }
         _viewportLayer = param1;
         setVPLListeners();
      }
      
      public function reset() : void
      {
         if(_isLive)
         {
            unsetLiveStatus();
         }
         else
         {
            animationPlane.gotoAndStop(1);
            lilyPlane.reset();
         }
      }
      
      private function handleFishUpdateRemoved(param1:Event) : void
      {
         _dirtyFlagOn = false;
         dispatchEvent(new Event(PLAYOUT_ENDS));
      }
      
      public function get dirtyRenderState() : Boolean
      {
         return Boolean(animationPlane.isPlaying || lilyPlane.isAtRest);
      }
      
      protected function handlePlayoutComplete() : void
      {
         lilyPlane.curlFtarg = 0;
         dispatchEvent(new Event(PLAYOUT_COMPLETE));
      }
      
      protected function handleVPLOver(param1:MouseEvent) : void
      {
         if(!_isLive)
         {
            return;
         }
         if(!animationPlane.isPlaying)
         {
            lilyPlane.curlFtarg = -0.5;
            lilyPlane.wobble();
            SoundManager.playSound(sfxOverPad);
         }
         dispatchEvent(new Event(ROLLOVER_LILYPAD));
      }
      
      protected function setVPLListeners() : void
      {
         _viewportLayer.addEventListener(MouseEvent.CLICK,handleVPLClick);
         _viewportLayer.addEventListener(MouseEvent.ROLL_OVER,handleVPLOver);
         _viewportLayer.addEventListener(MouseEvent.ROLL_OUT,handleVPLOut);
         _viewportLayer.buttonMode = true;
      }
      
      public function get isLive() : Boolean
      {
         return _isLive;
      }
      
      private function handleFishUpdateAdded(param1:Event) : void
      {
         _dirtyFlagOn = true;
         dispatchEvent(new Event(PLAYOUT_BEGINS));
      }
      
      private function handleLilyPadMeshUpdate(param1:Event) : void
      {
         dispatchEvent(new Event(OVERRIDE_DIRTYFLAG));
      }
      
      protected function handleVPLClick(param1:MouseEvent) : void
      {
         if(!_isLive || animationPlane.isPlaying)
         {
            return;
         }
         lilyPlane.curlFtarg = -1;
         animationPlane.playLabel("playout",0,0,handlePlayoutComplete);
         SoundManager.playSound(sfxLiftPad);
      }
   }
}

