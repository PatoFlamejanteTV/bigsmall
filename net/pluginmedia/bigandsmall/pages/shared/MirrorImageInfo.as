package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.display.BitmapData;
   
   public class MirrorImageInfo
   {
      
      public var bitmapData:BitmapData;
      
      public var scale:Number;
      
      public var y:Number;
      
      public var x:Number;
      
      public var z:Number;
      
      public var label:String;
      
      public function MirrorImageInfo(param1:String, param2:BitmapData, param3:Number, param4:Number, param5:Number, param6:Number)
      {
         super();
         this.label = param1;
         this.bitmapData = param2;
         this.x = param3;
         this.y = param4;
         this.z = param5;
         this.scale = param6;
      }
   }
}

