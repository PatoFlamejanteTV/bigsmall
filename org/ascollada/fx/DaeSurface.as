package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.utils.Logger;
   
   public class DaeSurface extends DaeEntity
   {
      
      public var init_from:String;
      
      public var type:String;
      
      public function DaeSurface(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_FXCMN_SURFACE_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_FXCMN_SURFACE_ELEMENT + "\' element");
         }
         super.read(param1);
         this.type = getAttribute(param1,ASCollada.DAE_TYPE_ATTRIBUTE);
         this.init_from = getNodeContent(getNode(param1,ASCollada.DAE_INITFROM_ELEMENT));
         Logger.log(" => => surface type: " + this.type + " init_from: " + this.init_from);
      }
   }
}

