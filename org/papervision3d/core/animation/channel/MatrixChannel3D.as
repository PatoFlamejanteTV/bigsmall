package org.papervision3d.core.animation.channel
{
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MatrixChannel3D extends AbstractChannel3D
   {
      
      public var member:String;
      
      public function MatrixChannel3D(param1:DisplayObject3D, param2:String = null)
      {
         super(param1,param2);
         this.member = null;
      }
      
      override public function updateToTime(param1:Number) : void
      {
         super.updateToTime(param1);
         target.copyTransform(currentKeyFrame.output[0]);
      }
      
      override public function updateToFrame(param1:uint) : void
      {
         super.updateToFrame(param1);
         target.copyTransform(currentKeyFrame.output[0]);
      }
   }
}

