package org.papervision3d.cameras
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import org.papervision3d.view.Viewport3D;
   
   public class DebugCamera3D extends Camera3D
   {
      
      protected var keyLeft:Boolean = false;
      
      protected var targetRotationX:Number = 0;
      
      protected var targetRotationY:Number = 0;
      
      protected var sideFactor:Number = 0;
      
      protected var _propertiesDisplay:Sprite;
      
      protected var viewport3D:Viewport3D;
      
      protected var fovText:TextField;
      
      protected var xText:TextField;
      
      protected var yText:TextField;
      
      protected var zText:TextField;
      
      protected var startPoint:Point;
      
      protected var startRotationX:Number;
      
      protected var startRotationY:Number;
      
      protected var keyBackward:Boolean = false;
      
      protected var farText:TextField;
      
      protected var keyForward:Boolean = false;
      
      protected var rotationXText:TextField;
      
      protected var rotationZText:TextField;
      
      protected var rotationYText:TextField;
      
      protected var forwardFactor:Number = 0;
      
      protected var nearText:TextField;
      
      protected var viewportStage:Stage;
      
      protected var _inertia:Number = 3;
      
      protected var keyRight:Boolean = false;
      
      public function DebugCamera3D(param1:Viewport3D, param2:Number = 90, param3:Number = 10, param4:Number = 5000)
      {
         super(param2,param3,param4,true);
         this.viewport3D = param1;
         this.viewport = param1.sizeRectangle;
         this.focus = this.viewport.height / 2 / Math.tan(param2 / 2 * (Math.PI / 180));
         this.zoom = this.focus / param3;
         this.focus = param3;
         this.far = param4;
         displayProperties();
         checkStageReady();
      }
      
      protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case "W".charCodeAt():
            case Keyboard.UP:
               keyForward = true;
               keyBackward = false;
               break;
            case "S".charCodeAt():
            case Keyboard.DOWN:
               keyBackward = true;
               keyForward = false;
               break;
            case "A".charCodeAt():
            case Keyboard.LEFT:
               keyLeft = true;
               keyRight = false;
               break;
            case "D".charCodeAt():
            case Keyboard.RIGHT:
               keyRight = true;
               keyLeft = false;
               break;
            case "Q".charCodeAt():
               --rotationZ;
               break;
            case "E".charCodeAt():
               ++rotationZ;
               break;
            case "F".charCodeAt():
               --fov;
               break;
            case "R".charCodeAt():
               ++fov;
               break;
            case "G".charCodeAt():
               near -= 10;
               break;
            case "T".charCodeAt():
               near += 10;
               break;
            case "H".charCodeAt():
               far -= 10;
               break;
            case "Y".charCodeAt():
               far += 10;
         }
      }
      
      public function set inertia(param1:Number) : void
      {
         _inertia = param1;
      }
      
      protected function setupEvents() : void
      {
         viewportStage = viewport3D.containerSprite.stage;
         viewportStage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         viewportStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         viewportStage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         viewportStage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         viewportStage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
      }
      
      protected function displayProperties() : void
      {
         _propertiesDisplay = new Sprite();
         _propertiesDisplay.graphics.beginFill(0);
         _propertiesDisplay.graphics.drawRect(0,0,100,100);
         _propertiesDisplay.graphics.endFill();
         _propertiesDisplay.x = 0;
         _propertiesDisplay.y = 0;
         var _loc1_:TextFormat = new TextFormat("_sans",9);
         xText = new TextField();
         yText = new TextField();
         zText = new TextField();
         rotationXText = new TextField();
         rotationYText = new TextField();
         rotationZText = new TextField();
         fovText = new TextField();
         nearText = new TextField();
         farText = new TextField();
         var _loc2_:Array = [xText,yText,zText,rotationXText,rotationYText,rotationZText,fovText,nearText,farText];
         var _loc3_:int = 10;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc2_[_loc4_].width = 100;
            _loc2_[_loc4_].selectable = false;
            _loc2_[_loc4_].textColor = 16776960;
            _loc2_[_loc4_].text = "";
            _loc2_[_loc4_].defaultTextFormat = _loc1_;
            _loc2_[_loc4_].y = _loc3_ * _loc4_;
            _propertiesDisplay.addChild(_loc2_[_loc4_]);
            _loc4_++;
         }
         viewport3D.addChild(_propertiesDisplay);
      }
      
      protected function onEnterFrameHandler(param1:Event) : void
      {
         if(keyForward)
         {
            forwardFactor += 50;
         }
         if(keyBackward)
         {
            forwardFactor += -50;
         }
         if(keyLeft)
         {
            sideFactor += -50;
         }
         if(keyRight)
         {
            sideFactor += 50;
         }
         var _loc2_:Number = this.rotationX + (targetRotationX - this.rotationX) / _inertia;
         var _loc3_:Number = this.rotationY + (targetRotationY - this.rotationY) / _inertia;
         this.rotationX = Math.round(_loc2_ * 10) / 10;
         this.rotationY = Math.round(_loc3_ * 10) / 10;
         forwardFactor += (0 - forwardFactor) / _inertia;
         sideFactor += (0 - sideFactor) / _inertia;
         if(forwardFactor > 0)
         {
            this.moveForward(forwardFactor);
         }
         else
         {
            this.moveBackward(-forwardFactor);
         }
         if(sideFactor > 0)
         {
            this.moveRight(sideFactor);
         }
         else
         {
            this.moveLeft(-sideFactor);
         }
         xText.text = "x:" + int(x);
         yText.text = "y:" + int(y);
         zText.text = "z:" + int(z);
         rotationXText.text = "rotationX:" + int(_loc2_);
         rotationYText.text = "rotationY:" + int(_loc3_);
         rotationZText.text = "rotationZ:" + int(rotationZ);
         fovText.text = "fov:" + Math.round(fov);
         nearText.text = "near:" + Math.round(near);
         farText.text = "far:" + Math.round(far);
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         viewportStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
      }
      
      protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case "W".charCodeAt():
            case Keyboard.UP:
               keyForward = false;
               break;
            case "S".charCodeAt():
            case Keyboard.DOWN:
               keyBackward = false;
               break;
            case "A".charCodeAt():
            case Keyboard.LEFT:
               keyLeft = false;
               break;
            case "D".charCodeAt():
            case Keyboard.RIGHT:
               keyRight = false;
         }
      }
      
      public function get propsDisplay() : Sprite
      {
         return _propertiesDisplay;
      }
      
      public function get inertia() : Number
      {
         return _inertia;
      }
      
      protected function onAddedToStageHandler(param1:Event) : void
      {
         setupEvents();
      }
      
      protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         targetRotationY = startRotationY - (startPoint.x - viewportStage.mouseX) / 10;
         targetRotationX = startRotationX + (startPoint.y - viewportStage.mouseY) / 10;
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         viewportStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         startPoint = new Point(viewportStage.mouseX,viewportStage.mouseY);
         startRotationY = this.rotationY;
         startRotationX = this.rotationX;
      }
      
      public function set propsDisplay(param1:Sprite) : void
      {
         _propertiesDisplay = param1;
      }
      
      private function checkStageReady() : void
      {
         if(viewport3D.containerSprite.stage == null)
         {
            viewport3D.containerSprite.addEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);
         }
         else
         {
            setupEvents();
         }
      }
   }
}

