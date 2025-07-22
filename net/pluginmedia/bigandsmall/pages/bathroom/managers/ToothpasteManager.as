package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.materials.FadeChangeableBitmapMaterial;
   import org.papervision3d.core.geom.Particles;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class ToothpasteManager extends Particles
   {
      
      public var collisionObjects:Array = new Array();
      
      public var particleMaterials:Array = new Array();
      
      protected var layers:Array;
      
      public var particleMovie:MovieClip;
      
      protected var toothpasteLayer:ViewportLayer;
      
      public var particleSplatMovie:MovieClip;
      
      protected var spareParticles:Array = new Array();
      
      protected var triangleBoundingBoxes:Dictionary;
      
      protected var renderScales:Dictionary;
      
      protected var drawMatrix:Matrix = new Matrix();
      
      protected var particleCount:int = 0;
      
      protected var changeableMatNames:Dictionary;
      
      public var basicView:BasicView;
      
      protected var boundingBoxes:Dictionary;
      
      public function ToothpasteManager(param1:MovieClip, param2:MovieClip, param3:BasicView)
      {
         this.basicView = param3;
         particleMaterials.push(new LayeredParticleMaterial(param1));
         particleMovie = param1;
         particleSplatMovie = param2;
         renderScales = new Dictionary();
         boundingBoxes = new Dictionary();
         triangleBoundingBoxes = new Dictionary();
         changeableMatNames = new Dictionary();
         super("Toothpaste");
      }
      
      private function cubesCollide(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number) : Boolean
      {
         if(!(param2 < param7 || param1 > param8))
         {
            if(!(param4 < param9 || param3 > param10))
            {
               if(!(param6 < param11 || param5 > param12))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function fireToothPaste(param1:Number, param2:Number, param3:Number, param4:int = 1, param5:Number3D = null, param6:Number = 1) : void
      {
         var _loc7_:ToothpasteBlob = null;
         param6 *= 0.15;
         var _loc8_:int = 0;
         while(_loc8_ <= param4)
         {
            if(spareParticles.length > 0)
            {
               _loc7_ = spareParticles.shift() as ToothpasteBlob;
               _loc7_.resetBlob(param6 * (Math.random() * 0.2 + 0.9),param1,param2,param3,param5);
            }
            else
            {
               _loc7_ = new ToothpasteBlob(particleMaterials[particleCount % particleMaterials.length],param6 * (Math.random() * 0.2 + 0.9),param1,param2,param3,param5);
               ++particleCount;
            }
            addParticle(_loc7_);
            _loc8_++;
         }
      }
      
      private function getTriangleCubes(param1:TriangleMesh3D, param2:Dictionary = null) : Dictionary
      {
         var _loc3_:Number3D = null;
         var _loc4_:Number3D = null;
         var _loc5_:Number3D = null;
         var _loc6_:Object = null;
         var _loc7_:Plane3D = null;
         var _loc8_:Triangle3D = null;
         if(param2 == null)
         {
            param2 = new Dictionary();
         }
         for each(_loc8_ in param1.geometry.faces)
         {
            _loc6_ = {};
            _loc6_.min = new Number3D();
            _loc6_.max = new Number3D();
            _loc3_ = _loc8_.v0.toNumber3D();
            _loc4_ = _loc8_.v1.toNumber3D();
            _loc5_ = _loc8_.v2.toNumber3D();
            Matrix3D.multiplyVector(param1.world,_loc3_);
            Matrix3D.multiplyVector(param1.world,_loc4_);
            Matrix3D.multiplyVector(param1.world,_loc5_);
            _loc7_ = Plane3D.fromThreePoints(_loc3_,_loc4_,_loc5_).getFlip();
            _loc6_.min.x = Math.min(_loc3_.x,_loc4_.x,_loc5_.x);
            _loc6_.min.y = Math.min(_loc3_.y,_loc4_.y,_loc5_.y);
            _loc6_.min.z = Math.min(_loc3_.z,_loc4_.z,_loc5_.z);
            _loc6_.max.x = Math.max(_loc3_.x,_loc4_.x,_loc5_.x);
            _loc6_.max.y = Math.max(_loc3_.y,_loc4_.y,_loc5_.y);
            _loc6_.max.z = Math.max(_loc3_.z,_loc4_.z,_loc5_.z);
            _loc6_.a = _loc3_;
            _loc6_.b = _loc4_;
            _loc6_.c = _loc5_;
            _loc6_.plane = _loc7_;
            param2[_loc8_] = _loc6_;
         }
         return param2;
      }
      
      private function drawToTex(param1:Number, param2:Number, param3:Triangle3D, param4:ToothpasteBlob) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc18_:BitmapData = null;
         var _loc19_:BitmapData = null;
         var _loc5_:MaterialObject3D = param3.material;
         var _loc8_:Array = param3.uv;
         var _loc9_:Number = Number(_loc8_[0].u);
         var _loc10_:Number = Number(_loc8_[1].u);
         var _loc11_:Number = Number(_loc8_[2].u);
         var _loc12_:Number = Number(_loc8_[0].v);
         var _loc13_:Number = Number(_loc8_[1].v);
         var _loc14_:Number = Number(_loc8_[2].v);
         var _loc15_:Number = (_loc10_ - _loc9_) * param2 + (_loc11_ - _loc9_) * param1 + _loc9_;
         var _loc16_:Number = (_loc13_ - _loc12_) * param2 + (_loc14_ - _loc12_) * param1 + _loc12_;
         var _loc17_:Number = renderScales[param3.instance] * 1.4;
         drawMatrix.identity();
         drawMatrix.scale(_loc17_,_loc17_);
         if(_loc5_ is BitmapMaterial)
         {
            _loc6_ = BitmapMaterial.AUTO_MIP_MAPPING ? _loc5_.widthOffset : _loc5_.bitmap.width;
            _loc7_ = BitmapMaterial.AUTO_MIP_MAPPING ? _loc5_.heightOffset : _loc5_.bitmap.height;
            drawMatrix.translate(_loc15_ * _loc6_,_loc7_ - _loc16_ * _loc7_);
            drawToBitmap(_loc5_.bitmap,drawMatrix);
         }
         if(_loc5_ is FadeChangeableBitmapMaterial)
         {
            _loc18_ = changeableMatNames[param3.instance].mat1;
            _loc19_ = changeableMatNames[param3.instance].mat2;
            _loc6_ = _loc18_.width;
            _loc7_ = _loc18_.height;
            drawMatrix.translate(_loc15_ * _loc6_,_loc7_ - _loc16_ * _loc7_);
            drawToBitmap(_loc18_,drawMatrix);
            _loc6_ = _loc19_.width;
            _loc7_ = _loc19_.height;
            drawMatrix.translate(_loc15_ * _loc6_,_loc7_ - _loc16_ * _loc7_);
            drawToBitmap(_loc19_,drawMatrix);
         }
         param4.killParticle = true;
      }
      
      public function update() : Boolean
      {
         var _loc4_:ToothpasteBlob = null;
         var _loc1_:int = int(particles.length);
         var _loc2_:Boolean = true;
         if(_loc1_ == 0)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = particles[_loc3_] as ToothpasteBlob;
            _loc4_.update();
            if(isNaN(_loc4_.vertex3D.x) || _loc4_.y <= -50)
            {
               _loc4_.killParticle = true;
            }
            else if(_loc4_.y <= -50)
            {
               _loc4_.killParticle = true;
            }
            else if(_loc4_.collidable)
            {
               if(blobCollided(_loc4_))
               {
                  _loc4_.killParticle = true;
                  if(_loc2_)
                  {
                     if(Math.random() < 0.6)
                     {
                        SoundManagerOld.playSoundSimple("ToothpasteSplat",Math.random() * 0.2 + 0.2,_loc4_.vertex3D.vertex3DInstance.x / 400);
                     }
                     _loc2_ = false;
                  }
               }
            }
            if(_loc4_.killParticle)
            {
               removeParticle(_loc4_);
               _loc1_--;
               spareParticles.push(_loc4_);
               if(_loc3_ < particles.length)
               {
                  _loc3_--;
               }
            }
            _loc3_++;
         }
         clearLayers();
         return true;
      }
      
      public function refreshBoundingBoxes() : void
      {
         var _loc1_:TriangleMesh3D = null;
         for each(_loc1_ in collisionObjects)
         {
            boundingBoxes[_loc1_] = _loc1_.worldBoundingBox();
            getTriangleCubes(_loc1_,triangleBoundingBoxes[_loc1_]);
         }
      }
      
      public function blobCollided(param1:ToothpasteBlob) : Boolean
      {
         var _loc5_:Number3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:TriangleMesh3D = null;
         var _loc18_:Triangle3D = null;
         var _loc19_:Number3D = null;
         var _loc20_:Number3D = null;
         var _loc21_:Number3D = null;
         var _loc22_:Plane3D = null;
         var _loc2_:Number3D = param1.vertex3D.getPosition();
         var _loc3_:Number3D = Number3D.add(_loc2_,param1.velocity);
         Matrix3D.multiplyVector(this.world,_loc2_);
         Matrix3D.multiplyVector(this.world,_loc3_);
         var _loc4_:Boolean = false;
         _loc9_ = _loc2_.x > _loc3_.x ? _loc3_.x : _loc2_.x;
         _loc10_ = _loc2_.x > _loc3_.x ? _loc2_.x : _loc3_.x;
         _loc11_ = _loc2_.y > _loc3_.y ? _loc3_.y : _loc2_.y;
         _loc12_ = _loc2_.y > _loc3_.y ? _loc2_.y : _loc3_.y;
         _loc13_ = _loc2_.z > _loc3_.z ? _loc3_.z : _loc2_.z;
         _loc14_ = _loc2_.z > _loc3_.z ? _loc2_.z : _loc3_.z;
         for each(_loc17_ in collisionObjects)
         {
            _loc15_ = boundingBoxes[_loc17_];
            if(cubesCollide(_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_.min.x,_loc15_.max.x,_loc15_.min.y,_loc15_.max.y,_loc15_.min.z,_loc15_.max.z))
            {
               for each(_loc18_ in _loc17_.geometry.faces)
               {
                  _loc16_ = triangleBoundingBoxes[_loc17_][_loc18_];
                  if(cubesCollide(_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc16_.min.x,_loc16_.max.x,_loc16_.min.y,_loc16_.max.y,_loc16_.min.z,_loc16_.max.z))
                  {
                     _loc19_ = _loc16_.a;
                     _loc20_ = _loc16_.b;
                     _loc21_ = _loc16_.c;
                     _loc22_ = _loc16_.plane;
                     _loc5_ = _loc22_.getIntersectionLineNumbers(_loc2_,_loc3_);
                     _loc6_ = _loc5_.x;
                     _loc7_ = _loc5_.y;
                     _loc8_ = _loc5_.z;
                     if(_loc6_ >= _loc9_ && _loc6_ <= _loc10_)
                     {
                        if(_loc7_ >= _loc11_ && _loc7_ <= _loc12_)
                        {
                           if(_loc8_ >= _loc13_ && _loc8_ <= _loc14_)
                           {
                              if(pointInTriangle(_loc19_,_loc20_,_loc21_,_loc5_,_loc18_,param1))
                              {
                                 _loc4_ = true;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function drawToBitmap(param1:BitmapData, param2:Matrix = null) : void
      {
         param1.lock();
         particleSplatMovie.gotoAndStop(Math.ceil(Math.random() * 10));
         param1.draw(particleSplatMovie,param2,null,null,null,true);
         param1.unlock();
      }
      
      public function clearLayers() : void
      {
         var _loc2_:Sprite = null;
         var _loc1_:int = 0;
         while(_loc1_ < layers.length)
         {
            _loc2_ = layers[_loc1_];
            _loc2_.graphics.clear();
            _loc1_++;
         }
      }
      
      public function addCollisionObject(param1:DisplayObject3D, param2:Number = 0.5) : void
      {
         collisionObjects.push(param1);
         var _loc3_:Object = TriangleMesh3D(param1).worldBoundingBox();
         boundingBoxes[param1] = _loc3_;
         renderScales[param1] = param2;
         triangleBoundingBoxes[param1] = getTriangleCubes(TriangleMesh3D(param1),null);
      }
      
      public function addFadeChangeableCollisionObject(param1:DisplayObject3D, param2:String, param3:String, param4:Number = 0.5) : void
      {
         changeableMatNames[param1] = {
            "mat1":FadeChangeableBitmapMaterial(param1.material).getBitmap(param2),
            "mat2":FadeChangeableBitmapMaterial(param1.material).getBitmap(param3)
         };
         addCollisionObject(param1,param4);
      }
      
      public function initLayers(param1:ViewportLayer) : void
      {
         var _loc3_:Sprite = null;
         toothpasteLayer = param1;
         layers = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < particleMovie.totalFrames)
         {
            _loc3_ = new Sprite();
            toothpasteLayer.addChild(_loc3_);
            layers.push(_loc3_);
            _loc2_++;
         }
         LayeredParticleMaterial(particleMaterials[0]).setLayers(layers);
      }
      
      public function pointInTriangle(param1:Number3D, param2:Number3D, param3:Number3D, param4:Number3D, param5:Triangle3D, param6:ToothpasteBlob) : Boolean
      {
         var _loc7_:Number3D = Number3D.sub(param3,param1);
         var _loc8_:Number3D = Number3D.sub(param2,param1);
         var _loc9_:Number3D = Number3D.sub(param4,param1);
         var _loc10_:Number = Number3D.dot(_loc7_,_loc7_);
         var _loc11_:Number = Number3D.dot(_loc7_,_loc8_);
         var _loc12_:Number = Number3D.dot(_loc7_,_loc9_);
         var _loc13_:Number = Number3D.dot(_loc8_,_loc8_);
         var _loc14_:Number = Number3D.dot(_loc8_,_loc9_);
         var _loc15_:Number = 1 / (_loc10_ * _loc13_ - _loc11_ * _loc11_);
         var _loc16_:Number = (_loc13_ * _loc12_ - _loc11_ * _loc14_) * _loc15_;
         var _loc17_:Number = (_loc10_ * _loc14_ - _loc11_ * _loc12_) * _loc15_;
         if(_loc16_ > 0 && _loc17_ > 0 && _loc16_ + _loc17_ < 1)
         {
            drawToTex(_loc16_,_loc17_,param5,param6);
            return true;
         }
         return false;
      }
   }
}

