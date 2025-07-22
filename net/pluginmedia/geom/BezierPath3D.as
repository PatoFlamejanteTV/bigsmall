package net.pluginmedia.geom
{
   import flash.display.Graphics;
   import net.pluginmedia.tools.GFXTools;
   import org.papervision3d.core.math.Number3D;
   
   public class BezierPath3D extends PointPath3D
   {
      
      public var autoSpacePath:Boolean = true;
      
      protected var curveMag:Number;
      
      public var transitStepInc:Number = 0.04;
      
      public var autoPlaceControls:Boolean = true;
      
      protected var _segments:Array;
      
      public function BezierPath3D(param1:Number = 8, ... rest)
      {
         var _loc3_:BezierPoint3D = null;
         _segments = [];
         super();
         curveMag = param1;
         pointLabelFormat.color = 65535;
         for each(_loc3_ in rest)
         {
            pushPoint3D(_loc3_);
         }
         if(rest.length > 0)
         {
            reCalcSegments();
         }
      }
      
      override public function addPoint3D(param1:Point3D) : void
      {
         pushPoint3D(param1);
         reCalcSegments();
      }
      
      public function get segments() : Array
      {
         return _segments;
      }
      
      override public function debugDraw2D(param1:Graphics = null) : void
      {
         var _loc2_:BezierSegment3D = null;
         super.debugDraw2D(param1);
         for each(_loc2_ in _segments)
         {
            GFXTools.drawPoint(param1,_loc2_.pointA,2,65280);
            GFXTools.drawPoint(param1,_loc2_.controlA,4,16711680);
            GFXTools.drawLine(param1,_loc2_.pointA,_loc2_.controlA,255,1,0.3);
            GFXTools.drawPoint(param1,_loc2_.pointB,2,65280);
            GFXTools.drawPoint(param1,_loc2_.controlB,4,16711680);
            GFXTools.drawLine(param1,_loc2_.pointB,_loc2_.controlB,255,1,0.3);
            GFXTools.drawLine(param1,_loc2_.pointA,_loc2_.pointB,16777215,1,0.3);
         }
      }
      
      public function purgeSegments() : void
      {
         while(_segments.length > 0)
         {
            _segments[0] = null;
            _segments.splice(0,1);
         }
         _segments = new Array();
         _length = 0;
      }
      
      override public function toString() : String
      {
         return "BezierPath3D :: " + this._points.toString();
      }
      
      public function reCalcSegments(param1:Number = 0) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:BezierPoint3D = null;
         var _loc6_:BezierPoint3D = null;
         var _loc7_:BezierPoint3D = null;
         var _loc8_:BezierPoint3D = null;
         var _loc9_:BezierPoint3D = null;
         var _loc10_:Number3D = null;
         var _loc11_:Number3D = null;
         var _loc12_:Number3D = null;
         var _loc13_:Number3D = null;
         var _loc14_:Number3D = null;
         var _loc15_:Number3D = null;
         var _loc16_:Number3D = null;
         var _loc17_:Number3D = null;
         var _loc18_:Number3D = null;
         var _loc19_:BezierPoint3D = null;
         var _loc20_:BezierPoint3D = null;
         var _loc21_:BezierSegment3D = null;
         var _loc2_:int = 0;
         if(param1 < 0)
         {
            _loc2_ = Math.max(0,_segments.length + param1);
         }
         else if(param1 > 0)
         {
            _loc2_ = Math.min(_segments.length,param1);
         }
         if(this._points.length - _loc2_ < 2)
         {
            return;
         }
         if(autoPlaceControls)
         {
            _loc4_ = _loc2_;
            while(_loc4_ < _points.length - 2)
            {
               _loc7_ = _points[_loc4_];
               _loc8_ = _points[_loc4_ + 1];
               _loc9_ = _points[_loc4_ + 2];
               _loc10_ = Number3D.sub(_loc8_,_loc7_);
               _loc11_ = Number3D.sub(_loc9_,_loc8_);
               _loc12_ = _loc10_.clone();
               _loc12_.normalize();
               _loc13_ = _loc11_.clone();
               _loc13_.normalize();
               _loc14_ = Number3D.add(_loc12_,_loc13_);
               _loc15_ = _loc14_.clone();
               _loc15_.multiplyEq(_loc11_.modulo / curveMag);
               _loc16_ = _loc14_.clone();
               _loc16_.multiplyEq(-_loc10_.modulo / curveMag);
               _loc17_ = Number3D.add(_loc8_,_loc16_);
               _loc18_ = Number3D.add(_loc8_,_loc15_);
               _loc8_.controlA = _loc17_;
               _loc8_.controlB = _loc18_;
               _loc4_++;
            }
            _loc5_ = _points[_points.length - 1] as BezierPoint3D;
            _loc5_.controlA.x = _loc5_.x;
            _loc5_.controlA.y = _loc5_.y;
            _loc5_.controlA.z = _loc5_.z;
            _loc6_ = _points[0] as BezierPoint3D;
            _loc6_.controlB.x = _loc6_.x;
            _loc6_.controlB.y = _loc6_.y;
            _loc6_.controlB.z = _loc6_.z;
         }
         purgeSegments();
         var _loc3_:Number = 0;
         while(_loc3_ < _points.length - 1)
         {
            _loc19_ = _points[_loc3_];
            _loc20_ = _points[_loc3_ + 1];
            _loc21_ = new BezierSegment3D(_loc19_,_loc19_.controlB,_loc20_,_loc20_.controlA);
            _segments.push(_loc21_);
            _length += _loc21_.length;
            _loc3_++;
         }
      }
      
      public function getNumber3DAtT(param1:Number) : Number3D
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:BezierSegment3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number3D = null;
         var _loc9_:BezierSegment3D = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number3D = null;
         var _loc12_:int = 0;
         var _loc2_:Number3D = new Number3D(0,0,0);
         if(_segments.length == 0)
         {
            return _loc2_;
         }
         if(autoSpacePath)
         {
            _loc3_ = param1 * length;
            _loc4_ = length;
            _loc5_ = _segments.length - 1;
            while(_loc5_ >= 0)
            {
               _loc4_ -= _segments[_loc5_].length;
               if(_loc3_ >= _loc4_)
               {
                  _loc6_ = _segments[_loc5_];
                  _loc7_ = (_loc3_ - _loc4_) / _loc6_.length;
                  return _loc6_.getNumber3DAtT(_loc7_);
               }
               _loc5_--;
            }
            return _loc2_;
         }
         _loc12_ = Math.floor(param1 * _segments.length);
         if(_loc12_ == _segments.length)
         {
            _loc12_--;
            _loc9_ = _segments[_loc12_];
            _loc10_ = 1;
         }
         else
         {
            _loc9_ = _segments[_loc12_];
            _loc10_ = _segments.length * param1 - _loc12_;
         }
         return _loc9_.getNumber3DAtT(_loc10_);
      }
      
      override public function destroy() : void
      {
         purgeSegments();
         while(_points.length > 0)
         {
            _points[0] = null;
            _points.splice(0,1);
         }
         _points = new Array();
      }
      
      override public function clone() : *
      {
         var _loc3_:BezierPoint3D = null;
         var _loc1_:Array = _points.concat();
         var _loc2_:BezierPath3D = new BezierPath3D(curveMag);
         for each(_loc3_ in _loc1_)
         {
            _loc2_.pushPoint3D(_loc3_);
         }
         _loc2_.reCalcSegments();
         _loc2_.transitStepInc = this.transitStepInc;
         return _loc2_ as BezierPath3D;
      }
   }
}

