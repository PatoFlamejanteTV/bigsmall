package net.pluginmedia.brain.core.events
{
   public class BrainEventType
   {
      
      public static const TRANSITION:String = "BrainEventType.Transition";
      
      public static const CHANGE_PAGE:String = "BrainEventType.ChangePage";
      
      public static const KILL_APP:String = "BrainEventType.KillApp";
      
      public static const KILL_PAGE:String = "BrainEventType.KillPage";
      
      public static const SOUND_REGISTER:String = "BrainEventType.SoundRegister";
      
      public static const SOUND_REGISTER_COLLECTION:String = "BrainEventType.SoundRegisterCollection";
      
      public static const SOUND_PLAY:String = "BrainEventType.SoundPlay";
      
      public static const SOUND_STOP_CHANNEL:String = "BrainEventType.SoundStopChannel";
      
      public static const SOUND_STOP_NAMED:String = "BrainEventType.SoundStopNamed";
      
      public static const SOUND_STOP_ALL:String = "BrainEventType.SoundStopAll";
      
      public static const SOUND_MUTE:String = "BrainEventType.SoundMute";
      
      public static const SOUND_UNMUTE:String = "BrainEventType.SoundUnMute";
      
      public static const SOUND_TOGGLE_MUTE:String = "BrainEventType.SoundToggleMute";
      
      public static const MULTIPAGE_LOADPROGRESS:String = "BrainEventType.MULTIPAGE_LOADPROGRESS";
      
      public static const HIDE_PRELOADER:String = "BrainEventType.HIDE_PRELOADER";
      
      public static const PRIORITISE_LOADQUEUE:String = "BrainEventType.PRIORITISE_LOADQUEUE";
      
      public static const GET_LOADPROGRESS:String = "BrainEventType.GET_LOADPROGRESS";
      
      public static const GET_PAGEOBJECTREF:String = "BrainEventType.GET_PAGEOBJ";
      
      public function BrainEventType()
      {
         super();
      }
   }
}

