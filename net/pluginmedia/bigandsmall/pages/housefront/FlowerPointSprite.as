package net.pluginmedia.bigandsmall.pages.housefront
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class FlowerPointSprite extends PointSprite
   {
      
      private var basicView:BasicView;
      
      private var rotVel:Number = 0;
      
      private var _viewportLayer:ViewportLayer;
      
      private var clip:MovieClip;
      
      private var anim:AnimationOld = new AnimationOld(clip);
      
      private var rotEase:Number = 0.15;
      
      private var pointSpriteMat:SpriteParticleMaterial = new SpriteParticleMaterial(anim);
      
      private var minThresh:Number;
      
      private var isClickTarget:Boolean = false;
      
      public var clickWibbleForce:Number;
      
      public function FlowerPointSprite(param1:BasicView, param2:MovieClip, param3:Number, param4:Number = 10, param5:Number = 1)
      {
         basicView = param1;
         clickWibbleForce = param4;
         clip = param2;
         minThresh = param3;
         pointSpriteMat.smooth = true;
         super(pointSpriteMat,param5);
         autoCalcScreenCoords = true;
      }
      
      private function handleLayerOut(param1:MouseEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function get viewportLayer() : ViewportLayer
      {
         return _viewportLayer;
      }
      
      public function injectWibbleForce(param1:Number = 0) : void
      {
         rotVel += param1;
      }
      
      private function removeLayerListeners(param1:ViewportLayer) : void
      {
         param1.buttonMode = false;
         param1.removeEventListener(MouseEvent.MOUSE_OVER,handleLayerOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,handleLayerOut);
         param1.removeEventListener(MouseEvent.CLICK,handleLayerClick);
      }
      
      public function setLayer(param1:ViewportLayer) : void
      {
         if(_viewportLayer)
         {
            removeLayerListeners(_viewportLayer);
         }
         _viewportLayer = param1;
         addLayerListeners(_viewportLayer);
         AccessibilityManager.addAccessibilityProperties(_viewportLayer,"Flower","Interactive flower",AccessibilityDefinitions.PRELOADER_FLOWER);
      }
      
      public function updateAttraction(param1:Number2D) : void
      {
         var _loc2_:Number2D = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number2D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc2_ = new Number2D(screen.x,screen.y);
         _loc4_ = Number2D.subtract(param1,_loc2_);
         _loc3_ = _loc4_.modulo;
         _loc4_.normalise();
         var _loc7_:Number = clip.rotation;
         if(!isClickTarget)
         {
            if(_loc3_ < minThresh)
            {
               _loc5_ = _loc4_.angle();
               if(isNaN(_loc5_))
               {
                  return;
               }
               _loc8_ = 1 - _loc3_ / minThresh;
               if(isNaN(_loc8_))
               {
                  _loc8_ = 1;
               }
               _loc6_ = (_loc5_ + 90) * _loc8_;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         else
         {
            _loc5_ = _loc4_.angle();
            if(isNaN(_loc5_))
            {
               return;
            }
            _loc6_ = _loc5_ + 90;
         }
         rotVel += getRotationDiff(_loc7_,_loc6_,rotEase);
         clip.rotation += rotVel;
         rotVel *= 0.8;
      }
      
      private function getRotationDiff(param1:Number, param2:Number, param3:Number = 0.5) : Number
      {
         if(param2 < 0)
         {
            param2 += 360;
         }
         var _loc4_:Number = (param2 - param1) * param3;
         var _loc5_:Number = 360 - param1;
         var _loc6_:Number = 360 - param2;
         if(_loc5_ - _loc6_ > 180)
         {
            if(param1 < 180)
            {
               _loc4_ = (param2 - 360 - param1) * param3;
            }
            else
            {
               _loc4_ = (param2 - (param1 + 360)) * param3;
            }
         }
         return _loc4_;
      }
      
      public function setTabEnabled(param1:Boolean) : void
      {
         if(_viewportLayer)
         {
            _viewportLayer.tabEnabled = param1;
         }
      }
      
      private function addLayerListeners(param1:ViewportLayer) : void
      {
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.MOUSE_OVER,handleLayerOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,handleLayerOut);
         param1.addEventListener(MouseEvent.CLICK,handleLayerClick);
      }
      
      public function destroy() : void
      {
         if(this.viewportLayer)
         {
            removeLayerListeners(viewportLayer);
         }
         this.material = null;
         pointSpriteMat.destroy();
         pointSpriteMat = null;
         anim = null;
      }
      
      private function handleLayerOver(param1:MouseEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function handleLayerClick(param1:MouseEvent) : void
      {
         injectWibbleForce(clickWibbleForce);
         anim.playToNextLabel();
         dispatchEvent(param1);
      }
   }
}

