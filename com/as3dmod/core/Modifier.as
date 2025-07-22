package com.as3dmod.core
{
   public class Modifier
   {
      
      protected var mod:MeshProxy;
      
      public function Modifier()
      {
         super();
      }
      
      public function setModifiable(param1:MeshProxy) : void
      {
         this.mod = param1;
      }
      
      public function getVertices() : Array
      {
         return mod.getVertices();
      }
   }
}

