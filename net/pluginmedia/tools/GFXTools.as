package net.pluginmedia.tools
{
   import flash.display.Graphics;
   import org.papervision3d.core.math.Number3D;
   
   public class GFXTools
   {
      
      public function GFXTools()
      {
         super();
      }
      
      public static function drawLine(param1:Graphics, param2:Number3D, param3:Number3D, param4:uint = 16777215, param5:Number = 0.25, param6:Number = 1) : void
      {
         param1.lineStyle(param5,param4,param6);
         param1.moveTo(param2.x,param2.y);
         param1.lineTo(param3.x,param3.y);
      }
      
      public static function drawPoint(param1:Graphics, param2:Number3D, param3:Number = 3, param4:uint = 255) : void
      {
         param1.lineStyle(0.25,param4,1);
         param1.drawCircle(param2.x,param2.y,param3);
         param1.endFill();
      }
   }
}

