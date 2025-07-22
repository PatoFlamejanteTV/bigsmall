package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.PathControlPointsInfo;
   import net.pluginmedia.brain.core.animation.SuperMovieClip;
   import net.pluginmedia.geom.Point3D;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.BitmapParticleMaterialSplit;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.special.BitmapParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class StraightSegment extends PathSegment
   {
      
      public static const STRAIGHT:String = "straightSegment";
      
      protected var planeTreeYOffs:Number = 20;
      
      protected var controlStart:Point3D = new Point3D();
      
      protected var rightWall:Plane;
      
      protected var decorResolution:Number = 1;
      
      protected var treePartScale:Number = 3;
      
      protected var incidentalSprite:PointSprite;
      
      protected var incidentalMat:SpriteParticleMaterial;
      
      protected var decorationGroups:Array;
      
      protected var planeFirst:Boolean = false;
      
      protected var incidentalAnim:SuperMovieClip;
      
      protected var controlEnd:Point3D = new Point3D();
      
      public var nextSegment:AbstractSegment;
      
      protected var rightWallTex:MaterialObject3D;
      
      protected var decorations:Array = [];
      
      protected var zeroPoint:Point = new Point();
      
      protected var incidentalLayer:ViewportLayer;
      
      protected var initialGeomPlanes:Number = 0;
      
      protected var decorOffset:Number = 0;
      
      protected var stateableArrow:MysteriousWoodsArrow;
      
      public var drawScale:Number = 0.55;
      
      protected var _hasIncidentalAnim:Boolean = false;
      
      protected var _exitPlacement:Number3D;
      
      protected var segWidthExp:Number = 1.5;
      
      protected var leftWallTex:MaterialObject3D;
      
      protected var leftWall:Plane;
      
      public function StraightSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:Array, param6:Number = 0.5, param7:Number = 0, param8:Number = 0, param9:Boolean = false)
      {
         decorOffset = param7;
         decorResolution = param6;
         _hasIncidentalAnim = param9;
         initialGeomPlanes = param8;
         decorationGroups = param5;
         super(param1,param2,param3,param4,1200);
      }
      
      override public function setControlsForPath(param1:String, param2:PathControlPointsInfo) : void
      {
         super.setControlsForPath(param1,param2);
         positionDecorationsInlineWithPath();
      }
      
      protected function positionDecorationsInlineWithPath() : void
      {
         var _loc2_:DisplayObject3D = null;
         var _loc1_:int = 0;
         while(_loc1_ < decorations.length)
         {
            _loc2_ = DisplayObject3D(decorations[_loc1_]);
            _loc2_.x = SegmentPathInfo(paths[STRAIGHT]).path.getNumber3DAtT(_loc2_.z / segmentSize).x;
            _loc1_++;
         }
      }
      
      override protected function initPaths() : void
      {
         super.initPaths();
         addPath(STRAIGHT,new Number3D(0,0,segmentSize),new Number3D(-200,0,segmentSize * 0.35),new Number3D(200,0,segmentSize * 0.65),0);
      }
      
      private function handleIncidentalAnimComplete() : void
      {
         removeChild(incidentalSprite);
         incidentalMat.removeSprite();
      }
      
      protected function factoryDecoration(param1:Boolean = false) : DisplayObject3D
      {
         var _loc2_:DisplayObject3D = null;
         var _loc7_:BitmapParticleMaterial = null;
         var _loc9_:Number = NaN;
         var _loc10_:MaterialObject3D = null;
         var _loc3_:MovieClip = _resources.getRandomDecorationTexture(decorationGroups);
         var _loc4_:Rectangle = _loc3_.getBounds(_loc3_);
         var _loc5_:Matrix = new Matrix(1,0,0,1,-_loc4_.x,-_loc4_.y);
         var _loc6_:BitmapData = new BitmapData(_loc4_.width * drawScale,_loc4_.height * drawScale,true,0);
         var _loc8_:Point = new Point(_loc4_.x * drawScale,(_loc4_.y + 10) * drawScale);
         if(Math.random() < 0.5)
         {
            _loc5_.scale(-drawScale,drawScale);
            _loc5_.translate(_loc3_.width * drawScale,0);
            _loc8_.x = -(_loc4_.x + _loc4_.width) * drawScale;
         }
         else
         {
            _loc5_.scale(drawScale,drawScale);
         }
         _loc6_.draw(_loc3_,_loc5_);
         if(param1)
         {
            _loc9_ = _loc4_.height / _loc4_.width;
            _loc10_ = new BitmapMaterial(_loc6_);
            _loc2_ = new Plane(_loc10_,segmentSize * segWidthExp,segmentSize * segWidthExp * _loc9_,4,3);
            _loc2_.y = segmentSize * segWidthExp * _loc9_ * 0.5 - planeTreeYOffs;
         }
         else
         {
            _loc7_ = new BitmapParticleMaterialSplit(_loc6_,1,_loc8_.x,_loc8_.y);
            _loc2_ = new PointSprite(_loc7_,treePartScale * (1 / drawScale));
         }
         return _loc2_;
      }
      
      override public function park() : void
      {
         if(_hasIncidentalAnim)
         {
            incidentalAnim.stop();
            removeChild(incidentalSprite);
            incidentalMat.removeSprite();
         }
      }
      
      override public function deactivate() : void
      {
         if(_hasIncidentalAnim)
         {
            unflagDirtyLayer(incidentalLayer);
         }
         super.deactivate();
      }
      
      public function get hasIncidentalAnim() : Boolean
      {
         return _hasIncidentalAnim;
      }
      
      override public function activate() : void
      {
         super.activate();
         if(_hasIncidentalAnim)
         {
            addChild(incidentalSprite);
            incidentalAnim.playLabel("sequence",0,0,handleIncidentalAnimComplete);
            flagDirtyLayer(incidentalLayer);
         }
      }
      
      override protected function buildDisplay(param1:DAEFixed, param2:Boolean = false) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:DisplayObject3D = null;
         super.buildDisplay(param1,param2);
         if(_hasIncidentalAnim)
         {
            _loc6_ = _resources.getIncidentalAnim();
            if(_loc6_)
            {
               incidentalAnim = new SuperMovieClip(_loc6_);
               incidentalMat = new SpriteParticleMaterial(incidentalAnim);
               incidentalSprite = new PointSprite(incidentalMat,2.45);
               incidentalSprite.z = segmentSize / 4 * 2;
               incidentalSprite.y = segmentSize / 4;
               incidentalLayer = uiLayer.getChildLayer(incidentalSprite,true,true);
            }
         }
         leftWallTex = new BitmapMaterial(_resources.tile);
         leftWall = new Plane(leftWallTex,segmentSize,segmentSize,3,2);
         leftWall.x = -segmentSize * segWidthExp >> 1;
         leftWall.z = segmentSize >> 1;
         leftWall.y = segmentSize >> 1;
         leftWall.rotationY = -90;
         addChild(leftWall);
         geomLayer.addDisplayObject3D(leftWall,true);
         rightWallTex = new BitmapMaterial(_resources.tile,false);
         rightWall = new Plane(rightWallTex,segmentSize,segmentSize,2,2);
         rightWall.x = segmentSize * segWidthExp >> 1;
         rightWall.z = segmentSize >> 1;
         rightWall.y = segmentSize >> 1;
         rightWall.rotationY = 90;
         addChild(rightWall);
         geomLayer.addDisplayObject3D(rightWall,true);
         var _loc3_:Number = decorResolution * segmentSize;
         var _loc4_:Number = decorOffset * segmentSize;
         var _loc5_:int = 0;
         while(_loc4_ < segmentSize)
         {
            if(_loc5_ < initialGeomPlanes)
            {
               _loc7_ = factoryDecoration(true);
            }
            else
            {
               _loc7_ = factoryDecoration();
            }
            _loc7_.z = _loc4_;
            _loc4_ += _loc3_;
            addChild(_loc7_);
            decorations.push(_loc7_);
            woodsLayer.addDisplayObject3D(_loc7_,true);
            _loc5_++;
         }
         positionDecorationsInlineWithPath();
      }
   }
}

