package net.pluginmedia.bigandsmall.pages.bedroom
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   
   public class ModifiableVertex
   {
      
      public var vert:Vertex3D = null;
      
      public var dist:Number = 0;
      
      public var vertOriginal:Number3D = null;
      
      public function ModifiableVertex(param1:Vertex3D, param2:Number)
      {
         super();
         this.vert = param1;
         vertOriginal = param1.getPosition();
         this.dist = param2;
      }
   }
}

