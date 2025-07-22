package net.pluginmedia.pv3d.materials
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.papervision3d.materials.BitmapMaterial;
   
   public class ChangeableBitmapMaterial extends BitmapMaterial
   {
      
      protected var bitmapDict:Dictionary;
      
      protected var _prevActiveBitmap:String;
      
      protected var _textureBitmap:BitmapData;
      
      protected var _texWidth:uint;
      
      protected var _texHeight:uint;
      
      protected var _transparent:Boolean;
      
      protected var _activeBitmap:String;
      
      protected var m:Matrix;
      
      public function ChangeableBitmapMaterial(param1:BitmapData = null, param2:String = "default", param3:uint = 128, param4:uint = 128, param5:Boolean = false)
      {
         _texWidth = param3;
         _texHeight = param4;
         _transparent = param5;
         _textureBitmap = new BitmapData(param3,param4,param5,0);
         super(_textureBitmap,false);
         m = new Matrix();
         bitmapDict = new Dictionary();
         if(param1)
         {
            addBitmap(param1,param2);
            this.activeBitmap = param2;
         }
      }
      
      public function addBitmap(param1:BitmapData, param2:String) : void
      {
         bitmapDict[param2] = param1;
      }
      
      public function reset() : void
      {
         bitmap = new BitmapData(_texWidth,_texHeight,_transparent,991296);
         drawIntoTexture(bitmapDict[activeBitmap]);
         resetUVS();
      }
      
      public function get transparent() : Boolean
      {
         return _transparent;
      }
      
      public function get activeBitmap() : String
      {
         return _activeBitmap;
      }
      
      protected function drawIntoTexture(param1:BitmapData) : void
      {
         if(param1.width == _textureBitmap.width && param1.height == _textureBitmap.height)
         {
            _textureBitmap.copyPixels(param1,param1.rect,new Point(0,0));
         }
         else
         {
            m.identity();
            m.scale(_textureBitmap.width / param1.width,_textureBitmap.height / param1.height);
            _textureBitmap.draw(param1,m);
         }
      }
      
      public function set activeBitmap(param1:String) : void
      {
         var _loc2_:BitmapData = bitmapDict[param1];
         if(param1 == _activeBitmap)
         {
            return;
         }
         switch(_loc2_)
         {
            default:
               _prevActiveBitmap = _activeBitmap;
            case null:
               _activeBitmap = param1;
               drawIntoTexture(_loc2_);
               break;
            case null:
         }
      }
   }
}

