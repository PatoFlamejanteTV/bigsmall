package net.pluginmedia.pv3d
{
   import flash.display.MovieClip;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.ParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class PointSpriteMovieUpdater extends PointSprite
   {
      
      public var doUpdateClip:Boolean = true;
      
      private var _minAngle:Number;
      
      private var _maxAngle:Number;
      
      public function PointSpriteMovieUpdater(param1:ParticleMaterial, param2:Number, param3:Number)
      {
         _minAngle = param2;
         _maxAngle = param3;
         super(param1);
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc4_:SpriteParticleMaterial = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc3_:Number = super.project(param1,param2);
         if(doUpdateClip)
         {
            _loc4_ = material as SpriteParticleMaterial;
            _loc5_ = _loc4_.movie as MovieClip;
            _loc6_ = view.n13 * Number3D.toDEGREES;
            _loc7_ = (clamp(_loc6_) - _minAngle) / (_maxAngle - _minAngle);
            _loc8_ = _loc7_ * _loc5_.totalFrames;
            _loc5_.gotoAndStop(_loc8_);
         }
         return _loc3_;
      }
      
      private function clamp(param1:Number) : Number
      {
         var _loc2_:Number = Math.max(param1,Math.min(_minAngle,_maxAngle));
         return Math.min(_loc2_,Math.max(_minAngle,_maxAngle));
      }
   }
}

