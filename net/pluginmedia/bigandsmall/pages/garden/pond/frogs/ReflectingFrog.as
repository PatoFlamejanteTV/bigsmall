package net.pluginmedia.bigandsmall.pages.garden.pond.frogs
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.mesh.AnimationPlane;
   import net.pluginmedia.bigandsmall.core.mesh.ReflectionPlane;
   import net.pluginmedia.bigandsmall.pages.garden.pond.IControllablePondInteractive;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class ReflectingFrog extends ReflectionPlane implements IControllablePondInteractive
   {
      
      public static var DIRTYFLAG_ON:String = "ReflectingFrog.DIRTYFLAG_ON";
      
      public static var DIRTYFLAG_OFF:String = "ReflectingFrog.DIRTYFLAG_OFF";
      
      public static var PLAYOUT_COMPLETE:String = "ReflectingFrog.PLAYOUT_COMPLETE";
      
      public static var PLAYOUT_BEGINS:String = "ReflectingFrog.PLAYOUT_BEGINS";
      
      public static var NULL_PLAYOUT_BEGINS:String = "ReflectingFrog.NULL_PLAYOUT_BEGINS";
      
      public var animLayer:ViewportLayer;
      
      public var reflLayer:ViewportLayer;
      
      private var _dirtyFlagOn:Boolean = false;
      
      public var frogPlane:FrogAnimationPlane;
      
      public var scaleFactor:Number = 0;
      
      public function ReflectingFrog(param1:MovieClip, param2:ViewportLayer, param3:ViewportLayer)
      {
         frogPlane = new FrogAnimationPlane(param1);
         super(frogPlane);
         addFrogPlaneListeners();
         animLayer = frogPlane.viewportLayer = param2.getChildLayer(frogPlane,true);
         reflLayer = param3.getChildLayer(reflectionPlane,true,true);
      }
      
      private function addFrogPlaneListeners() : void
      {
         frogPlane.addEventListener(FrogAnimationPlane.PLAYOUT_COMPLETE,handleFrogPlayoutComplete);
         frogPlane.addEventListener(FrogAnimationPlane.PLAYOUT_BEGINS,handleFrogPlayoutBegins);
         frogPlane.addEventListener(FrogAnimationPlane.NULL_PLAYOUT_BEGINS,handleFrogNullPlayoutBegins);
         frogPlane.addEventListener(MouseEvent.ROLL_OVER,handleFrogOver);
         frogPlane.addEventListener(AnimationPlane.DID_BEGIN_PLAYING,handleFrogUpdateAdded);
         frogPlane.addEventListener(AnimationPlane.DID_END_PLAYING,handleFrogUpdateRemoved);
      }
      
      private function handleFrogUpdateRemoved(param1:Event) : void
      {
         _dirtyFlagOn = false;
         dispatchEvent(new Event(DIRTYFLAG_OFF));
      }
      
      public function unsetLiveStatus() : void
      {
         frogPlane.unsetLiveStatus();
      }
      
      public function setLiveStatus(param1:Boolean = false) : void
      {
         frogPlane.setLiveStatus();
      }
      
      private function handleFrogNullPlayoutBegins(param1:Event) : void
      {
         dispatchEvent(new Event(NULL_PLAYOUT_BEGINS));
      }
      
      private function handleFrogPlayoutBegins(param1:Event) : void
      {
         dispatchEvent(new Event(PLAYOUT_BEGINS));
      }
      
      public function get dirtyFlagOn() : Boolean
      {
         return _dirtyFlagOn;
      }
      
      public function reset() : void
      {
         frogPlane.reset();
      }
      
      private function handleFrogOver(param1:MouseEvent) : void
      {
         if(!frogPlane.playedReveal)
         {
            dispatchEvent(param1);
         }
      }
      
      private function handleFrogUpdateAdded(param1:Event) : void
      {
         _dirtyFlagOn = true;
         dispatchEvent(new Event(DIRTYFLAG_ON));
      }
      
      private function handleFrogPlayoutComplete(param1:Event) : void
      {
         dispatchEvent(new Event(PLAYOUT_COMPLETE));
      }
      
      public function get dirtyRenderState() : Boolean
      {
         return frogPlane.isPlaying;
      }
      
      private function removeLivePlaneListeners() : void
      {
         frogPlane.removeEventListener(FrogAnimationPlane.PLAYOUT_COMPLETE,handleFrogPlayoutComplete);
         frogPlane.removeEventListener(FrogAnimationPlane.PLAYOUT_BEGINS,handleFrogPlayoutBegins);
         frogPlane.removeEventListener(FrogAnimationPlane.NULL_PLAYOUT_BEGINS,handleFrogNullPlayoutBegins);
         frogPlane.removeEventListener(MouseEvent.ROLL_OVER,handleFrogOver);
         frogPlane.removeEventListener(AnimationPlane.DID_BEGIN_PLAYING,handleFrogUpdateAdded);
         frogPlane.removeEventListener(AnimationPlane.DID_END_PLAYING,handleFrogUpdateRemoved);
      }
      
      public function get isLive() : Boolean
      {
         return frogPlane.isLive;
      }
   }
}

