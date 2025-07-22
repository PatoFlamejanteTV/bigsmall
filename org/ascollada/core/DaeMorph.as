package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeMorph extends DaeEntity
   {
      
      public static const METHOD_NORMALIZED:String = "NORMALIZED";
      
      public static const METHOD_RELATIVE:String = "RELATIVE";
      
      public var method:String;
      
      public var targets:Array;
      
      public var weights:Array;
      
      public var source:String;
      
      public function DaeMorph(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XMLList = null;
         var _loc7_:XML = null;
         var _loc8_:DaeSource = null;
         var _loc9_:DaeInput = null;
         if(param1.localName() != ASCollada.DAE_CONTROLLER_MORPH_ELEMENT)
         {
            return;
         }
         super.read(param1);
         this.source = getAttribute(param1,ASCollada.DAE_SOURCE_ATTRIBUTE);
         this.method = getAttribute(param1,ASCollada.DAE_METHOD_ATTRIBUTE) == METHOD_RELATIVE ? METHOD_RELATIVE : METHOD_NORMALIZED;
         Logger.log("reading morph, source: " + this.source + " method: " + this.method);
         var _loc2_:XML = getNode(param1,ASCollada.DAE_TARGETS_ELEMENT);
         this.targets = this.weights = null;
         var _loc3_:Object = new Object();
         var _loc4_:XMLList = getNodeList(param1,ASCollada.DAE_SOURCE_ELEMENT);
         for each(_loc5_ in _loc4_)
         {
            _loc8_ = new DaeSource(_loc5_);
            _loc3_[_loc8_.id] = _loc8_;
         }
         _loc6_ = getNodeList(_loc2_,ASCollada.DAE_INPUT_ELEMENT);
         for each(_loc7_ in _loc6_)
         {
            _loc9_ = new DaeInput(_loc7_);
            switch(_loc9_.semantic)
            {
               case ASCollada.DAE_TARGET_MORPH_INPUT:
                  this.targets = _loc3_[_loc9_.source].values;
                  break;
               case ASCollada.DAE_WEIGHT_MORPH_INPUT:
                  this.weights = _loc3_[_loc9_.source].values;
                  break;
            }
         }
         if(!this.targets)
         {
            throw new Error("Invalid morph, could not find morph-targets");
         }
         if(!this.weights)
         {
            throw new Error("Invalid morph, could not find morhp-weights!");
         }
      }
   }
}

