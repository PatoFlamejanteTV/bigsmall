package net.pluginmedia.bigandsmall.pages.garden
{
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.pv3d.cameras.RailCamera;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.view.BasicView;
   
   public class RailCamPositionManager extends EventDispatcher
   {
      
      public var targetMoveRate:Number = 0.005;
      
      public var smallCam:RailCamera;
      
      protected var controlRectL:Rectangle;
      
      protected var controlRectR:Rectangle;
      
      protected var currentCam:RailCamera;
      
      protected var _isPanningLeft:Boolean = false;
      
      protected var basicView:BasicView;
      
      protected var _isPanningRight:Boolean = false;
      
      public var bigCam:RailCamera;
      
      public function RailCamPositionManager(param1:BasicView, param2:RailCamera, param3:Rectangle, param4:RailCamera, param5:Rectangle)
      {
         super();
         basicView = param1;
         controlRectL = param3;
         controlRectR = param5;
         smallCam = param2;
         bigCam = param4;
      }
      
      public function update() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = basicView.viewport.mouseX;
         var _loc2_:Number = basicView.viewport.mouseY;
         if(camPosition > 0 && pointWithinRect(controlRectL,_loc1_,_loc2_))
         {
            _isPanningLeft = true;
            _loc3_ = 1 - (_loc1_ + controlRectL.x) / (controlRectL.x + controlRectL.width);
            _loc3_ = Math.pow(_loc3_,1.2);
            currentCam.targetPosition -= _loc3_ * targetMoveRate;
         }
         else
         {
            _isPanningLeft = false;
         }
         if(camPosition < 1 && pointWithinRect(controlRectR,_loc1_,_loc2_))
         {
            _isPanningRight = true;
            _loc3_ = (_loc1_ - controlRectR.x) / controlRectR.width;
            _loc3_ = Math.pow(_loc3_,1.2);
            currentCam.targetPosition += _loc3_ * targetMoveRate;
         }
         else
         {
            _isPanningRight = false;
         }
         if(camPosition > 0 && KeyUtils.isDown(Keyboard.LEFT))
         {
            currentCam.targetPosition -= targetMoveRate;
            _isPanningLeft = true;
         }
         else if(camPosition < 1 && KeyUtils.isDown(Keyboard.RIGHT))
         {
            currentCam.targetPosition += targetMoveRate;
            _isPanningRight = true;
         }
         var _loc4_:Number = basicView.viewport.mouseY / basicView.viewport.viewportHeight;
         return currentCam.updatePosition(currentCam.targetPosition,_loc4_);
      }
      
      public function get didMoveLastUpdate() : Boolean
      {
         return _isPanningLeft || _isPanningRight;
      }
      
      public function setCameraToPosition(param1:Number) : void
      {
         smallCam.railPosition = param1;
         bigCam.railPosition = param1;
         smallCam.targetPosition = param1;
         bigCam.targetPosition = param1;
         basicView.singleRender();
      }
      
      public function get isPanningRight() : Boolean
      {
         return _isPanningRight;
      }
      
      public function get camPosition() : Number
      {
         if(currentCam)
         {
            return currentCam.targetPosition;
         }
         return -1;
      }
      
      private function pointWithinRect(param1:Rectangle, param2:Number, param3:Number) : Boolean
      {
         if(param2 > param1.x && param2 < param1.x + param1.width)
         {
            if(param3 > param1.y && param3 < param1.y + param1.height)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setCharacter(param1:String) : void
      {
         if(param1 == CharacterDefinitions.BIG)
         {
            if(currentCam == smallCam)
            {
               bigCam.railPosition = smallCam.railPosition;
            }
            currentCam = bigCam;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            if(currentCam == bigCam)
            {
               smallCam.railPosition = bigCam.railPosition;
            }
            currentCam = smallCam;
         }
      }
      
      public function get isPanningLeft() : Boolean
      {
         return _isPanningLeft;
      }
   }
}

