package net.pluginmedia.bigandsmall.pages.garden.tree.characters
{
   import flash.display.MovieClip;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class AppleTreeBig extends DisplayObject3D
   {
      
      private var speakChannelRef:String;
      
      private var baseBodyClip:MovieClip;
      
      private var onCurrentSpeakerCompleteFunc:Function = null;
      
      private var promptQueue:Array = [];
      
      private var customHeadContainer:MovieClip;
      
      private var particleMaterial:SpriteParticleMaterial;
      
      private var idleHead:MovieClip;
      
      private var voxHeadLibrary:Dictionary = new Dictionary();
      
      private var voxBodyLibrary:Dictionary = new Dictionary();
      
      private var currentBodyClip:MovieClip;
      
      private var promptQueueSize:int = 1;
      
      private var pointSprite:PointSprite;
      
      public function AppleTreeBig(param1:String)
      {
         super();
         speakChannelRef = param1;
      }
      
      private function showIdleHead() : void
      {
         flushHeadContainer();
         if(customHeadContainer)
         {
            customHeadContainer.addChild(idleHead);
         }
      }
      
      private function handleBodySyncComplete() : void
      {
         speakerDone();
      }
      
      public function prepare() : void
      {
         promptQueue = [];
         showIdleHead();
         showBaseBody();
         show();
      }
      
      public function hide() : void
      {
         removeChild(pointSprite);
         particleMaterial.removeSprite();
      }
      
      public function update() : void
      {
         var _loc1_:Object = null;
         if(!SoundManager.isChannelBusy(speakChannelRef) && promptQueue.length > 0)
         {
            _loc1_ = promptQueue.shift();
            actLine(_loc1_.label,false,_loc1_.callback);
         }
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
      
      private function handleHeadSyncComplete() : void
      {
         speakerDone();
      }
      
      private function bodyActLine(param1:MovieClip, param2:String) : void
      {
         var bodyclip:MovieClip = param1;
         var strlab:String = param2;
         particleMaterial.movie = currentBodyClip = bodyclip;
         try
         {
            SoundManager.playSyncAnimSound(bodyclip,strlab,speakChannelRef,-1,1,0,0,0,handleBodySyncComplete);
         }
         catch(e:Error)
         {
            trace("AppleTreeBig.bodyActLine error :: ",strlab,e);
         }
      }
      
      public function actLine(param1:String, param2:Boolean = false, param3:Function = null) : void
      {
         if(SoundManager.isChannelBusy(speakChannelRef) && !param2)
         {
            if(promptQueue.length >= promptQueueSize)
            {
               promptQueue.shift();
            }
            promptQueue.push({
               "label":param1,
               "callback":param3
            });
            return;
         }
         if(param2)
         {
            SoundManager.stopChannel(speakChannelRef);
            showBaseBody();
            showIdleHead();
         }
         var _loc4_:MovieClip = voxBodyLibrary[param1];
         if(_loc4_)
         {
            bodyActLine(_loc4_,param1);
         }
         else
         {
            _loc4_ = voxHeadLibrary[param1];
            if(_loc4_)
            {
               headActLine(_loc4_,param1);
            }
            else
            {
               trace("AppleTreeBig.actLine error :: could not source actor clip for label",param1);
            }
         }
         onCurrentSpeakerCompleteFunc = param3;
      }
      
      public function get isTalking() : Boolean
      {
         return SoundManager.isChannelBusy(speakChannelRef);
      }
      
      private function headActLine(param1:MovieClip, param2:String) : void
      {
         var actclip:MovieClip = param1;
         var strlab:String = param2;
         flushHeadContainer();
         customHeadContainer.addChild(actclip);
         try
         {
            SoundManager.playSyncAnimSound(actclip,strlab,speakChannelRef,-1,1,0,0,0,handleHeadSyncComplete);
         }
         catch(e:Error)
         {
            trace("AppleTreeBig.headActLine error :: ",strlab,e);
         }
      }
      
      private function showBaseBody() : void
      {
         particleMaterial.movie = baseBodyClip;
         currentBodyClip.gotoAndStop(1);
         currentBodyClip = baseBodyClip;
      }
      
      public function park() : void
      {
         hide();
      }
      
      public function setContent(param1:MovieClip, param2:MovieClip) : void
      {
         if(pointSprite)
         {
            return;
         }
         idleHead = param2;
         idleHead.stop();
         customHeadContainer = param1["customHead"];
         baseBodyClip = currentBodyClip = param1;
         particleMaterial = new SpriteParticleMaterial(baseBodyClip);
         pointSprite = new PointSprite(particleMaterial);
         pointSprite.size = 1;
         addChild(pointSprite);
         showIdleHead();
         showBaseBody();
         promptQueue = [];
      }
      
      private function speakerDone() : void
      {
         showBaseBody();
         showIdleHead();
         if(onCurrentSpeakerCompleteFunc is Function)
         {
            onCurrentSpeakerCompleteFunc.apply(this);
         }
         onCurrentSpeakerCompleteFunc = null;
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
         SoundManager.stopChannel(speakChannelRef);
         promptQueue = [];
         showIdleHead();
         showBaseBody();
      }
      
      public function registerVoxHead(param1:String, param2:Sound, param3:MovieClip) : void
      {
         SoundManager.quickRegisterSound(param1,param2);
         param3.stop();
         voxHeadLibrary[param1] = param3;
      }
      
      public function show() : void
      {
         addChild(pointSprite);
      }
      
      public function registerVoxBody(param1:String, param2:Sound, param3:MovieClip) : void
      {
         SoundManager.quickRegisterSound(param1,param2);
         param3.stop();
         voxBodyLibrary[param1] = param3;
      }
   }
}

