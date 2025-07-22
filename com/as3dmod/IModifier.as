package com.as3dmod
{
   import com.as3dmod.core.MeshProxy;
   
   public interface IModifier
   {
      
      function apply() : void;
      
      function setModifiable(param1:MeshProxy) : void;
   }
}

