package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Blind extends Plane
   {
      
      public static const ROLL_OVER_FLAP:String = "blindRolloverFlap";
      
      protected var _enabled:Boolean = true;
      
      private var blindMaterialOpen:MovieMaterial;
      
      private var rectWidth:Number = 483;
      
      protected var _viewportLayer:ViewportLayer;
      
      private var blindAnim:AnimationOld;
      
      protected var _viewportLayerButton:VPortLayerButton;
      
      private var blindMovie:MovieClip;
      
      private var blindMaterialClosed:MovieMaterial;
      
      private var rectHeight:Number = 500;
      
      private var closed:Boolean = true;
      
      private var h:Number = 160;
      
      private var w:Number = 200;
      
      private var scaleYOpen:Number;
      
      private var segs:Number = 2;
      
      public function Blind(param1:MovieClip, param2:Number)
      {
         blindMovie = param1;
         scaleYOpen = param2;
         var _loc3_:Rectangle = new Rectangle(0,0,rectWidth,rectHeight);
         _loc3_.inflate(50,0);
         var _loc4_:Rectangle = new Rectangle(0,0,rectWidth,rectHeight * scaleYOpen);
         _loc4_.inflate(50,0);
         blindMaterialClosed = new MovieMaterial(blindMovie,true,false,false,_loc3_);
         blindMaterialOpen = new MovieMaterial(blindMovie,true,false,false,_loc4_);
         super(blindMaterialClosed,w,h,segs,segs);
         var _loc5_:Matrix3D = Matrix3D.translationMatrix(0,-h / 2,0);
         this.geometry.transformVertices(_loc5_);
         blindAnim = new AnimationOld(blindMovie);
         blindAnim.addEventListener(AnimationOldEvent.PROGRESS,onAnimationProgress);
         blindAnim.addEventListener(AnimationOldEvent.COMPLETE,handleAnimationComplete);
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function get isClosed() : Boolean
      {
         return closed;
      }
      
      private function onAnimationProgress(param1:AnimationOldEvent) : void
      {
         dispatchEvent(new AnimationOldEvent(AnimationOldEvent.PROGRESS));
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         if(_viewportLayerButton)
         {
            _viewportLayerButton.setEnabledState(param1);
         }
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      private function sizePlaneOpen() : void
      {
         this.scaleY = scaleYOpen;
         blindMovie.scaleY = scaleYOpen;
         blindMaterialOpen.drawBitmap();
         this.material = blindMaterialOpen;
      }
      
      private function handleAnimationComplete(param1:AnimationOldEvent) : void
      {
         onAnimComplete();
      }
      
      public function set viewportLayerButton(param1:VPortLayerButton) : void
      {
         _viewportLayerButton = param1;
         _viewportLayerButton.addEventListener(MouseEvent.MOUSE_OVER,handleBlindRollover);
      }
      
      public function set viewportLayer(param1:ViewportLayer) : void
      {
         _viewportLayer = param1;
      }
      
      private function handleBlindRollover(param1:MouseEvent) : void
      {
         if(!blindAnim.isPlaying && closed)
         {
            blindMaterialClosed.animated = true;
            blindAnim.playOutLabel("rollover");
         }
      }
      
      public function get viewportLayerButton() : VPortLayerButton
      {
         return _viewportLayerButton;
      }
      
      private function sizePlaneClosed() : void
      {
         this.scaleY = 1;
         blindMovie.scaleY = 1;
         blindMaterialClosed.drawBitmap();
         this.material = blindMaterialClosed;
      }
      
      private function onAnimComplete() : void
      {
         if(!closed)
         {
            sizePlaneOpen();
         }
         blindMaterialOpen.drawBitmap();
         blindMaterialClosed.drawBitmap();
         blindMaterialOpen.animated = false;
         blindMaterialClosed.animated = false;
      }
      
      public function openBlind(param1:Boolean = true) : void
      {
         closed = false;
         sizePlaneClosed();
         blindMaterialOpen.animated = true;
         blindMaterialClosed.animated = true;
         if(!param1)
         {
            blindAnim.playOutLabel("blind up");
         }
         else
         {
            blindAnim.gotoAndStop("blind down");
            onAnimComplete();
         }
      }
      
      public function set isClosed(param1:Boolean) : void
      {
         if(param1)
         {
            closeBlind();
         }
         else
         {
            openBlind();
         }
      }
      
      public function closeBlind(param1:Boolean = false) : void
      {
         closed = true;
         sizePlaneClosed();
         blindMaterialOpen.animated = true;
         blindMaterialClosed.animated = true;
         if(!param1)
         {
            blindAnim.playOutLabel("blind down");
         }
         else
         {
            blindAnim.gotoAndStop("blind up");
            onAnimComplete();
         }
      }
   }
}

