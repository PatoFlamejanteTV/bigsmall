package net.pluginmedia.bigandsmall.pages.garden.characters.big
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.garden.characters.IGardenCharacter;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.CameraThetaRelativePointSpriteMovieUpdater;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class BigLoungingController extends DisplayObject3D implements IGardenCharacter
   {
      
      private var speakChannelRef:String;
      
      private var bigTurnMat:SpriteParticleMaterial;
      
      private var customHeadContainer:MovieClip;
      
      private var idleHead:MovieClip;
      
      private var voxHeadLibrary:Dictionary = new Dictionary();
      
      private var idleHeadIsLive:Boolean = false;
      
      private var bigTurnUpdater:CameraThetaRelativePointSpriteMovieUpdater;
      
      private var bigTurnMov:MovieClip;
      
      public function BigLoungingController(param1:String)
      {
         super();
         speakChannelRef = param1;
      }
      
      private function showIdleHead(param1:Boolean = false) : void
      {
         idleHead.gotoAndStop("HeadOn");
         flushHeadContainer();
         if(customHeadContainer)
         {
            customHeadContainer.addChild(idleHead);
         }
         idleHeadIsLive = true;
      }
      
      private function handleIdleHeadUpdate(param1:Event = null) : void
      {
         if(!idleHeadIsLive)
         {
            return;
         }
         var _loc2_:int = bigTurnUpdater.frame - idleHead.currentFrame;
         if(_loc2_ > 0)
         {
            idleHead.gotoAndStop(idleHead.currentFrame + int(_loc2_ * 0.35));
         }
         else if(_loc2_ < 0)
         {
            idleHead.gotoAndStop(idleHead.currentFrame + int(_loc2_ * 0.35));
         }
      }
      
      public function prepare() : void
      {
         this.visible = true;
      }
      
      public function activate() : void
      {
         addIdleHeadUpdateListener();
      }
      
      private function addIdleHeadUpdateListener() : void
      {
         idleHead.addEventListener(Event.ENTER_FRAME,handleIdleHeadUpdate);
      }
      
      private function showCustomHead(param1:MovieClip) : void
      {
         flushHeadContainer();
         customHeadContainer.addChild(param1);
         idleHeadIsLive = false;
      }
      
      public function get isTalking() : Boolean
      {
         return SoundManager.isChannelBusy(speakChannelRef);
      }
      
      private function flushHeadContainer() : void
      {
         if(!customHeadContainer)
         {
            return;
         }
         while(customHeadContainer.numChildren > 0)
         {
            customHeadContainer.removeChildAt(0);
         }
      }
      
      private function handleSyncComplete() : void
      {
         showIdleHead();
      }
      
      public function speakLine(param1:String) : void
      {
         var headclip:MovieClip;
         var strlab:String = param1;
         if(SoundManager.isChannelBusy(speakChannelRef) || SoundManagerOld.channelOccupied(1))
         {
            return;
         }
         headclip = voxHeadLibrary[strlab];
         if(!headclip)
         {
            return;
         }
         showCustomHead(headclip);
         try
         {
            SoundManager.playSyncAnimSound(headclip,strlab,speakChannelRef,26,2,0,0,0,handleSyncComplete);
         }
         catch(e:Error)
         {
            trace("BigLoungingController.speakLine error :: ",strlab,e);
         }
      }
      
      public function park() : void
      {
         this.visible = false;
         bigTurnMat.removeSprite();
      }
      
      private function removeIdleHeadUpdateListener() : void
      {
         idleHead.removeEventListener(Event.ENTER_FRAME,handleIdleHeadUpdate);
      }
      
      public function deactivate() : void
      {
         removeIdleHeadUpdateListener();
         showIdleHead(true);
      }
      
      public function registerVoxHead(param1:String, param2:Sound, param3:MovieClip) : void
      {
         SoundManager.quickRegisterSound(param1,param2);
         param3.stop();
         voxHeadLibrary[param1] = param3;
      }
      
      public function setContent(param1:MovieClip, param2:MovieClip, param3:Number = 1, param4:Number = 1) : void
      {
         if(bigTurnMov)
         {
            return;
         }
         bigTurnMov = param1;
         idleHead = param2;
         idleHead.stop();
         customHeadContainer = bigTurnMov["customHead"];
         bigTurnMat = new SpriteParticleMaterial(bigTurnMov);
         bigTurnUpdater = new CameraThetaRelativePointSpriteMovieUpdater(bigTurnMat,param3,param4);
         bigTurnUpdater.size = 1;
         addChild(bigTurnUpdater);
         showIdleHead();
         deactivate();
      }
   }
}

