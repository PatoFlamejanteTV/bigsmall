package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.types.DaeArray;
   
   public class DaeSource extends DaeEntity
   {
      
      public var values:Array;
      
      public var accessor:DaeAccessor;
      
      public function DaeSource(param1:XML)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         this.values = new Array();
         if(param1.localName() != ASCollada.DAE_SOURCE_ELEMENT)
         {
            return;
         }
         super.read(param1);
         var _loc2_:DaeArray = new DaeArray(param1);
         var _loc3_:XML = getNode(param1,ASCollada.DAE_TECHNIQUE_COMMON_ELEMENT);
         if(!_loc3_)
         {
            this.values = _loc2_.values;
            return;
         }
         var _loc4_:XML = getNode(_loc3_,ASCollada.DAE_ACCESSOR_ELEMENT);
         if(!_loc4_)
         {
            throw new Error("As a child of <source>, this element must contain exactly one <accessor> element.");
         }
         this.accessor = new DaeAccessor(_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.count)
         {
            if(this.accessor.stride > 1)
            {
               _loc6_ = new Array();
               _loc7_ = 0;
               while(_loc7_ < this.accessor.stride)
               {
                  _loc6_.push(_loc2_.values[_loc5_ + _loc7_]);
                  _loc7_++;
               }
               this.values.push(_loc6_);
            }
            else
            {
               this.values.push(_loc2_.values[_loc5_]);
            }
            _loc5_ += this.accessor.stride;
         }
      }
   }
}

