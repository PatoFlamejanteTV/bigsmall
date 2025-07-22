package net.pluginmedia.bigandsmall.pages.livingroom.bandgame
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.pluginmedia.utils.SoundPlayer;
   import net.pluginmedia.utils.SuperSound;
   
   public class BandPlayer extends Sprite
   {
      
      private var fadeIn:Number = 0;
      
      private var _currentInstrument:SuperSound;
      
      private var identifier:String;
      
      private var instrumentRegistry:Object = {};
      
      private var fadeInc:Number = 0.35;
      
      private var pan:Number;
      
      private var maxVolume:Number;
      
      public function BandPlayer(param1:String, param2:Number = 0, param3:Number = 1)
      {
         super();
         identifier = param1;
         maxVolume = param3;
         this.pan = param2;
      }
      
      public function get currentInstrument() : SuperSound
      {
         return _currentInstrument;
      }
      
      public function chooseInstrument(param1:String) : void
      {
         silence();
         fadeIn = 0;
         if(param1 != "NULL")
         {
            _currentInstrument = instrumentRegistry[param1] as SuperSound;
         }
         else
         {
            _currentInstrument = null;
         }
      }
      
      public function registerInstrument(param1:Class, param2:String, param3:Number = 1) : void
      {
         instrumentRegistry[param2] = SoundPlayer.addSound(param2,param1,param3);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         if(_currentInstrument !== null)
         {
            if(fadeIn < maxVolume)
            {
               fadeIn += (maxVolume - fadeIn) * fadeInc;
               _currentInstrument.volume = fadeIn;
            }
         }
      }
      
      public function removeEnterFrameListener() : void
      {
         removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function silence() : void
      {
         var _loc1_:SuperSound = null;
         for each(_loc1_ in instrumentRegistry)
         {
            _loc1_.volume = 0;
         }
      }
      
      public function begin() : void
      {
         var _loc1_:SuperSound = null;
         addEnterFrameListener();
         for each(_loc1_ in instrumentRegistry)
         {
            _loc1_.loopSound(int.MAX_VALUE,0,pan,0);
         }
      }
      
      public function addEnterFrameListener() : void
      {
         addEventListener(Event.ENTER_FRAME,handleEnterFrame);
      }
      
      public function end() : void
      {
         var _loc1_:SuperSound = null;
         removeEnterFrameListener();
         for each(_loc1_ in instrumentRegistry)
         {
            _loc1_.stopSound();
         }
         _currentInstrument = null;
      }
   }
}

