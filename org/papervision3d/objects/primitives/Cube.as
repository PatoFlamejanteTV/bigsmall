package org.papervision3d.objects.primitives
{
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.geom.*;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.materials.utils.MaterialsList;
   
   public class Cube extends TriangleMesh3D
   {
      
      public static var NONE:int = 0;
      
      public static var FRONT:int = 1;
      
      public static var BACK:int = 2;
      
      public static var RIGHT:int = 4;
      
      public static var LEFT:int = 8;
      
      public static var TOP:int = 16;
      
      public static var BOTTOM:int = 32;
      
      public static var ALL:int = FRONT + BACK + RIGHT + LEFT + TOP + BOTTOM;
      
      public var segments:Number3D;
      
      private var insideFaces:int;
      
      private var excludeFaces:int;
      
      public function Cube(param1:MaterialsList, param2:Number = 500, param3:Number = 500, param4:Number = 500, param5:int = 1, param6:int = 1, param7:int = 1, param8:int = 0, param9:int = 0)
      {
         super(param1.getMaterialByName("all"),new Array(),new Array(),null);
         this.materials = param1;
         this.insideFaces = param8;
         this.excludeFaces = param9;
         segments = new Number3D(param5,param6,param7);
         buildCube(param2,param4,param3);
      }
      
      public function destroy() : void
      {
         var _loc1_:MaterialObject3D = null;
         for each(_loc1_ in materials)
         {
            _loc1_.unregisterObject(this);
         }
      }
      
      protected function buildCube(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc7_:Triangle3D = null;
         var _loc4_:Number = param1 / 2;
         var _loc5_:Number = param2 / 2;
         var _loc6_:Number = param3 / 2;
         if(!(excludeFaces & FRONT))
         {
            buildPlane("front","x","y",param1,param2,_loc6_,!Boolean(insideFaces & FRONT));
         }
         if(!(excludeFaces & BACK))
         {
            buildPlane("back","x","y",param1,param2,-_loc6_,Boolean(insideFaces & BACK));
         }
         if(!(excludeFaces & RIGHT))
         {
            buildPlane("right","z","y",param3,param2,_loc4_,Boolean(insideFaces & RIGHT));
         }
         if(!(excludeFaces & LEFT))
         {
            buildPlane("left","z","y",param3,param2,-_loc4_,!Boolean(insideFaces & LEFT));
         }
         if(!(excludeFaces & TOP))
         {
            buildPlane("top","x","z",param1,param3,_loc5_,Boolean(insideFaces & TOP));
         }
         if(!(excludeFaces & BOTTOM))
         {
            buildPlane("bottom","x","z",param1,param3,-_loc5_,!Boolean(insideFaces & BOTTOM));
         }
         mergeVertices();
         for each(_loc7_ in this.geometry.faces)
         {
            _loc7_.renderCommand.create = createRenderTriangle;
         }
         this.geometry.ready = true;
         if(Papervision3D.useRIGHTHANDED)
         {
            this.geometry.flipFaces();
         }
      }
      
      protected function buildPlane(param1:String, param2:String, param3:String, param4:Number, param5:Number, param6:Number, param7:Boolean = false) : void
      {
         var _loc8_:MaterialObject3D = null;
         var _loc9_:String = null;
         var _loc23_:NumberUV = null;
         var _loc24_:NumberUV = null;
         var _loc25_:NumberUV = null;
         var _loc26_:int = 0;
         var _loc27_:Vertex3D = null;
         var _loc28_:Vertex3D = null;
         var _loc29_:Vertex3D = null;
         var _loc30_:Vertex3D = null;
         _loc8_ = materials.getMaterialByName(param1);
         if(!_loc8_)
         {
            _loc8_ = materials.getMaterialByName("all");
            if(!_loc8_)
            {
               PaperLogger.warning("Required material not found in given materials list. Supported materials are: front, back, right, left, top, bottom & all.");
               return;
            }
         }
         _loc8_.registerObject(this);
         if(param2 == "x" && param3 == "y" || param2 == "y" && param3 == "x")
         {
            _loc9_ = "z";
         }
         else if(param2 == "x" && param3 == "z" || param2 == "z" && param3 == "x")
         {
            _loc9_ = "y";
         }
         else if(param2 == "z" && param3 == "y" || param2 == "y" && param3 == "z")
         {
            _loc9_ = "x";
         }
         var _loc10_:Number = param7 ? -1 : 1;
         var _loc11_:Number = Number(this.segments[param2]);
         var _loc12_:Number = Number(this.segments[param3]);
         var _loc13_:Number = _loc11_ + 1;
         var _loc14_:Number = _loc12_ + 1;
         var _loc15_:Array = this.geometry.vertices;
         var _loc16_:Array = this.geometry.faces;
         var _loc17_:Array = new Array();
         var _loc18_:Number = param4 / 2;
         var _loc19_:Number = param5 / 2;
         var _loc20_:Number = param4 / _loc11_;
         var _loc21_:Number = param5 / _loc12_;
         var _loc22_:int = 0;
         while(_loc22_ < _loc13_)
         {
            _loc26_ = 0;
            while(_loc26_ < _loc14_)
            {
               _loc27_ = new Vertex3D();
               _loc27_[param2] = (_loc22_ * _loc20_ - _loc18_) * _loc10_;
               _loc27_[param3] = _loc26_ * _loc21_ - _loc19_;
               _loc27_[_loc9_] = param6;
               _loc15_.push(_loc27_);
               _loc17_.push(_loc27_);
               _loc26_++;
            }
            _loc22_++;
         }
         _loc22_ = 0;
         while(_loc22_ < _loc11_)
         {
            _loc26_ = 0;
            while(_loc26_ < _loc12_)
            {
               _loc28_ = _loc17_[_loc22_ * _loc14_ + _loc26_];
               _loc29_ = _loc17_[_loc22_ * _loc14_ + (_loc26_ + 1)];
               _loc30_ = _loc17_[(_loc22_ + 1) * _loc14_ + _loc26_];
               _loc23_ = new NumberUV(_loc22_ / _loc11_,_loc26_ / _loc12_);
               _loc24_ = new NumberUV(_loc22_ / _loc11_,(_loc26_ + 1) / _loc12_);
               _loc25_ = new NumberUV((_loc22_ + 1) / _loc11_,_loc26_ / _loc12_);
               _loc16_.push(new Triangle3D(this,[_loc28_,_loc30_,_loc29_],_loc8_,[_loc23_,_loc25_,_loc24_]));
               _loc28_ = _loc17_[(_loc22_ + 1) * _loc14_ + (_loc26_ + 1)];
               _loc29_ = _loc17_[(_loc22_ + 1) * _loc14_ + _loc26_];
               _loc30_ = _loc17_[_loc22_ * _loc14_ + (_loc26_ + 1)];
               _loc23_ = new NumberUV((_loc22_ + 1) / _loc11_,(_loc26_ + 1) / _loc12_);
               _loc24_ = new NumberUV((_loc22_ + 1) / _loc11_,_loc26_ / _loc12_);
               _loc25_ = new NumberUV(_loc22_ / _loc11_,(_loc26_ + 1) / _loc12_);
               _loc16_.push(new Triangle3D(this,[_loc29_,_loc28_,_loc30_],_loc8_,[_loc24_,_loc23_,_loc25_]));
               _loc26_++;
            }
            _loc22_++;
         }
      }
   }
}

