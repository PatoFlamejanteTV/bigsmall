package net.pluginmedia.bigandsmall.pages.livingroom.drawinggame
{
   import flash.display.BlendMode;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import gs.TweenMax;
   import gs.easing.Elastic;
   import org.papervision3d.core.math.Number2D;
   
   public class DrawingStateBig extends DrawingState
   {
      
      protected var targetAngle:Number;
      
      protected var currentHandAngle:Number;
      
      protected var currentArmAngle:Number;
      
      public function DrawingStateBig(param1:DisplayObjectContainer, param2:MovieClip, param3:MovieClip)
      {
         super(param1,param2,param3);
         currentArmAngle = 90;
         currentHandAngle = 90;
         targetAngle = 90;
         param2.filters = [new BlurFilter(1,1,2)];
      }
      
      override public function setColor(param1:ColourTray) : void
      {
         super.setColor(param1);
         drawColorTransform.alphaMultiplier = 0.5;
      }
      
      private function updateRotation() : void
      {
         currentHandAngle += getRotationDiff(currentHandAngle,targetAngle,0.5);
         currentArmAngle += getRotationDiff(currentArmAngle,currentHandAngle,0.5);
         armClip.rotation = currentArmAngle;
         currentArmAngle = armClip.rotation;
         armClip.rotation = currentHandAngle;
         currentHandAngle = armClip.rotation;
         if(armClip.arm !== null)
         {
            armClip.arm.rotation = currentArmAngle - currentHandAngle;
            if(armClip.armoutline !== null)
            {
               armClip.armoutline.rotation = armClip.arm.rotation;
            }
         }
      }
      
      override protected function drawData(param1:Matrix) : void
      {
         targetBitmap.draw(handPrint,param1,drawColorTransform,BlendMode.HARDLIGHT,null,true);
      }
      
      override public function stampAnim() : void
      {
         armClip.scaleX = armClip.scaleY = 0.6;
         TweenMax.to(armClip,1.5,{
            "scaleX":defaultArmScale,
            "scaleY":defaultArmScale,
            "ease":Elastic.easeOut
         });
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
      
      override public function moveMouse(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         armClip.x = param1;
         armClip.y = param2;
         var _loc5_:Number2D = new Number2D(param1 - param3,param2 - param4);
         targetAngle = _loc5_.angle();
         updateRotation();
      }
   }
}

