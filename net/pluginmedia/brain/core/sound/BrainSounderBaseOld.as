package net.pluginmedia.brain.core.sound
{
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   import net.pluginmedia.brain.core.interfaces.IBrainSounderOld;
   
   public class BrainSounderBaseOld extends EventDispatcher implements IBrainSounderOld
   {
      
      protected var _strID:String = null;
      
      protected var _soundInfo:SoundInfoOld = null;
      
      public function BrainSounderBaseOld(param1:String, param2:SoundInfoOld)
      {
         super();
         if(param2 === null)
         {
            _soundInfo = new SoundInfoOld();
         }
         else
         {
            _soundInfo = param2;
         }
         _strID = param1;
      }
      
      public function stop(param1:Number = 0) : void
      {
      }
      
      public function updateTransform(param1:SoundTransform) : void
      {
      }
      
      public function onPosition() : void
      {
         if(_soundInfo.onPositionFunc !== null)
         {
            _soundInfo.onPositionFunc();
         }
      }
      
      public function onBegin() : void
      {
         if(_soundInfo.onBeginFunc !== null)
         {
            if(_soundInfo.onBeginParams !== null)
            {
               _soundInfo.onBeginFunc.apply(null,_soundInfo.onBeginParams);
            }
            else
            {
               _soundInfo.onBeginFunc();
            }
         }
      }
      
      public function onProgress() : void
      {
         if(_soundInfo.onProgressFunc !== null)
         {
            _soundInfo.onProgressFunc();
         }
      }
      
      public function get strID() : String
      {
         return _strID;
      }
      
      public function play(param1:SoundInfoOld = null) : void
      {
      }
      
      public function onComplete() : void
      {
         if(_soundInfo.onCompleteFunc !== null)
         {
            if(_soundInfo.onCompleteParams !== null)
            {
               _soundInfo.onCompleteFunc.apply(null,_soundInfo.onCompleteParams);
            }
            else
            {
               _soundInfo.onCompleteFunc();
            }
         }
      }
      
      public function get soundInfo() : SoundInfoOld
      {
         return _soundInfo;
      }
   }
}

