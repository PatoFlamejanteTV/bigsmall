package net.pluginmedia.bigandsmall.pages.garden.pond
{
   import flash.display.BitmapData;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.shared.MirrorImageInfo;
   import net.pluginmedia.pv3d.materials.MirrorMaterial;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MirrorPond
   {
      
      public static var DEFAULTDATA:String = "MirrorPond.DEAFULTDATA";
      
      private var bigSnapshot:BitmapData;
      
      private var lighterTransform:ColorTransform = new ColorTransform(1,1,1,1,10,10,10);
      
      private var reflections:Dictionary = new Dictionary();
      
      private var smallSnapshot:BitmapData;
      
      private var targetDisplayObject:DisplayObject3D;
      
      private var defaultData:BitmapData;
      
      public var cVert:Vertex3D;
      
      private var filterPoint:Point = new Point();
      
      public var pondWindowMat:MirrorMaterial;
      
      private var blurFilter:BlurFilter = new BlurFilter(16,0);
      
      public function MirrorPond(param1:DisplayObject3D)
      {
         super();
         targetDisplayObject = param1;
         cVert = new Vertex3D(0,0,0);
         targetDisplayObject.geometry.vertices.push(cVert);
         targetDisplayObject.geometry.ready = true;
         targetDisplayObject.geometry.dirty = true;
         defaultData = new BitmapData(1,1,false,16711935);
         registerSnapshot(DEFAULTDATA,defaultData);
         pondWindowMat = new MirrorMaterial(defaultData);
         pondWindowMat.setDistanceVertex(cVert);
         targetDisplayObject.material = pondWindowMat;
      }
      
      public function selectSnapshot(param1:String) : void
      {
         var _loc2_:MirrorImageInfo = reflections[param1];
         if(!_loc2_)
         {
            return;
         }
         pondWindowMat.bitmap = _loc2_.bitmapData;
         pondWindowMat.scale = _loc2_.scale;
         cVert.x = _loc2_.x;
         cVert.y = _loc2_.y;
         cVert.z = _loc2_.z;
      }
      
      public function registerSnapshot(param1:String, param2:BitmapData, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 1) : void
      {
         var _loc7_:MirrorImageInfo = new MirrorImageInfo(param1,param2,param3,param4,param5,param6);
         reflections[param1] = _loc7_;
      }
      
      private function applyFX(param1:BitmapData) : void
      {
         param1.applyFilter(param1,param1.rect,filterPoint,blurFilter);
         param1.colorTransform(param1.rect,lighterTransform);
      }
   }
}

