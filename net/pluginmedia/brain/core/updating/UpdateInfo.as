package net.pluginmedia.brain.core.updating
{
   import flash.display.Stage;
   
   public class UpdateInfo
   {
      
      private var framecount:uint;
      
      private var total:uint;
      
      private var delta:uint;
      
      private var stageX:uint;
      
      private var stageY:uint;
      
      private var _stage:Stage;
      
      public function UpdateInfo(param1:uint, param2:uint, param3:uint, param4:Stage, param5:Number, param6:Number)
      {
         super();
         delta = param1;
         total = param2;
         framecount = param3;
         _stage = param4;
         stageX = param5;
         stageY = param6;
      }
      
      public function get stageMouseX() : Number
      {
         return stageX;
      }
      
      public function get deltaTime() : uint
      {
         return delta;
      }
      
      public function get frameCount() : uint
      {
         return framecount;
      }
      
      public function get stage() : Stage
      {
         return _stage;
      }
      
      public function get totalTime() : uint
      {
         return total;
      }
      
      public function get stageMouseY() : Number
      {
         return stageY;
      }
   }
}

