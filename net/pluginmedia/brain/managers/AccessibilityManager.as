package net.pluginmedia.brain.managers
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.InteractiveObject;
   import flash.events.FocusEvent;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class AccessibilityManager
   {
      
      public static var _tabIndexMarker:Number = 0;
      
      public static var tiStep:Number = 5;
      
      public static var tabAccess:Dictionary = new Dictionary(true);
      
      public static var accessNameRefs:Dictionary = new Dictionary(true);
      
      public function AccessibilityManager()
      {
         super();
      }
      
      public static function addAccessibilityProperties(param1:InteractiveObject, param2:String = "", param3:String = "", param4:Number = -1) : void
      {
         var _loc5_:AccessibilityProperties = new AccessibilityProperties();
         _loc5_.name = param2;
         _loc5_.description = param3;
         var _loc6_:int = getNextHighestTabIndex(param4);
         param1.tabIndex = _loc6_;
         tabAccess[_loc6_] = param1;
         accessNameRefs[param1] = _loc5_;
         param1.addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         BrainLogger.out(param1,"using tab index",_loc6_);
         param1.accessibilityProperties = _loc5_;
      }
      
      private static function handleFocusIn(param1:FocusEvent) : void
      {
         var _loc2_:AccessibilityProperties = accessNameRefs[param1.target];
         if(_loc2_)
         {
            trace("TABBED TO ::",_loc2_.name);
         }
      }
      
      public static function getNextHighestTabIndex(param1:int = 0) : Number
      {
         var _loc2_:int = param1;
         while(tabAccess[_loc2_] !== undefined)
         {
            _loc2_++;
         }
         return _loc2_;
      }
   }
}

