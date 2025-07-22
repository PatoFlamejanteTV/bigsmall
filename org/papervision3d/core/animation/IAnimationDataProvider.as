package org.papervision3d.core.animation
{
   import org.papervision3d.core.animation.channel.AbstractChannel3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public interface IAnimationDataProvider
   {
      
      function get fps() : uint;
      
      function getAnimationChannelsByClip(param1:String) : Array;
      
      function getAnimationChannels(param1:DisplayObject3D = null) : Array;
      
      function getAnimationChannelByName(param1:String) : AbstractChannel3D;
   }
}

