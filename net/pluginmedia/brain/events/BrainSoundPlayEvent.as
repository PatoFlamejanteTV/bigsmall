package net.pluginmedia.brain.events
{
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   
   public class BrainSoundPlayEvent extends BrainSoundEvent
   {
      
      private var _strID:String = null;
      
      private var _soundInfo:SoundInfoOld = null;
      
      public function BrainSoundPlayEvent(param1:String = null, param2:SoundInfoOld = null)
      {
         _strID = param1;
         _soundInfo = param2;
         super(BrainSoundEventType.PLAY);
      }
      
      public function get soundInfo() : SoundInfoOld
      {
         return _soundInfo;
      }
      
      public function get strID() : String
      {
         return _strID;
      }
   }
}

