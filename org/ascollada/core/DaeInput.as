package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeInput extends DaeEntity
   {
      
      public var offset:uint;
      
      public var setId:uint;
      
      public var semantic:String;
      
      public var source:String;
      
      public function DaeInput(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_INPUT_ELEMENT)
         {
            return;
         }
         super.read(param1);
         this.semantic = getAttribute(param1,ASCollada.DAE_SEMANTIC_ATTRIBUTE);
         this.source = getAttribute(param1,ASCollada.DAE_SOURCE_ATTRIBUTE);
         this.offset = parseInt(getAttribute(param1,ASCollada.DAE_OFFSET_ATTRIBUTE),10);
         this.offset = this.offset ? this.offset : 0;
         this.setId = parseInt(getAttribute(param1,ASCollada.DAE_SET_ATTRIBUTE),10);
      }
   }
}

