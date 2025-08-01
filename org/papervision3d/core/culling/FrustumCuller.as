package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.AxisAlignedBoundingBox;
   import org.papervision3d.core.math.BoundingSphere;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class FrustumCuller implements IObjectCuller
   {
      
      public static const INSIDE:int = 1;
      
      public static const OUTSIDE:int = -1;
      
      public static const INTERSECT:int = 0;
      
      private var _tang:Number;
      
      private var _near:Number;
      
      private var _ratio:Number;
      
      private var _fov:Number;
      
      private var _far:Number;
      
      private var _nh:Number;
      
      private var _fh:Number;
      
      private var _nw:Number;
      
      public var transform:Matrix3D;
      
      private var _sphereY:Number;
      
      private var _sphereX:Number;
      
      private var _fw:Number;
      
      public function FrustumCuller()
      {
         super();
         this.transform = Matrix3D.IDENTITY;
         this.initialize();
      }
      
      public function get ratio() : Number
      {
         return _ratio;
      }
      
      public function pointInFrustum(param1:Number, param2:Number, param3:Number) : int
      {
         var _loc4_:Matrix3D = this.transform;
         var _loc5_:Number = param1 - _loc4_.n14;
         var _loc6_:Number = param2 - _loc4_.n24;
         var _loc7_:Number = param3 - _loc4_.n34;
         var _loc8_:Number = _loc5_ * _loc4_.n13 + _loc6_ * _loc4_.n23 + _loc7_ * _loc4_.n33;
         if(_loc8_ > _far || _loc8_ < _near)
         {
            return OUTSIDE;
         }
         var _loc9_:Number = _loc5_ * _loc4_.n12 + _loc6_ * _loc4_.n22 + _loc7_ * _loc4_.n32;
         var _loc10_:Number = _loc8_ * _tang;
         if(_loc9_ > _loc10_ || _loc9_ < -_loc10_)
         {
            return OUTSIDE;
         }
         var _loc11_:Number = _loc5_ * _loc4_.n11 + _loc6_ * _loc4_.n21 + _loc7_ * _loc4_.n31;
         _loc10_ *= _ratio;
         if(_loc11_ > _loc10_ || _loc11_ < -_loc10_)
         {
            return OUTSIDE;
         }
         return INSIDE;
      }
      
      public function get fov() : Number
      {
         return _fov;
      }
      
      public function set ratio(param1:Number) : void
      {
         this.initialize(_fov,param1,_near,_far);
      }
      
      public function set near(param1:Number) : void
      {
         this.initialize(_fov,_ratio,param1,_far);
      }
      
      public function set fov(param1:Number) : void
      {
         this.initialize(param1,_ratio,_near,_far);
      }
      
      public function get far() : Number
      {
         return _far;
      }
      
      public function initialize(param1:Number = 60, param2:Number = 1.333, param3:Number = 1, param4:Number = 5000) : void
      {
         _fov = param1;
         _ratio = param2;
         _near = param3;
         _far = param4;
         var _loc5_:Number = Math.PI / 180 * _fov * 0.5;
         _tang = Math.tan(_loc5_);
         _nh = _near * _tang;
         _nw = _nh * _ratio;
         _fh = _far * _tang;
         _fw = _fh * _ratio;
         var _loc6_:Number = Math.atan(_tang * _ratio);
         _sphereX = 1 / Math.cos(_loc6_);
         _sphereY = 1 / Math.cos(_loc5_);
      }
      
      public function set far(param1:Number) : void
      {
         this.initialize(_fov,_ratio,_near,param1);
      }
      
      public function get near() : Number
      {
         return _near;
      }
      
      public function sphereInFrustum(param1:DisplayObject3D, param2:BoundingSphere) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = param2.radius * Math.max(param1.scaleX,Math.max(param1.scaleY,param1.scaleZ));
         var _loc8_:int = INSIDE;
         var _loc9_:Matrix3D = this.transform;
         var _loc10_:Number = param1.world.n14 - _loc9_.n14;
         var _loc11_:Number = param1.world.n24 - _loc9_.n24;
         var _loc12_:Number = param1.world.n34 - _loc9_.n34;
         _loc7_ = _loc10_ * _loc9_.n13 + _loc11_ * _loc9_.n23 + _loc12_ * _loc9_.n33;
         if(_loc7_ > _far + _loc3_ || _loc7_ < _near - _loc3_)
         {
            return OUTSIDE;
         }
         if(_loc7_ > _far - _loc3_ || _loc7_ < _near + _loc3_)
         {
            _loc8_ = INTERSECT;
         }
         _loc6_ = _loc10_ * _loc9_.n12 + _loc11_ * _loc9_.n22 + _loc12_ * _loc9_.n32;
         _loc4_ = _sphereY * _loc3_;
         _loc7_ *= _tang;
         if(_loc6_ > _loc7_ + _loc4_ || _loc6_ < -_loc7_ - _loc4_)
         {
            return OUTSIDE;
         }
         if(_loc6_ > _loc7_ - _loc4_ || _loc6_ < -_loc7_ + _loc4_)
         {
            _loc8_ = INTERSECT;
         }
         _loc5_ = _loc10_ * _loc9_.n11 + _loc11_ * _loc9_.n21 + _loc12_ * _loc9_.n31;
         _loc7_ *= _ratio;
         _loc4_ = _sphereX * _loc3_;
         if(_loc5_ > _loc7_ + _loc4_ || _loc5_ < -_loc7_ - _loc4_)
         {
            return OUTSIDE;
         }
         if(_loc5_ > _loc7_ - _loc4_ || _loc5_ < -_loc7_ + _loc4_)
         {
            _loc8_ = INTERSECT;
         }
         return _loc8_;
      }
      
      public function testObject(param1:DisplayObject3D) : int
      {
         var _loc2_:int = INSIDE;
         if(!param1.geometry || !param1.geometry.vertices || !param1.geometry.vertices.length)
         {
            return _loc2_;
         }
         switch(param1.frustumTestMethod)
         {
            case FrustumTestMethod.BOUNDING_SPHERE:
               _loc2_ = sphereInFrustum(param1,param1.geometry.boundingSphere);
               break;
            case FrustumTestMethod.BOUNDING_BOX:
               _loc2_ = aabbInFrustum(param1,param1.geometry.aabb);
               break;
            case FrustumTestMethod.NO_TESTING:
         }
         return _loc2_;
      }
      
      public function aabbInFrustum(param1:DisplayObject3D, param2:AxisAlignedBoundingBox, param3:Boolean = true) : int
      {
         var _loc4_:Vertex3D = null;
         var _loc5_:Number3D = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = param2.getBoxVertices();
         for each(_loc4_ in _loc8_)
         {
            _loc5_ = _loc4_.toNumber3D();
            Matrix3D.multiplyVector(param1.world,_loc5_);
            if(pointInFrustum(_loc5_.x,_loc5_.y,_loc5_.z) == INSIDE)
            {
               _loc6_++;
               if(param3)
               {
                  return INSIDE;
               }
            }
            else
            {
               _loc7_++;
            }
            if(Boolean(_loc6_) && Boolean(_loc7_))
            {
               return INTERSECT;
            }
         }
         if(_loc6_)
         {
            return _loc6_ < 8 ? INTERSECT : INSIDE;
         }
         return OUTSIDE;
      }
   }
}

