package net.pluginmedia.brain.buttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class AssetToggleButton extends AssetButton
   {
      
      public function AssetToggleButton(param1:*, param2:String = null, param3:String = null, param4:Object = null)
      {
         super(param1,param2,param3,actionObj);
      }
      
      override protected function updateVisualState() : void
      {
         var _loc1_:MovieClip = null;
         if(displayObjectAsset is MovieClip)
         {
            _loc1_ = displayObjectAsset as MovieClip;
            if(_isSelected)
            {
               _loc1_.gotoAndStop("_off");
            }
            else if(!_isSelected)
            {
               _loc1_.gotoAndStop("_on");
            }
            return;
         }
         super.updateVisualState();
      }
      
      override protected function handleClick(param1:MouseEvent) : void
      {
         if(_isSelected)
         {
            setSelectedState(false);
         }
         else
         {
            setSelectedState(true);
         }
         broadcast(actionType,actionString,actionObj);
      }
   }
}

