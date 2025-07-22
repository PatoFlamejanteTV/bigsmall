package net.pluginmedia.brain.core.sound.interfaces
{
   import flash.events.IEventDispatcher;
   
   public interface IBrainSoundInstance extends IEventDispatcher
   {
      
      function set channelVolume(param1:Number) : void;
      
      function stop() : void;
      
      function get onStart() : Function;
      
      function set onStart(param1:Function) : void;
      
      function set loop(param1:Number) : void;
      
      function get offset() : Number;
      
      function set volumeMult(param1:Number) : void;
      
      function get volume() : Number;
      
      function get id() : String;
      
      function get pan() : Number;
      
      function updateTransform() : void;
      
      function get loop() : Number;
      
      function set offset(param1:Number) : void;
      
      function get position() : Number;
      
      function get volumeMult() : Number;
      
      function resume() : void;
      
      function set onComplete(param1:Function) : void;
      
      function play() : void;
      
      function get length() : Number;
      
      function pause() : void;
      
      function get onComplete() : Function;
      
      function set pan(param1:Number) : void;
      
      function set volume(param1:Number) : void;
      
      function get progress() : Number;
      
      function get channelVolume() : Number;
      
      function get isPaused() : Boolean;
   }
}

