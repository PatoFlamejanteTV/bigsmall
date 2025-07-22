package net.pluginmedia.bigandsmall.pages.mysteriouswoods
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import net.pluginmedia.pv3d.DAEFixed;
   
   public class ResourceController extends EventDispatcher
   {
      
      public var rightArrowSmall:MovieClip;
      
      protected var decorations:Array = [];
      
      protected var incidentalAnims:Array = [];
      
      public var endDanceClip:MovieClip;
      
      public var finalSegDAE:DAEFixed;
      
      protected var lastTextureClip:MovieClip;
      
      public var junctionDAE1:DAEFixed;
      
      public var forwardArrowSmall:MovieClip;
      
      public var leftArrowBig:MovieClip;
      
      protected var moleAnims:Array = [];
      
      public var bigEndClips:Array = [];
      
      public var forwardArrowBig:MovieClip;
      
      public var leftArrowSmall:MovieClip;
      
      public var tile:BitmapData;
      
      public var pathDAE2:DAEFixed;
      
      public var rightArrowBig:MovieClip;
      
      public var pathDAE1:DAEFixed;
      
      public var smallEndClips:Array = [];
      
      public var pathDAE3:DAEFixed;
      
      public var rewardDAE1:DAEFixed;
      
      public function ResourceController()
      {
         super();
      }
      
      public function addIncidentalAnim(param1:MovieClip) : void
      {
         incidentalAnims.push(param1);
      }
      
      public function getRewardAnim(param1:uint) : MovieClip
      {
         return MovieClip(moleAnims[param1]);
      }
      
      public function getRandomDecorationTexture(param1:Array = null) : MovieClip
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            _loc2_ = decorations[int(decorations.length * Math.random())];
         }
         else
         {
            _loc4_ = int(param1[int(param1.length * Math.random())]);
            _loc2_ = decorations[_loc4_];
         }
         var _loc3_:MovieClip = _loc2_[int(_loc2_.length * Math.random())];
         if(_loc3_ == lastTextureClip)
         {
            return getRandomDecorationTexture(param1);
         }
         lastTextureClip = _loc3_;
         return _loc3_;
      }
      
      public function addRewardAnim(param1:MovieClip) : void
      {
         moleAnims.push(param1);
      }
      
      public function getIncidentalAnim() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(incidentalAnims.length > 0)
         {
            _loc1_ = incidentalAnims.shift();
         }
         return MovieClip(_loc1_);
      }
      
      public function addDecorationTexture(param1:MovieClip, param2:uint) : void
      {
         if(decorations[param2] == null)
         {
            decorations[param2] = [];
         }
         decorations[param2].push(param1);
      }
      
      public function pushBigEndClip(param1:MovieClip) : void
      {
         param1.stop();
         bigEndClips.push(param1);
      }
      
      public function pushSmallEndClip(param1:MovieClip) : void
      {
         param1.stop();
         smallEndClips.push(param1);
      }
   }
}

