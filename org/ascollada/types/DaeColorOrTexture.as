package org.ascollada.types
{
   import org.ascollada.core.DaeEntity;
   import org.ascollada.fx.DaeTexture;
   
   public class DaeColorOrTexture extends DaeEntity
   {
      
      public static const TYPE_COLOR:uint = 0;
      
      public static const TYPE_TEXTURE:uint = 1;
      
      public static const TYPE_PARAM:uint = 2;
      
      public var color:Array;
      
      public var type:uint = TYPE_COLOR;
      
      public var texture:DaeTexture;
      
      public function DaeColorOrTexture(param1:XML = null)
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
               case "color":
                  this.type = TYPE_COLOR;
                  this.color = getFloats(_loc5_);
                  return;
               case "texture":
                  this.type = TYPE_TEXTURE;
                  this.texture = new DaeTexture(_loc5_);
                  return;
               case "param":
                  this.type = TYPE_PARAM;
                  return;
            }
            _loc4_++;
         }
      }
   }
}

