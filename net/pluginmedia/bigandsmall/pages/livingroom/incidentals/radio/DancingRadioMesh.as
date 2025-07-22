package net.pluginmedia.bigandsmall.pages.livingroom.incidentals.radio
{
   import flash.display.MovieClip;
   import org.papervision3d.core.math.Number2D;
   
   public class DancingRadioMesh
   {
      
      private var meshPoint:MovieClip;
      
      private var isEdge:Boolean;
      
      private var leftPoint:Number2D;
      
      private var point:Number2D;
      
      private var rightPoint:Number2D;
      
      private var rows:uint;
      
      private var points:Array;
      
      private var bottomPoint:Number2D;
      
      private var i:uint;
      
      private var j:uint;
      
      private var mesh:MovieClip;
      
      private var meshPoints:Array;
      
      private var cols:uint;
      
      private var topPoint:Number2D;
      
      public function DancingRadioMesh()
      {
         super();
      }
      
      private function setupMeshPoints() : void
      {
         meshPoints = new Array(rows);
         points = new Array(rows);
         i = 0;
         while(i < rows)
         {
            meshPoints[i] = new Array(cols);
            points[i] = new Array(cols);
            j = 0;
            while(j < cols)
            {
               points[i][j] = new Number2D();
               isEdge = i == 0 || i == rows - 1 || (j == 0 || j == cols - 1);
               if(isEdge)
               {
                  meshPoints[i][j] = mesh["r" + i.toString() + "c" + j.toString()];
               }
               ++j;
            }
            ++i;
         }
      }
      
      public function getMesh() : MovieClip
      {
         return mesh;
      }
      
      private function updateMeshPoints() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         i = 0;
         while(i < rows)
         {
            j = 0;
            while(j < cols)
            {
               isEdge = i == 0 || i == rows - 1 || (j == 0 || j == cols - 1);
               if(isEdge)
               {
                  meshPoint = meshPoints[i][j] as MovieClip;
                  point = points[i][j] as Number2D;
                  point.x = meshPoint.x;
                  point.y = meshPoint.y * 1.5;
               }
               ++j;
            }
            ++i;
         }
         i = 1;
         while(i < rows - 1)
         {
            j = 1;
            while(j < cols - 1)
            {
               point = points[i][j] as Number2D;
               leftPoint = points[i][0];
               rightPoint = points[i][cols - 1];
               topPoint = points[0][j];
               bottomPoint = points[rows - 1][j];
               _loc1_ = bottomPoint.y - topPoint.y;
               _loc2_ = rightPoint.x - leftPoint.x;
               point.x = leftPoint.x + _loc2_ * (j / (cols - 1));
               point.y = topPoint.y + _loc1_ * (i / (rows - 1));
               ++j;
            }
            ++i;
         }
      }
      
      public function setMesh(param1:MovieClip, param2:uint = 4, param3:uint = 4) : void
      {
         mesh = param1;
         rows = param2;
         cols = param3;
         setupMeshPoints();
      }
      
      public function getPoints() : Array
      {
         updateMeshPoints();
         return points;
      }
   }
}

