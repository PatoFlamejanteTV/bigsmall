package org.papervision3d.core.render.project
{
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class BasicProjectionPipeline extends ProjectionPipeline
   {
      
      public function BasicProjectionPipeline()
      {
         super();
         init();
      }
      
      protected function init() : void
      {
      }
      
      override public function project(param1:RenderSessionData) : void
      {
         var _loc3_:DisplayObject3D = null;
         var _loc5_:Number = NaN;
         param1.camera.transformView();
         var _loc2_:Array = param1.renderObjects;
         var _loc4_:Number = _loc2_.length;
         if(param1.camera.useProjectionMatrix)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.visible)
               {
                  if(param1.viewPort.viewportObjectFilter)
                  {
                     _loc5_ = param1.viewPort.viewportObjectFilter.testObject(_loc3_);
                     if(_loc5_)
                     {
                        projectObject(_loc3_,param1,_loc5_);
                     }
                     else
                     {
                        ++param1.renderStatistics.filteredObjects;
                     }
                  }
                  else
                  {
                     projectObject(_loc3_,param1,1);
                  }
               }
            }
         }
         else
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.visible)
               {
                  if(param1.viewPort.viewportObjectFilter)
                  {
                     _loc5_ = param1.viewPort.viewportObjectFilter.testObject(_loc3_);
                     if(_loc5_)
                     {
                        projectObject(_loc3_,param1,_loc5_);
                     }
                     else
                     {
                        ++param1.renderStatistics.filteredObjects;
                     }
                  }
                  else
                  {
                     projectObject(_loc3_,param1,1);
                  }
               }
            }
         }
      }
      
      protected function projectObject(param1:DisplayObject3D, param2:RenderSessionData, param3:Number) : void
      {
         param1.cullTest = param3;
         if(param1.parent)
         {
            param1.project(param1.parent as DisplayObject3D,param2);
         }
         else
         {
            param1.project(param2.camera,param2);
         }
      }
   }
}

