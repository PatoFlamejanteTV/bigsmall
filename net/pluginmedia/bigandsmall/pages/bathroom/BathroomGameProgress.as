package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import org.papervision3d.view.BasicView;
   
   public class BathroomGameProgress extends Sprite
   {
      
      private var dockClip:MovieClip;
      
      private var basicView:BasicView;
      
      private var backButton:AssetButton;
      
      private var progressAnim:AnimationOld;
      
      public function BathroomGameProgress(param1:BasicView, param2:MovieClip, param3:MovieClip, param4:MovieClip)
      {
         super();
         this.basicView = param1;
         dockClip = param2;
         addChild(dockClip);
         progressAnim = new AnimationOld(param3);
         progressAnim.gotoAndStop(1);
         progressAnim.x = -55;
         progressAnim.y = -46;
         addChild(progressAnim);
         backButton = new AssetButton(param4);
         backButton.x = -75;
         backButton.y = 286;
         backButton.addEventListener(MouseEvent.CLICK,handleExitClick);
         addChild(backButton);
         AccessibilityManager.addAccessibilityProperties(backButton,"Back","Exit the game",AccessibilityDefinitions.UIBUTTON);
         unSummon(true);
      }
      
      public function summon(param1:Boolean = false) : void
      {
         if(!param1)
         {
            TweenMax.to(this,0.5,{"x":basicView.viewport.viewportWidth});
         }
         else
         {
            this.x = basicView.viewport.containerSprite.width - this.width;
         }
      }
      
      public function gotoPercent(param1:uint, param2:Boolean = false) : void
      {
         if(param2)
         {
            progressAnim.gotoAndStop(Math.min(100,param1 + 1));
         }
         else
         {
            progressAnim.playToFrame(Math.min(100,param1 + 1));
         }
      }
      
      public function unSummon(param1:Boolean = true) : void
      {
         if(!param1)
         {
            TweenMax.to(this,0.5,{"x":basicView.viewport.viewportWidth + this.width});
         }
         else
         {
            this.x = basicView.viewport.viewportWidth + this.width;
         }
      }
      
      public function onPrepare() : void
      {
      }
      
      public function onPark() : void
      {
      }
      
      private function handleExitClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("GAME_EXIT"));
      }
   }
}

