package net.pluginmedia.bigandsmall.pages.livingroom.drawinggame
{
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.easing.Elastic;
   import org.papervision3d.core.math.Number2D;
   
   public class DrawingStateSmall extends DrawingStateBig
   {
      
      private var mousePosPrev:Point = new Point(0,0);
      
      private var rotVel:Number = 0;
      
      private var splotThresholdSquared:Number;
      
      private var splotThreshold:Number = 20;
      
      public function DrawingStateSmall(param1:DisplayObjectContainer, param2:MovieClip, param3:MovieClip)
      {
         splotThresholdSquared = splotThreshold * splotThreshold;
         super(param1,param2,param3);
         param2.filters = [new BlurFilter(1,1,2)];
         armClip.rotation = 90;
      }
      
      override public function setColor(param1:ColourTray) : void
      {
         super.setColor(param1);
         drawColorTransform.alphaMultiplier = 1;
      }
      
      override protected function drawData(param1:Matrix) : void
      {
         targetBitmap.draw(handPrint,param1,drawColorTransform);
      }
      
      override public function stampAnim() : void
      {
         armClip.scaleX = armClip.scaleY = 0.5;
         TweenMax.to(armClip,1.5,{
            "scaleX":defaultArmScale,
            "scaleY":defaultArmScale,
            "ease":Elastic.easeOut
         });
      }
      
      override public function drawDrips(param1:Number, param2:Number, param3:BitmapData) : void
      {
         var _loc4_:Shape = new Shape();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.beginFill(16777215,1);
         _loc5_.drawCircle(0,0,Math.random() * 5);
         _loc5_.endFill();
         var _loc6_:Matrix = new Matrix();
         _loc6_.translate(param1,param2);
         targetBitmap.draw(_loc4_,_loc6_,drawColorTransform);
      }
      
      override public function moveMouse(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc10_:Number = NaN;
         armClip.x = param1;
         armClip.y = param2;
         var _loc5_:Number2D = new Number2D(param1 - param3,param2 - 800);
         var _loc6_:Number = _loc5_.angle();
         armClip.rotation = 180 + _loc6_;
         var _loc7_:Number = (_loc5_.modulo - 570) / 530;
         armClip.arm.scaleX = armClip.armoutline.scaleX = 0.8 + _loc7_;
         armClip.arm.scaleY = armClip.armoutline.scaleY = 1.5 - _loc7_;
         rotVel *= 0.3;
         var _loc8_:Number = Math.max(-90,Math.min(90,param1 - mousePosPrev.x));
         var _loc9_:Number = (_loc8_ - armClip.hand.rotation) * 0.4;
         rotVel += _loc9_;
         armClip.hand.rotation += rotVel;
         armClip.armoutline.rotation = armClip.arm.rotation = armClip.hand.rotation * 0.2;
         if(_loc7_ > 0.6)
         {
            _loc10_ = (_loc7_ - 0.6) * 2.5;
            armClip.x += Math.random() * _loc10_ * 12 - 6;
            _loc5_.multiplyEq(_loc10_ * (-0.1 + _loc10_ * Math.random() * 0.02));
            armClip.x += _loc5_.x;
            armClip.y += _loc5_.y;
         }
         if(Math.random() < 0.3)
         {
            dripping = true;
         }
         mousePosPrev.x = param1;
         mousePosPrev.y = param2;
      }
   }
}

