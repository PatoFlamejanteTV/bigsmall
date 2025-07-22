package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.PathControlPointsInfo;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.SegmentTransitionEvent;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.DAEFixed;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class PathSegment extends AbstractSegment
   {
      
      protected var arrowObjs:Array = [];
      
      protected var paths:Dictionary = new Dictionary();
      
      protected var rotationMatrix:Matrix3D = new Matrix3D();
      
      public function PathSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:Number = 1200, param6:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function set orientation(param1:Number) : void
      {
         super.orientation = param1;
         rotationMatrix = Matrix3D.rotationY(_orientation * SuperMath.DEGREES_TO_RADS);
      }
      
      public function getPositionOnPathAtTime(param1:String, param2:Number) : Number3D
      {
         var _loc3_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         return adjustToParent(_loc3_.path.getNumber3DAtT(param2));
      }
      
      public function getConnectedSegmentPositionForPath(param1:String) : Number3D
      {
         var _loc2_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         return adjustToParent(_loc2_.pathExit);
      }
      
      public function setSegmentForEndOfPath(param1:String, param2:AbstractSegment) : void
      {
         var _loc3_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         _loc3_.targetSegment = param2;
         param2.previousSegment = this;
         param2.previousSegmentPath = param1;
      }
      
      protected function initArrowObject(param1:String, param2:Number3D, param3:Number) : MysteriousWoodsArrow
      {
         var _loc4_:MysteriousWoodsArrow = new MysteriousWoodsArrow();
         var _loc5_:Number3D = new Number3D(0,0,segmentSize * 0.5);
         var _loc6_:Number3D = Number3D.sub(param2,_loc5_);
         _loc6_.multiplyEq(0.41);
         var _loc7_:Number3D = Number3D.add(_loc5_,_loc6_);
         _loc4_.pathKey = param1;
         _loc4_.registerState(CharacterDefinitions.BIG,_resources.forwardArrowBig,_loc7_.x,_loc7_.y + 50,_loc7_.z,2);
         _loc4_.registerState(CharacterDefinitions.SMALL,_resources.forwardArrowSmall,_loc7_.x,_loc7_.y + 50,_loc7_.z,2);
         _loc4_.viewportLayer = uiLayer.getChildLayer(_loc4_,true,true);
         AccessibilityManager.addAccessibilityProperties(_loc4_.viewportLayer,"Arrow: Go Forwards","Arrow: Go Forwards",AccessibilityDefinitions.MWOODS_ARROWS);
         _loc4_.addEventListener(MouseEvent.CLICK,handleArrowClick);
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,handleArrowRolledOver);
         return _loc4_;
      }
      
      public function getTargetSegmentOfPath(param1:String) : AbstractSegment
      {
         var _loc2_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         return _loc2_.targetSegment;
      }
      
      protected function handleArrowClick(param1:MouseEvent) : void
      {
         var _loc2_:MysteriousWoodsArrow = param1.target as MysteriousWoodsArrow;
         var _loc3_:SegmentPathInfo = paths[_loc2_.pathKey] as SegmentPathInfo;
         dispatchEvent(new SegmentTransitionEvent(SegmentTransitionEvent.TRANSITION,_loc2_.pathKey));
      }
      
      protected function initPaths() : void
      {
      }
      
      override protected function init() : void
      {
         initPaths();
      }
      
      public function getBezierOfPath(param1:String) : BezierPath3D
      {
         var _loc2_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         return _loc2_.path;
      }
      
      override public function deactivate() : void
      {
         var _loc1_:MysteriousWoodsArrow = null;
         super.deactivate();
         for each(_loc1_ in arrowObjs)
         {
            _loc1_.deactivate();
         }
      }
      
      protected function addPath(param1:String, param2:Number3D, param3:Number3D, param4:Number3D, param5:Number) : void
      {
         var _loc6_:SegmentPathInfo = new SegmentPathInfo();
         _loc6_.exitOrientation = param5;
         _loc6_.pathExit = param2;
         _loc6_.pathControlA = param3;
         _loc6_.pathControlB = param4;
         var _loc7_:MysteriousWoodsArrow = initArrowObject(param1,param2,param5);
         _loc7_.deactivate();
         addChild(_loc7_);
         arrowObjs.push(_loc7_);
         _loc6_.initPath();
         _loc6_.arrow = _loc7_;
         paths[param1] = _loc6_;
      }
      
      public function setControlsForPath(param1:String, param2:PathControlPointsInfo) : void
      {
         var _loc3_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         var _loc4_:Number3D = param2.pointA.clone();
         var _loc5_:Number3D = param2.pointB.clone();
         _loc4_.multiplyEq(segmentSize);
         _loc5_.multiplyEq(segmentSize);
         _loc3_.pathControlA.copyFrom(_loc4_);
         _loc3_.pathControlB.copyFrom(_loc5_);
         _loc3_.updatePath();
      }
      
      protected function handleArrowRolledOver(param1:MouseEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function getExitOrientationOfPath(param1:String) : Number
      {
         var _loc2_:SegmentPathInfo = paths[param1] as SegmentPathInfo;
         return orientation + _loc2_.exitOrientation;
      }
      
      override public function activate() : void
      {
         var _loc1_:MysteriousWoodsArrow = null;
         super.activate();
         for each(_loc1_ in arrowObjs)
         {
            trace("arrow selecting state:",currentPOV);
            _loc1_.selectState(currentPOV);
            _loc1_.activate();
         }
      }
      
      protected function adjustToParent(param1:Number3D) : Number3D
      {
         var _loc2_:Number3D = param1.clone();
         Matrix3D.rotateAxis(rotationMatrix,_loc2_);
         _loc2_.multiplyEq(param1.modulo);
         return Number3D.add(_loc2_,position);
      }
   }
}

