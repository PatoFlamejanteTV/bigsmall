package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeVisualScene extends DaeEntity
   {
      
      public var nodes:Array;
      
      private var _yUp:uint;
      
      public function DaeVisualScene(param1:XML = null, param2:uint = 1)
      {
         _yUp = param2;
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XMLList = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:XML = null;
         this.nodes = new Array();
         if(param1.localName() != ASCollada.DAE_VSCENE_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_VSCENE_ELEMENT + "\' element");
         }
         super.read(param1);
         Logger.log("reading visual scene: " + this.id);
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_NODE_ELEMENT);
         if(!_loc2_.length())
         {
            throw new Error("require at least 1 <node> element!");
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length())
         {
            this.nodes.push(new DaeNode(_loc2_[_loc3_],_yUp));
            _loc3_++;
         }
         var _loc4_:XMLList = getNodeList(param1,ASCollada.DAE_EXTRA_ELEMENT);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = getNodeList(_loc5_,ASCollada.DAE_TECHNIQUE_ELEMENT);
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = getAttribute(_loc7_,ASCollada.DAE_PROFILE_ATTRIBUTE);
               switch(_loc8_)
               {
                  case ASCollada.DAEMAX_MAX_PROFILE:
                     _loc9_ = getNode(_loc7_,ASCollada.DAEMAX_FRAMERATE_PARAMETER);
                     if(_loc9_)
                     {
                        this.extras[ASCollada.DAEMAX_FRAMERATE_PARAMETER] = parseFloat(getNodeContent(_loc9_));
                     }
                     break;
                  case "FCOLLADA":
                     _loc10_ = getNode(_loc7_,"start_time");
                     if(_loc10_)
                     {
                        this.extras["start_time"] = parseFloat(getNodeContent(_loc10_));
                     }
                     _loc11_ = getNode(_loc7_,"end_time");
                     if(_loc11_)
                     {
                        this.extras["end_time"] = parseFloat(getNodeContent(_loc11_));
                     }
                     break;
               }
            }
         }
      }
      
      public function get endTime() : Number
      {
         return this.extras["end_time"];
      }
      
      public function get frameRate() : Number
      {
         return this.extras[ASCollada.DAEMAX_FRAMERATE_PARAMETER];
      }
      
      public function get startTime() : Number
      {
         return this.extras["start_time"];
      }
   }
}

