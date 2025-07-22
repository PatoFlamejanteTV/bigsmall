package net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments
{
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.ResourceController;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.pv3d.DAEFixed;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class JunctionSegment extends PathSegment
   {
      
      public static const LEFT:String = "leftSegment";
      
      public static const RIGHT:String = "rightSegment";
      
      public function JunctionSegment(param1:ViewportLayer, param2:ViewportLayer, param3:DAEFixed, param4:ResourceController, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,1200,param5);
      }
      
      override protected function initArrowObject(param1:String, param2:Number3D, param3:Number) : MysteriousWoodsArrow
      {
         var _loc4_:MysteriousWoodsArrow = new MysteriousWoodsArrow();
         var _loc5_:Number3D = new Number3D(0,0,segmentSize * 0.5);
         var _loc6_:Number3D = Number3D.sub(param2,_loc5_);
         _loc6_.multiplyEq(0.41);
         var _loc7_:Number3D = Number3D.add(_loc5_,_loc6_);
         _loc4_.pathKey = param1;
         _loc4_.viewportLayer = uiLayer.getChildLayer(_loc4_,true,true);
         _loc4_.addEventListener(MouseEvent.CLICK,handleArrowClick);
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,handleArrowRolledOver);
         if(param1 == LEFT)
         {
            _loc4_.registerState(CharacterDefinitions.BIG,_resources.leftArrowBig,_loc7_.x,_loc7_.y + 150,_loc7_.z,1.5);
            _loc4_.registerState(CharacterDefinitions.SMALL,_resources.leftArrowSmall,_loc7_.x,_loc7_.y + 150,_loc7_.z,1.5);
            AccessibilityManager.addAccessibilityProperties(_loc4_.viewportLayer,"Arrow: Turn Left","Arrow: Turn Left",AccessibilityDefinitions.MWOODS_ARROWS);
         }
         else if(param1 == RIGHT)
         {
            _loc4_.registerState(CharacterDefinitions.BIG,_resources.rightArrowBig,_loc7_.x,_loc7_.y + 150,_loc7_.z,1.5);
            _loc4_.registerState(CharacterDefinitions.SMALL,_resources.rightArrowSmall,_loc7_.x,_loc7_.y + 150,_loc7_.z,1.5);
            AccessibilityManager.addAccessibilityProperties(_loc4_.viewportLayer,"Arrow: Turn Right","Arrow: Turn Right",AccessibilityDefinitions.MWOODS_ARROWS);
         }
         return _loc4_;
      }
      
      override protected function initPaths() : void
      {
         super.initPaths();
         addPath(LEFT,new Number3D(-segmentSize >> 1,0,segmentSize >> 1),new Number3D(0,0,segmentSize * 0.3),new Number3D(segmentSize * -0.2,0,segmentSize >> 1),-90);
         addPath(RIGHT,new Number3D(segmentSize >> 1,0,segmentSize >> 1),new Number3D(0,0,segmentSize * 0.3),new Number3D(segmentSize * 0.2,0,segmentSize >> 1),90);
      }
   }
}

