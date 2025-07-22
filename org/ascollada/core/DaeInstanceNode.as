package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeInstanceNode extends DaeEntity
   {
      
      public var url:String;
      
      public function DaeInstanceNode(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         super.read(param1);
         this.url = getAttribute(param1,ASCollada.DAE_URL_ATTRIBUTE);
      }
   }
}

