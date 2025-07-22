package net.pluginmedia.bigandsmall.pages.garden.pond.statics
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class ReflectingReeds extends DisplayObject3D
   {
      
      public var reflPlane:Plane;
      
      public var aboveLayer:ViewportLayer;
      
      public var reedPlane:Plane;
      
      public var reflLayer:ViewportLayer;
      
      public function ReflectingReeds(param1:Number, param2:Number, param3:Number, param4:Number, param5:*, param6:ViewportLayer, param7:ViewportLayer, param8:BlurFilter, param9:ColorTransform, param10:Number = 0)
      {
         var _loc11_:BitmapData = null;
         var _loc16_:DisplayObject = null;
         super();
         if(param5 is BitmapData)
         {
            _loc11_ = param5 as BitmapData;
         }
         else if(param5 is DisplayObject)
         {
            _loc16_ = param5 as DisplayObject;
            _loc11_ = new BitmapData(_loc16_.width,_loc16_.height,true,0);
            _loc11_.draw(_loc16_);
         }
         var _loc12_:MaterialObject3D = new BitmapMaterial(_loc11_);
         reedPlane = new Plane(_loc12_,param1,param2,param3,param4);
         addChild(reedPlane);
         var _loc13_:BitmapData = new BitmapData(_loc11_.width,_loc11_.height,true,16777215);
         var _loc14_:Matrix = new Matrix();
         _loc14_.scale(1,-1);
         _loc14_.translate(0,_loc13_.height);
         _loc13_.draw(param5,_loc14_,param9);
         _loc13_.applyFilter(_loc13_,_loc13_.rect,new Point(),param8);
         var _loc15_:MaterialObject3D = new BitmapMaterial(_loc13_);
         reflPlane = new Plane(_loc15_,param1,param2,param3,param4);
         reflPlane.y = -param2 + param10;
         addChild(reflPlane);
         aboveLayer = param6.getChildLayer(reedPlane,true,true);
         reflLayer = param7.getChildLayer(reflPlane,true,true);
      }
   }
}

