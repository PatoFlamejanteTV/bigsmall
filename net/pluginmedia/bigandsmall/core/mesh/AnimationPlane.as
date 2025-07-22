package net.pluginmedia.bigandsmall.core.mesh
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   
   public class AnimationPlane extends Plane
   {
      
      public static var DID_BEGIN_PLAYING:String = "AnimationPlane.DID_BEGIN_PLAYING";
      
      public static var DID_END_PLAYING:String = "AnimationPlane.DID_END_PLAYING";
      
      protected var fillRect:Rectangle = new Rectangle(0,0,1,1);
      
      public var pMat:BitmapMaterial;
      
      protected var startUVs:Array = [];
      
      protected var _isPlaying:Boolean = false;
      
      protected var startPoints:Array = [];
      
      public var movie:MovieClip;
      
      public var drawScaleX:Number;
      
      public var drawScaleY:Number;
      
      public var bounds:Rectangle;
      
      protected var lastFrame:int = 1;
      
      protected var _dirtyMesh:Boolean = false;
      
      public var bitmapData:BitmapData;
      
      public function AnimationPlane(param1:MovieClip, param2:Number = 1, param3:Number = 1, param4:Number = 2, param5:Number = 2)
      {
         var _loc6_:Number = 1;
         var _loc7_:Number = 1;
         drawScaleX = param2;
         drawScaleY = param3;
         movie = param1;
         movie.stop();
         bitmapData = new BitmapData(512,512,true,0);
         pMat = new BitmapMaterial(bitmapData);
         super(pMat,_loc6_,_loc7_,param4,param5);
         this.geometry.dirty = true;
         storeStartPoints();
         updateMesh();
         _dirtyMesh = true;
      }
      
      public function stop() : void
      {
         movie.stop();
         _isPlaying = false;
         onEndPlaying();
      }
      
      protected function getNewBitmapData(param1:Number, param2:Number, param3:BitmapData = null) : BitmapData
      {
         var _loc4_:Boolean = false;
         if(param3)
         {
            if(param1 > param3.width || param2 > param3.height)
            {
               _loc4_ = true;
            }
            else if(param1 / param3.width < 0.25 && param2 / param3.height < 0.25)
            {
               _loc4_ = true;
            }
         }
         else
         {
            _loc4_ = true;
         }
         if(_loc4_)
         {
            param1 = roundUpToMipMap(param1);
            param2 = roundUpToMipMap(param2);
            param3 = new BitmapData(param1,param2,true,0);
         }
         else
         {
            fillRect.width = param1 + 5;
            fillRect.height = param2 + 5;
            param3.fillRect(fillRect,0);
         }
         return param3;
      }
      
      protected function storeStartPoints() : void
      {
         var _loc3_:Triangle3D = null;
         startPoints = [];
         startUVs = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.geometry.vertices.length)
         {
            startPoints.push(new Point(this.geometry.vertices[_loc1_].x + 0.5,this.geometry.vertices[_loc1_].y - 0.5));
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.geometry.faces.length)
         {
            _loc3_ = geometry.faces[_loc2_];
            startUVs.push(_loc3_._uvArray.concat());
            _loc2_++;
         }
      }
      
      public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         movie.gotoAndPlay(param1,param2);
         _isPlaying = true;
         _dirtyMesh = true;
         onBeginPlaying();
      }
      
      protected function removeAllListeners() : void
      {
         onEndPlaying();
      }
      
      protected function onBeginPlaying() : void
      {
         dispatchEvent(new Event(DID_BEGIN_PLAYING));
      }
      
      protected function roundUpToMipMap(param1:Number) : uint
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = Math.ceil(param1);
         var _loc3_:uint = 0;
         var _loc5_:Boolean = false;
         if(_loc2_ == 0 || _loc2_ == 1)
         {
            _loc5_ = true;
            _loc4_ = 1;
         }
         while(!_loc5_)
         {
            if(_loc2_ == 2 || _loc2_ == 3)
            {
               _loc5_ = true;
               _loc4_ = Math.pow(2,_loc3_ + 2);
            }
            else
            {
               _loc3_++;
               _loc2_ >>= 1;
               if(_loc3_ >= 10)
               {
                  _loc4_ = 2048;
                  _loc5_ = true;
               }
            }
         }
         return _loc4_;
      }
      
      protected function onEndPlaying() : void
      {
         dispatchEvent(new Event(DID_END_PLAYING));
      }
      
      public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         movie.gotoAndStop(param1,param2);
         _isPlaying = false;
         _dirtyMesh = true;
         updateMesh();
         onEndPlaying();
      }
      
      public function get totalFrames() : int
      {
         return movie.totalFrames;
      }
      
      public function updateMesh() : void
      {
         var _loc9_:Point = null;
         var _loc10_:Vertex3D = null;
         bounds = movie.getBounds(movie);
         if(bounds.width == 0 || bounds.height == 0)
         {
         }
         bounds.left = Math.floor(bounds.left * drawScaleX);
         bounds.right = Math.ceil(bounds.right * drawScaleX);
         bounds.top = Math.floor(bounds.top * drawScaleY);
         bounds.bottom = Math.ceil(bounds.bottom * drawScaleY);
         pMat.bitmap = bitmapData = getNewBitmapData(bounds.width,bounds.height,bitmapData);
         bitmapData.lock();
         var _loc1_:Number = bounds.width / drawScaleX;
         var _loc2_:Number = bounds.height / drawScaleY;
         var _loc3_:Number = bounds.left / drawScaleX;
         var _loc4_:Number = -bounds.top / drawScaleY;
         var _loc5_:int = int(startPoints.length);
         var _loc6_:Array = geometry.vertices;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc9_ = startPoints[_loc7_];
            _loc10_ = _loc6_[_loc7_];
            _loc10_.x = _loc9_.x * _loc1_ + _loc3_;
            _loc10_.y = _loc9_.y * _loc2_ + _loc4_;
            _loc7_++;
         }
         pMat.maxU = bounds.width / bitmapData.width;
         pMat.maxV = bounds.height / bitmapData.height;
         var _loc8_:Matrix = new Matrix();
         _loc8_.translate(-bounds.left / drawScaleX,-bounds.top / drawScaleY);
         _loc8_.scale(drawScaleX,drawScaleY);
         bitmapData.draw(movie,_loc8_);
         _dirtyMesh = false;
         geometry.dirty = true;
         geometry.ready = true;
         pMat.resetUVS();
         bitmapData.unlock();
      }
      
      public function get dirtyMesh() : Boolean
      {
         return _dirtyMesh;
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc3_:int = 0;
         if(_isPlaying)
         {
            pMat.smooth = true;
            _loc3_ = movie.currentFrame;
            if(_loc3_ != lastFrame)
            {
               _dirtyMesh = true;
            }
            if(_dirtyMesh)
            {
               updateMesh();
            }
            lastFrame = _loc3_;
         }
         return super.project(param1,param2);
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      public function play() : void
      {
         movie.play();
         _isPlaying = true;
         onBeginPlaying();
      }
      
      public function get currentFrame() : int
      {
         return movie.currentFrame;
      }
   }
}

