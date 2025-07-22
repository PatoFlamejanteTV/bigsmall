package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeVertexWeights extends DaeEntity
   {
      
      public var v:Array;
      
      public var inputs:Array;
      
      public var vcounts:Array;
      
      public var count:int;
      
      public function DaeVertexWeights(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc6_:DaeInput = null;
         this.inputs = new Array();
         if(param1.localName() != ASCollada.DAE_WEIGHTS_ELEMENT)
         {
            throw new Error("not a <" + ASCollada.DAE_WEIGHTS_ELEMENT + "> element!");
         }
         super.read(param1);
         this.count = getAttributeAsInt(param1,ASCollada.DAE_COUNT_ATTRIBUTE);
         Logger.log(" => reading vertex_weights");
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_INPUT_ELEMENT);
         if(_loc2_.length() < 2)
         {
            throw new Error("<joints> requires at least 2 <input> elements!");
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc6_ = new DaeInput(_loc2_[_loc3_]);
            this.inputs.push(_loc6_);
            _loc3_++;
         }
         this.v = new Array();
         this.vcounts = new Array();
         var _loc4_:XML = getNode(param1,ASCollada.DAE_VERTEX_ELEMENT);
         var _loc5_:XML = getNode(param1,ASCollada.DAE_VERTEXCOUNT_ELEMENT);
         if(!_loc4_ || !_loc5_)
         {
            return;
         }
         this.v = getInts(_loc4_);
         this.vcounts = getInts(_loc5_);
      }
   }
}

