package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeAnimation extends DaeEntity
   {
      
      public var channels:Array;
      
      public var animations:Array;
      
      public function DaeAnimation(param1:XML = null)
      {
         super(param1);
      }
      
      private function parseAnimation(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:DaeChannel = null;
         var _loc8_:XML = null;
         var _loc9_:XMLList = null;
         var _loc10_:uint = 0;
         var _loc11_:XML = null;
         var _loc12_:DaeInput = null;
         var _loc13_:DaeSource = null;
         var _loc14_:DaeSampler = null;
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_ANIMATION_ELEMENT);
         var _loc3_:XMLList = getNodeList(param1,ASCollada.DAE_CHANNEL_ELEMENT);
         var _loc4_:XMLList = getNodeList(param1,ASCollada.DAE_SAMPLER_ELEMENT);
         if(_loc2_.length() > 0)
         {
            for each(_loc6_ in _loc2_)
            {
               this.animations.push(new DaeAnimation(_loc6_));
            }
         }
         else if(_loc3_.length() == 0)
         {
            throw new Error("require at least one <channel> element!");
         }
         this.channels = new Array();
         for each(_loc5_ in _loc3_)
         {
            _loc7_ = new DaeChannel(_loc5_);
            _loc8_ = getNodeById(param1,ASCollada.DAE_SAMPLER_ELEMENT,_loc7_.source);
            _loc9_ = getNodeList(_loc8_,ASCollada.DAE_INPUT_ELEMENT);
            _loc10_ = 12;
            for each(_loc11_ in _loc9_)
            {
               _loc12_ = new DaeInput(_loc11_);
               _loc13_ = new DaeSource(getNodeById(param1,ASCollada.DAE_SOURCE_ELEMENT,_loc12_.source));
               _loc14_ = new DaeSampler(_loc8_);
               _loc14_.type = _loc12_.semantic;
               _loc14_.values = _loc13_.values;
               switch(_loc12_.semantic)
               {
                  case "INTERPOLATION":
                     _loc7_.interpolations = _loc14_.values;
                     break;
                  case "INPUT":
                     _loc7_.input = _loc14_.values;
                     break;
                  case "OUTPUT":
                     _loc7_.output = _loc14_.values;
                     break;
               }
            }
            this.channels.push(_loc7_);
         }
      }
      
      override public function read(param1:XML) : void
      {
         this.animations = new Array();
         this.channels = new Array();
         if(param1.localName() != ASCollada.DAE_ANIMATION_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_ANIMATION_ELEMENT + "\' element");
         }
         super.read(param1);
         parseAnimation(param1);
      }
   }
}

