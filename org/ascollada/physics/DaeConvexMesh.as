package org.ascollada.physics
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeGeometry;
   import org.ascollada.core.DaeMesh;
   
   public class DaeConvexMesh extends DaeMesh
   {
      
      public var convex_hull_off:String;
      
      public var isHull:Boolean;
      
      public function DaeConvexMesh(param1:DaeGeometry, param2:XML = null)
      {
         super(param1,param2);
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_CONVEX_MESH_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_CONVEX_MESH_ELEMENT + "\' element");
         }
         this.convex_hull_off = getAttribute(param1,ASCollada.DAE_CONVEX_HULL_OF_ATTRIBUTE,true);
         this.isHull = this.convex_hull_off.length > 0;
         if(this.isHull)
         {
            return;
         }
         super.read(param1);
      }
   }
}

