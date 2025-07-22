package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.utils.Logger;
   
   public class DaeSampler2D extends DaeEntity
   {
      
      public var source:String;
      
      public function DaeSampler2D(param1:XML)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_FXCMN_SAMPLER2D_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_FXCMN_SAMPLER2D_ELEMENT + "\' element");
         }
         super.read(param1);
         this.source = getNodeContent(getNode(param1,ASCollada.DAE_SOURCE_ELEMENT));
         Logger.log(" => => sampler2D source: " + this.source);
      }
   }
}

