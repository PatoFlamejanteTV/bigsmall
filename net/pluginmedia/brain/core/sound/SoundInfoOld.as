package net.pluginmedia.brain.core.sound
{
   import flash.display.MovieClip;
   import net.pluginmedia.brain.core.BrainLogger;
   
   public class SoundInfoOld
   {
      
      public static var TARGCHANNEL_ANY:int = -1;
      
      public static var CHANCONFLICT_QUEUE:int = 0;
      
      public static var CHANCONFLICT_SKIP:int = 1;
      
      public static var CHANCONFLICT_OVERRIDE:int = 2;
      
      public var controlMCFrameRate:int = 25;
      
      public var controlMC:MovieClip = null;
      
      public var channel:int = -1;
      
      public var baselineMinVol:Number = 0;
      
      public var onProgressFunc:Function = null;
      
      public var onPositionFunc:Function = null;
      
      public var startOffset:Number = 0;
      
      public var volume:Number = 1;
      
      public var pan:Number = 0;
      
      public var onCompleteParams:Array = null;
      
      public var onCompleteFunc:Function = null;
      
      public var onBeginFunc:Function = null;
      
      public var onBeginParams:Array = null;
      
      public var onConflictResponse:int = SoundInfoOld.CHANCONFLICT_SKIP;
      
      public var loop:int = 0;
      
      public var targetChannel:int = SoundInfoOld.TARGCHANNEL_ANY;
      
      public var baselineMaxVol:Number = 1;
      
      public function SoundInfoOld(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = -1)
      {
         super();
         this.volume = param1;
         this.pan = param2;
         this.loop = param3;
         startOffset = param4;
         this.targetChannel = param5;
      }
      
      public function toString() : void
      {
         BrainLogger.out("SoundPlayRequest ----");
         BrainLogger.out("targetChannel",targetChannel);
         BrainLogger.out("onConflictResponse",onConflictResponse);
         BrainLogger.out("baselineMaxVol",baselineMaxVol);
         BrainLogger.out("baselineMinVol",baselineMinVol);
         BrainLogger.out("volume",volume);
         BrainLogger.out("pan",pan);
         BrainLogger.out("loop",loop);
         BrainLogger.out("onBeginFunc",onBeginFunc);
         BrainLogger.out("onCompleteFunc",onCompleteFunc);
         BrainLogger.out("onProgressFunc",onProgressFunc);
         BrainLogger.out("onPositionFunc",onPositionFunc);
         BrainLogger.out("--------------");
      }
   }
}

