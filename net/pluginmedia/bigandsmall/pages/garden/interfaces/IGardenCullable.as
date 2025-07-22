package net.pluginmedia.bigandsmall.pages.garden.interfaces
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public interface IGardenCullable
   {
      
      function get referringDisplayObject3D() : DisplayObject3D;
      
      function get points() : Array;
      
      function manuallyDefineCullRect(param1:Rectangle) : void;
      
      function initCullPoints() : void;
      
      function checkIsIn(param1:Number, param2:Number) : Boolean;
      
      function get referringDisplayObject3DParent() : DisplayObjectContainer3D;
   }
}

