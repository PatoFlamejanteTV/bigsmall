package net.pluginmedia.bigandsmall.ui
{
   import flash.display.MovieClip;
   
   public class StateablePointSpriteState
   {
      
      public var size:Number = 0;
      
      public var movie:MovieClip;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public function StateablePointSpriteState(param1:MovieClip, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 1)
      {
         super();
         this.x = param2;
         this.y = param3;
         this.z = param4;
         this.size = param5;
         this.movie = param1;
      }
   }
}

