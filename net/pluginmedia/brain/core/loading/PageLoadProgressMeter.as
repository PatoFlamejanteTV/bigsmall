package net.pluginmedia.brain.core.loading
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.pluginmedia.brain.core.interfaces.ILoadable;
   
   public class PageLoadProgressMeter extends Sprite
   {
      
      protected var isSummoned:Boolean = true;
      
      protected var pageHeight:Number;
      
      protected var progressBarOutl:Shape = new Shape();
      
      protected var progressBar:Shape = new Shape();
      
      protected var barHeight:Number = 12;
      
      protected var progressOutText:TextField = new TextField();
      
      protected var containerClip:Sprite = new Sprite();
      
      protected var monitorSubject:ILoadable;
      
      protected var pageWidth:Number;
      
      protected var barWidth:Number = 200;
      
      public function PageLoadProgressMeter(param1:Number, param2:Number)
      {
         super();
         pageWidth = param1;
         pageHeight = param2;
         addChild(containerClip);
         initGFX();
         setProgressVisual(0);
         banish(true);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         stepLoadProgress();
      }
      
      protected function initGFX() : void
      {
         containerClip.graphics.beginFill(16711680,0.5);
         containerClip.graphics.drawRect(0,0,pageWidth,pageHeight);
         containerClip.graphics.endFill();
         progressBarOutl.graphics.lineStyle(0.25,16777215,1);
         progressBarOutl.graphics.drawRect(-1,-1,barWidth + 1,barHeight + 1);
         progressBarOutl.x = pageWidth / 2 - barWidth / 2;
         progressBarOutl.y = pageHeight / 2 - barHeight / 2 + 20;
         containerClip.addChild(progressBarOutl);
         progressBar.graphics.beginFill(255,1);
         progressBar.graphics.drawRect(0,0,barWidth,barHeight);
         progressBar.graphics.endFill();
         progressBar.x = pageWidth / 2 - barWidth / 2;
         progressBar.y = pageHeight / 2 - barHeight / 2 + 20;
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
      
      public function reset() : void
      {
         monitorSubject = null;
         disableEnterFrame();
      }
      
      protected function enableEnterFrame() : void
      {
         this.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function monitor(param1:ILoadable) : void
      {
         monitorSubject = param1;
         enableEnterFrame();
         summon();
      }
      
      public function banish(param1:Boolean = true) : void
      {
         if(isSummoned)
         {
            isSummoned = false;
            this.visible = false;
         }
      }
      
      public function stepLoadProgress() : void
      {
         var _loc1_:int = monitorSubject.unitLoaded * 100;
         setProgressVisual(_loc1_);
      }
      
      public function summon(param1:Boolean = true) : void
      {
         if(!isSummoned)
         {
            isSummoned = true;
            this.visible = true;
         }
      }
      
      protected function setProgressVisual(param1:Number) : void
      {
         progressOutText.text = param1.toString();
         progressBar.scaleX = param1 / 100;
      }
      
      protected function disableEnterFrame() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
   }
}

