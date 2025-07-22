package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.physics.DaeConvexMesh;
   import org.ascollada.utils.Logger;
   
   public class DaeGeometry extends DaeEntity
   {
      
      public var spline:DaeSpline;
      
      public var splines:Array;
      
      public var convex_mesh:DaeConvexMesh;
      
      public var mesh:DaeMesh;
      
      public function DaeGeometry(param1:XML = null, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.read(param1);
         Logger.log("reading geometry: " + this.id);
         this.mesh = null;
         this.convex_mesh = null;
         this.spline = null;
         this.splines = new Array();
         if(async)
         {
            return;
         }
         var _loc2_:XML = getNode(param1,ASCollada.DAE_CONVEX_MESH_ELEMENT);
         if(!_loc2_)
         {
            _loc2_ = getNode(param1,ASCollada.DAE_MESH_ELEMENT);
            if(!_loc2_)
            {
               _loc2_ = getNode(param1,ASCollada.DAE_SPLINE_ELEMENT);
            }
         }
         if(!_loc2_)
         {
            Logger.error("expected one of <convex_mesh>, <mesh> or <spline>!");
            throw new Error("expected one of <convex_mesh>, <mesh> or <spline>!");
         }
         switch(_loc2_.localName())
         {
            case ASCollada.DAE_CONVEX_MESH_ELEMENT:
               this.convex_mesh = new DaeConvexMesh(this,_loc2_);
               break;
            case ASCollada.DAE_MESH_ELEMENT:
               this.mesh = new DaeMesh(this,_loc2_);
               break;
            case ASCollada.DAE_SPLINE_ELEMENT:
               this.spline = new DaeSpline(_loc2_);
               _loc3_ = getNodeList(param1,ASCollada.DAE_SPLINE_ELEMENT);
               _loc4_ = int(_loc3_.length());
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  this.splines.push(new DaeSpline(_loc3_[_loc5_]));
                  _loc5_++;
               }
         }
      }
   }
}

