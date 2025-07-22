package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeSpline extends DaeEntity
   {
      
      public var vertices:Array;
      
      public var closed:Boolean;
      
      public function DaeSpline(param1:XML)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:DaeInput = null;
         var _loc7_:XML = null;
         var _loc8_:DaeSource = null;
         if(param1.localName() != ASCollada.DAE_SPLINE_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_SPLINE_ELEMENT + "\' element");
         }
         super.read(param1);
         this.closed = getAttribute(param1,ASCollada.DAE_CLOSED_ATTRIBUTE) == "true" ? true : false;
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_SOURCE_ELEMENT);
         if(_loc2_ == new XMLList())
         {
            throw new Error("<spline> requires at least one <source> element!");
         }
         var _loc3_:XML = getNode(param1,ASCollada.DAE_CONTROL_VERTICES_ELEMENT);
         if(!_loc3_)
         {
            throw new Error("<spline> requires exactly one <control_vertices> element!");
         }
         var _loc4_:XMLList = getNodeList(_loc3_,ASCollada.DAE_INPUT_ELEMENT);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = new DaeInput(_loc5_);
            switch(_loc6_.semantic)
            {
               case "POSITION":
                  _loc7_ = getNodeById(param1,ASCollada.DAE_SOURCE_ELEMENT,_loc6_.source);
                  if(!_loc7_)
                  {
                     throw new Error("source with id=" + _loc6_.source + " not found!");
                  }
                  _loc8_ = new DaeSource(_loc7_[0]);
                  this.vertices = _loc8_.values;
                  break;
               case "INTERPOLATION":
                  break;
               case "IN_TANGENT":
                  break;
               case "OUT_TANGENT":
                  break;
               case "CONTINUITY":
                  break;
               case "LINEAR_STEPS":
                  break;
            }
         }
      }
   }
}

