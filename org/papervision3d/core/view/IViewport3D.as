package org.papervision3d.core.view
{
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface IViewport3D
   {
      
      function updateAfterRender(param1:RenderSessionData) : void;
      
      function updateBeforeRender(param1:RenderSessionData) : void;
   }
}

