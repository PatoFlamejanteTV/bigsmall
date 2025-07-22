package net.pluginmedia.bigandsmall.pages.livingroom.drawinggame
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import net.pluginmedia.utils.SoundCollection;
   import org.papervision3d.core.math.Number3D;
   
   public class DrawingState
   {
      
      public var container:DisplayObjectContainer;
      
      public var paintScoopStrRef:String = null;
      
      public var armClip:MovieClip;
      
      public var printColour:int;
      
      protected var soundDefOnColChoice:String = null;
      
      protected var targetBitmap:BitmapData;
      
      public var currentColour:ColourTray;
      
      public var paintSplatStrRef:String = null;
      
      protected var splatCollection:SoundCollection;
      
      public var drawColorTransform:ColorTransform;
      
      public var dripping:Boolean;
      
      public var defaultArmScale:Number = 0.7;
      
      public var handPrint:MovieClip;
      
      public function DrawingState(param1:DisplayObjectContainer, param2:MovieClip, param3:MovieClip)
      {
         super();
         armClip = param3;
         handPrint = param2;
         this.container = param1;
         drawColorTransform = new ColorTransform();
         handPrint.gotoAndStop(1);
         armClip.gotoAndStop(1);
         armClip.scaleX = armClip.scaleY = defaultArmScale;
         dripping = false;
      }
      
      public function setState() : void
      {
         setColor(currentColour);
      }
      
      public function removeFromStage() : void
      {
         if(container.contains(armClip))
         {
            container.removeChild(armClip);
         }
      }
      
      public function moveMouse(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         armClip.x = param1;
         armClip.y = param2;
      }
      
      protected function drawData(param1:Matrix) : void
      {
         targetBitmap.draw(handPrint,param1,drawColorTransform,BlendMode.MULTIPLY);
      }
      
      public function setPrintColour(param1:int) : void
      {
         printColour = param1;
      }
      
      public function drawHandPrint(param1:Number, param2:Number, param3:BitmapData) : void
      {
         var _loc4_:Matrix = new Matrix();
         _loc4_.rotate(armClip.rotation * Number3D.toRADIANS);
         _loc4_.translate(param1,param2);
         drawData(_loc4_);
         if(handPrint.currentFrame < handPrint.totalFrames)
         {
            handPrint.nextFrame();
         }
         if(armClip.hand)
         {
            armClip.hand.gotoAndPlay("print");
            armClip.hand.paint.gotoAndPlay("print");
         }
      }
      
      public function addToStage() : void
      {
         if(!container.contains(armClip))
         {
            container.addChild(armClip);
         }
      }
      
      public function chooseColor(param1:ColourTray) : void
      {
         setColor(param1);
      }
      
      public function setColor(param1:ColourTray) : void
      {
         currentColour = param1;
         drawColorTransform.redMultiplier = currentColour.red / 255;
         drawColorTransform.greenMultiplier = currentColour.green / 255;
         drawColorTransform.blueMultiplier = currentColour.blue / 255;
         drawColorTransform.alphaMultiplier = 1;
         drawColorTransform.redOffset = 0;
         drawColorTransform.greenOffset = 0;
         drawColorTransform.blueOffset = 0;
         drawColorTransform.alphaOffset = 0;
         if(armClip.hand.paint !== null)
         {
            MovieClip(armClip.hand.paint).transform.colorTransform = drawColorTransform;
         }
         if(handPrint)
         {
            handPrint.gotoAndStop(1);
         }
      }
      
      public function setTargetBitmap(param1:BitmapData) : void
      {
         targetBitmap = param1;
      }
      
      public function unSetState() : void
      {
      }
      
      public function stampAnim() : void
      {
      }
      
      public function drawDrips(param1:Number, param2:Number, param3:BitmapData) : void
      {
      }
   }
}

