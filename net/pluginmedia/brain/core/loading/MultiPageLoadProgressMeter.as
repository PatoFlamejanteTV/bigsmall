package net.pluginmedia.brain.core.loading
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   import net.pluginmedia.brain.core.interfaces.IPageManager;
   import net.pluginmedia.brain.managers.LoadManager;
   
   public class MultiPageLoadProgressMeter extends PageLoadProgressMeter
   {
      
      protected var _iLoadableList:Array = [];
      
      protected var _preloaderData:MultiPageLoadProgressMeterInfo;
      
      protected var _loadManager:LoadManager;
      
      protected var _pageManager:IPageManager;
      
      public function MultiPageLoadProgressMeter(param1:Number, param2:Number, param3:LoadManager, param4:IPageManager)
      {
         _loadManager = param3;
         _pageManager = param4;
         super(param1,param2);
      }
      
      override public function stepLoadProgress() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Function = null;
         if(!_iLoadableList || _iLoadableList.length == 0)
         {
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = _loadManager.getListUnitLoaded(_iLoadableList);
         }
         _loc1_ = _loc1_ * 100 + 1;
         if(_loc1_ >= 101)
         {
            _loc2_ = _preloaderData.onComplete;
            reset();
            banish();
            if(_loc2_ !== null)
            {
               _loc2_();
            }
         }
         setProgressVisual(_loc1_);
      }
      
      override protected function initGFX() : void
      {
         containerClip.graphics.beginFill(255,0.5);
         containerClip.graphics.drawRect(0,0,pageWidth,pageHeight);
         containerClip.graphics.endFill();
         progressBarOutl.graphics.lineStyle(0.25,16777215,1);
         progressBarOutl.graphics.drawRect(-1,-1,barWidth + 1,barHeight + 1);
         progressBarOutl.x = pageWidth / 2 - barWidth / 2;
         progressBarOutl.y = pageHeight / 2 - barHeight / 2;
         containerClip.addChild(progressBarOutl);
         progressBar.graphics.beginFill(16711935,1);
         progressBar.graphics.drawRect(0,0,barWidth,barHeight);
         progressBar.graphics.endFill();
         progressBar.x = pageWidth / 2 - barWidth / 2;
         progressBar.y = pageHeight / 2 - barHeight / 2;
         containerClip.addChild(progressBar);
         progressOutText = new TextField();
         progressOutText.text = "0";
         progressOutText.autoSize = TextFieldAutoSize.LEFT;
         progressOutText.x = progressBarOutl.x;
         progressOutText.y = progressBarOutl.y - progressOutText.height;
         containerClip.addChild(progressOutText);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = 16777215;
         progressOutText.defaultTextFormat = _loc1_;
      }
      
      public function monitorPages(param1:MultiPageLoadProgressMeterInfo, param2:Boolean = true) : void
      {
         reset();
         if(param2)
         {
            summon();
         }
         _preloaderData = param1;
         _iLoadableList = getPagesFromStrings(_preloaderData.collectionList);
         enableEnterFrame();
      }
      
      override public function reset() : void
      {
         monitorSubject = null;
         _preloaderData = null;
         _iLoadableList = null;
         disableEnterFrame();
      }
      
      protected function getPagesFromStrings(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:ILoadable = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = _pageManager.getPageByID(_loc3_ as String) as ILoadable;
            if(_loc4_ !== null)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

