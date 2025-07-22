package net.pluginmedia.bigandsmall.core.animation
{
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.brain.core.events.ShareRequestEvent;
   import net.pluginmedia.brain.core.interfaces.ISharer;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   
   public class BigAndSmallCompTransitionFX extends CompositeTransitionFX implements ISharer
   {
      
      public function BigAndSmallCompTransitionFX(param1:* = null)
      {
         super(param1);
      }
      
      private function handleSetTransitionFX(param1:SharerInfo) : void
      {
         setUserDataPool(param1.reference as Dictionary);
      }
      
      public function onShareableRegistration() : void
      {
         dispatchShareRequest(new ShareRequest(this,"GlobalAssets.TransitionFX",handleSetTransitionFX));
      }
      
      public function doCharacterTransitionOut(param1:String, param2:Function = null, param3:Array = null) : void
      {
         _isPlaying = true;
         if(param1 == CharacterDefinitions.BIG)
         {
            this.doNamedTransitionOut("Transition_A",param2);
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            this.doNamedTransitionOut("Transition_B",param2,param3,true);
         }
      }
      
      public function doCharacterTransitionIn(param1:String, param2:Function = null, param3:Array = null) : void
      {
         _isPlaying = true;
         if(param1 == CharacterDefinitions.BIG)
         {
            this.doNamedTransitionIn("Transition_A",param2);
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            this.doNamedTransitionIn("Transition_B",param2,param3,true);
         }
      }
      
      protected function dispatchShareRequest(param1:ShareRequest) : void
      {
         dispatchEvent(new ShareRequestEvent(ShareRequestEvent.SHARE_REQUEST,param1));
      }
      
      public function receiveShareable(param1:SharerInfo) : void
      {
      }
   }
}

