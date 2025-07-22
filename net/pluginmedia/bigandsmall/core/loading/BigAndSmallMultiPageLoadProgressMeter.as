package net.pluginmedia.bigandsmall.core.loading
{
   import flash.display.MovieClip;
   import gs.TweenMax;
   import net.pluginmedia.brain.core.interfaces.IPageManager;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeter;
   import net.pluginmedia.brain.core.loading.MultiPageLoadProgressMeterInfo;
   import net.pluginmedia.brain.managers.LoadManager;
   
   public class BigAndSmallMultiPageLoadProgressMeter extends MultiPageLoadProgressMeter
   {
      
      protected var visual:MovieClip;
      
      protected var isTransiting:Boolean = false;
      
      public function BigAndSmallMultiPageLoadProgressMeter(param1:Number, param2:Number, param3:LoadManager, param4:IPageManager, param5:Class)
      {
         visual = new param5();
         addChild(visual);
         super(param1,param2,param3,param4);
         summon(true);
      }
      
      public function summonWallpaper(param1:Boolean = false) : void
      {
         isSummoned = true;
         if(param1)
         {
            wallpaper.alpha = 1;
            wallpaper.visible = true;
         }
         else
         {
            TweenMax.to(wallpaper,1,{
               "autoAlpha":1,
               "overwrite":true
            });
         }
      }
      
      public function get wallpaper() : MovieClip
      {
         return visual.wallpaper;
      }
      
      override public function summon(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this);
         if(param1)
         {
            visual.visible = true;
            visual.alpha = 1;
            handleSummonComplete();
         }
         else
         {
            isTransiting = true;
            TweenMax.to(visual,1,{
               "autoAlpha":1,
               "overwrite":true,
               "onComplete":handleSummonComplete
            });
         }
      }
      
      override protected function initGFX() : void
      {
      }
      
      override public function monitorPages(param1:MultiPageLoadProgressMeterInfo, param2:Boolean = true) : void
      {
         super.monitorPages(param1,param2);
         if(loadBar)
         {
            loadBar.gotoAndStop(1);
         }
      }
      
      public function get logo() : MovieClip
      {
         return visual.logo;
      }
      
      public function get loadBar() : MovieClip
      {
         return visual.loadbar;
      }
      
      override protected function setProgressVisual(param1:Number) : void
      {
         if(loadBar)
         {
            loadBar.gotoAndStop(int(param1));
         }
      }
      
      protected function handleBanishComplete() : void
      {
         isTransiting = false;
      }
      
      protected function handleSummonComplete() : void
      {
         isTransiting = false;
      }
      
      override public function banish(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this);
         if(param1)
         {
            visual.visible = false;
            visual.alpha = 0;
            handleBanishComplete();
         }
         else
         {
            isTransiting = true;
            TweenMax.to(visual,1,{
               "autoAlpha":0,
               "overwrite":true,
               "onComplete":handleBanishComplete
            });
         }
      }
      
      public function banishWallpaper(param1:Boolean = false) : void
      {
         isSummoned = false;
         if(param1)
         {
            wallpaper.alpha = 0;
            wallpaper.visible = false;
         }
         else
         {
            TweenMax.to(wallpaper,1,{
               "autoAlpha":0,
               "overwrite":true
            });
         }
      }
      
      public function removeBeebiesLogo() : void
      {
         visual.removeChild(logo);
      }
   }
}

