package net.pluginmedia.bigandsmall.pages.garden.tree.events
{
   import flash.events.Event;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleParticle;
   
   public class AppleTreeEvent extends Event
   {
      
      public static const APPLE_FINDS_REST:String = "appleFindsRest";
      
      public static const APPLE_IMPACTS_FLOOR:String = "appleImpactsFloor";
      
      public static const APPLE_HITS_BIG:String = "applehitsBig";
      
      public static const CHARACTER_FINISHED:String = "appleTreeCharacterFinished";
      
      private var _apple:AppleParticle;
      
      public function AppleTreeEvent(param1:String, param2:AppleParticle)
      {
         super(param1);
         _apple = param2;
      }
      
      public function get apple() : AppleParticle
      {
         return _apple;
      }
   }
}

