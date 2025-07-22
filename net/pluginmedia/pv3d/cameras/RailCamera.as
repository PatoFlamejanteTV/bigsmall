package net.pluginmedia.pv3d.cameras
{
   import net.pluginmedia.geom.BezierPath3D;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class RailCamera extends Camera3D implements ICameraUpdateable
   {
      
      protected var targetRail:BezierPath3D;
      
      protected var positionUnit:Number = 0;
      
      protected var targetUnit:Number = 0;
      
      protected var positionRail:BezierPath3D;
      
      public function RailCamera(param1:BezierPath3D, param2:BezierPath3D, param3:Number = 60)
      {
         super(param3);
         positionRail = param1;
         targetRail = param2;
         target = new DisplayObject3D();
      }
      
      public function get targetPosition() : Number
      {
         return targetUnit;
      }
      
      public function get railPosition() : Number
      {
         return positionUnit;
      }
      
      public function set targetPosition(param1:Number) : void
      {
         targetUnit = param1;
      }
      
      public function updatePosition(param1:Number, param2:Number, param3:Number = 0.14) : Boolean
      {
         var _loc4_:Boolean = false;
         param1 = SuperMath.clamp(param1,0,1);
         param2 = SuperMath.clamp(param2,0,1);
         targetUnit = param1;
         positionUnit = easeUnit(positionUnit,targetUnit,param3);
         if(positionUnit != targetUnit)
         {
            position = positionRail.getNumber3DAtT(positionUnit);
            target.position = targetRail.getNumber3DAtT(positionUnit);
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      public function set railPosition(param1:Number) : void
      {
         positionUnit = param1;
         targetUnit = param1;
         position = positionRail.getNumber3DAtT(positionUnit);
         target.position = targetRail.getNumber3DAtT(targetUnit);
      }
      
      private function easeUnit(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = (param2 - param1) * param3;
         return Math.abs(_loc4_) < 0.0001 ? param2 : param1 + _loc4_;
      }
   }
}

