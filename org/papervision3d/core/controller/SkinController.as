package org.papervision3d.core.controller
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.special.Skin3D;
   
   public class SkinController implements IObjectController
   {
      
      private var _cached:Array;
      
      public var bindShapeMatrix:Matrix3D;
      
      public var invBindMatrices:Array;
      
      public var joints:Array;
      
      public var target:Skin3D;
      
      public var poseMatrix:Matrix3D;
      
      public var vertexWeights:Array;
      
      public function SkinController(param1:Skin3D)
      {
         super();
         this.target = param1;
         this.joints = new Array();
         this.invBindMatrices = new Array();
         this.vertexWeights = new Array();
      }
      
      private function skinMesh(param1:DisplayObject3D, param2:Array, param3:Matrix3D, param4:Array, param5:Array) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number3D = null;
         var _loc8_:Number3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:Matrix3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         _loc7_ = new Number3D();
         _loc10_ = Matrix3D.multiply(param1.world,param3);
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            _loc11_ = Number(param2[_loc6_].weight);
            _loc12_ = int(param2[_loc6_].vertexIndex);
            if(!(_loc11_ <= 0.0001 || _loc11_ >= 1.0001))
            {
               _loc8_ = param4[_loc12_];
               _loc9_ = param5[_loc12_];
               _loc7_.x = _loc8_.x;
               _loc7_.y = _loc8_.y;
               _loc7_.z = _loc8_.z;
               Matrix3D.multiplyVector(_loc10_,_loc7_);
               _loc9_.x += _loc7_.x * _loc11_;
               _loc9_.y += _loc7_.y * _loc11_;
               _loc9_.z += _loc7_.z * _loc11_;
            }
            _loc6_++;
         }
      }
      
      public function update() : void
      {
         var _loc2_:int = 0;
         if(!joints.length || !bindShapeMatrix)
         {
            return;
         }
         if(!_cached)
         {
            cacheVertices();
         }
         if(invBindMatrices.length != this.joints.length)
         {
            return;
         }
         var _loc1_:Array = target.geometry.vertices;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_].x = _loc1_[_loc2_].y = _loc1_[_loc2_].z = 0;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < joints.length)
         {
            skinMesh(joints[_loc2_],this.vertexWeights[_loc2_],invBindMatrices[_loc2_],_cached,_loc1_);
            _loc2_++;
         }
      }
      
      private function cacheVertices() : void
      {
         this.target.transformVertices(this.bindShapeMatrix);
         this.target.geometry.ready = true;
         var _loc1_:Array = this.target.geometry.vertices;
         _cached = new Array(_loc1_.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _cached[_loc2_] = new Number3D(_loc1_[_loc2_].x,_loc1_[_loc2_].y,_loc1_[_loc2_].z);
            _loc2_++;
         }
      }
   }
}

