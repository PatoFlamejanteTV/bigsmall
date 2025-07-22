package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeMesh extends DaeEntity
   {
      
      public var geometry:DaeGeometry;
      
      public var sources:Object;
      
      public var vertices:Array;
      
      public var primitives:Array;
      
      public function DaeMesh(param1:DaeGeometry, param2:XML = null)
      {
         super(param2);
         this.geometry = param1;
      }
      
      override public function read(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:DaeSource = null;
         var _loc5_:XML = null;
         var _loc6_:DaeVertices = null;
         var _loc7_:DaeInput = null;
         var _loc8_:XMLList = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:XML = null;
         var _loc12_:DaePrimitive = null;
         if(param1.localName() != ASCollada.DAE_MESH_ELEMENT && param1.localName() != ASCollada.DAE_CONVEX_MESH_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_MESH_ELEMENT + " or a \'" + ASCollada.DAE_CONVEX_MESH_ELEMENT + "\' element");
         }
         super.read(param1);
         this.sources = new Object();
         this.primitives = new Array();
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_SOURCE_ELEMENT);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new DaeSource(_loc3_);
            this.sources[_loc4_.id] = _loc4_.values;
         }
         _loc5_ = getNode(param1,ASCollada.DAE_VERTICES_ELEMENT);
         _loc6_ = new DaeVertices(_loc5_);
         for each(_loc7_ in _loc6_.inputs)
         {
            if(_loc7_.semantic == "POSITION")
            {
               this.vertices = sources[_loc7_.source];
               this.sources[_loc6_.id] = sources[_loc7_.source];
            }
         }
         _loc8_ = param1.children();
         _loc9_ = int(_loc8_.length());
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = _loc8_[_loc10_];
            switch(String(_loc11_.localName()))
            {
               case ASCollada.DAE_TRIANGLES_ELEMENT:
               case ASCollada.DAE_TRIFANS_ELEMENT:
               case ASCollada.DAE_TRISTRIPS_ELEMENT:
               case ASCollada.DAE_LINESTRIPS_ELEMENT:
               case ASCollada.DAE_LINES_ELEMENT:
               case ASCollada.DAE_POLYGONS_ELEMENT:
               case ASCollada.DAE_POLYLIST_ELEMENT:
                  _loc12_ = new DaePrimitive(this,_loc11_);
                  if(_loc12_.count > 0)
                  {
                     this.primitives.push(_loc12_);
                  }
                  break;
            }
            _loc10_++;
         }
      }
   }
}

