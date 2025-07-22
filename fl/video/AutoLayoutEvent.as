package fl.video
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class AutoLayoutEvent extends LayoutEvent implements IVPEvent
   {
      
      public static const AUTO_LAYOUT:String = "autoLayout";
      
      private var _vp:uint;
      
      public function AutoLayoutEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Rectangle = null, param5:Rectangle = null, param6:uint = 0)
      {
         super(param1,param2,param3,param4,param5);
         _vp = param6;
      }
      
      override public function clone() : Event
      {
         return new AutoLayoutEvent(type,bubbles,cancelable,Rectangle(oldBounds.clone()),Rectangle(oldRegistrationBounds.clone()),vp);
      }
      
      public function set vp(param1:uint) : void
      {
         _vp = param1;
      }
      
      public function get vp() : uint
      {
         return _vp;
      }
   }
}

