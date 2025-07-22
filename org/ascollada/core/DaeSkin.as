package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeSkin extends DaeEntity
   {
      
      public var vertex_weights:Array;
      
      public var bind_shape_matrix:Array;
      
      public var jointsType:String;
      
      public var blendWeightsByJointID:Object;
      
      public var joints:Array;
      
      public var source:String;
      
      public var bind_matrices:Array;
      
      public function DaeSkin(param1:XML = null)
      {
         super(param1);
      }
      
      public function findJointBindMatrix2(param1:String) : Array
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.joints.length)
         {
            if(param1 == this.joints[_loc2_])
            {
               return this.bind_matrices[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function findJointVertexWeights(param1:DaeNode) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:String = this.jointsType == "IDREF" ? param1.id : param1.sid;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this.vertex_weights.length)
         {
            _loc5_ = this.vertex_weights[_loc4_];
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].joint == _loc2_)
               {
                  _loc3_.push(_loc5_[_loc6_]);
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function findJointBindMatrix(param1:DaeNode) : Array
      {
         var _loc2_:String = this.jointsType == "IDREF" ? param1.id : param1.sid;
         var _loc3_:int = 0;
         while(_loc3_ < this.joints.length)
         {
            if(_loc2_ == this.joints[_loc3_])
            {
               return this.bind_matrices[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function normalizeBlendWeights(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc5_ += _loc4_[_loc3_].weight;
               _loc4_[_loc3_].originalWeight = _loc4_[_loc3_].weight;
               _loc3_++;
            }
            if(!(_loc5_ == 0 || _loc5_ == 1))
            {
               _loc6_ = 1 / _loc5_;
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  _loc4_[_loc3_].weight *= _loc6_;
                  _loc3_++;
               }
            }
            _loc2_++;
         }
      }
      
      public function findJointVertexWeightsByIDOrSID(param1:String) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.vertex_weights.length)
         {
            _loc4_ = this.vertex_weights[_loc3_];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].joint == param1)
               {
                  _loc2_.push(_loc4_[_loc5_]);
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function read(param1:XML) : void
      {
         var _loc8_:XML = null;
         var _loc9_:DaeInput = null;
         var _loc10_:DaeSource = null;
         var _loc12_:XML = null;
         var _loc13_:int = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:Number = NaN;
         var _loc25_:String = null;
         var _loc26_:DaeBlendWeight = null;
         this.joints = new Array();
         this.vertex_weights = new Array();
         this.bind_matrices = new Array();
         if(param1.localName() != ASCollada.DAE_CONTROLLER_SKIN_ELEMENT)
         {
            return;
         }
         super.read(param1);
         this.source = getAttribute(param1,ASCollada.DAE_SOURCE_ATTRIBUTE);
         Logger.log("reading skin, source: " + this.source);
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_BINDSHAPEMX_SKIN_PARAMETER);
         if(_loc2_.length())
         {
            this.bind_shape_matrix = getFloats(_loc2_[0]);
         }
         else
         {
            this.bind_shape_matrix = [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
         }
         var _loc3_:XMLList = getNodeList(param1,ASCollada.DAE_SOURCE_ELEMENT);
         if(_loc3_.length() < 3)
         {
            throw new Error("<skin> requires a minimum of 3 <source> elements!");
         }
         var _loc4_:XML = getNode(param1,ASCollada.DAE_JOINTS_ELEMENT);
         if(!_loc4_)
         {
            throw new Error("need exactly one <joints> element!");
         }
         var _loc5_:XML = getNode(param1,ASCollada.DAE_WEIGHTS_ELEMENT);
         if(!_loc5_)
         {
            throw new Error("need exactly one <vertex_weights> element!");
         }
         var _loc6_:XMLList = getNodeList(_loc4_,ASCollada.DAE_INPUT_ELEMENT);
         var _loc7_:DaeVertexWeights = new DaeVertexWeights(_loc5_);
         var _loc11_:Object = new Object();
         for each(_loc12_ in _loc6_)
         {
            _loc9_ = new DaeInput(_loc12_);
            _loc8_ = getNodeById(param1,ASCollada.DAE_SOURCE_ELEMENT,_loc9_.source);
            if(!_loc8_)
            {
               throw new Error("source not found! (id=\'" + _loc9_.source + "\')");
            }
            _loc10_ = new DaeSource(_loc8_);
            switch(_loc9_.semantic)
            {
               case ASCollada.DAE_JOINT_SKIN_INPUT:
                  this.joints = _loc10_.values;
                  this.jointsType = _loc10_.accessor.params[ASCollada.DAE_JOINT_SKIN_INPUT];
                  break;
               case ASCollada.DAE_BINDMATRIX_SKIN_INPUT:
                  this.bind_matrices = _loc10_.values;
                  break;
            }
         }
         _loc13_ = 0;
         _loc14_ = 0;
         _loc15_ = 1;
         for each(_loc9_ in _loc7_.inputs)
         {
            _loc8_ = getNodeById(param1,ASCollada.DAE_SOURCE_ELEMENT,_loc9_.source);
            if(!_loc8_)
            {
               throw new Error("source not found! (id=\'" + _loc9_.source + "\')");
            }
            _loc10_ = new DaeSource(_loc8_);
            switch(_loc9_.semantic)
            {
               case ASCollada.DAE_JOINT_SKIN_INPUT:
                  _loc14_ = _loc9_.offset;
                  _loc13_++;
                  break;
               case ASCollada.DAE_WEIGHT_SKIN_INPUT:
                  _loc16_ = _loc10_.values;
                  _loc15_ = _loc9_.offset;
                  _loc13_++;
                  break;
            }
         }
         _loc17_ = 0;
         _loc18_ = 0;
         while(_loc18_ < _loc7_.vcounts.length)
         {
            _loc19_ = int(_loc7_.vcounts[_loc18_]);
            _loc20_ = new Array();
            _loc21_ = 0;
            while(_loc21_ < _loc19_)
            {
               _loc22_ = int(_loc7_.v[_loc17_ + _loc14_]);
               _loc23_ = int(_loc7_.v[_loc17_ + _loc15_]);
               _loc24_ = Number(_loc16_[_loc23_]);
               _loc25_ = _loc22_ < 0 ? null : this.joints[_loc22_];
               _loc26_ = new DaeBlendWeight(_loc18_,_loc25_,_loc24_);
               _loc20_.push(_loc26_);
               _loc17_ += _loc13_;
               _loc21_++;
            }
            this.vertex_weights[_loc18_] = _loc20_;
            _loc18_++;
         }
         Logger.log(" => => #vertex_weights " + vertex_weights.length);
      }
   }
}

