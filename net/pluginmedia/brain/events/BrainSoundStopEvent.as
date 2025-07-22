package net.pluginmedia.brain.events
{
   public class BrainSoundStopEvent extends BrainSoundEvent
   {
      
      private var _channel:int = -1;
      
      private var _fade:Number = 0;
      
      private var _strID:String = null;
      
      public function BrainSoundStopEvent(param1:Number = 0, param2:String = null, param3:int = -1)
      {
         _fade = param1;
         _strID = param2;
         _channel = param3;
         var _loc4_:String = null;
         if(_strID !== null)
         {
            _loc4_ = BrainSoundEventType.STOP_NAMED;
         }
         else if(_channel !== -1)
         {
            _loc4_ = BrainSoundEventType.STOP_CHANNEL;
         }
         else
         {
            _loc4_ = BrainSoundEventType.STOP_ALL;
         }
         super(_loc4_);
      }
      
      public function get channel() : int
      {
         return _channel;
      }
      
      public function get fade() : Number
      {
         return _fade;
      }
      
      public function get strID() : String
      {
         return _strID;
      }
   }
}

