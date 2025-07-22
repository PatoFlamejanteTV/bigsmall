package net.pluginmedia.bigandsmall.core
{
   import flash.events.MouseEvent;
   import net.pluginmedia.brain.core.BrainLogger;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Incidental extends DisplayObject3D
   {
      
      public var active:Boolean = false;
      
      public var layer:ViewportLayer;
      
      protected var currentPOV:String;
      
      public var playing:Boolean = false;
      
      public var label:String;
      
      public function Incidental(param1:String)
      {
         super();
         this.label = param1;
      }
      
      public function handleClick() : void
      {
         if(playing)
         {
            stop();
         }
         else
         {
            play();
         }
      }
      
      public function destroy() : void
      {
         stop();
         active = false;
         playing = false;
      }
      
      public function stop() : void
      {
         playing = false;
      }
      
      public function play() : void
      {
         playing = true;
      }
      
      public function prepare() : void
      {
      }
      
      public function setLayer(param1:ViewportLayer) : void
      {
         if(layer)
         {
            layer.removeEventListener(MouseEvent.CLICK,onLayerMouseClick);
            layer.removeEventListener(MouseEvent.ROLL_OVER,onLayerMouseRoll);
            layer.removeEventListener(MouseEvent.ROLL_OUT,onLayerMouseRollout);
         }
         layer = param1;
         layer.addEventListener(MouseEvent.CLICK,onLayerMouseClick);
         layer.addEventListener(MouseEvent.ROLL_OVER,onLayerMouseRoll);
         layer.addEventListener(MouseEvent.ROLL_OUT,onLayerMouseRollout);
      }
      
      public function rollover() : void
      {
      }
      
      private function onLayerMouseRollout(param1:MouseEvent) : void
      {
         if(active)
         {
            rollout();
            dispatchEvent(param1.clone());
         }
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
      }
      
      public function park() : void
      {
      }
      
      private function onLayerMouseRoll(param1:MouseEvent) : void
      {
         if(active)
         {
            rollover();
            dispatchEvent(param1.clone());
         }
      }
      
      public function rollout() : void
      {
      }
      
      public function activate() : void
      {
         active = true;
         if(layer)
         {
            layer.buttonMode = true;
         }
      }
      
      private function onLayerMouseClick(param1:MouseEvent) : void
      {
         if(active)
         {
            handleClick();
            dispatchEvent(param1.clone());
         }
      }
      
      public function deactivate() : void
      {
         active = false;
         if(layer)
         {
            layer.buttonMode = false;
         }
      }
      
      public function setPauseState(param1:Boolean) : void
      {
         BrainLogger.out("Incidental setPauseState",param1);
      }
   }
}

