package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeAccessor extends DaeEntity
   {
      
      public var offset:uint;
      
      public var params:Object;
      
      public var stride:uint;
      
      public var source:String;
      
      public var count:uint;
      
      public function DaeAccessor(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1.localName() != ASCollada.DAE_ACCESSOR_ELEMENT)
         {
            throw new Error("expected a " + ASCollada.DAE_ACCESSOR_ELEMENT + " element");
         }
         super.read(param1);
         this.count = getAttributeAsInt(param1,ASCollada.DAE_COUNT_ATTRIBUTE);
         this.offset = getAttributeAsInt(param1,ASCollada.DAE_OFFSET_ATTRIBUTE);
         this.source = getAttribute(param1,ASCollada.DAE_SOURCE_ATTRIBUTE);
         this.stride = getAttributeAsInt(param1,ASCollada.DAE_STRIDE_ATTRIBUTE,1);
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_PARAMETER);
         this.params = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = getAttribute(_loc4_,ASCollada.DAE_NAME_ATTRIBUTE);
            _loc6_ = getAttribute(_loc4_,ASCollada.DAE_TYPE_ATTRIBUTE);
            this.params[_loc5_] = _loc6_;
            _loc3_++;
         }
      }
   }
}

