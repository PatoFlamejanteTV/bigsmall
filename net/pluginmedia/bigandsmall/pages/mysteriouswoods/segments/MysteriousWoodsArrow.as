package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import net.pluginmedia.bigandsmall.ui.StateablePointSpriteButton;
   import net.pluginmedia.bigandsmall.ui.StateablePointSpriteState;
   
   public class MysteriousWoodsArrow extends StateablePointSpriteButton
   {
      
      public var pathKey:String;
      
      public function MysteriousWoodsArrow()
      {
         super();
         setAlpha(0);
      }
      
      override public function activate() : void
      {
         super.activate();
         addChild(pSprite);
         fadeIn();
         if(viewportLayer)
         {
            viewportLayer.tabEnabled = true;
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         setAlpha(0);
         removeChild(pSprite);
         spriteParticleMat.removeSprite();
         if(viewportLayer)
         {
            viewportLayer.tabEnabled = false;
         }
      }
      
      override public function subsumeState(param1:StateablePointSpriteState) : void
      {
         super.subsumeState(param1);
      }
   }
}

