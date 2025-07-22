package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   
   public class DaeTexture extends DaeEntity
   {
      
      public var texture:String;
      
      public var texcoord:String;
      
      public function DaeTexture(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         super.read(param1);
         this.texture = getAttribute(param1,ASCollada.DAE_FXSTD_TEXTURE_ATTRIBUTE);
         this.texcoord = getAttribute(param1,ASCollada.DAE_FXSTD_TEXTURESET_ATTRIBUTE);
      }
   }
}

