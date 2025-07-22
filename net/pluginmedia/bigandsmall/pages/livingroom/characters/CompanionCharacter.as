package net.pluginmedia.bigandsmall.pages.livingroom.characters
{
   import flash.display.MovieClip;
   import flash.media.Sound;
   import net.pluginmedia.bigandsmall.interfaces.ICharacter;
   import net.pluginmedia.bigandsmall.pages.livingroom.LipSyncData;
   import net.pluginmedia.brain.core.BrainLogger;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CompanionCharacter extends DisplayObject3D implements ICharacter
   {
      
      public var isTalking:Boolean = false;
      
      public var _isActive:Boolean;
      
      public var voiceOverData:Object = {};
      
      public var playedLabels:Array = [];
      
      public var parentUnpackAsset:Function;
      
      public function CompanionCharacter()
      {
         super();
         _isActive = false;
         autoCalcScreenCoords = true;
      }
      
      public function deactivate() : void
      {
         _isActive = false;
      }
      
      public function unpackAsset(param1:String, param2:Boolean = false, param3:Class = null) : *
      {
         if(parentUnpackAsset === null)
         {
            throw new Error("CompanionCharacter :: ERROR : SpeakingCharacter function for unpacking assets not set");
         }
         return parentUnpackAsset(param1,param2,param3);
      }
      
      public function prepare() : void
      {
      }
      
      public function park() : void
      {
      }
      
      public function setVoiceOver(param1:String, param2:String, param3:String = null, param4:int = 0, param5:Boolean = false) : LipSyncData
      {
         if(!param3)
         {
            param3 = "small_whole_" + param2;
         }
         var _loc6_:MovieClip = unpackAsset(param3);
         if(!_loc6_)
         {
            throw new Error("CompanionCharacter :: ERROR : speaking character movie " + param3 + " not found");
         }
         var _loc7_:Sound = unpackAsset(param2);
         if(!_loc7_)
         {
            throw new Error("CompanionCharacter :: ERROR : speaking character sound " + param2 + " not found");
         }
         SoundManagerOld.addSound(param2,_loc7_);
         var _loc8_:LipSyncData = new LipSyncData(_loc6_,param2,param4,param5);
         voiceOverData[param1] = _loc8_;
         return _loc8_;
      }
      
      public function showSyncedMovie(param1:MovieClip) : void
      {
      }
      
      public function refreshPlayableLabels() : void
      {
         BrainLogger.out("CompanionCharacter :: refreshPlayableLabels");
         playedLabels = [];
      }
      
      public function talkingFinished() : void
      {
         BrainLogger.out("CompanionCharacter :: TALKING FINISHED");
         stopSyncedMovie();
         isTalking = false;
      }
      
      public function playVoiceOver(param1:String, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         BrainLogger.out("CompanionCharacter :: ATTEMPT VOX " + voiceOverData[param1],param1);
         if(playedLabels.indexOf(param1) !== -1 && !param3)
         {
            BrainLogger.out("CompanionCharacter :: VOX DENIED [REPEAT REQUEST] ");
            return false;
         }
         var _loc4_:LipSyncData = voiceOverData[param1];
         if(_loc4_ === null)
         {
            BrainLogger.out("CompanionCharacter :: playVoiceOver :: Could not source lip sync data opbject for requested label; " + param1);
            return false;
         }
         if(_loc4_.playCount < _loc4_.maxPlayCount || _loc4_.maxPlayCount == 0 || param3)
         {
            if(SoundManagerOld.playSyncedSound(_loc4_.soundRef,_loc4_.movie,1,talkingFinished,25))
            {
               isTalking = true;
               showSyncedMovie(_loc4_.movie);
               if(_loc4_.holdRepeat)
               {
                  playedLabels.push(param1);
               }
               if(_loc4_.maxPlayCount > 0)
               {
                  ++_loc4_.playCount;
               }
            }
         }
         return true;
      }
      
      public function activate() : void
      {
         _isActive = true;
      }
      
      public function stopSyncedMovie() : void
      {
      }
      
      public function get isActive() : Boolean
      {
         return _isActive;
      }
   }
}

