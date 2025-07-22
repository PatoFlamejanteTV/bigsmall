package net.pluginmedia.brain.core.interfaces
{
   import flash.media.SoundTransform;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   
   public interface IBrainSounderOld
   {
      
      function stop(param1:Number = 0) : void;
      
      function onProgress() : void;
      
      function play(param1:SoundInfoOld = null) : void;
      
      function onPosition() : void;
      
      function onBegin() : void;
      
      function updateTransform(param1:SoundTransform) : void;
      
      function get strID() : String;
      
      function get soundInfo() : SoundInfoOld;
      
      function onComplete() : void;
   }
}

