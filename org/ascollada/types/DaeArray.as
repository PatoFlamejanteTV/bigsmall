package org.ascollada.types
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   
   public class DaeArray extends DaeEntity
   {
      
      public var values:Array;
      
      public var count:int;
      
      public function DaeArray(param1:XML = null)
      {
         super(param1);
      }
      
      private function getData(param1:XML) : Array
      {
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(_loc5_.localName())
            {
               case ASCollada.DAE_BOOL_ARRAY_ELEMENT:
                  this.count = getAttributeAsInt(_loc5_,ASCollada.DAE_COUNT_ATTRIBUTE);
                  return getBools(_loc5_);
               case ASCollada.DAE_INT_ARRAY_ELEMENT:
                  this.count = getAttributeAsInt(_loc5_,ASCollada.DAE_COUNT_ATTRIBUTE);
                  return getInts(_loc5_);
               case ASCollada.DAE_IDREF_ARRAY_ELEMENT:
                  this.count = getAttributeAsInt(_loc5_,ASCollada.DAE_COUNT_ATTRIBUTE);
                  return getStrings(_loc5_);
               case ASCollada.DAE_FLOAT_ARRAY_ELEMENT:
                  this.count = getAttributeAsInt(_loc5_,ASCollada.DAE_COUNT_ATTRIBUTE);
                  return getFloats(_loc5_);
               case ASCollada.DAE_NAME_ARRAY_ELEMENT:
                  this.count = getAttributeAsInt(_loc5_,ASCollada.DAE_COUNT_ATTRIBUTE);
                  return getStrings(_loc5_);
            }
            _loc4_++;
         }
         return null;
      }
      
      override public function read(param1:XML) : void
      {
         super.read(param1);
         this.count = 0;
         this.values = getData(param1);
         if(!this.values)
         {
            throw new Error(" no data!");
         }
      }
   }
}

