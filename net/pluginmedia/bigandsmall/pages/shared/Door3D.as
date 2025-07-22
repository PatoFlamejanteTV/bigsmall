package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.display.Sprite;
   import flash.events.Event;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Door3D extends DisplayObject3D
   {
      
      public static var EV_ANIM_BEGIN:String = "animationBegins";
      
      public static var EV_ANIM_END:String = "animationEnds";
      
      public static var EV_ANIM_PROGRESS:String = "animationProgress";
      
      public static var EV_DOOR_OPENS:String = "doorOpens";
      
      public var defaultRotY:Number = 0;
      
      private var stillCount:uint = 0;
      
      public var rotYOnOpen:Number = 90;
      
      public var tweenSpeedOpen:Number = 1.5;
      
      private var isOpen:Boolean = false;
      
      public var rotYOnOver:Number = 0;
      
      public var tweenSpeed:Number = 0.3;
      
      private var velocity:Number = 0;
      
      public var isTweening:Boolean = false;
      
      public var doorModel:DisplayObject3D = null;
      
      private var targetRotation:Number;
      
      public var tweenSpeedShut:Number = 0.75;
      
      private var frameTick:Sprite;
      
      private var allowShutEvent:Boolean = false;
      
      public function Door3D(param1:DisplayObject3D)
      {
         super();
         doorModel = param1;
         addChild(doorModel);
         frameTick = new Sprite();
         frameTick.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
         targetRotation = defaultRotY;
      }
      
      public function setDoorModelOverState(param1:Boolean) : void
      {
         if(isOpen)
         {
            return;
         }
         if(param1)
         {
            allowShutEvent = false;
            if(rotationY != rotYOnOver)
            {
               dispatchEvent(new Event(EV_DOOR_OPENS));
            }
            targetRotation = rotYOnOver;
            handleTweenBegin();
         }
         else
         {
            allowShutEvent = true;
            targetRotation = defaultRotY;
            handleTweenBegin();
         }
      }
      
      public function openDoor(param1:Boolean = false) : void
      {
         if(!param1)
         {
            targetRotation = rotYOnOpen;
            handleTweenBegin();
         }
         else
         {
            doorModel.rotationY = rotYOnOpen;
            velocity = 0;
            isTweening = false;
         }
         isOpen = true;
      }
      
      private function handleTweenBegin() : void
      {
         if(!isTweening)
         {
            dispatchEvent(new Event(EV_ANIM_BEGIN));
            isTweening = true;
         }
         stillCount = 0;
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = false;
         if(isTweening)
         {
            velocity *= 0.55;
            _loc2_ = targetRotation - doorModel.rotationY;
            _loc3_ = targetRotation == defaultRotY;
            velocity += _loc2_ * tweenSpeed;
            if(_loc3_ && doorModel.rotationY + velocity < defaultRotY)
            {
               if(allowShutEvent)
               {
                  allowShutEvent = false;
                  dispatchEvent(new DoorEvent(DoorEvent.SHUT,velocity));
               }
               velocity *= -1;
            }
            doorModel.rotationY += velocity;
            if(velocity < 0.01)
            {
               if(++stillCount > 5)
               {
                  handleTweenComplete();
               }
            }
            else
            {
               stillCount = 0;
            }
            dispatchEvent(new Event(EV_ANIM_PROGRESS));
         }
      }
      
      private function handleTweenComplete() : void
      {
         if(isTweening)
         {
            velocity = 0;
            dispatchEvent(new Event(EV_ANIM_END));
            isTweening = false;
         }
      }
      
      public function closeDoor(param1:Boolean = false) : void
      {
         if(!param1)
         {
            targetRotation = defaultRotY;
            handleTweenBegin();
         }
         else
         {
            doorModel.rotationY = defaultRotY;
            velocity = 0;
            isTweening = false;
         }
         isOpen = false;
      }
   }
}

