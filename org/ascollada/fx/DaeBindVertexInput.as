package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   
   public class DaeBindVertexInput extends DaeEntity
   {
      
      public var input_set:int;
      
      public var input_semantic:String;
      
      public var semantic:String;
      
      public function DaeBindVertexInput(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         super.read(param1);
         semantic = getAttribute(param1,ASCollada.DAE_SEMANTIC_ATTRIBUTE);
         input_semantic = getAttribute(param1,ASCollada.DAE_INPUT_SEMANTIC_ATTRIBUTE);
         input_set = getAttributeAsInt(param1,ASCollada.DAE_INPUT_SET_ATTRIBUTE);
      }
   }
}

