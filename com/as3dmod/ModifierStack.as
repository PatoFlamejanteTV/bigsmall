package com.as3dmod
{
   import com.as3dmod.core.MeshProxy;
   import com.as3dmod.plugins.Library3d;
   import com.as3dmod.plugins.PluginFactory;
   
   public class ModifierStack
   {
      
      private var lib3d:Library3d;
      
      private var stack:Array;
      
      private var baseMesh:MeshProxy;
      
      public function ModifierStack(param1:Library3d, param2:*)
      {
         super();
         this.lib3d = param1;
         baseMesh = PluginFactory.getMeshProxy(param1);
         baseMesh.setMesh(param2);
         baseMesh.analyzeGeometry();
         stack = new Array();
      }
      
      public function clear() : void
      {
         stack = new Array();
      }
      
      public function collapse() : void
      {
         apply();
         baseMesh.collapseGeometry();
         stack = new Array();
      }
      
      public function apply() : void
      {
         baseMesh.resetGeometry();
         var _loc1_:int = 0;
         while(_loc1_ < stack.length)
         {
            (stack[_loc1_] as IModifier).apply();
            _loc1_++;
         }
      }
      
      public function get mesh() : MeshProxy
      {
         return baseMesh;
      }
      
      public function addModifier(param1:IModifier) : void
      {
         param1.setModifiable(baseMesh);
         stack.push(param1);
      }
   }
}

