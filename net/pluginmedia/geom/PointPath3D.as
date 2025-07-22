package net.pluginmedia.geom
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.pluginmedia.tools.GFXTools;
   import org.papervision3d.core.math.Number3D;
   
   public class PointPath3D extends Sprite
   {
      
      protected var _points:Array;
      
      protected var _length:Number = 0;
      
      protected var pointLabels:Array;
      
      protected var pointLabelFormat:TextFormat;
      
      public function PointPath3D(... rest)
      {
         var _loc2_:Point3D = null;
         _points = [];
         pointLabels = [];
         pointLabelFormat = new TextFormat();
         super();
         for each(_loc2_ in rest)
         {
            pushPoint3D(_loc2_);
         }
         if(rest.length > 0)
         {
            reCalcLength();
         }
      }
      
      public function addPoint3D(param1:Point3D) : void
      {
         pushPoint3D(param1);
         reCalcLength();
      }
      
      protected function getPointLabel(param1:Number) : String
      {
         return String(param1);
      }
      
      public function get points() : Array
      {
         return _points;
      }
      
      public function get length() : Number
      {
         return _length;
      }
      
      protected function pushPoint3D(param1:Point3D) : void
      {
         _points.push(param1);
      }
      
      public function debugDraw2D(param1:Graphics = null) : void
      {
         if(param1 === null)
         {
            param1 = this.graphics;
         }
         graphics.clear();
         clearPointLabels();
         debugDrawPoints2D(param1);
      }
      
      protected function debugDrawPoints2D(param1:Graphics = null) : void
      {
         var _loc4_:Point3D = null;
         var _loc5_:TextField = null;
         if(param1 === null)
         {
            param1 = this.graphics;
         }
         var _loc2_:Point3D = null;
         var _loc3_:Number = 0;
         for each(_loc4_ in _points)
         {
            GFXTools.drawPoint(param1,_loc4_);
            if(_loc2_ !== null)
            {
               GFXTools.drawLine(param1,_loc2_,_loc4_);
            }
            _loc2_ = _loc4_;
            _loc5_ = new TextField();
            _loc5_.autoSize = TextFieldAutoSize.LEFT;
            _loc5_.defaultTextFormat = pointLabelFormat;
            _loc5_.text = getPointLabel(_loc3_);
            _loc5_.x = _loc4_.x;
            _loc5_.y = _loc4_.y;
            addChild(_loc5_);
            pointLabels.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function reCalcLength() : void
      {
         var _loc3_:Point3D = null;
         var _loc4_:Point3D = null;
         var _loc5_:Number = NaN;
         _length = 0;
         var _loc1_:Number3D = new Number3D(0,0,0);
         var _loc2_:Number = 0;
         while(_loc2_ < _points.length - 1)
         {
            _loc3_ = _points[_loc2_];
            _loc4_ = _points[_loc2_ + 1];
            _loc1_.x = _loc3_.x - _loc4_.x;
            _loc1_.y = _loc3_.y + _loc4_.y;
            _loc1_.z = _loc3_.z + _loc4_.z;
            _loc5_ = _loc1_.modulo;
            _length += _loc5_;
            _loc2_++;
         }
      }
      
      protected function clearPointLabels() : void
      {
         var _loc1_:TextField = null;
         while(pointLabels.length > 0)
         {
            _loc1_ = pointLabels[0];
            if(this.contains(_loc1_))
            {
               removeChild(_loc1_);
               pointLabels.splice(0,1);
            }
         }
      }
      
      public function destroy() : void
      {
         while(_points.length > 0)
         {
            _points[0] = null;
            _points.splice(0,1);
         }
         _points = new Array();
         reCalcLength();
      }
      
      public function clone() : *
      {
         var _loc3_:Point3D = null;
         var _loc1_:Array = _points.concat();
         var _loc2_:PointPath3D = new PointPath3D();
         for each(_loc3_ in _loc1_)
         {
            _loc2_.pushPoint3D(_loc3_);
         }
         return _loc2_ as PointPath3D;
      }
   }
}

