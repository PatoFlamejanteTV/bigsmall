package net.pluginmedia.bigandsmall.core.loading
{
   import flash.events.EventDispatcher;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapFileMaterial;
   import org.papervision3d.objects.parsers.DAE;
   
   public class DAETextureLoadHelper extends EventDispatcher
   {
      
      public function DAETextureLoadHelper()
      {
         super();
      }
      
      public function addDAE(param1:DAE) : void
      {
         var _loc2_:MaterialObject3D = null;
         var _loc3_:BitmapFileMaterial = null;
         for each(_loc2_ in param1.materials.materialsByName)
         {
            if(_loc2_ is BitmapFileMaterial)
            {
               _loc3_ = BitmapFileMaterial(_loc2_);
            }
         }
      }
   }
}

