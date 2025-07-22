package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.types.DaeColorOrTexture;
   
   public class DaePhong extends DaeLambert
   {
      
      public var specular:DaeColorOrTexture;
      
      public var shininess:Number = 0;
      
      public function DaePhong(param1:XML = null)
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
               case ASCollada.DAE_SPECULAR_MATERIAL_PARAMETER:
                  this.specular = new DaeColorOrTexture(_loc5_);
                  break;
               case ASCollada.DAE_SHININESS_MATERIAL_PARAMETER:
                  this.shininess = parseFloat(getNodeContent(getNode(_loc5_,"float")));
                  break;
            }
            _loc4_++;
         }
      }
   }
}

