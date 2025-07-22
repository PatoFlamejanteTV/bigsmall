package org.papervision3d.core.render.shader
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.shaders.Shader;
   
   public class ShaderRenderer extends EventDispatcher implements IShaderRenderer
   {
      
      public var container:Sprite;
      
      public var shadeLayers:Dictionary;
      
      public var outputBitmap:BitmapData;
      
      public var bitmapContainer:Bitmap;
      
      public var resizedInput:Boolean = false;
      
      public var bitmapLayer:Sprite;
      
      private var _inputBitmapData:BitmapData;
      
      public function ShaderRenderer()
      {
         super();
         container = new Sprite();
         bitmapLayer = new Sprite();
         bitmapContainer = new Bitmap();
         bitmapLayer.addChild(bitmapContainer);
         bitmapLayer.blendMode = BlendMode.NORMAL;
         shadeLayers = new Dictionary();
         container.addChild(bitmapLayer);
      }
      
      public function clear() : void
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in shadeLayers)
         {
            if(inputBitmap && inputBitmap.width > 0 && inputBitmap.height > 0)
            {
               _loc1_.graphics.clear();
               _loc1_.graphics.beginFill(0,1);
               _loc1_.graphics.drawRect(0,0,inputBitmap.width,inputBitmap.height);
               _loc1_.graphics.endFill();
            }
         }
      }
      
      public function render(param1:RenderSessionData) : void
      {
         if(outputBitmap)
         {
            outputBitmap.fillRect(outputBitmap.rect,0);
            bitmapContainer.bitmapData = inputBitmap;
            outputBitmap.draw(container,null,null,null,outputBitmap.rect,false);
            if(outputBitmap.transparent)
            {
               outputBitmap.copyChannel(inputBitmap,outputBitmap.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
            }
         }
      }
      
      public function get inputBitmap() : BitmapData
      {
         return _inputBitmapData;
      }
      
      public function set inputBitmap(param1:BitmapData) : void
      {
         if(param1 != null)
         {
            if(_inputBitmapData != param1)
            {
               _inputBitmapData = param1;
               if(outputBitmap)
               {
                  if(_inputBitmapData.width != outputBitmap.width || _inputBitmapData.height != outputBitmap.height)
                  {
                     resizedInput = true;
                     outputBitmap.dispose();
                     outputBitmap = _inputBitmapData.clone();
                  }
               }
               else
               {
                  resizedInput = true;
                  outputBitmap = _inputBitmapData.clone();
               }
            }
         }
      }
      
      public function getLayerForShader(param1:Shader) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         shadeLayers[param1] = _loc2_;
         var _loc3_:Sprite = new Sprite();
         _loc2_.addChild(_loc3_);
         if(inputBitmap != null)
         {
            _loc3_.graphics.beginFill(0,0);
            _loc3_.graphics.drawRect(0,0,inputBitmap.width,inputBitmap.height);
            _loc3_.graphics.endFill();
         }
         container.addChild(_loc2_);
         _loc2_.blendMode = param1.layerBlendMode;
         return _loc2_;
      }
      
      public function destroy() : void
      {
         bitmapLayer = null;
         outputBitmap.dispose();
      }
   }
}

