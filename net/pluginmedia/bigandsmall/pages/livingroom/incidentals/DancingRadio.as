package net.pluginmedia.bigandsmall.pages.livingroom.incidentals
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.livingroom.incidentals.radio.DancingRadioMesh;
   import net.pluginmedia.brain.core.loading.AssetLoader;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.primitives.Cube;
   
   public class DancingRadio extends Incidental
   {
      
      private var bigDancingClip:MovieClip;
      
      private var channel:SoundChannel;
      
      private var smallTrack:Sound;
      
      private var noiseClip:MovieClip;
      
      private var playingNoise:Boolean;
      
      private var smallDancingClip:MovieClip;
      
      private var noise:Sound;
      
      private var bigTrack:Sound;
      
      private var additionals:Array;
      
      private var frontFaceVertices:Array;
      
      private var radioCube:Cube;
      
      private var unitProgress:Number = 0;
      
      private var currentTrack:Sound;
      
      private var radioCubeLow:Cube;
      
      private var currentDancingClip:MovieClip;
      
      private var lowPolyRadioIsOn:Boolean = true;
      
      private var mesh:DancingRadioMesh;
      
      private var radioMaterials:MaterialsList;
      
      private var rolloverTrack:Sound;
      
      private var backFaceVertices:Array;
      
      public function DancingRadio(param1:String)
      {
         super(param1);
      }
      
      override public function stop() : void
      {
         if(playing)
         {
            onTrackProgress();
            stopRadio();
            playing = false;
         }
      }
      
      private function onTrackComplete(param1:Event) : void
      {
         stop();
      }
      
      private function switchToHighPolyRadio() : void
      {
         radioCube.visible = true;
         radioCubeLow.visible = false;
         if(!lowPolyRadioIsOn)
         {
            return;
         }
         removeChild(radioCubeLow);
         addChild(radioCube);
         lowPolyRadioIsOn = false;
      }
      
      private function switchToLowPolyRadio() : void
      {
         radioCube.visible = false;
         radioCubeLow.visible = true;
         if(lowPolyRadioIsOn)
         {
            return;
         }
         removeChild(radioCube);
         addChild(radioCubeLow);
         lowPolyRadioIsOn = true;
      }
      
      private function stopRadio() : void
      {
         bigDancingClip.gotoAndStop(1);
         smallDancingClip.gotoAndStop(1);
         if(channel != null)
         {
            channel.stop();
            channel.removeEventListener(Event.SOUND_COMPLETE,onTrackComplete);
         }
         bigDancingClip.removeEventListener(Event.ENTER_FRAME,onTrackProgress);
         smallDancingClip.removeEventListener(Event.ENTER_FRAME,onTrackProgress);
         playing = false;
         switchToLowPolyRadio();
      }
      
      public function setContent(param1:Object) : void
      {
         var _loc2_:AssetLoader = AssetLoader(param1);
         bigDancingClip = _loc2_.getAssetByName("BigDancingRadioPoints");
         bigTrack = _loc2_.getAssetByName("BigRadioTrack");
         smallDancingClip = _loc2_.getAssetByName("SmallDancingRadioPoints");
         smallTrack = _loc2_.getAssetByName("SmallRadioTrack");
         noise = _loc2_.getAssetByName("lr_radio_over");
         noiseClip = _loc2_.getAssetByName("NoiseClip");
         setupCube(AssetLoader(param1));
      }
      
      private function startRadio() : void
      {
         currentDancingClip.gotoAndPlay(1);
         currentDancingClip.addEventListener(Event.ENTER_FRAME,onTrackProgress);
         unitProgress = 0;
         channel = currentTrack.play();
         channel.addEventListener(Event.SOUND_COMPLETE,onTrackComplete);
         playing = true;
         switchToHighPolyRadio();
         dispatchEvent(new Event("radioStarted"));
      }
      
      override public function play() : void
      {
         if(active && !playing)
         {
            mesh.setMesh(currentDancingClip,4,4);
            startRadio();
         }
      }
      
      override public function handleClick() : void
      {
         if(playing)
         {
            if(currentTrack == bigTrack)
            {
               if(unitProgress > 0.3)
               {
                  stop();
               }
            }
            else
            {
               stop();
            }
         }
         else
         {
            play();
         }
      }
      
      private function getCubeVertices(param1:Cube, param2:uint, param3:uint, param4:uint = 4, param5:uint = 4) : void
      {
         var _loc7_:Vertex3D = null;
         var _loc12_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Vertex3D = null;
         var _loc16_:int = 0;
         var _loc6_:Array = param1.geometry.vertices;
         var _loc8_:uint = uint(param2 >> 1);
         var _loc9_:uint = uint(param3 >> 1);
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         var _loc13_:Array = param1.geometry.faces;
         _loc12_ = 0;
         while(_loc12_ < _loc6_.length)
         {
            _loc7_ = _loc6_[_loc12_] as Vertex3D;
            _loc14_ = false;
            if(_loc7_.z < 0)
            {
               _loc10_.push(_loc7_);
            }
            else if(_loc7_.z > 0)
            {
               _loc11_.push(_loc7_);
            }
            _loc12_++;
         }
         frontFaceVertices = sortVerticesTo2DByY(_loc10_);
         backFaceVertices = sortVerticesTo2DByY(_loc11_);
         _loc12_ = 0;
         while(_loc12_ < frontFaceVertices.length)
         {
            _loc16_ = 0;
            while(_loc16_ < frontFaceVertices[_loc12_].length)
            {
               _loc7_ = frontFaceVertices[_loc12_][_loc16_] as Vertex3D;
               _loc16_++;
            }
            _loc12_++;
         }
      }
      
      private function bubbleSort(param1:Array, param2:String = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc6_:* = param2 != null;
         _loc3_ = param1.length - 2;
         while(_loc3_ >= 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc7_ = _loc6_ ? param1[_loc4_][param2] : param1[_loc4_];
               _loc8_ = _loc6_ ? param1[_loc4_ + 1][param2] : param1[_loc4_ + 1];
               if(_loc7_ > _loc8_)
               {
                  _loc5_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc5_;
               }
               _loc4_++;
            }
            _loc3_--;
         }
      }
      
      private function onNoiseComplete(param1:Event) : void
      {
         noiseClip.removeEventListener(Event.ENTER_FRAME,onTrackProgress);
         playingNoise = false;
         if(!playing)
         {
            switchToLowPolyRadio();
         }
      }
      
      private function setupCube(param1:AssetLoader) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:BitmapData = null;
         var _loc2_:MovieClip = param1.getAssetByName("DancingRadioPoints");
         mesh = new DancingRadioMesh();
         mesh.setMesh(bigDancingClip,4,4);
         radioMaterials = new MaterialsList();
         _loc3_ = param1.getAssetByName("RadioTextureFRONT");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"back");
         _loc3_ = param1.getAssetByName("RadioTextureLEFT");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"left");
         _loc3_ = param1.getAssetByName("RadioTextureRIGHT");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"right");
         _loc3_ = param1.getAssetByName("RadioTextureTOP");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"top");
         _loc3_ = param1.getAssetByName("RadioTextureBOTTOM");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"bottom");
         _loc3_ = param1.getAssetByName("RadioTextureBOTTOM");
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         radioMaterials.addMaterial(new BitmapMaterial(_loc4_.clone()),"front");
         radioCube = new Cube(radioMaterials,120,60,30,3,3,1,0,0);
         radioCube.scale = 0.4;
         getCubeVertices(radioCube,80,50);
         addChild(radioCube);
         radioCube.visible = false;
         radioCubeLow = new Cube(radioMaterials,160,60,120,1,2,1,Cube.NONE);
         radioCubeLow.scale = 0.4;
         addChild(radioCubeLow);
         lowPolyRadioIsOn = true;
      }
      
      private function sortVerticesTo2DByY(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc4_:Vertex3D = null;
         var _loc7_:String = null;
         var _loc3_:Array = [];
         var _loc5_:Object = {};
         var _loc6_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1[_loc2_];
            _loc7_ = _loc4_.y.toString();
            if(_loc5_[_loc7_] is Array)
            {
               _loc5_[_loc7_].push(_loc4_);
            }
            else
            {
               _loc6_.push(_loc4_.y);
               _loc5_[_loc7_] = new Array();
               _loc5_[_loc7_].push(_loc4_);
            }
            _loc2_++;
         }
         bubbleSort(_loc6_);
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            _loc3_[_loc2_] = _loc5_[_loc6_[_loc2_].toString()];
            _loc2_++;
         }
         return _loc3_;
      }
      
      override public function rollover() : void
      {
         if(!playing && !playingNoise && active)
         {
            switchToHighPolyRadio();
            playingNoise = true;
            channel = noise.play();
            channel.addEventListener(Event.SOUND_COMPLETE,onNoiseComplete);
            mesh.setMesh(noiseClip);
            onTrackProgress();
            noiseClip.addEventListener(Event.ENTER_FRAME,onTrackProgress);
            noiseClip.gotoAndPlay(1);
         }
      }
      
      override public function setCharacter(param1:String) : void
      {
         switch(param1)
         {
            case CharacterDefinitions.BIG:
               currentTrack = bigTrack;
               currentDancingClip = bigDancingClip;
               break;
            case CharacterDefinitions.SMALL:
               currentTrack = smallTrack;
               currentDancingClip = smallDancingClip;
         }
         mesh.setMesh(currentDancingClip,4,4);
         stop();
      }
      
      private function onTrackProgress(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vertex3D = null;
         var _loc5_:Number2D = null;
         var _loc6_:Number2D = null;
         if(param1 != null)
         {
            unitProgress = channel.position / currentTrack.length;
            if(mesh.getMesh() == noiseClip)
            {
               unitProgress = channel.position / noise.length;
               noiseClip.gotoAndStop(int(unitProgress * (noise.length / 1000 * 25)) + 1);
            }
            else
            {
               currentDancingClip.gotoAndStop(int(unitProgress * (currentTrack.length / 1000 * 25)) + 1);
            }
         }
         else if(currentDancingClip)
         {
            currentDancingClip.gotoAndStop(1);
         }
         dispatchEvent(new Event("animationProgress"));
         var _loc7_:Array = mesh.getPoints();
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc7_[0].length)
            {
               _loc5_ = _loc7_[_loc2_][_loc3_] as Number2D;
               _loc6_ = _loc7_[_loc7_.length - 1 - _loc2_][_loc3_] as Number2D;
               _loc4_ = frontFaceVertices[_loc2_][_loc3_];
               _loc4_.x = _loc5_.x;
               _loc4_.y = _loc5_.y;
               _loc4_ = backFaceVertices[_loc2_][backFaceVertices[_loc2_].length - 1 - _loc3_];
               _loc4_.x = _loc5_.x;
               _loc4_.y = _loc5_.y;
               _loc3_++;
            }
            _loc2_++;
         }
      }
   }
}

