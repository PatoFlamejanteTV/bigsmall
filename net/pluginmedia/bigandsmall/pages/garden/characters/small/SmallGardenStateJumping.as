package net.pluginmedia.bigandsmall.pages.garden.characters.small
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.papervision3d.core.math.Number3D;
   
   public class SmallGardenStateJumping extends SmallGardenStateBase
   {
      
      private var timerExpired:Boolean = false;
      
      private var expiryTimer:Timer = new Timer(8000);
      
      public function SmallGardenStateJumping(param1:Number3D, param2:MovieClip, param3:Number = 1)
      {
         expiryTimer.addEventListener(TimerEvent.TIMER,handleExpiryTimer);
         super(param1,param2,param3);
      }
      
      override public function park() : void
      {
         timerExpired = false;
         super.park();
      }
      
      private function onEntryComplete() : void
      {
         movie.playLabel("jump",int.MAX_VALUE);
         beginExpiryTimer();
      }
      
      override public function get OUTRO_COMPLETE() : String
      {
         return "SmallGardenStateJumping.OUTRO_COMPLETE";
      }
      
      override public function get DEFAULTMOUTHLABEL() : String
      {
         return "a";
      }
      
      override public function update() : void
      {
         if(stateExpired)
         {
            return;
         }
         if(timerExpired && !_isTalking)
         {
            stateExpires();
         }
      }
      
      private function onExitComplete() : void
      {
         dispatchEvent(new Event(OUTRO_COMPLETE));
      }
      
      private function endExpiryTimer() : void
      {
         expiryTimer.reset();
         expiryTimer.stop();
      }
      
      private function beginExpiryTimer() : void
      {
         timerExpired = false;
         expiryTimer.start();
      }
      
      private function handleExpiryTimer(param1:Event) : void
      {
         timerExpired = true;
         endExpiryTimer();
      }
      
      override public function activate() : void
      {
         stateExpired = false;
         this.visible = true;
         movie.playLabel("enter",0,0,onEntryComplete);
      }
      
      override public function deactivate() : void
      {
         endExpiryTimer();
         movie.playLabel("exit",0,0,onExitComplete);
      }
   }
}

