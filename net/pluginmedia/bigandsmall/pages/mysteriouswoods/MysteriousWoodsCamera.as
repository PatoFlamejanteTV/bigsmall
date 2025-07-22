package net.pluginmedia.bigandsmall.pages.mysteriouswoods
{
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MysteriousWoodsCamera extends Camera3D implements ICameraUpdateable
   {
      
      public function MysteriousWoodsCamera(param1:Number = 60, param2:Number = 10, param3:Number = 5000, param4:Boolean = false, param5:Boolean = false)
      {
         this.target = DisplayObject3D.ZERO;
         this.target.z = 1;
         super(param1,param2,param3,param4,param5);
      }
      
      public function updatePosition(param1:Number, param2:Number, param3:Number = 0.4) : Boolean
      {
         return false;
      }
   }
}

