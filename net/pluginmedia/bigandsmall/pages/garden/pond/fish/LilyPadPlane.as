package net.pluginmedia.bigandsmall.pages.garden.pond.fish
{
   import com.as3dmod.ModifierStack;
   import com.as3dmod.modifiers.Bend;
   import com.as3dmod.plugins.pv3d.LibraryPv3d;
   import com.as3dmod.util.ModConstant;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class LilyPadPlane extends Plane
   {
      
      public static var DID_UPDATE_MESH:String = "LilyPadPlane.DID_UPDATE_MESH";
      
      private var velX:Number = 0;
      
      private var velZ:Number = 0;
      
      private var baseX:Number = 0;
      
      private var baseZ:Number = 0;
      
      private var asBend:Bend = new Bend();
      
      public var curlSpd:Number = 0.5;
      
      public var curlFtarg:Number = 0;
      
      private var asStack:ModifierStack;
      
      public function LilyPadPlane(param1:MovieClip, param2:Number = 50, param3:Number = 50, param4:int = 1, param5:Number = 1, param6:Number = 0)
      {
         var _loc7_:MaterialObject3D = new MovieMaterial(param1,true);
         _loc7_.lineAlpha = 0;
         super(_loc7_,param2,param3,param4,param5);
         var _loc8_:Matrix3D = Matrix3D.rotationX(90 * Number3D.toRADIANS);
         geometry.transformVertices(_loc8_);
         _loc8_ = Matrix3D.rotationY(param6 * Number3D.toRADIANS);
         geometry.transformVertices(_loc8_);
         asStack = new ModifierStack(new LibraryPv3d(),this);
         asBend = new Bend(0,0.5);
         asBend.bendAxis = ModConstant.Z;
         asBend.constraint = ModConstant.LEFT;
         asStack.addModifier(asBend);
      }
      
      public function isAtRest() : Boolean
      {
         if(asBend.force != curlFtarg)
         {
            return true;
         }
         return false;
      }
      
      public function reset() : void
      {
         curlFtarg = 0;
         this.x = baseX;
         this.z = baseZ;
         velX = 0;
         velZ = 0;
      }
      
      public function update() : void
      {
         var _loc3_:Number = NaN;
         if(asBend.force != curlFtarg)
         {
            _loc3_ = asBend.force - curlFtarg;
            if(Math.abs(_loc3_) > 0.1)
            {
               asBend.force -= _loc3_ * curlSpd;
            }
            else
            {
               asBend.force = curlFtarg;
            }
            asStack.apply();
            dispatchEvent(new Event(DID_UPDATE_MESH));
         }
         var _loc1_:Number = this.x - baseX;
         if(Math.abs(_loc1_) < 0.01)
         {
            this.x = baseX;
         }
         else
         {
            velX += _loc1_ * 0.1;
         }
         if(Math.abs(velX) > 0.001)
         {
            velX *= 0.9;
            this.x -= velX;
         }
         else
         {
            velX = 0;
         }
         var _loc2_:Number = this.z - baseZ;
         if(Math.abs(_loc2_) < 0.01)
         {
            this.z = baseZ;
         }
         else
         {
            velZ += _loc2_ * 0.1;
         }
         if(Math.abs(velZ) > 0.001)
         {
            velZ *= 0.9;
            this.z -= velZ;
         }
         else
         {
            velZ = 0;
         }
      }
      
      public function wobble() : void
      {
         this.x += SuperMath.random(-20,20);
         this.z += SuperMath.random(-20,20);
      }
   }
}

