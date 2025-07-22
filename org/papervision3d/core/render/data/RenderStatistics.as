package org.papervision3d.core.render.data
{
   public class RenderStatistics
   {
      
      public var renderTime:int = 0;
      
      public var culledObjects:int = 0;
      
      public var shadedTriangles:int = 0;
      
      public var culledParticles:int = 0;
      
      public var culledTriangles:int = 0;
      
      public var triangles:int = 0;
      
      public var particles:int = 0;
      
      public var rendered:int = 0;
      
      public var projectionTime:int = 0;
      
      public var filteredObjects:int = 0;
      
      public var lines:int = 0;
      
      public function RenderStatistics()
      {
         super();
      }
      
      public function clear() : void
      {
         projectionTime = 0;
         renderTime = 0;
         rendered = 0;
         particles = 0;
         triangles = 0;
         culledTriangles = 0;
         culledParticles = 0;
         lines = 0;
         shadedTriangles = 0;
         filteredObjects = 0;
         culledObjects = 0;
      }
      
      public function clone() : RenderStatistics
      {
         var _loc1_:RenderStatistics = new RenderStatistics();
         _loc1_.projectionTime = projectionTime;
         _loc1_.renderTime = renderTime;
         _loc1_.rendered = rendered;
         _loc1_.particles = particles;
         _loc1_.triangles = triangles;
         _loc1_.culledTriangles = culledTriangles;
         _loc1_.lines = lines;
         _loc1_.shadedTriangles = shadedTriangles;
         _loc1_.filteredObjects = filteredObjects;
         _loc1_.culledObjects = culledObjects;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return new String("ProjectionTime:" + projectionTime + " RenderTime:" + renderTime + " Particles:" + particles + " CulledParticles :" + culledParticles + " Triangles:" + triangles + " ShadedTriangles :" + shadedTriangles + " CulledTriangles:" + culledTriangles + " FilteredObjects:" + filteredObjects + " CulledObjects:" + culledObjects + "");
      }
   }
}

