package net.pluginmedia.bigandsmall.video
{
   import fl.video.FLVPlayback;
   import fl.video.VideoPlayer;
   import flash.display.Sprite;
   
   public class VideoPlayback extends Sprite
   {
      
      public var controlPanel:VideoPlayerControl;
      
      public var flvPlayback:FLVPlayback;
      
      public var blackBackground:Sprite;
      
      public function VideoPlayback(param1:uint = 512, param2:uint = 288)
      {
         super();
         flvPlayback = new FLVPlayback();
         flvPlayback.width = param1;
         flvPlayback.height = param2;
         controlPanel = new VideoPlayerControl(flvPlayback);
         controlPanel.drop.height = param2;
         controlPanel.drop.y = -param2;
         controlPanel.y = flvPlayback.height;
         blackBackground = new Sprite();
         blackBackground.graphics.beginFill(0,1);
         blackBackground.graphics.drawRect(0,0,param1,param2);
         addChild(blackBackground);
         addChild(flvPlayback);
         addChild(controlPanel);
      }
      
      public function stop() : void
      {
         controlPanel.stop();
      }
      
      public function load(param1:String) : void
      {
         controlPanel.load(param1);
         smooth = true;
      }
      
      public function play() : void
      {
         controlPanel.play();
      }
      
      public function close() : void
      {
         controlPanel.close();
      }
      
      public function set smooth(param1:Boolean) : void
      {
         var _loc2_:VideoPlayer = flvPlayback.getVideoPlayer(1);
         _loc2_.smoothing = param1;
      }
   }
}

