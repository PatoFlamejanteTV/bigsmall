package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Stage;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.core.render.material.IUpdateAfterMaterial;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   
   public class MovieMaterial extends BitmapMaterial implements ITriangleDrawer, IUpdateBeforeMaterial, IUpdateAfterMaterial
   {
      
      public var movieTransparent:Boolean;
      
      private var quality:String;
      
      private var materialIsUsed:Boolean = false;
      
      private var stage:Stage;
      
      private var autoClipRect:Rectangle;
      
      public var allowAutoResize:Boolean = false;
      
      public var movie:DisplayObject;
      
      private var movieAnimated:Boolean;
      
      protected var recreateBitmapInSuper:Boolean;
      
      private var userClipRect:Rectangle;
      
      public function MovieMaterial(param1:DisplayObject = null, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Rectangle = null)
      {
         super();
         movieTransparent = param2;
         this.animated = param3;
         this.precise = param4;
         userClipRect = param5;
         if(param1)
         {
            texture = param1;
         }
      }
      
      protected function createBitmapFromSprite(param1:DisplayObject) : BitmapData
      {
         movie = param1;
         initBitmap(movie);
         drawBitmap();
         bitmap = super.createBitmap(bitmap);
         return bitmap;
      }
      
      public function set rect(param1:Rectangle) : void
      {
         userClipRect = param1;
         createBitmapFromSprite(movie);
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
         if(movieAnimated == true && materialIsUsed == true)
         {
            drawBitmap();
            if(recreateBitmapInSuper)
            {
               bitmap = super.createBitmap(bitmap);
               recreateBitmapInSuper = false;
            }
         }
      }
      
      public function set animated(param1:Boolean) : void
      {
         movieAnimated = param1;
      }
      
      public function drawBitmap() : void
      {
         var _loc3_:String = null;
         bitmap.fillRect(bitmap.rect,fillColor);
         if(Boolean(stage) && Boolean(quality))
         {
            _loc3_ = stage.quality;
            stage.quality = quality;
         }
         var _loc1_:Rectangle = rect;
         var _loc2_:Matrix = new Matrix(1,0,0,1,-_loc1_.x,-_loc1_.y);
         bitmap.draw(movie,_loc2_,movie.transform.colorTransform,null);
         if(!userClipRect)
         {
            autoClipRect = movie.getBounds(movie);
         }
         if(Boolean(stage) && Boolean(quality))
         {
            stage.quality = _loc3_;
         }
      }
      
      override public function get texture() : Object
      {
         return this._texture;
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         materialIsUsed = false;
         if(movieAnimated)
         {
            if(userClipRect)
            {
               _loc2_ = int(userClipRect.width + 0.5);
               _loc3_ = int(userClipRect.height + 0.5);
            }
            else
            {
               _loc2_ = int(movie.width + 0.5);
               _loc3_ = int(movie.height + 0.5);
            }
            if(allowAutoResize && (_loc2_ != bitmap.width || _loc3_ != bitmap.height))
            {
               initBitmap(movie);
               recreateBitmapInSuper = true;
            }
         }
      }
      
      protected function initBitmap(param1:DisplayObject) : void
      {
         if(bitmap)
         {
            bitmap.dispose();
         }
         if(userClipRect)
         {
            bitmap = new BitmapData(int(userClipRect.width + 0.5),int(userClipRect.height + 0.5),movieTransparent,fillColor);
         }
         else if(param1.width == 0 || param1.height == 0)
         {
            bitmap = new BitmapData(256,256,movieTransparent,fillColor);
         }
         else
         {
            bitmap = new BitmapData(int(param1.width + 0.5),int(param1.height + 0.5),movieTransparent,fillColor);
         }
      }
      
      public function get animated() : Boolean
      {
         return movieAnimated;
      }
      
      public function get rect() : Rectangle
      {
         var _loc1_:Rectangle = userClipRect || autoClipRect;
         if(!_loc1_ && Boolean(movie))
         {
            _loc1_ = movie.getBounds(movie);
         }
         return _loc1_;
      }
      
      override public function set texture(param1:Object) : void
      {
         if(param1 is DisplayObject == false)
         {
            PaperLogger.error("MovieMaterial.texture requires a Sprite to be passed as the object");
            return;
         }
         bitmap = createBitmapFromSprite(DisplayObject(param1));
         _texture = param1;
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         materialIsUsed = true;
         super.drawTriangle(param1,param2,param3,param4,param5);
      }
      
      public function setQuality(param1:String, param2:Stage, param3:Boolean = true) : void
      {
         this.quality = param1;
         this.stage = param2;
         if(param3)
         {
            createBitmapFromSprite(movie);
         }
      }
   }
}

