package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.geom.BezierPoint3D;
   import org.papervision3d.core.math.Number3D;
   
   public class SegmentPathInfo
   {
      
      public var targetSegment:AbstractSegment;
      
      public var pathExit:Number3D;
      
      public var path:BezierPath3D;
      
      public var pathControlA:Number3D;
      
      public var arrow:MysteriousWoodsArrow;
      
      public var pathControlB:Number3D;
      
      public var exitOrientation:Number;
      
      public function SegmentPathInfo()
      {
         super();
      }
      
      public function updatePath() : void
      {
         path.reCalcSegments();
      }
      
      public function initPath() : void
      {
         path = new BezierPath3D();
         path.autoPlaceControls = false;
         path.autoSpacePath = false;
         path.points.push(new BezierPoint3D(0,0,0,pathControlA,pathControlA));
         path.points.push(new BezierPoint3D(pathExit.x,pathExit.y,pathExit.z,pathControlB,pathControlB));
         path.transitStepInc = 0.01;
         updatePath();
      }
   }
}

