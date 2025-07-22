package org.ascollada.core
{
   import flash.utils.Dictionary;
   import org.ascollada.ASCollada;
   
   public class DaePrimitive extends DaeEntity
   {
      
      public var vcount:Array;
      
      public var material:String;
      
      public var mesh:DaeMesh;
      
      public var count:uint;
      
      private var _inputs:Dictionary;
      
      public var polygons:Array;
      
      public var type:String;
      
      public function DaePrimitive(param1:DaeMesh, param2:XML = null)
      {
         this.mesh = param1;
         super(param2);
      }
      
      protected function parse(param1:XML) : void
      {
         var _loc6_:DaeInput = null;
         var _loc8_:XML = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc2_:Array = getInts(getNode(param1,ASCollada.DAE_POLYGON_ELEMENT));
         var _loc3_:XML = getNode(param1,ASCollada.DAE_VERTEXCOUNT_ELEMENT);
         var _loc4_:XMLList = getNodeList(param1,ASCollada.DAE_INPUT_ELEMENT);
         var _loc5_:Array = new Array();
         var _loc7_:uint = 0;
         if(_loc3_ is XML)
         {
            this.vcount = getInts(_loc3_);
         }
         for each(_loc8_ in _loc4_)
         {
            _loc6_ = new DaeInput(_loc8_);
            _loc7_ = Math.max(_loc7_,_loc6_.offset + 1);
            _loc5_.push(_loc6_);
            _inputs[_loc6_] = new Array();
         }
         _loc9_ = 0;
         while(_loc9_ < _loc2_.length)
         {
            for each(_loc6_ in _loc5_)
            {
               _loc10_ = int(_loc2_[_loc9_ + _loc6_.offset]);
               _loc11_ = mesh.sources[_loc6_.source];
               switch(_loc6_.semantic)
               {
                  case "VERTEX":
                     _inputs[_loc6_].push(_loc10_);
                     break;
                  default:
                     _inputs[_loc6_].push(_loc11_[_loc10_]);
                     break;
               }
            }
            _loc9_ += _loc7_;
         }
      }
      
      public function get vertices() : Array
      {
         return getFirstInput("VERTEX");
      }
      
      public function get normals() : Array
      {
         return getFirstInput("NORMAL");
      }
      
      private function getFirstInput(param1:String) : Array
      {
         var _loc2_:* = undefined;
         for(_loc2_ in _inputs)
         {
            if(_loc2_.semantic == param1)
            {
               return _inputs[_loc2_];
            }
         }
         return null;
      }
      
      private function checkNode(param1:XML) : Boolean
      {
         var _loc2_:String = String(param1.localName());
         return _loc2_ == ASCollada.DAE_TRIANGLES_ELEMENT || _loc2_ == ASCollada.DAE_TRIFANS_ELEMENT || _loc2_ == ASCollada.DAE_TRISTRIPS_ELEMENT || _loc2_ == ASCollada.DAE_LINESTRIPS_ELEMENT || _loc2_ == ASCollada.DAE_LINES_ELEMENT || _loc2_ == ASCollada.DAE_POLYGONS_ELEMENT || _loc2_ == ASCollada.DAE_POLYLIST_ELEMENT;
      }
      
      public function getTexCoords(param1:uint = 0) : Array
      {
         return getInputBySet("TEXCOORD",param1);
      }
      
      private function getInputBySet(param1:String, param2:int) : Array
      {
         var _loc3_:* = undefined;
         if(getInputCount(param1) == 1)
         {
            return getFirstInput(param1);
         }
         for(_loc3_ in _inputs)
         {
            if(_loc3_.semantic == param1 && _loc3_.setId == param2)
            {
               return _inputs[_loc3_];
            }
         }
         return new Array();
      }
      
      private function parsePolygons(param1:XML) : void
      {
         var _loc3_:DaeInput = null;
         var _loc7_:int = 0;
         var _loc8_:XML = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc2_:Array = new Array();
         var _loc4_:uint = 0;
         var _loc5_:XMLList = getNodeList(param1,ASCollada.DAE_INPUT_ELEMENT);
         var _loc6_:XMLList = getNodeList(param1,ASCollada.DAE_POLYGON_ELEMENT);
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length())
         {
            _loc3_ = new DaeInput(_loc5_[_loc7_]);
            _loc4_ = Math.max(_loc4_,_loc3_.offset + 1);
            _loc2_.push(_loc3_);
            _inputs[_loc3_] = new Array();
            _loc7_++;
         }
         for each(_loc8_ in _loc6_)
         {
            _loc9_ = getInts(_loc8_);
            _loc10_ = new Array();
            _loc7_ = 0;
            while(_loc7_ < _loc9_.length)
            {
               for each(_loc3_ in _loc2_)
               {
                  _loc11_ = int(_loc9_[_loc7_ + _loc3_.offset]);
                  _loc12_ = mesh.sources[_loc3_.source];
                  switch(_loc3_.semantic)
                  {
                     case "VERTEX":
                        _inputs[_loc3_].push(_loc11_);
                        _loc10_.push(_loc11_);
                        break;
                     default:
                        _inputs[_loc3_].push(_loc12_[_loc11_]);
                        break;
                  }
               }
               _loc7_ += _loc4_;
            }
            this.polygons.push(_loc10_);
         }
      }
      
      override public function read(param1:XML) : void
      {
         if(!checkNode(param1))
         {
            throw new Error("expected a primitive element!");
         }
         if(!this.mesh)
         {
            throw new Error("parent-element \'mesh\' or \'convex_mesh\' not set!");
         }
         super.read(param1);
         this.type = String(param1.localName());
         this.count = getAttributeAsInt(param1,ASCollada.DAE_COUNT_ATTRIBUTE);
         this.material = getAttribute(param1,ASCollada.DAE_MATERIAL_ATTRIBUTE);
         this.vcount = new Array();
         this.polygons = new Array();
         if(this.count == 0)
         {
            return;
         }
         _inputs = new Dictionary();
         var _loc2_:XML = param1.parent() as XML;
         switch(String(_loc2_.localName()))
         {
            case ASCollada.DAE_MESH_ELEMENT:
               switch(param1.name().localName.toString())
               {
                  case ASCollada.DAE_POLYGONS_ELEMENT:
                     parsePolygons(param1);
                     break;
                  default:
                     parse(param1);
               }
               break;
            case ASCollada.DAE_CONVEX_MESH_ELEMENT:
         }
      }
      
      private function getInputCount(param1:String) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         for(_loc3_ in _inputs)
         {
            if(_loc3_.semantic == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
   }
}

