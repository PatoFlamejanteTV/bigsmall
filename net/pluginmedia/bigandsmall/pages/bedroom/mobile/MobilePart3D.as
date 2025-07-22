package net.pluginmedia.bigandsmall.pages.bedroom.mobile
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import net.pluginmedia.bigandsmall.physics.VerletParticle;
   import net.pluginmedia.bigandsmall.physics.VerletString;
   import net.pluginmedia.bigandsmall.physics.VerletTriangle;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.pv3d.materials.special.LineMaterial3D;
   import org.papervision3d.core.geom.Lines3D;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Cube;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class MobilePart3D extends DisplayObject3D
   {
      
      private var lineThick:int = 1;
      
      private var debugMat:MaterialObject3D = new WireframeMaterial(255,1);
      
      private var lines2:Lines3D;
      
      private var lines1:Lines3D;
      
      private var str1Verts:Array = [];
      
      private var cubeMatList:MaterialsList = new MaterialsList();
      
      private var ray:Number3D = new Number3D();
      
      private var toDEGREES:Number = 57.29577951308232;
      
      private var rotmat:Matrix3D = null;
      
      private var string1:VerletString;
      
      private var string2:VerletString;
      
      private var string1Root:VerletParticle;
      
      private var ikTriangle:VerletTriangle;
      
      private var string2Term:VerletParticle;
      
      private var decorPlane1Layer:ViewportLayer;
      
      private var useMat:MaterialObject3D = debugMat;
      
      private var _decorPlane1:MobileDecor;
      
      private var decorPlanes:Array;
      
      private var triBaseLen:Number = 80;
      
      private var _decorPlane2:MobileDecor;
      
      private var decorPlane1LayerButton:VPortLayerButton;
      
      private var numStringVerts:int = 6;
      
      private var dragEnabled:Boolean = false;
      
      private var cubeEndDims:Point = new Point(10,10);
      
      private var triSpineLen:Number = 1;
      
      private var strutOverlap:Number = 10;
      
      private var ikString1:VerletString;
      
      private var cubeMeshB:Cube;
      
      private var str2Verts:Array = [];
      
      private var string2Root:VerletParticle;
      
      public var worldOffset:Number3D = new Number3D();
      
      private var cubeMeshA:Cube;
      
      private var decorPlane2LayerButton:VPortLayerButton;
      
      private var lineMat:LineMaterial3D = new LineMaterial3D(255,1);
      
      private var ikString2:VerletString;
      
      private var cam:CameraObject3D;
      
      private var string1Term:VerletParticle;
      
      private var dragTarget:VerletParticle = null;
      
      private var cubeMat:MaterialObject3D;
      
      private var basicView:BasicView;
      
      private var decorPlane2Layer:ViewportLayer;
      
      public var planeObj:Plane3D = new Plane3D();
      
      private var faceDivs:int = 1;
      
      public function MobilePart3D(param1:BasicView)
      {
         super();
         this.scaleY *= -1;
         basicView = param1;
      }
      
      private function update3D() : void
      {
         var _loc5_:MobileDecor = null;
         var _loc6_:VerletParticle = null;
         var _loc7_:VerletParticle = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:VerletParticle = null;
         var _loc11_:VerletParticle = null;
         var _loc1_:Number = this.strutAngle;
         cubeMeshA.rotationZ = _loc1_;
         cubeMeshB.rotationZ = _loc1_;
         updateStrutLength();
         var _loc2_:int = 0;
         while(_loc2_ < numStringVerts)
         {
            _loc6_ = ikString1.cParts[_loc2_] as VerletParticle;
            _loc7_ = ikString2.cParts[_loc2_] as VerletParticle;
            _loc8_ = str1Verts[_loc2_] as Vertex3D;
            _loc9_ = str2Verts[_loc2_] as Vertex3D;
            _loc8_.x = _loc6_.loc.x;
            _loc8_.y = _loc6_.loc.y;
            _loc9_.x = _loc7_.loc.x;
            _loc9_.y = _loc7_.loc.y;
            _loc2_++;
         }
         _decorPlane1.spinVel = Math.abs(string1Term.vel.x + string1Term.vel.y) / 2;
         _decorPlane2.spinVel = Math.abs(string2Term.vel.x + string2Term.vel.y) / 2;
         var _loc3_:Number2D = null;
         var _loc4_:Number3D = null;
         for each(_loc5_ in decorPlanes)
         {
            if(_loc5_.isDragging)
            {
               _loc4_ = getDragCoords();
               if(_loc4_.x > 100)
               {
                  _loc4_.x = 100;
               }
               if(_loc4_.x < -700)
               {
                  _loc4_.x = -700;
               }
               if(_loc4_.y > 350)
               {
                  _loc4_.y = 350;
               }
               if(_loc4_.y < -100)
               {
                  _loc4_.y = -100;
               }
               if(_loc4_.x > -90 && _loc4_.y > 200)
               {
                  _loc4_.x = -90;
               }
               _loc10_ = null;
               _loc11_ = null;
               if(_loc5_ == decorPlane1)
               {
                  _loc10_ = string1Root;
                  _loc11_ = string1Term;
               }
               else if(_loc5_ == decorPlane2)
               {
                  _loc10_ = string2Root;
                  _loc11_ = string2Term;
               }
               _loc11_.loc.y = _loc4_.y;
               if(this.rotationY == 90)
               {
                  _loc11_.loc.x = -_loc4_.x;
               }
               else
               {
                  _loc11_.loc.x = _loc4_.x;
               }
               _loc3_ = new Number2D(_loc11_.loc.x - _loc10_.loc.x,_loc11_.loc.y - _loc10_.loc.y);
               dispatchEvent(new MobileDragEvent(_loc3_.modulo,_loc4_.x));
            }
         }
         _decorPlane1.update();
         _decorPlane2.update();
         translateLineContainers(ikTriangle.midBC);
         translateDecor(ikTriangle.midBC);
      }
      
      public function get triangle() : VerletTriangle
      {
         return ikTriangle;
      }
      
      public function init(param1:CameraObject3D, param2:DisplayObject, param3:DisplayObject, param4:uint, param5:uint, param6:Class, param7:VerletParticle, param8:Number = 1, param9:Number = 0.5, param10:Number = 8, param11:Number = 2) : void
      {
         cam = param1;
         initPhys(param7,param8,param9,param10,param11);
         init3D(param2,param3,param4,param5,param6);
      }
      
      public function translateLineContainers(param1:Point) : void
      {
         lines1.x = -param1.x;
         lines1.y = -param1.y + cubeEndDims.y / 2;
         lines2.x = -param1.x;
         lines2.y = -param1.y + cubeEndDims.y / 2;
      }
      
      public function get decorPlane2() : MobileDecor
      {
         return _decorPlane2;
      }
      
      private function updateStrutLength() : void
      {
         var _loc1_:Number = triangle.baseLength;
         var _loc2_:Number = triangle.lengthBC;
         var _loc3_:Number = _loc2_ / _loc1_;
         cubeMeshA.scaleX = cubeMeshB.scaleX = _loc3_;
      }
      
      public function get decorPlane1() : MobileDecor
      {
         return _decorPlane1;
      }
      
      public function get strutAngle() : Number
      {
         var _loc1_:Point = ikTriangle.vBC;
         if(_loc1_.x < 0)
         {
            _loc1_.x *= -1;
            _loc1_.y *= -1;
         }
         return Math.atan2(_loc1_.y,_loc1_.x) * toDEGREES;
      }
      
      public function disableDrag() : void
      {
         dragEnabled = false;
      }
      
      private function initPhys(param1:VerletParticle, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         ikString1 = new VerletString(param1.loc.x - triBaseLen / 2,param1.loc.y + triSpineLen,numStringVerts,param4,0,1);
         ikString1.timeStep = param2;
         ikString1.spring = param3;
         string1Root = ikString1.cParts[0] as VerletParticle;
         string1Term = ikString1.cParts[ikString1.cParts.length - 1] as VerletParticle;
         string1Term.mass = 2;
         ikString2 = new VerletString(param1.loc.x + triBaseLen / 2,param1.loc.y + triSpineLen,numStringVerts,param5,0,1);
         ikString2.timeStep = param2;
         ikString2.spring = param3;
         string2Root = ikString2.cParts[0] as VerletParticle;
         string2Term = ikString2.cParts[ikString2.cParts.length - 1] as VerletParticle;
         string2Term.mass = 2;
         ikTriangle = new VerletTriangle();
         ikTriangle.timeStep = param2;
         ikTriangle.spring = param3;
         ikTriangle.initPoints(param1,string1Root,string2Root,triBaseLen,triSpineLen);
      }
      
      public function stopDrag(param1:MobileDecor) : void
      {
         dispatchEvent(new Event("StopDrag"));
         param1.drop();
      }
      
      public function enableDrag() : void
      {
         dragEnabled = true;
      }
      
      private function getDragCoords() : Number3D
      {
         ray = basicView.camera.unproject(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY);
         ray = Number3D.add(ray,basicView.camera.position);
         var _loc1_:Number3D = planeObj.getIntersectionLineNumbers(basicView.camera.position,ray);
         _loc1_.minusEq(worldOffset);
         _loc1_.y *= -1;
         return _loc1_;
      }
      
      public function initLayers(param1:ViewportLayer) : void
      {
         decorPlane1Layer = param1.getChildLayer(_decorPlane1,true);
         decorPlane2Layer = param1.getChildLayer(_decorPlane2,true);
         param1.getChildLayer(lines1,true);
         param1.getChildLayer(lines2,true);
         param1.addDisplayObject3D(cubeMeshA);
         param1.addDisplayObject3D(cubeMeshB);
      }
      
      private function updatePhys() : void
      {
         ikTriangle.update();
         ikString1.update();
         ikString2.update();
      }
      
      private function init3D(param1:DisplayObject, param2:DisplayObject, param3:uint, param4:uint, param5:Class) : void
      {
         var _loc18_:Vertex3D = null;
         var _loc19_:Vertex3D = null;
         var _loc20_:Vertex3D = null;
         var _loc21_:Line3D = null;
         var _loc22_:Vertex3D = null;
         var _loc23_:Line3D = null;
         var _loc6_:MovieClip = new param5();
         var _loc7_:MovieClip = new param5();
         var _loc8_:MovieClip = new param5();
         _loc6_.transform.colorTransform = new ColorTransform(1,1,1,1,-20,-20,-20);
         var _loc9_:MovieMaterial = new MovieMaterial(_loc6_,true);
         _loc7_.transform.colorTransform = new ColorTransform(1,1,1,1,-10,-10,-10);
         var _loc10_:MovieMaterial = new MovieMaterial(_loc7_,true);
         var _loc11_:MovieMaterial = new MovieMaterial(_loc8_,true);
         cubeMatList.addMaterial(_loc11_,"top");
         cubeMatList.addMaterial(_loc9_,"bottom");
         cubeMatList.addMaterial(_loc11_,"back");
         cubeMatList.addMaterial(_loc10_,"front");
         cubeMatList.addMaterial(_loc10_,"left");
         cubeMatList.addMaterial(_loc9_,"right");
         cubeMeshA = new Cube(cubeMatList,(triBaseLen + strutOverlap) / 2,cubeEndDims.x,cubeEndDims.y,faceDivs,faceDivs,faceDivs,Cube.ALL);
         addChild(cubeMeshA);
         cubeMeshB = new Cube(cubeMatList,(triBaseLen + strutOverlap) / 2,cubeEndDims.x,cubeEndDims.y,faceDivs,faceDivs,faceDivs,Cube.ALL);
         addChild(cubeMeshB);
         var _loc12_:Matrix3D = null;
         _loc12_ = Matrix3D.translationMatrix((triBaseLen + strutOverlap) / 4,0,0);
         cubeMeshA.geometry.transformVertices(_loc12_);
         _loc12_ = Matrix3D.translationMatrix(-(triBaseLen + strutOverlap) / 4,0,0);
         cubeMeshB.geometry.transformVertices(_loc12_);
         var _loc13_:LineMaterial3D = new LineMaterial3D(param3,1);
         var _loc14_:LineMaterial3D = new LineMaterial3D(param4,1);
         lines1 = new Lines3D(_loc13_,"mobilePartLines1");
         addChild(lines1);
         lines2 = new Lines3D(_loc14_,"mobilePartLines2");
         addChild(lines2);
         var _loc15_:int = 0;
         while(_loc15_ < numStringVerts)
         {
            _loc18_ = null;
            _loc18_ = new Vertex3D(0,0,0);
            str1Verts.push(_loc18_);
            _loc19_ = null;
            _loc19_ = new Vertex3D(0,0,0);
            str2Verts.push(_loc19_);
            if(_loc15_ > 0)
            {
               _loc20_ = str1Verts[_loc15_ - 1] as Vertex3D;
               _loc21_ = new Line3D(lines1,_loc13_,lineThick,_loc18_,_loc20_);
               lines1.addLine(_loc21_);
               _loc22_ = str2Verts[_loc15_ - 1] as Vertex3D;
               _loc23_ = new Line3D(lines1,_loc14_,lineThick,_loc19_,_loc22_);
               lines2.addLine(_loc23_);
            }
            _loc15_++;
         }
         var _loc16_:VerletParticle = null;
         var _loc17_:VerletParticle = null;
         _loc16_ = string1Term;
         _loc17_ = ikString1.cParts[ikString1.cParts.length - 2] as VerletParticle;
         _decorPlane1 = new MobileDecor(param1,1,_loc16_,_loc17_);
         addChild(_decorPlane1);
         _loc16_ = string2Term;
         _loc17_ = ikString2.cParts[ikString2.cParts.length - 2] as VerletParticle;
         _decorPlane2 = new MobileDecor(param2,1,_loc16_,_loc17_);
         addChild(_decorPlane2);
         decorPlanes = [_decorPlane1,_decorPlane2];
      }
      
      public function accumulateForce(param1:Number, param2:Number) : void
      {
         ikTriangle.accumulateForce(param1,param2);
         ikString1.accumulateForce(param1,param2);
         ikString2.accumulateForce(param1,param2);
      }
      
      public function translateDecor(param1:Point) : void
      {
         _decorPlane1.x = string1Term.loc.x - param1.x;
         _decorPlane1.y = string1Term.loc.y - param1.y + cubeEndDims.y / 2;
         _decorPlane2.x = string2Term.loc.x - param1.x;
         _decorPlane2.y = string2Term.loc.y - param1.y + cubeEndDims.y / 2;
      }
      
      public function startDrag(param1:MobileDecor) : void
      {
         dispatchEvent(new Event("StartDrag"));
         param1.pickUp();
      }
      
      public function update() : void
      {
         updatePhys();
         update3D();
      }
      
      public function translateCubeMeshes(param1:Point) : void
      {
         cubeMeshA.x = param1.x;
         cubeMeshA.y = param1.y;
         cubeMeshB.x = cubeMeshA.x;
         cubeMeshB.y = cubeMeshA.y;
      }
      
      public function drop() : void
      {
         if(_decorPlane1.isDragging)
         {
            stopDrag(_decorPlane1);
         }
         if(_decorPlane2.isDragging)
         {
            stopDrag(_decorPlane2);
         }
      }
      
      public function updateStrutRotation(param1:Number) : void
      {
         cubeMeshA.rotationX = param1;
         cubeMeshB.rotationX = param1;
      }
   }
}

