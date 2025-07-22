package net.pluginmedia.bigandsmall.ui
{
   import flash.filters.GlowFilter;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class VPortLayerButton extends VPortLayerComponent
   {
      
      protected var outerGlowFilter:GlowFilter = new GlowFilter(16777215,1,16,16,2,2);
      
      public var innerGlow:Boolean = false;
      
      protected var _isSelected:Boolean = false;
      
      protected var allowHighlight:Boolean = true;
      
      protected var innerGlowFilter:GlowFilter = new GlowFilter(16777215,1,16,16,2,2,true);
      
      public function VPortLayerButton(param1:ViewportLayer)
      {
         super(param1);
      }
      
      public function forceHighlight(param1:Boolean) : void
      {
         setHighlight(param1);
      }
      
      public function disableHighlight() : void
      {
         allowHighlight = false;
         setHighlight(false);
      }
      
      override protected function updateVisualState() : void
      {
         if(_isSelected)
         {
            if(_isEnabled)
            {
               if(!_isOver)
               {
                  setHighlight(false);
               }
               else
               {
                  setHighlight(true);
               }
            }
            else if(!_isOver)
            {
               setHighlight(false);
            }
            else
            {
               setHighlight(false);
            }
         }
         else if(_isEnabled)
         {
            if(!_isOver)
            {
               setHighlight(false);
            }
            else
            {
               setHighlight(true);
            }
         }
         else if(!_isOver)
         {
            setHighlight(false);
         }
         else
         {
            setHighlight(false);
         }
      }
      
      public function enableHighlight() : void
      {
         allowHighlight = true;
      }
      
      override protected function setHighlight(param1:Boolean) : void
      {
         if(param1 && allowHighlight)
         {
            if(innerGlow)
            {
               _viewportLayer.filters = [outerGlowFilter,innerGlowFilter];
            }
            else
            {
               _viewportLayer.filters = [outerGlowFilter];
            }
         }
         else
         {
            _viewportLayer.filters = [];
         }
      }
      
      public function setSelectedState(param1:Boolean = true) : void
      {
         _isSelected = param1;
         updateVisualState();
      }
   }
}

