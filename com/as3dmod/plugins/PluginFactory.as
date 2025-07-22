package com.as3dmod.plugins
{
   import com.as3dmod.core.MeshProxy;
   import flash.utils.getDefinitionByName;
   
   public class PluginFactory
   {
      
      public function PluginFactory()
      {
         super();
      }
      
      public static function getMeshProxy(param1:Library3d) : MeshProxy
      {
         var _loc2_:Class = getDefinitionByName(param1.meshClass) as Class;
         return new _loc2_();
      }
   }
}

