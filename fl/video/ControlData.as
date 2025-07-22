package fl.video
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ControlData
   {
      
      public var state_mc:Array;
      
      public var origWidth:Number;
      
      public var handle_mc:Sprite;
      
      public var state:uint;
      
      public var leftMargin:Number;
      
      public var fullness_mc:DisplayObject;
      
      public var isDragging:Boolean;
      
      public var currentState_mc:DisplayObject;
      
      public var percentage:Number;
      
      public var owner:DisplayObject;
      
      public var origX:Number;
      
      public var origY:Number;
      
      public var bottomMargin:Number;
      
      public var disabled_mc:DisplayObject;
      
      public var enabled:Boolean;
      
      public var hit_mc:Sprite;
      
      public var origHeight:Number;
      
      public var index:int;
      
      public var mask_mc:DisplayObject;
      
      public var avatar:DisplayObject;
      
      public var fill_mc:DisplayObject;
      
      public var topMargin:Number;
      
      public var uiMgr:UIManager;
      
      public var progress_mc:DisplayObject;
      
      public var rightMargin:Number;
      
      public var ctrl:DisplayObject;
      
      public var origScaleX:Number;
      
      public var origScaleY:Number;
      
      public function ControlData(param1:UIManager, param2:DisplayObject, param3:DisplayObject, param4:int)
      {
         var uiMgr:UIManager = param1;
         var ctrl:DisplayObject = param2;
         var owner:DisplayObject = param3;
         var index:int = param4;
         super();
         this.uiMgr = uiMgr;
         this.index = index;
         this.ctrl = ctrl;
         this.owner = owner;
         try
         {
            ctrl["uiMgr"] = uiMgr;
         }
         catch(re:ReferenceError)
         {
         }
      }
   }
}

