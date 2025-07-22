package net.pluginmedia.pv3d
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.ParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CameraThetaRelativePointSpriteMovieUpdater extends PointSprite
   {
      
      public static var DID_UPDATE:String = "CameraThetaRelativePointSpriteMovieUpdater.DID_UPDATE";
      
      public var doUpdateClip:Boolean = true;
      
      private var lastFrame:int = 0;
      
      private var _minAngle:Number;
      
      public var frame:int = 1;
      
      private var _maxAngle:Number;
      
      public function CameraThetaRelativePointSpriteMovieUpdater(param1:ParticleMaterial, param2:Number, param3:Number)
      {
         _minAngle = param2;
         _maxAngle = param3;
         super(param1);
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc4_:CameraObject3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:SpriteParticleMaterial = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Number = NaN;
         var _loc3_:Number = super.project(param1,param2);
         if(doUpdateClip)
         {
            _loc4_ = param2.camera;
            _loc5_ = this.sceneX - _loc4_.x;
            _loc6_ = this.sceneZ - _loc4_.z;
            _loc7_ = Math.atan2(_loc6_,_loc5_) * Number3D.toDEGREES - 90;
            if(_loc7_ > _maxAngle)
            {
               _loc7_ = _maxAngle;
            }
            if(_loc7_ < _minAngle)
            {
               _loc7_ = _minAngle;
            }
            _loc8_ = material as SpriteParticleMaterial;
            _loc9_ = _loc8_.movie as MovieClip;
            _loc10_ = (_loc7_ - _minAngle) / (_maxAngle - _minAngle);
            frame = _loc10_ * _loc9_.totalFrames;
            _loc9_.gotoAndStop(frame);
            if(frame != lastFrame)
            {
               dispatchEvent(new Event(DID_UPDATE));
            }
            lastFrame = frame;
         }
         return _loc3_;
      }
   }
}

