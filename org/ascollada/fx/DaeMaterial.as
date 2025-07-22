package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeAsset;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.utils.Logger;
   
   public class DaeMaterial extends DaeEntity
   {
      
      public var effect:String;
      
      public function DaeMaterial(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         super.read(param1);
         Logger.log("reading material: " + this.id);
         var _loc2_:XML = getNode(param1,ASCollada.DAE_ASSET_ELEMENT);
         if(_loc2_)
         {
            this.asset = new DaeAsset(_loc2_);
         }
         var _loc3_:XML = getNode(param1,ASCollada.DAE_INSTANCE_EFFECT_ELEMENT);
         this.effect = getAttribute(_loc3_,ASCollada.DAE_URL_ATTRIBUTE);
         Logger.log(" => effect url: " + this.effect);
      }
   }
}

