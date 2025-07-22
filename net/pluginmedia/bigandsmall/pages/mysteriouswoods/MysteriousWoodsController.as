package net.pluginmedia.bigandsmall.pages.mysteriouswoods
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.animation.BigAndSmallCompTransitionFX;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.definitions.PageDefinitions;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.AbstractSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.DeadEndSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.EndSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.JunctionSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.PathSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.segments.StraightSegment;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.PathControlPointsInfo;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.SegmentTransitionEvent;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.TransitionManager;
   import net.pluginmedia.bigandsmall.pages.mysteriouswoods.transitions.TransitionObject;
   import net.pluginmedia.brain.core.events.BrainEvent;
   import net.pluginmedia.brain.core.events.BrainEventType;
   import net.pluginmedia.pv3d.DAEFixed;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class MysteriousWoodsController extends DisplayObject3D
   {
      
      public static const PROMPT_INCIDENTAL_ANIM:String = "MysteriousWoodsController.PROMPT_INCIDENTAL_ANIM";
      
      public static const PROMPT_ARROW_OVER:String = "MysteriousWoodsController.PROMPT_ARROW_OVER";
      
      public static var LEFT:Number = -90;
      
      public static var RIGHT:Number = 90;
      
      private var smallCamera:CameraObject3D;
      
      private var segmentViewDistance:Number = 3750;
      
      private var uiLayer:ViewportLayer;
      
      private var currentPOV:String;
      
      private var transitionManager:TransitionManager;
      
      private var segments:Array = [];
      
      private var rewards:Array = [];
      
      private var resources:ResourceController;
      
      private var junctions:Array = [];
      
      private var bigCamera:CameraObject3D;
      
      private var segmentViewDistanceSq:Number = segmentViewDistance * segmentViewDistance;
      
      private var _renderStateIsDirty:Boolean = false;
      
      private var voxManager:MysteriousWoodsVoxController = new MysteriousWoodsVoxController();
      
      private var transitionCamera:CameraObject3D;
      
      private var end:EndSegment;
      
      private var placement:Number3D;
      
      private var currentLiveSegment:AbstractSegment;
      
      private var basicView:BasicView;
      
      private var transitionFX:BigAndSmallCompTransitionFX;
      
      public function MysteriousWoodsController(param1:BasicView, param2:Number3D, param3:ResourceController, param4:CameraObject3D, param5:CameraObject3D, param6:BigAndSmallCompTransitionFX)
      {
         basicView = param1;
         smallCamera = param4;
         bigCamera = param5;
         transitionFX = param6;
         transitionCamera = param4;
         this.placement = param2;
         this.resources = param3;
         super();
         uiLayer = new ViewportLayer(basicView.viewport,null);
         uiLayer.forceDepth = true;
         uiLayer.screenDepth = int.MIN_VALUE;
         basicView.viewport.containerSprite.addLayer(uiLayer);
         init();
         setCharacter(CharacterDefinitions.BIG);
      }
      
      public function prepare() : void
      {
         if(transitionManager)
         {
            transitionManager.setCharacter(currentPOV);
         }
         voxManager.reset();
         transitionToSegment(segments[0]);
      }
      
      private function init() : void
      {
         transitionManager = new TransitionManager(transitionCamera);
         transitionManager.pageOffset = placement;
         transitionManager.addEventListener(TransitionManager.TRANSITION_BEGINS,handleTransitionBegins);
         transitionManager.addEventListener(TransitionManager.TRANSITION_ENDS,handleTransitionEnds);
         transitionManager.addEventListener(BrainEvent.ACTION,handleBrainEvent);
         initSegments();
         currentLiveSegment = AbstractSegment(segments[0]);
         transitionManager.snapToSegment(currentLiveSegment);
      }
      
      private function pushRewardSegment(param1:DAEFixed, param2:uint, param3:Boolean = false) : DeadEndSegment
      {
         var _loc4_:ViewportLayer = new ViewportLayer(basicView.viewport,null);
         basicView.viewport.containerSprite.addLayer(_loc4_);
         var _loc5_:DeadEndSegment = new DeadEndSegment(uiLayer,_loc4_,param1,resources,param2,param3);
         registerSegment(_loc5_);
         return _loc5_;
      }
      
      private function pushEndSegment(param1:DAEFixed) : EndSegment
      {
         var _loc2_:ViewportLayer = new ViewportLayer(basicView.viewport,null);
         basicView.viewport.containerSprite.addLayer(_loc2_);
         var _loc3_:EndSegment = new EndSegment(uiLayer,_loc2_,param1,resources,transitionFX,resources.endDanceClip,MysteriousWoodsVoxController.END_DANCE);
         _loc3_.registerAnimationSeq(CharacterDefinitions.BIG + "_0",resources.smallEndClips[0],MysteriousWoodsVoxController.BIG_COMPLETION_I);
         _loc3_.registerAnimationSeq(CharacterDefinitions.BIG + "_1",resources.smallEndClips[1],MysteriousWoodsVoxController.BIG_COMPLETION_II);
         _loc3_.registerAnimationSeq(CharacterDefinitions.SMALL + "_0",resources.bigEndClips[0],MysteriousWoodsVoxController.SMALL_COMPLETION_I);
         _loc3_.registerAnimationSeq(CharacterDefinitions.SMALL + "_1",resources.bigEndClips[1],MysteriousWoodsVoxController.SMALL_COMPLETION_II);
         registerSegment(_loc3_);
         return _loc3_;
      }
      
      private function handleBrainEvent(param1:BrainEvent) : void
      {
         dispatchEvent(new BrainEvent(param1.actionType,param1.actionTarget,param1.data));
      }
      
      public function transitionFromSegment(param1:PathSegment, param2:String) : void
      {
         var _loc3_:AbstractSegment = param1.getTargetSegmentOfPath(param2);
         if(param1 == _loc3_ || _loc3_ == null || _loc3_ == currentLiveSegment)
         {
            return;
         }
         currentLiveSegment = _loc3_;
         updateSegmentVisibility(_loc3_);
         transitionManager.doTransition(param1,param2);
      }
      
      private function pushForkSegment(param1:DAEFixed, param2:Boolean = false) : JunctionSegment
      {
         var _loc3_:ViewportLayer = new ViewportLayer(basicView.viewport,null);
         basicView.viewport.containerSprite.addLayer(_loc3_);
         var _loc4_:JunctionSegment = new JunctionSegment(uiLayer,_loc3_,param1,resources,param2);
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,handleArrowRolledOver);
         registerSegment(_loc4_);
         return _loc4_;
      }
      
      private function registerSegment(param1:AbstractSegment) : void
      {
         segments.push(param1);
         addSegmentListeners(param1);
      }
      
      private function connectSegments(param1:PathSegment, param2:AbstractSegment, param3:String) : void
      {
         param1.setSegmentForEndOfPath(param3,param2);
         param2.position = param1.getConnectedSegmentPositionForPath(param3);
         param2.orientation = param1.getExitOrientationOfPath(param3);
      }
      
      private function addSegmentListeners(param1:AbstractSegment) : void
      {
         param1.addEventListener(BrainEvent.ACTION,handleBrainEvent);
         param1.addEventListener(SegmentTransitionEvent.TRANSITION,handleSegmentTransitionEvent);
         param1.addEventListener(SegmentTransitionEvent.RETURN,handleSegmentReturnTransitionEvent);
      }
      
      public function get dirtyLayers() : Array
      {
         if(currentLiveSegment)
         {
            return currentLiveSegment.dirtyLayers;
         }
         return [];
      }
      
      private function handleTransitionEnds(param1:Event) : void
      {
         var _loc2_:TransitionObject = transitionManager.currentTransition;
         currentLiveSegment = _loc2_.targetSegment;
         if(!(currentLiveSegment is DeadEndSegment))
         {
            dispatchEvent(new BrainEvent(BigAndSmallEventType.SHOW_BS_BUTTONS));
            dispatchEvent(new BrainEvent(BigAndSmallEventType.SHOW_BS_NAVMENUBUTTON));
         }
         updateSegmentVisibility();
         if(currentLiveSegment is JunctionSegment)
         {
            voxManager.atJunction(junctions.indexOf(currentLiveSegment));
         }
         else if(currentLiveSegment is DeadEndSegment)
         {
            voxManager.atDeadEnd(rewards.indexOf(currentLiveSegment));
         }
         else if(currentLiveSegment is EndSegment)
         {
            voxManager.atFinalSegment();
         }
         else if(currentLiveSegment is StraightSegment)
         {
            voxManager.atStraightSegment();
            if(StraightSegment(currentLiveSegment).hasIncidentalAnim)
            {
               dispatchEvent(new Event(PROMPT_INCIDENTAL_ANIM));
            }
         }
      }
      
      public function update() : void
      {
      }
      
      private function initSegments() : void
      {
         var _loc1_:StraightSegment = pushStraightSegment(resources.pathDAE1,[0],0.45,0,0,false);
         var _loc2_:StraightSegment = pushStraightSegment(resources.pathDAE2,[0],0.35,0,0,true);
         var _loc3_:StraightSegment = pushStraightSegment(resources.pathDAE3,[0],0.45,0,0,true);
         var _loc4_:DeadEndSegment = pushRewardSegment(resources.rewardDAE1,0);
         var _loc5_:JunctionSegment = pushForkSegment(resources.junctionDAE1);
         var _loc6_:StraightSegment = pushStraightSegment(resources.pathDAE2,[0,1],0.35,0.35,3,false);
         var _loc7_:StraightSegment = pushStraightSegment(resources.pathDAE3,[0,1],0.3,0,0,true);
         var _loc8_:DeadEndSegment = pushRewardSegment(resources.rewardDAE1,1,true);
         var _loc9_:JunctionSegment = pushForkSegment(resources.junctionDAE1,true);
         var _loc10_:StraightSegment = pushStraightSegment(resources.pathDAE3,[1,2],0.35,0.35,3,false);
         var _loc11_:StraightSegment = pushStraightSegment(resources.pathDAE2,[1,2],0.3,0,0,true);
         var _loc12_:DeadEndSegment = pushRewardSegment(resources.rewardDAE1,2,true);
         var _loc13_:JunctionSegment = pushForkSegment(resources.junctionDAE1,true);
         var _loc14_:StraightSegment = pushStraightSegment(resources.pathDAE2,[2],0.35,0.35,3,false);
         var _loc15_:StraightSegment = pushStraightSegment(resources.pathDAE3,[2],0.3,0,0,true);
         var _loc16_:DeadEndSegment = pushRewardSegment(resources.rewardDAE1,3);
         var _loc17_:JunctionSegment = pushForkSegment(resources.junctionDAE1);
         end = pushEndSegment(resources.finalSegDAE);
         end.addEventListener(EndSegment.ANIMSEQ_COMPLETE,handleGameFinished);
         junctions.push(_loc5_,_loc9_,_loc13_,_loc17_);
         rewards.push(_loc4_,_loc8_,_loc12_,_loc16_);
         var _loc18_:PathControlPointsInfo = new PathControlPointsInfo(Number3D.ZERO,new Number3D(0,0,1));
         var _loc19_:PathControlPointsInfo = new PathControlPointsInfo(new Number3D(-0.1,0,0.35),new Number3D(-0.1,0,0.65));
         var _loc20_:PathControlPointsInfo = new PathControlPointsInfo(new Number3D(0.1,0,0.35),new Number3D(0.1,0,0.65));
         var _loc21_:PathControlPointsInfo = new PathControlPointsInfo(new Number3D(0.08,0,0.35),new Number3D(-0.1,0,0.65));
         _loc1_.setControlsForPath(StraightSegment.STRAIGHT,_loc18_);
         _loc2_.setControlsForPath(StraightSegment.STRAIGHT,_loc18_);
         _loc3_.setControlsForPath(StraightSegment.STRAIGHT,_loc20_);
         _loc6_.setControlsForPath(StraightSegment.STRAIGHT,_loc19_);
         _loc7_.setControlsForPath(StraightSegment.STRAIGHT,_loc20_);
         _loc10_.setControlsForPath(StraightSegment.STRAIGHT,_loc20_);
         _loc11_.setControlsForPath(StraightSegment.STRAIGHT,_loc19_);
         _loc14_.setControlsForPath(StraightSegment.STRAIGHT,_loc21_);
         _loc15_.setControlsForPath(StraightSegment.STRAIGHT,_loc20_);
         connectSegments(_loc1_,_loc2_,StraightSegment.STRAIGHT);
         connectSegments(_loc2_,_loc3_,StraightSegment.STRAIGHT);
         connectSegments(_loc3_,_loc5_,StraightSegment.STRAIGHT);
         connectSegments(_loc5_,_loc4_,JunctionSegment.LEFT);
         connectSegments(_loc5_,_loc6_,JunctionSegment.RIGHT);
         connectSegments(_loc6_,_loc7_,StraightSegment.STRAIGHT);
         connectSegments(_loc7_,_loc9_,StraightSegment.STRAIGHT);
         connectSegments(_loc9_,_loc8_,JunctionSegment.RIGHT);
         connectSegments(_loc9_,_loc10_,JunctionSegment.LEFT);
         connectSegments(_loc10_,_loc11_,StraightSegment.STRAIGHT);
         connectSegments(_loc11_,_loc13_,StraightSegment.STRAIGHT);
         connectSegments(_loc13_,_loc12_,JunctionSegment.RIGHT);
         connectSegments(_loc13_,_loc14_,JunctionSegment.LEFT);
         connectSegments(_loc14_,_loc15_,StraightSegment.STRAIGHT);
         connectSegments(_loc15_,_loc17_,StraightSegment.STRAIGHT);
         connectSegments(_loc17_,_loc16_,JunctionSegment.LEFT);
         connectSegments(_loc17_,end,JunctionSegment.RIGHT);
      }
      
      private function handleGameFinished(param1:Event) : void
      {
         dispatchEvent(new BrainEvent(BrainEventType.CHANGE_PAGE,PageDefinitions.GARDEN_HUB));
      }
      
      public function set camera(param1:CameraObject3D) : void
      {
         transitionCamera = param1;
         transitionManager.camera = param1;
      }
      
      public function updateCamera() : Boolean
      {
         return transitionManager.update();
      }
      
      private function pushStraightSegment(param1:DAEFixed, param2:Array, param3:Number = 0.5, param4:Number = 0, param5:Number = 0, param6:Boolean = false) : StraightSegment
      {
         var _loc7_:ViewportLayer = new ViewportLayer(basicView.viewport,null);
         basicView.viewport.containerSprite.addLayer(_loc7_);
         var _loc8_:StraightSegment = new StraightSegment(uiLayer,_loc7_,param1,resources,param2,param3,param4,param5,param6);
         _loc8_.addEventListener(MouseEvent.ROLL_OVER,handleArrowRolledOver);
         registerSegment(_loc8_);
         return _loc8_;
      }
      
      private function handleSegmentTransitionEvent(param1:SegmentTransitionEvent) : void
      {
         var _loc2_:PathSegment = param1.target as PathSegment;
         transitionFromSegment(_loc2_,param1.path);
         voxManager.arrowClicked();
      }
      
      private function handleSegmentReturnTransitionEvent(param1:SegmentTransitionEvent) : void
      {
         var _loc2_:AbstractSegment = param1.target as AbstractSegment;
         transitionToSegment(_loc2_,_loc2_.previousSegmentPath);
         voxManager.arrowClicked();
         dispatchEvent(param1);
      }
      
      public function transitionToSegment(param1:AbstractSegment, param2:String = null) : void
      {
         if(!param1)
         {
            return;
         }
         if(!currentLiveSegment)
         {
            currentLiveSegment = param1;
            updateSegmentVisibility();
            currentLiveSegment.prepare();
            transitionManager.updateCameraTarget(currentLiveSegment.orientation);
            transitionCamera.position = Number3D.add(placement,currentLiveSegment.position);
            transitionCamera.y = transitionManager.yOffset;
            return;
         }
         transitionManager.doReverseTransition(currentLiveSegment,param2);
         updateSegmentVisibility(param1);
      }
      
      public function setCharacter(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:AbstractSegment = null;
         currentPOV = param1;
         for each(_loc3_ in segments)
         {
            _loc3_.setCharacter(currentPOV);
         }
         if(transitionManager)
         {
            transitionManager.setCharacter(currentPOV);
         }
         if(voxManager)
         {
            voxManager.setCharacter(currentPOV);
         }
         if(param2)
         {
            if(currentLiveSegment)
            {
               currentLiveSegment.deactivate();
               currentLiveSegment.park();
            }
            currentLiveSegment = null;
            transitionToSegment(segments[0]);
            currentLiveSegment.activate();
            transitionManager.updateCameraTarget(0);
         }
      }
      
      public function park() : void
      {
         if(currentLiveSegment)
         {
            currentLiveSegment.park();
         }
         currentLiveSegment = null;
      }
      
      private function updateSegmentVisibility(param1:AbstractSegment = null) : void
      {
         var _loc6_:AbstractSegment = null;
         if(!param1)
         {
            param1 = currentLiveSegment;
         }
         var _loc2_:int = int(segments.indexOf(currentLiveSegment));
         var _loc3_:int = 4;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         while(_loc4_ < segments.length)
         {
            _loc6_ = segments[_loc4_] as AbstractSegment;
            _loc6_.compLayer.screenDepth = _loc4_;
            _loc6_.compLayer.forceDepth = true;
            if(_loc4_ >= _loc2_ - 2 && _loc4_ <= _loc2_ + _loc3_)
            {
               if(!_loc6_.parent)
               {
                  addChild(_loc6_);
               }
            }
            else
            {
               removeChild(_loc6_);
            }
            _loc4_++;
         }
      }
      
      private function handleArrowRolledOver(param1:MouseEvent) : void
      {
         voxManager.arrowRolledOver();
         dispatchEvent(new Event(PROMPT_ARROW_OVER));
      }
      
      public function deactivate() : void
      {
         if(currentLiveSegment)
         {
            currentLiveSegment.deactivate();
         }
         if(voxManager)
         {
            voxManager.deactivate();
         }
      }
      
      public function activate() : void
      {
         if(currentLiveSegment)
         {
            currentLiveSegment.activate();
         }
         ICameraUpdateable(transitionCamera).updatePosition(0,0,0);
         transitionManager.updateCameraTarget(0);
         if(voxManager)
         {
            voxManager.activate();
         }
      }
      
      private function handleTransitionBegins(param1:Event) : void
      {
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_BUTTONS));
         dispatchEvent(new BrainEvent(BigAndSmallEventType.HIDE_BS_NAVMENUBUTTON));
      }
   }
}

