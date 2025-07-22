package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import net.pluginmedia.bigandsmall.definitions.AccessibilityDefinitions;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.BigBluePillowDragArea;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.BigGreenPillowDragArea;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.DraggablePillow;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.SmallPillowDropTarget;
   import net.pluginmedia.bigandsmall.pages.bedroom.pillows.SmallTargetDropArea;
   import net.pluginmedia.bigandsmall.pages.bedroom.teddy.DraggableFreakyAssTeddyDragArea;
   import net.pluginmedia.bigandsmall.physics.VerletStick;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import net.pluginmedia.brain.core.events.DragDropEvent;
   import net.pluginmedia.brain.managers.AccessibilityManager;
   import net.pluginmedia.brain.managers.ClickStickManager;
   import net.pluginmedia.brain.managers.DragDropManager;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   
   public class BigDraggablePillows extends Sprite
   {
      
      public static const BLUEPILLOW_ONSMALL:String = "bluePillowOnSmall";
      
      public static const GREENPILLOW_ONSMALL:String = "greenPillowOnSmall";
      
      public static const TEDDY_ONSMALL:String = "freakyAssTeddyOnSmall";
      
      public static const BLUEPILLOW_MOVING:String = "bluePillowMoving";
      
      public static const GREENPILLOW_MOVING:String = "greenPillowMoving";
      
      public static const TEDDY_MOVING:String = "teddyMoving";
      
      public var active:Boolean;
      
      public var smallDropProximity:Number = 20;
      
      protected var bluePillowDefaultPos:Number3D;
      
      protected var pendulousLength:Number = 100;
      
      public var greenButton:VPortLayerButton;
      
      protected var pendulousDrag:VerletStick;
      
      private var clickStickManager:DragDropManager;
      
      public var blueButton:VPortLayerButton;
      
      public var freakyTeddy:DraggableBedroomObject;
      
      protected var freakyTeddyDefaultPos:Number3D;
      
      protected var greenPillowDefaultPos:Number3D;
      
      public var teddyButton:VPortLayerButton;
      
      public var greenPillow:DraggableBedroomObject;
      
      protected var basicViewStage:Stage;
      
      protected var bluePillowTarget:DraggablePillow;
      
      protected var targetDO3D:DisplayObject3D;
      
      public var bluePillow:DraggableBedroomObject;
      
      protected var room:DisplayObject3D;
      
      protected var freakyTeddyTarget:DraggablePillow;
      
      protected var basicView:BasicView;
      
      protected var greenPillowTarget:DraggablePillow;
      
      protected var smallTarget:SmallPillowDropTarget;
      
      public function BigDraggablePillows(param1:BasicView, param2:DisplayObject3D, param3:DisplayObject3D)
      {
         super();
         basicView = param1;
         this.room = param2;
         this.targetDO3D = param3;
         initBasicViewStage(param1);
         initTargetAreas();
         initVerlet();
      }
      
      private function getBluePillowZPlaneTransform(param1:Number) : Number
      {
         var _loc2_:Number = (1 - param1) * 600 - 160;
         return _loc2_ - -124;
      }
      
      private function tendDraggableTo(param1:DraggableBedroomObject, param2:Number, param3:Number, param4:Number, param5:Number = 4, param6:Boolean = false) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!param6)
         {
            _loc7_ = param2 - param1.x;
            _loc8_ = param3 - param1.y;
            _loc9_ = param4 - param1.z;
            param1.x += _loc7_ / param5;
            param1.y += _loc8_ / param5;
            param1.z += _loc9_ / param5;
            _loc10_ = 0.001;
            if(Math.abs(_loc7_) > _loc10_ || Math.abs(_loc8_) > _loc10_ || Math.abs(_loc9_) > _loc10_)
            {
               if(param1 == bluePillow)
               {
                  dispatchEvent(new Event(BLUEPILLOW_MOVING));
               }
               else if(param1 == greenPillow)
               {
                  dispatchEvent(new Event(GREENPILLOW_MOVING));
               }
               else if(param1 == freakyTeddy)
               {
                  dispatchEvent(new Event(TEDDY_MOVING));
               }
            }
         }
         else
         {
            param1.x = param2;
            param1.y = param3;
            param1.z = param4;
         }
      }
      
      public function setGreenPillow(param1:DraggableBedroomObject, param2:VPortLayerButton) : void
      {
         greenButton = param2;
         greenPillow = param1;
         greenPillowDefaultPos = param1.position.clone();
         greenPillowTarget.setPillowObject(param1);
      }
      
      private function handlePillowPickedUp(param1:DragDropEvent) : void
      {
         if(param1.draggable == greenPillowTarget)
         {
            greenPillow.pickUp();
            SoundManagerOld.playSound("bed_cushion");
            greenButton.forceHighlight(false);
         }
         else if(param1.draggable == bluePillowTarget)
         {
            bluePillow.pickUp();
            SoundManagerOld.playSound("bed_cushion");
            blueButton.forceHighlight(false);
         }
         else if(param1.draggable == freakyTeddyTarget)
         {
            freakyTeddy.pickUp();
            SoundManagerOld.playSound("bed_toy_bigpickup");
            teddyButton.forceHighlight(false);
         }
      }
      
      private function initBasicViewStage(param1:BasicView) : void
      {
         basicViewStage = param1.stage;
         clickStickManager = new ClickStickManager(basicViewStage);
         addClicknStickListeners();
      }
      
      private function clampDraggable(param1:DraggableBedroomObject) : void
      {
         var _loc2_:Number = 300;
         var _loc3_:Number = -70;
         var _loc4_:Number = 300;
         var _loc5_:Number = 0;
         var _loc6_:Number = -50;
         var _loc7_:Number = -309;
         param1.x = Math.max(_loc3_,param1.x);
         param1.x = Math.min(_loc2_,param1.x);
         param1.y = Math.max(_loc5_,param1.y);
         param1.y = Math.min(_loc4_,param1.y);
         param1.z = Math.max(_loc7_,param1.z);
         param1.z = Math.min(_loc6_,param1.z);
      }
      
      private function getGreenPillowZPlaneTransform(param1:Number) : Number
      {
         var _loc2_:Number = (1 - param1) * 600 - 160;
         return _loc2_ - -124;
      }
      
      public function setTeddy(param1:DraggableBedroomObject, param2:VPortLayerButton) : void
      {
         teddyButton = param2;
         freakyTeddy = param1;
         freakyTeddyDefaultPos = freakyTeddy.position.clone();
         freakyTeddyTarget.setPillowObject(param1);
      }
      
      private function handleTargetRollout(param1:Event) : void
      {
         var _loc2_:DraggablePillow = DraggablePillow(param1.target);
         if(_loc2_ == bluePillowTarget)
         {
            blueButton.forceHighlight(false);
         }
         else if(_loc2_ == greenPillowTarget)
         {
            greenButton.forceHighlight(false);
         }
         else if(_loc2_ == freakyTeddyTarget)
         {
            teddyButton.forceHighlight(false);
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         greenPillowTarget.visible = param1;
         bluePillowTarget.visible = param1;
         freakyTeddyTarget.visible = param1;
      }
      
      private function updateVerlet(param1:DisplayObject, param2:DraggableBedroomObject) : void
      {
         pendulousDrag.nodeA.loc.x = param2.screen.x - basicView.viewport.containerSprite.x;
         pendulousDrag.nodeA.loc.y = param2.screen.y - basicView.viewport.containerSprite.y;
         pendulousDrag.accumulateForce(0,10);
         pendulousDrag.update();
         var _loc3_:DisplayObject = param2.spriteMaterial._movie;
         var _loc4_:Point = pendulousDrag.nodeA.loc;
         var _loc5_:Point = pendulousDrag.nodeB.loc;
         var _loc6_:Number = Math.atan2(_loc5_.y - _loc4_.y,_loc5_.x - _loc4_.x);
         var _loc7_:Number = _loc6_ * 180 / Math.PI;
         var _loc8_:Number = Point.distance(_loc4_,_loc5_);
         var _loc9_:Number = _loc8_ / pendulousLength;
         _loc3_.rotation = _loc7_ - 90;
      }
      
      private function tendTo(param1:Sprite, param2:Number, param3:Number, param4:Number = 5) : void
      {
         var _loc5_:Number = param2 - param1.x;
         var _loc6_:Number = param3 - param1.y;
         param1.x += _loc5_ / param4;
         param1.y += _loc6_ / param4;
      }
      
      private function initTargetAreas() : void
      {
         smallTarget = new SmallPillowDropTarget(SmallTargetDropArea,200,200);
         smallTarget.alpha = 0;
         greenPillowTarget = new DraggablePillow(BigGreenPillowDragArea,200,200);
         AccessibilityManager.addAccessibilityProperties(greenPillowTarget,"Green pillow","Click to place under Small",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         bluePillowTarget = new DraggablePillow(BigBluePillowDragArea,300,300);
         AccessibilityManager.addAccessibilityProperties(bluePillowTarget,"Blue pillow","Click to place under Small",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         freakyTeddyTarget = new DraggablePillow(DraggableFreakyAssTeddyDragArea);
         AccessibilityManager.addAccessibilityProperties(freakyTeddyTarget,"Sleep Toy Thingy","Click to give to Small",AccessibilityDefinitions.BEDROOM_INTERACTIVE);
         greenPillowTarget.addEventListener(MouseEvent.ROLL_OVER,handleTargetRollover);
         greenPillowTarget.addEventListener(FocusEvent.FOCUS_IN,handleTargetRollover);
         bluePillowTarget.addEventListener(MouseEvent.ROLL_OVER,handleTargetRollover);
         bluePillowTarget.addEventListener(FocusEvent.FOCUS_IN,handleTargetRollover);
         freakyTeddyTarget.addEventListener(MouseEvent.ROLL_OVER,handleTargetRollover);
         freakyTeddyTarget.addEventListener(FocusEvent.FOCUS_IN,handleTargetRollover);
         greenPillowTarget.addEventListener(MouseEvent.ROLL_OUT,handleTargetRollout);
         greenPillowTarget.addEventListener(FocusEvent.FOCUS_OUT,handleTargetRollout);
         bluePillowTarget.addEventListener(MouseEvent.ROLL_OUT,handleTargetRollout);
         bluePillowTarget.addEventListener(FocusEvent.FOCUS_OUT,handleTargetRollout);
         freakyTeddyTarget.addEventListener(MouseEvent.ROLL_OUT,handleTargetRollout);
         freakyTeddyTarget.addEventListener(FocusEvent.FOCUS_OUT,handleTargetRollout);
         addChild(smallTarget);
         addChild(greenPillowTarget);
         addChild(bluePillowTarget);
         addChild(freakyTeddyTarget);
         clickStickManager.registerDraggable(greenPillowTarget);
         clickStickManager.registerDraggable(bluePillowTarget);
         clickStickManager.registerDraggable(freakyTeddyTarget);
         clickStickManager.registerDropTarget(smallTarget);
         updateTargets();
         greenPillowTarget.storeDefaultLoc();
         bluePillowTarget.storeDefaultLoc();
         freakyTeddyTarget.storeDefaultLoc();
      }
      
      private function initVerlet() : void
      {
         pendulousDrag = new VerletStick(0,0,pendulousLength);
         pendulousDrag.nodeA.isPinned = true;
         addChild(pendulousDrag);
      }
      
      public function update() : void
      {
         updateTargets();
      }
      
      public function reset(param1:Boolean = true) : void
      {
         greenPillow.drop();
         greenPillow.setVisible(true);
         bluePillow.drop();
         bluePillow.setVisible(true);
         freakyTeddy.drop();
         freakyTeddy.setVisible(true);
         if(param1)
         {
            greenPillow.x = greenPillowDefaultPos.x;
            greenPillow.y = greenPillowDefaultPos.y;
            greenPillow.z = greenPillowDefaultPos.z;
            bluePillow.x = bluePillowDefaultPos.x;
            bluePillow.y = bluePillowDefaultPos.y;
            bluePillow.z = bluePillowDefaultPos.z;
            freakyTeddy.x = freakyTeddyDefaultPos.x;
            freakyTeddy.y = freakyTeddyDefaultPos.y;
            freakyTeddy.z = freakyTeddyDefaultPos.z;
         }
         greenPillowTarget.reset();
         bluePillowTarget.reset();
         freakyTeddyTarget.reset();
      }
      
      private function handlePillowDroppedOver(param1:DragDropEvent) : void
      {
         var _loc2_:DraggablePillow = DraggablePillow(param1.draggable);
         _loc2_.snapToDefaultLoc(false);
         if(param1.draggable == greenPillowTarget)
         {
            greenPillow.setVisible(false);
            dispatchEvent(new Event(GREENPILLOW_ONSMALL));
            SoundManagerOld.playSound("bed_cushion");
         }
         else if(param1.draggable == bluePillowTarget)
         {
            bluePillow.setVisible(false);
            dispatchEvent(new Event(BLUEPILLOW_ONSMALL));
            SoundManagerOld.playSound("bed_cushion");
         }
         else if(param1.draggable == freakyTeddyTarget)
         {
            freakyTeddy.setVisible(false);
            dispatchEvent(new Event(TEDDY_ONSMALL));
            SoundManagerOld.playSound("bed_toy_biggives");
         }
         resetPillowDimensions();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         updateTargets();
      }
      
      private function addClicknStickListeners() : void
      {
         clickStickManager.addEventListener(DragDropEvent.PICK_UP,handlePillowPickedUp);
         clickStickManager.addEventListener(DragDropEvent.DROP,handlePillowDropped);
         clickStickManager.addEventListener(DragDropEvent.DROP_OVER,handlePillowDroppedOver);
      }
      
      private function handlePillowDropped(param1:DragDropEvent) : void
      {
         if(param1.draggable == greenPillowTarget)
         {
            greenPillow.drop();
         }
         else if(param1.draggable == bluePillowTarget)
         {
            bluePillow.drop();
         }
         else if(param1.draggable == freakyTeddyTarget)
         {
            freakyTeddy.drop();
         }
         resetPillowDimensions();
      }
      
      private function handleTargetRollover(param1:Event) : void
      {
         var _loc2_:DraggablePillow = DraggablePillow(param1.target);
         if(_loc2_ == bluePillowTarget)
         {
            if(!bluePillowTarget.isDragging)
            {
               blueButton.forceHighlight(true);
            }
         }
         else if(_loc2_ == greenPillowTarget)
         {
            if(!greenPillowTarget.isDragging)
            {
               greenButton.forceHighlight(true);
            }
         }
         else if(_loc2_ == freakyTeddyTarget)
         {
            if(!freakyTeddyTarget.isDragging)
            {
               teddyButton.forceHighlight(true);
            }
         }
      }
      
      public function setBluePillow(param1:DraggableBedroomObject, param2:VPortLayerButton) : void
      {
         blueButton = param2;
         bluePillow = param1;
         bluePillowDefaultPos = param1.position.clone();
         bluePillowTarget.setPillowObject(param1);
      }
      
      public function isInteractive() : Boolean
      {
         return greenPillowTarget.visible;
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.SPACE)
         {
            if(greenPillowTarget.hasFocus)
            {
               greenPillowTarget.onPut();
               greenPillow.setVisible(false);
               dispatchEvent(new Event(GREENPILLOW_ONSMALL));
               SoundManagerOld.playSound("bed_cushion");
            }
            if(bluePillowTarget.hasFocus)
            {
               bluePillowTarget.onPut();
               bluePillow.setVisible(false);
               dispatchEvent(new Event(BLUEPILLOW_ONSMALL));
               SoundManagerOld.playSound("bed_cushion");
            }
            if(freakyTeddyTarget.hasFocus)
            {
               freakyTeddyTarget.onPut();
               freakyTeddy.setVisible(false);
               dispatchEvent(new Event(TEDDY_ONSMALL));
               SoundManagerOld.playSound("bed_toy_biggives");
            }
         }
      }
      
      private function updateTargets() : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc1_:Number = basicViewStage.stageWidth;
         var _loc2_:Number = basicViewStage.stageHeight;
         var _loc3_:Number = basicViewStage.mouseX / _loc1_;
         var _loc4_:Number = basicViewStage.mouseY / _loc2_;
         smallTarget.x = targetDO3D.screen.x + basicView.viewport.containerSprite.x;
         smallTarget.y = targetDO3D.screen.y + basicView.viewport.containerSprite.y;
         var _loc5_:Number3D = new Number3D(basicView.camera.x - room.x,basicView.camera.y - room.y,basicView.camera.z - room.z);
         var _loc6_:Number3D = basicView.camera.unproject(basicView.viewport.containerSprite.mouseX,basicView.viewport.containerSprite.mouseY);
         _loc6_ = Number3D.add(_loc6_,_loc5_);
         var _loc7_:Plane3D = new Plane3D(new Number3D(0,1,0),new Number3D());
         var _loc8_:Number3D = new Number3D();
         if(bluePillowTarget.isDragging)
         {
            _loc8_.z = getBluePillowZPlaneTransform(_loc4_);
         }
         else if(greenPillowTarget.isDragging)
         {
            _loc8_.z = getGreenPillowZPlaneTransform(_loc4_);
         }
         else if(freakyTeddyTarget.isDragging)
         {
            _loc8_.z = getGreenPillowZPlaneTransform(_loc4_);
         }
         _loc7_.setNormalAndPoint(new Number3D(0,0,1),_loc8_);
         var _loc9_:Number3D = _loc7_.getIntersectionLineNumbers(_loc5_,_loc6_);
         if(!greenPillowTarget.isDragging && Boolean(greenPillow))
         {
            _loc10_ = greenPillow.screen.x + (basicViewStage.stageWidth >> 1);
            _loc11_ = greenPillow.screen.y + (basicViewStage.stageHeight >> 1);
            greenPillowTarget.x = _loc10_;
            greenPillowTarget.y = _loc11_;
            if(greenPillow.visible)
            {
               tendDraggableTo(greenPillow,greenPillowDefaultPos.x,greenPillowDefaultPos.y,greenPillowDefaultPos.z);
            }
         }
         else if(greenPillow)
         {
            tendDraggableTo(greenPillow,_loc9_.x,_loc9_.y,_loc9_.z,1.5,true);
            updateVerlet(greenPillowTarget,greenPillow);
            clampDraggable(greenPillow);
            dispatchEvent(new Event(GREENPILLOW_MOVING));
         }
         if(!bluePillowTarget.isDragging && Boolean(bluePillow))
         {
            _loc12_ = bluePillow.screen.x + (basicViewStage.stageWidth >> 1);
            _loc13_ = bluePillow.screen.y + (basicViewStage.stageHeight >> 1);
            bluePillowTarget.x = _loc12_;
            bluePillowTarget.y = _loc13_;
            if(bluePillow.visible)
            {
               tendDraggableTo(bluePillow,bluePillowDefaultPos.x,bluePillowDefaultPos.y,bluePillowDefaultPos.z);
            }
         }
         else if(bluePillow)
         {
            tendDraggableTo(bluePillow,_loc9_.x,_loc9_.y,_loc9_.z,1.5,true);
            updateVerlet(bluePillowTarget,bluePillow);
            clampDraggable(bluePillow);
            dispatchEvent(new Event(BLUEPILLOW_MOVING));
         }
         if(!freakyTeddyTarget.isDragging && Boolean(freakyTeddy))
         {
            _loc14_ = freakyTeddy.screen.x + (basicViewStage.stageWidth >> 1);
            _loc15_ = freakyTeddy.screen.y + (basicViewStage.stageHeight >> 1);
            freakyTeddyTarget.x = _loc14_;
            freakyTeddyTarget.y = _loc15_;
            if(freakyTeddy.visible)
            {
               tendDraggableTo(freakyTeddy,freakyTeddyDefaultPos.x,freakyTeddyDefaultPos.y,freakyTeddyDefaultPos.z);
            }
         }
         else if(freakyTeddy)
         {
            tendDraggableTo(freakyTeddy,_loc9_.x,_loc9_.y,_loc9_.z,1.5,true);
            updateVerlet(freakyTeddyTarget,freakyTeddy);
            clampDraggable(freakyTeddy);
            dispatchEvent(new Event(TEDDY_MOVING));
         }
      }
      
      public function activate() : void
      {
         active = true;
         greenPillow.setVisible(true);
         bluePillow.setVisible(true);
         freakyTeddy.setVisible(true);
         basicView.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
      }
      
      public function deactivate() : void
      {
         active = false;
         reset();
         greenPillow.setVisible(false);
         bluePillow.setVisible(false);
         freakyTeddy.setVisible(false);
         basicView.removeEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
      }
      
      public function tabEnableViewports(param1:Boolean) : void
      {
         greenPillowTarget.tabEnabled = param1;
         bluePillowTarget.tabEnabled = param1;
         freakyTeddyTarget.tabEnabled = param1;
      }
      
      private function resetPillowDimensions() : void
      {
         greenPillow.spriteMaterial.movie.rotation = 0;
         greenPillow.spriteMaterial.movie.scaleX = greenPillow.spriteMaterial.movie.scaleY = 1;
         bluePillow.spriteMaterial.movie.rotation = 0;
         bluePillow.spriteMaterial.movie.scaleX = bluePillow.spriteMaterial.movie.scaleY = 1;
         freakyTeddy.spriteMaterial.movie.rotation = 0;
         freakyTeddy.spriteMaterial.movie.scaleX = freakyTeddy.spriteMaterial.movie.scaleY = 1;
      }
      
      private function getTeddyZPlaneTransform(param1:Number) : Number
      {
         var _loc2_:Number = (1 - param1) * 600 - 160;
         return _loc2_ - -100;
      }
   }
}

