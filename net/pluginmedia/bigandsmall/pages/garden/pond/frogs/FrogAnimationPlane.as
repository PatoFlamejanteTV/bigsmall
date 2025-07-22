package net.pluginmedia.bigandsmall.pages.garden.pond.frogs
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.mesh.CharacterAnimationPlane;
   import net.pluginmedia.bigandsmall.pages.garden.pond.IControllablePondInteractive;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class FrogAnimationPlane extends CharacterAnimationPlane implements IControllablePondInteractive
   {
      
      public static var PLAYOUT_BEGINS:String = "FrogAnimationPlane.PLAYOUT_BEGINS";
      
      public static var NULL_PLAYOUT_BEGINS:String = "FrogAnimationPlane.NULL_PLAYOUT_BEGINS";
      
      public static var PLAYOUT_COMPLETE:String = "FrogAnimationPlane.PLAYOUT_COMPLETE";
      
      protected var _viewportLayer:ViewportLayer;
      
      protected var _isLive:Boolean = false;
      
      protected var _playedReveal:Boolean = false;
      
      public function FrogAnimationPlane(param1:MovieClip)
      {
         super(param1,0.75,0.75);
      }
      
      public function setLiveStatus(param1:Boolean = false) : void
      {
         _isLive = true;
         if(param1)
         {
            gotoAndStop("postTease");
         }
         else
         {
            playLabel("tease");
         }
      }
      
      override protected function removeAllListeners() : void
      {
         super.removeAllListeners();
         removeVPLListeners();
      }
      
      public function get playedReveal() : Boolean
      {
         return _playedReveal;
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      public function unsetLiveStatus() : void
      {
         _isLive = false;
         _playedReveal = false;
         if(_isPlaying)
         {
            gotoAndStop("null_over");
         }
      }
      
      public function reset() : void
      {
         if(isLive)
         {
            unsetLiveStatus();
         }
         else
         {
            gotoAndStop("null_over");
         }
      }
      
      protected function removeVPLListeners() : void
      {
         _viewportLayer.removeEventListener(MouseEvent.CLICK,handleVPLClick);
         _viewportLayer.removeEventListener(MouseEvent.ROLL_OVER,handleVPLOver);
         _viewportLayer.buttonMode = false;
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         if(_viewportLayer)
         {
            removeVPLListeners();
         }
         _viewportLayer = param1;
         addVPLListeners();
      }
      
      protected function handleNullPlayoutComplete() : void
      {
         gotoAndStop("null_over");
      }
      
      protected function handleVPLOver(param1:MouseEvent) : void
      {
         if(_isPlaying)
         {
            return;
         }
         if(isLive && !_playedReveal)
         {
            playLabel("over");
            _playedReveal = true;
         }
         else if(!isLive)
         {
            playLabel("null_over");
         }
         dispatchEvent(param1);
      }
      
      public function get dirtyRenderState() : Boolean
      {
         return _isPlaying;
      }
      
      protected function handlePlayoutComplete() : void
      {
         dispatchEvent(new Event(PLAYOUT_COMPLETE));
      }
      
      protected function addVPLListeners() : void
      {
         _viewportLayer.addEventListener(MouseEvent.CLICK,handleVPLClick);
         _viewportLayer.addEventListener(MouseEvent.ROLL_OVER,handleVPLOver);
         _viewportLayer.buttonMode = true;
      }
      
      public function get isLive() : Boolean
      {
         return _isLive;
      }
      
      protected function handleVPLClick(param1:MouseEvent) : void
      {
         if(isPlaying)
         {
            return;
         }
         if(!isLive)
         {
            playLabel("null_playout",0,0,handleNullPlayoutComplete);
            dispatchEvent(new Event(NULL_PLAYOUT_BEGINS));
         }
         else
         {
            playLabel("playout",0,0,handlePlayoutComplete);
            dispatchEvent(new Event(PLAYOUT_BEGINS));
         }
      }
   }
}

