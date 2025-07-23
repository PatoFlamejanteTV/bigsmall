# bigsmall
Decomp from CBeeBies game.

Due 99.9% of the decompiled code being bad/incomplete/etc, my main goal is to fix it so i can build a working .swf from it. (or atleast have an usable codebase)

For comparision, heres a code snippet:

``` actionscript
public static function getLightMatrix(param1:LightObject3D, param2:DisplayObject3D, param3:RenderSessionData, param4:Matrix3D) : Matrix3D
      {
         var _loc6_:Matrix3D = null;
         var _loc7_:Matrix3D = null;
         var _loc5_:Matrix3D = param4 ? param4 : Matrix3D.IDENTITY;
         if(param1 == null)
         {
            param1 = new PointLight3D();
            param1.copyPosition(param3.camera);
         }
         _targetPos.reset();
         _lightPos.reset();
         _lightDir.reset();
         _lightUp.reset();
         _lightSide.reset();
         _loc6_ = param1.transform;
         _loc7_ = param2.world;
         _lightPos.x = -_loc6_.n14;
         _lightPos.y = -_loc6_.n24;
         _lightPos.z = -_loc6_.n34;
         _targetPos.x = -_loc7_.n14;
         _targetPos.y = -_loc7_.n24;
         _targetPos.z = -_loc7_.n34;
         _lightDir.x = _targetPos.x - _lightPos.x;
         _lightDir.y = _targetPos.y - _lightPos.y;
         _lightDir.z = _targetPos.z - _lightPos.z;
         invMatrix.calculateInverse(param2.world);
         Matrix3D.multiplyVector3x3(invMatrix,_lightDir);
         _lightDir.normalize();
         _lightSide.x = _lightDir.y * UP.z - _lightDir.z * UP.y;
         _lightSide.y = _lightDir.z * UP.x - _lightDir.x * UP.z;
         _lightSide.z = _lightDir.x * UP.y - _lightDir.y * UP.x;
         _lightSide.normalize();
         _lightUp.x = _lightSide.y * _lightDir.z - _lightSide.z * _lightDir.y;
         _lightUp.y = _lightSide.z * _lightDir.x - _lightSide.x * _lightDir.z;
         _lightUp.z = _lightSide.x * _lightDir.y - _lightSide.y * _lightDir.x;
         _lightUp.normalize();
         if(Papervision3D.useRIGHTHANDED || param2.flipLightDirection)
         {
            _lightDir.x = -_lightDir.x;
            _lightDir.y = -_lightDir.y;
            _lightDir.z = -_lightDir.z;
         }
         _loc5_.n11 = _lightSide.x;
         _loc5_.n12 = _lightSide.y;
         _loc5_.n13 = _lightSide.z;
         _loc5_.n21 = _lightUp.x;
         _loc5_.n22 = _lightUp.y;
         _loc5_.n23 = _lightUp.z;
         _loc5_.n31 = _lightDir.x;
         _loc5_.n32 = _lightDir.y;
         _loc5_.n33 = _lightDir.z;
         return _loc5_;
      }
```
Now compare it to this cleaned up ver (thanks Claude :DDD)

``` actionscript
public static function getLightMatrix(light:LightObject3D, targetObject:DisplayObject3D, renderSession:RenderSessionData, outputMatrix:Matrix3D) : Matrix3D
{
   var lightTransform:Matrix3D = null;
   var targetWorldMatrix:Matrix3D = null;
   var lightViewMatrix:Matrix3D = outputMatrix ? outputMatrix : Matrix3D.IDENTITY;

   if(light == null)
   {
      light = new PointLight3D();
      light.copyPosition(renderSession.camera);
   }

   _targetPos.reset();
   _lightPos.reset();
   _lightDir.reset();
   _lightUp.reset();
   _lightSide.reset();

   lightTransform = light.transform;
   targetWorldMatrix = targetObject.world;

   _lightPos.x = -lightTransform.n14;
   _lightPos.y = -lightTransform.n24;
   _lightPos.z = -lightTransform.n34;

   _targetPos.x = -targetWorldMatrix.n14;
   _targetPos.y = -targetWorldMatrix.n24;
   _targetPos.z = -targetWorldMatrix.n34;

   _lightDir.x = _targetPos.x - _lightPos.x;
   _lightDir.y = _targetPos.y - _lightPos.y;
   _lightDir.z = _targetPos.z - _lightPos.z;

   invMatrix.calculateInverse(targetObject.world);
   Matrix3D.multiplyVector3x3(invMatrix, _lightDir);
   _lightDir.normalize();

   _lightSide.x = _lightDir.y * UP.z - _lightDir.z * UP.y;
   _lightSide.y = _lightDir.z * UP.x - _lightDir.x * UP.z;
   _lightSide.z = _lightDir.x * UP.y - _lightDir.y * UP.x;
   _lightSide.normalize();

   _lightUp.x = _lightSide.y * _lightDir.z - _lightSide.z * _lightDir.y;
   _lightUp.y = _lightSide.z * _lightDir.x - _lightSide.x * _lightDir.z;
   _lightUp.z = _lightSide.x * _lightDir.y - _lightSide.y * _lightDir.x;
   _lightUp.normalize();

   if(Papervision3D.useRIGHTHANDED || targetObject.flipLightDirection)
   {
      _lightDir.x = -_lightDir.x;
      _lightDir.y = -_lightDir.y;
      _lightDir.z = -_lightDir.z;
   }

   lightViewMatrix.n11 = _lightSide.x;
   lightViewMatrix.n12 = _lightSide.y;
   lightViewMatrix.n13 = _lightSide.z;
   lightViewMatrix.n21 = _lightUp.x;
   lightViewMatrix.n22 = _lightUp.y;
   lightViewMatrix.n23 = _lightUp.z;
   lightViewMatrix.n31 = _lightDir.x;
   lightViewMatrix.n32 = _lightDir.y;
   lightViewMatrix.n33 = _lightDir.z;

   return lightViewMatrix;
}
```

So yes, a LOT of things need to be worked on.
