package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   
   public class DaeInstanceMaterial extends DaeEntity
   {
      
      public var target:String;
      
      public var symbol:String;
      
      private var _bindVertexInputs:Array;
      
      public function DaeInstanceMaterial(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         super.read(param1);
         this.symbol = getAttribute(param1,ASCollada.DAE_SYMBOL_ATTRIBUTE);
         this.target = getAttribute(param1,ASCollada.DAE_TARGET_ATTRIBUTE);
         _bindVertexInputs = new Array();
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_BIND_ELEMENT:
                  break;
               case ASCollada.DAE_BIND_VERTEX_INPUT:
                  _bindVertexInputs.push(new DaeBindVertexInput(_loc5_));
                  break;
               case ASCollada.DAE_EXTRA_ELEMENT:
                  break;
            }
            _loc4_++;
         }
      }
      
      public function findBindVertexInput(param1:String, param2:String = "TEXCOORD") : DaeBindVertexInput
      {
         var _loc3_:DaeBindVertexInput = null;
         for each(_loc3_ in _bindVertexInputs)
         {
            if(_loc3_.semantic == param1 && _loc3_.input_semantic == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function get bindVertexInputs() : Array
      {
         return _bindVertexInputs;
      }
   }
}

