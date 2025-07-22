package net.pluginmedia.bigandsmall.pages.garden.characters.small
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.maths.SineOscillator;
   import org.papervision3d.core.math.Number3D;
   
   public class SmallGardenStateRunning extends SmallGardenStateBase
   {
      
      private var runOsc:SineOscillator;
      
      private var tLast:Number = 0;
      
      private var runPath:BezierPath3D;
      
      private var isMovFlipped:Boolean = false;
      
      public function SmallGardenStateRunning(param1:BezierPath3D, param2:SineOscillator, param3:MovieClip, param4:Number = 1)
      {
         runPath = param1;
         runOsc = param2;
         super(new Number3D(),param3,param4);
         flipMov();
      }
      
      private function flipMov() : void
      {
         movie.subjectClip.scaleX *= -1;
         isMovFlipped = !isMovFlipped;
      }
      
      override public function update() : void
      {
         var _loc3_:Number3D = null;
         if(stateExpired)
         {
            return;
         }
         var _loc1_:Number = runOsc.step(0.7);
         var _loc2_:Number = (_loc1_ + 1) / 2;
         if(_loc2_ > tLast)
         {
            if(!isMovFlipped)
            {
               flipMov();
               if(!isTalking)
               {
                  stateExpires();
               }
            }
         }
         else if(isMovFlipped)
         {
            flipMov();
            if(!isTalking)
            {
               stateExpires();
            }
         }
         tLast = _loc2_;
         _loc3_ = runPath.getNumber3DAtT(_loc2_);
         this.x = _loc3_.x;
         this.y = _loc3_.y;
         this.z = _loc3_.z;
      }
      
      override public function deactivate() : void
      {
         movie.playLabel("exit",0,0,onExitComplete);
      }
      
      override public function get OUTRO_COMPLETE() : String
      {
         return "SmallGardenStateRunning.OUTRO_COMPLETE";
      }
      
      override public function get DEFAULTMOUTHLABEL() : String
      {
         return "a";
      }
      
      override public function park() : void
      {
         super.park();
      }
      
      private function onExitComplete() : void
      {
         dispatchEvent(new Event(OUTRO_COMPLETE));
      }
      
      override public function activate() : void
      {
         stateExpired = false;
         this.visible = true;
         movie.playLabel("run",int.MAX_VALUE);
         update();
      }
   }
}

