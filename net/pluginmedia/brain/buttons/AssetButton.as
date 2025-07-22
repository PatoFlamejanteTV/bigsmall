package net.pluginmedia.brain.buttons
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import net.pluginmedia.brain.core.Button;
   
   public class AssetButton extends Button
   {
      
      protected var displayObjectAsset:DisplayObject;
      
      public function AssetButton(param1:*, param2:String = null, param3:String = null, param4:Object = null)
      {
         if(param1 is Class)
         {
            param1 = new param1() as MovieClip;
         }
         if(param1 is MovieClip)
         {
            param1.gotoAndStop(1);
         }
         if(param1 is DisplayObjectContainer)
         {
            param1.mouseChildren = false;
         }
         param1.buttonMode = true;
         displayObjectAsset = param1 as DisplayObject;
         this.mouseChildren = false;
         super(param2,param3,actionObj);
      }
      
      override protected function updateVisualState() : void
      {
         var _loc1_:MovieClip = null;
         if(displayObjectAsset is MovieClip)
         {
            _loc1_ = displayObjectAsset as MovieClip;
            if(_isDown)
            {
               _loc1_.gotoAndStop("_down");
            }
            else if(_isSelected)
            {
               _loc1_.gotoAndStop("_active");
            }
            else if(_isOver)
            {
               _loc1_.gotoAndStop("_over");
            }
            else
            {
               _loc1_.gotoAndStop("_up");
            }
            return;
         }
         super.updateVisualState();
      }
      
      override protected function buildView() : void
      {
         addChild(displayObjectAsset);
      }
   }
}

