package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeVertices extends DaeEntity
   {
      
      public var inputs:Object;
      
      public function DaeVertices(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:DaeInput = null;
         if(param1.localName() != ASCollada.DAE_VERTICES_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_VERTICES_ELEMENT + "\' element");
         }
         super.read(param1);
         this.inputs = new Object();
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_INPUT_ELEMENT);
         var _loc3_:uint = uint(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new DaeInput(_loc2_[_loc4_]);
            this.inputs[_loc5_.semantic] = _loc5_;
            _loc4_++;
         }
      }
   }
}

