package net.pluginmedia.bigandsmall.physics
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class VerletParticle extends Sprite
   {
      
      public var loc:Point;
      
      public var clip:Shape;
      
      public var locPrev:Point;
      
      private var isInteractive:Boolean = false;
      
      public var isPinned:Boolean = false;
      
      public var force:Point;
      
      public var mass:Number = 1;
      
      private var _isDragging:Boolean;
      
      public function VerletParticle(param1:Number, param2:Number)
      {
         super();
         loc = new Point(param1,param2);
         locPrev = new Point(param1,param2);
         force = new Point(0,0);
         clip = new Shape();
         clip.graphics.beginFill(16711680,1);
         clip.graphics.drawCircle(0,0,10);
         clip.graphics.endFill();
         addChild(clip);
         mouseChildren = false;
      }
      
      private function handleStageMouseUp(param1:MouseEvent) : void
      {
         drop();
      }
      
      public function verlet(param1:Number) : void
      {
         if(isDragging)
         {
            loc.x = clip.stage.mouseX;
            loc.y = clip.stage.mouseY;
         }
         var _loc2_:Number = loc.x - locPrev.x;
         var _loc3_:Number = loc.y - locPrev.y;
         locPrev.x = loc.x;
         locPrev.y = loc.y;
         if(!isDragging && !isPinned)
         {
            loc.x += _loc2_ + force.x * param1 * param1;
            loc.y += _loc3_ + force.y * param1 * param1;
         }
         force.x = 0;
         force.y = 0;
      }
      
      public function get isDragging() : Boolean
      {
         return _isDragging;
      }
      
      public function pickUp() : void
      {
         _isDragging = true;
         locPrev.x = loc.x;
         locPrev.y = loc.y;
      }
      
      public function clone() : VerletParticle
      {
         var _loc1_:VerletParticle = new VerletParticle(loc.x,loc.y);
         _loc1_.locPrev.x = this.locPrev.x;
         _loc1_.locPrev.y = this.locPrev.y;
         _loc1_.force.x = this.force.x;
         _loc1_.force.y = this.force.y;
         _loc1_.clip = this.clip;
         _loc1_.isPinned = this.isPinned;
         _loc1_.mass = this.mass;
         return _loc1_;
      }
      
      public function setInteractive(param1:Boolean) : void
      {
         if(!stage)
         {
            BrainLogger.warning(" IKParticle :: WARNING :: Attempted to make a stageless particle interactive");
            return;
         }
         if(param1 && !isInteractive)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseUp);
            isInteractive = true;
            buttonMode = true;
         }
         else if(isInteractive)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseUp);
            isInteractive = false;
            buttonMode = false;
         }
      }
      
      public function get vel() : Point
      {
         var _loc1_:Number = loc.x - locPrev.x;
         var _loc2_:Number = loc.y - locPrev.y;
         return new Point(_loc1_,_loc2_);
      }
      
      public function accumulateForce(param1:Number, param2:Number) : void
      {
         force.x += param1 * mass;
         force.y += param2 * mass;
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         pickUp();
      }
      
      public function drop() : void
      {
         _isDragging = false;
      }
      
      public function updateClip() : void
      {
         this.x = loc.x;
         this.y = loc.y;
      }
      
      public function forcePosition(param1:Number, param2:Number) : void
      {
         loc.x = param1;
         loc.y = param2;
         locPrev.x = loc.x;
         locPrev.y = loc.y;
      }
   }
}

