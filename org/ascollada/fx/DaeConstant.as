package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.types.DaeColorOrTexture;
   
   public class DaeConstant extends DaeEntity
   {
      
      public var emission:DaeColorOrTexture;
      
      public var reflectivity:Number = 0;
      
      public var transparent:DaeColorOrTexture;
      
      public var index_of_refraction:Number = 0;
      
      public var transparency:Number = 0;
      
      public var reflective:DaeColorOrTexture;
      
      public function DaeConstant(param1:XML = null)
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
               case ASCollada.DAE_EMISSION_MATERIAL_PARAMETER:
                  this.emission = new DaeColorOrTexture(_loc5_);
                  break;
               case ASCollada.DAE_REFLECTIVE_MATERIAL_PARAMETER:
                  this.reflective = new DaeColorOrTexture(_loc5_);
                  break;
               case ASCollada.DAE_REFLECTIVITY_MATERIAL_PARAMETER:
                  this.reflectivity = parseFloat(getNodeContent(getNode(_loc5_,"float")));
                  break;
               case ASCollada.DAE_TRANSPARENT_MATERIAL_PARAMETER:
                  this.transparent = new DaeColorOrTexture(_loc5_);
                  break;
               case ASCollada.DAE_TRANSPARENCY_MATERIAL_PARAMETER:
                  this.transparency = parseFloat(getNodeContent(getNode(_loc5_,"float")));
                  break;
               case ASCollada.DAE_INDEXOFREFRACTION_MATERIAL_PARAMETER:
                  this.reflectivity = parseFloat(getNodeContent(getNode(_loc5_,"float")));
                  break;
            }
            _loc4_++;
         }
      }
   }
}

