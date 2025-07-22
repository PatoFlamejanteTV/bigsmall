package org.ascollada.core
{
   import flash.display.BitmapData;
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeImage extends DaeEntity
   {
      
      public var bitmapData:BitmapData;
      
      public var init_from:String = "";
      
      public function DaeImage(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         super.read(param1);
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(_loc5_.localName())
            {
               case ASCollada.DAE_ASSET_ELEMENT:
                  this.asset = new DaeAsset(_loc5_);
                  break;
               case ASCollada.DAE_DATA_ELEMENT:
                  break;
               case ASCollada.DAE_INITFROM_ELEMENT:
                  this.init_from = unescape(_loc5_.text().toString());
                  this.init_from.split("\\").join("/");
                  Logger.log(" => " + this.id + " init_from: " + this.init_from);
                  break;
               case ASCollada.DAE_EXTRA_ELEMENT:
                  break;
            }
            _loc4_++;
         }
      }
   }
}

