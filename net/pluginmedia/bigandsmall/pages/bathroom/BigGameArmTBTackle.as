package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import org.papervision3d.core.math.Number2D;
   
   public class BigGameArmTBTackle extends Sprite
   {
      
      private var _isBrushing:Boolean = false;
      
      private var _velocity:Number2D = new Number2D();
      
      public var armClipAnim:AnimationOld;
      
      public function BigGameArmTBTackle(param1:MovieClip)
      {
         super();
         this.armClipAnim = new AnimationOld(param1);
         addChild(armClipAnim);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function updateArmPos(param1:Number, param2:Number) : void
      {
         _velocity.x = param1 - armClipAnim.x;
         _velocity.y = param2 - armClipAnim.y;
         armClipAnim.x = param1;
         armClipAnim.y = param2;
      }
      
      public function get velocity() : Number2D
      {
         return _velocity;
      }
      
      public function get velocityNormal() : Number2D
      {
         var _loc1_:Number2D = new Number2D();
         var _loc2_:Number = Math.sqrt(_velocity.x * _velocity.x + _velocity.y * _velocity.y);
         if(_loc2_ == 0)
         {
            return _loc1_;
         }
         _loc1_.x = _velocity.x / _loc2_;
         _loc1_.y = _velocity.y / _loc2_;
         return _loc1_;
      }
      
      public function prepare() : void
      {
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
         updateArmPos(param1.stageMouseX,param1.stageMouseY);
      }
      
      public function park() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      public function stopBrush() : void
      {
         _isBrushing = false;
         armClipAnim.gotoAndStop(1);
      }
      
      public function get isBrushing() : Boolean
      {
         return _isBrushing;
      }
      
      public function deactivate() : void
      {
         stopBrush();
      }
      
      public function startBrush() : void
      {
         _isBrushing = true;
         armClipAnim.loop(int.MAX_VALUE);
      }
   }
}

