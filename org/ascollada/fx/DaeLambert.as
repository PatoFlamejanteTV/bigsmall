package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.types.DaeColorOrTexture;
   
   public class DaeLambert extends DaeConstant
   {
      
      public var ambient:DaeColorOrTexture;
      
      public var diffuse:DaeColorOrTexture;
      
      public function DaeLambert(param1:XML = null)
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
               case ASCollada.DAE_AMBIENT_MATERIAL_PARAMETER:
                  this.ambient = new DaeColorOrTexture(_loc5_);
                  break;
               case ASCollada.DAE_DIFFUSE_MATERIAL_PARAMETER:
                  this.diffuse = new DaeColorOrTexture(_loc5_);
                  if(!this.diffuse.texture)
                  {
                  }
                  break;
            }
            _loc4_++;
         }
      }
   }
}

