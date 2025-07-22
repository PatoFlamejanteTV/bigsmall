package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.animation.BigAndSmallCompTransitionFX;
   import net.pluginmedia.bigandsmall.definitions.SoundChannelDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.MysteriousWoods;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class EndSegment extends AbstractSegment
   {
      
      public static const DANCE:String = "EndSegment.DANCE";
      
      public static const ANIMSEQ_COMPLETE:String = "EndSegment.ANIMSEQ_COMPLETE";
      
      private var danceAnimLayer:ViewportLayer;
      
      private var danceSoundRef:String;
      
      private var danceClip:MovieClip;
      
      private var endAnims:Dictionary = new Dictionary();
      
      private var pointSpriteMat:SpriteParticleMaterial;
      
      private var currentAnimObj:Object;
      
      private var transitionFX:BigAndSmallCompTransitionFX;
      
      private var nullClip:MovieClip = new MovieClip();
      
      private var pointSprite:PointSprite;
      
      private var endSeqIndex:int = 0;
      
      public function EndSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:BigAndSmallCompTransitionFX, param6:MovieClip, param7:String)
      {
         super(param1,param2,param3,param4);
         transitionFX = param5;
         registerAnimationSeq(DANCE,param6,param7);
      }
      
      public function resetAnims() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in endAnims)
         {
            MovieClip(_loc1_.clip).gotoAndStop(1);
         }
      }
      
      protected function doTransitionToDancePhase() : void
      {
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_BUTTONS));
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_NAVMENUBUTTON));
         transitionFX.doNamedTransitionIn("Transition_D",handleTransitionInDone);
         SoundManager.playSound(MysteriousWoods.SFX_ToDance);
      }
      
      private function handleTransitionInDone() : void
      {
         selectAnim(DANCE);
         transitionFX.doNamedTransitionOut("Transition_D",handleTransitionOutDone);
      }
      
      public function selectAnim(param1:String) : void
      {
         if(!param1)
         {
            pointSpriteMat.movie = nullClip;
            currentAnimObj = null;
            return;
         }
         var _loc2_:Object = endAnims[param1];
         if(_loc2_)
         {
            currentAnimObj = _loc2_;
            pointSpriteMat.movie = currentAnimObj.clip;
         }
      }
      
      override public function prepare() : void
      {
         selectAnim(currentPOV + "_" + endSeqIndex.toString());
         addChild(pointSprite);
      }
      
      private function handleTransitionOutDone() : void
      {
         dispatchEvent(new BrainEvent(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON));
         doAnimationSeq(doneDancePhase);
      }
      
      protected function doAnimationSeq(param1:Function) : void
      {
         SoundManager.playSyncAnimSound(currentAnimObj.clip,currentAnimObj.soundRef,SoundChannelDefinitions.VOX,25,1,0,0,0,param1);
      }
      
      override public function park() : void
      {
         pointSpriteMat.movie = nullClip;
         resetAnims();
         removeChild(pointSprite);
         pointSpriteMat.removeSprite();
      }
      
      override public function activate() : void
      {
         super.activate();
         doAnimationSeq(doTransitionToDancePhase);
         endSeqIndex = (endSeqIndex + 1) % 2;
         flagDirtyLayer(danceAnimLayer);
      }
      
      override public function deactivate() : void
      {
         SoundManager.stopChannel(SoundChannelDefinitions.VOX);
         unflagDirtyLayer(danceAnimLayer);
      }
      
      protected function doneDancePhase() : void
      {
         dispatchEvent(new Event(ANIMSEQ_COMPLETE));
      }
      
      override protected function buildDisplay(param1:DAEFixed, param2:Boolean = false) : void
      {
         super.buildDisplay(param1,param2);
         pointSpriteMat = new SpriteParticleMaterial(nullClip);
         pointSprite = new PointSprite(pointSpriteMat,1);
         pointSprite.z = segmentSize >> 1;
         danceAnimLayer = woodsLayer.getChildLayer(pointSprite,true,true);
      }
      
      public function registerAnimationSeq(param1:String, param2:MovieClip, param3:String) : void
      {
         param2.stop();
         endAnims[param1] = {
            "clip":param2,
            "soundRef":param3
         };
      }
   }
}

