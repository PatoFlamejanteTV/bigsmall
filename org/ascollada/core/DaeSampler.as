package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeSampler extends DaeEntity
   {
      
      public var values:Array;
      
      public var type:String;
      
      public function DaeSampler(param1:XML)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_SAMPLER_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_SAMPLER_ELEMENT + "\' element");
         }
         super.read(param1);
      }
   }
}

