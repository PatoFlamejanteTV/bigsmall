package org.papervision3d.objects.parsers
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import org.ascollada.ASCollada;
   import org.ascollada.core.*;
   import org.ascollada.fx.*;
   import org.ascollada.io.DaeReader;
   import org.ascollada.namespaces.*;
   import org.ascollada.types.*;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.animation.*;
   import org.papervision3d.core.animation.channel.*;
   import org.papervision3d.core.controller.IObjectController;
   import org.papervision3d.core.controller.SkinController;
   import org.papervision3d.core.geom.*;
   import org.papervision3d.core.geom.renderables.*;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.material.AbstractLightShadeMaterial;
   import org.papervision3d.core.math.*;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.events.AnimationEvent;
   import org.papervision3d.events.FileLoadEvent;
   import org.papervision3d.materials.*;
   import org.papervision3d.materials.shaders.ShadedMaterial;
   import org.papervision3d.materials.special.*;
   import org.papervision3d.materials.utils.*;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.special.Skin3D;
   
   use namespace collada;
   
   public class DAE extends DisplayObject3D implements IAnimationDataProvider, IAnimatable
   {
      
      public static const ROOTNODE_NAME:String = "COLLADA_Scene";
      
      public static var DEFAULT_LINE_COLOR:uint = 16776960;
      
      public static var DEFAULT_LINE_WIDTH:Number = 0;
      
      public static var DEFAULT_TGA_ALTERNATIVE:String = "png";
      
      public var filename:String;
      
      protected var _colladaIDToObject:Object;
      
      protected var _endTime:Number;
      
      protected var _numSkins:uint;
      
      public var COLLADA:XML;
      
      protected var _channelsByTarget:Dictionary;
      
      public var document:DaeDocument;
      
      public var parser:DaeReader;
      
      protected var _objectToNode:Object;
      
      protected var _isPlaying:Boolean = false;
      
      protected var _currentTime:int;
      
      public var useMaterialTargetName:Boolean = false;
      
      protected var _channels:Array;
      
      public var forceCoordSet:int = 0;
      
      public var fileTitle:String;
      
      protected var _geometries:Object;
      
      protected var _totalFrames:int = 0;
      
      protected var _textureSets:Object;
      
      protected var _colladaID:Dictionary;
      
      protected var _currentFrame:int = 0;
      
      protected var _playerType:String;
      
      protected var _rootNode:DisplayObject3D;
      
      protected var _loop:Boolean = false;
      
      protected var _isAnimated:Boolean = false;
      
      protected var _colladaSIDToObject:Object;
      
      protected var _skins:Dictionary;
      
      protected var _controllers:Array;
      
      protected var _queuedMaterials:Array;
      
      protected var _rightHanded:Boolean;
      
      protected var _startTime:Number;
      
      protected var _colladaSID:Dictionary;
      
      public var baseUrl:String;
      
      public var texturePath:String;
      
      protected var _autoPlay:Boolean;
      
      protected var _bindVertexInputs:Dictionary;
      
      public function DAE(param1:Boolean = true, param2:String = null, param3:Boolean = false)
      {
         super(param2);
         _autoPlay = param1;
         _rightHanded = Papervision3D.useRIGHTHANDED;
         _loop = param3;
         _playerType = Capabilities.playerType;
      }
      
      public function stop() : void
      {
         trace("STOP CALLED ON DAE");
         _isPlaying = false;
         dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE,_currentFrame,_totalFrames));
      }
      
      protected function buildSkin(param1:Skin3D, param2:DaeSkin, param3:Array, param4:DaeNode) : void
      {
         var _loc6_:DaeController = null;
         var _loc7_:DaeMorph = null;
         var _loc8_:int = 0;
         var _loc9_:GeometryObject3D = null;
         var _loc5_:GeometryObject3D = _geometries[param2.source];
         if(!_loc5_)
         {
            _loc6_ = this.document.controllers[param2.source];
            if((Boolean(_loc6_)) && Boolean(_loc6_.morph))
            {
               _loc7_ = _loc6_.morph;
               _loc5_ = _geometries[_loc7_.source];
               _loc8_ = 0;
               while(_loc8_ < _loc7_.targets.length)
               {
                  _loc9_ = _geometries[_loc7_.targets[_loc8_]];
                  _loc8_++;
               }
            }
            if(!_loc5_)
            {
               throw new Error("no geometry for source: " + param2.source);
            }
         }
         mergeGeometries(param1.geometry,_loc5_.clone(param1));
         _skins[param1] = param2;
      }
      
      protected function onParseGeometriesComplete(param1:Event) : void
      {
         if(this.parser.hasEventListener(Event.COMPLETE))
         {
            this.parser.removeEventListener(Event.COMPLETE,onParseGeometriesComplete);
         }
         buildScene();
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc3_:IObjectController = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:AbstractChannel3D = null;
         for each(_loc3_ in _controllers)
         {
            _loc3_.update();
         }
         if(_isPlaying && Boolean(_channels))
         {
            _loc4_ = _currentTime / 1000;
            _loc5_ = _endTime - _startTime;
            _loc6_ = getTimer() / 1000 - _loc4_;
            if(_loc6_ > _loc5_)
            {
               _currentTime = getTimer();
               _loc4_ = _currentTime / 1000;
               _loc6_ = 0;
            }
            _loc7_ = _loc6_ / _loc5_;
            if(_loc7_ == 0 && !_loop)
            {
               stop();
            }
            else
            {
               for each(_loc8_ in _channels)
               {
                  _loc8_.updateToTime(_loc7_);
               }
            }
         }
         return super.project(param1,param2);
      }
      
      public function play(param1:String = null) : void
      {
         _currentFrame = 0;
         _currentTime = getTimer();
         _isPlaying = _isAnimated && Boolean(_channels) && Boolean(_channels.length);
      }
      
      public function getAnimationChannelByName(param1:String) : AbstractChannel3D
      {
         return null;
      }
      
      protected function getSymbolName(param1:String) : String
      {
         var _loc2_:DaeEffect = null;
         var _loc3_:DaeEffect = null;
         for each(_loc3_ in this.document.effects)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_.texture_url;
            }
         }
         return null;
      }
      
      protected function loadNextMaterial(param1:FileLoadEvent = null) : void
      {
         var _loc2_:BitmapFileMaterial = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:BitmapFileMaterial = null;
         if(param1)
         {
            _loc2_ = param1.target as BitmapFileMaterial;
            if(_rightHanded && Boolean(_loc2_))
            {
               BitmapMaterialTools.mirrorBitmapX(_loc2_.bitmap);
            }
         }
         if(_queuedMaterials.length)
         {
            _loc3_ = _queuedMaterials.shift();
            _loc4_ = _loc3_.url;
            _loc5_ = _loc3_.symbol;
            _loc6_ = _loc3_.target;
            _loc4_ = _loc4_.replace(/\.tga/i,"." + DEFAULT_TGA_ALTERNATIVE);
            _loc7_ = _loc3_.material;
            _loc7_.addEventListener(FileLoadEvent.LOAD_COMPLETE,loadNextMaterial);
            _loc7_.addEventListener(FileLoadEvent.LOAD_ERROR,onMaterialError);
            _loc7_.texture = _loc4_;
            if(useMaterialTargetName)
            {
               _loc7_.name = _loc6_;
               this.materials.addMaterial(_loc7_,_loc6_);
            }
            else
            {
               _loc7_.name = _loc5_;
               this.materials.addMaterial(_loc7_,_loc5_);
            }
         }
         else
         {
            dispatchEvent(new FileLoadEvent(FileLoadEvent.COLLADA_MATERIALS_DONE,this.filename));
            onMaterialsLoaded();
         }
      }
      
      protected function findChildByID(param1:String, param2:DisplayObject3D = null) : DisplayObject3D
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:DisplayObject3D = null;
         param2 ||= this;
         if(_colladaID[param2] == param1)
         {
            return param2;
         }
         for each(_loc3_ in param2.children)
         {
            _loc4_ = findChildByID(param1,_loc3_);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function buildImagePath(param1:String, param2:String) : String
      {
         if(texturePath != null)
         {
            param2 = texturePath + param2.slice(param2.lastIndexOf("/") + 1);
         }
         var _loc3_:Array = param1.split("/");
         var _loc4_:Array = param2.split("/");
         while(_loc3_[0] == ".")
         {
            _loc3_.shift();
         }
         while(_loc4_[0] == ".")
         {
            _loc4_.shift();
         }
         while(_loc4_[0] == "..")
         {
            _loc4_.shift();
            _loc3_.pop();
         }
         var _loc5_:String = _loc3_.length > 1 ? _loc3_.join("/") : (_loc3_.length ? _loc3_[0] : "");
         return _loc5_ != "" ? _loc5_ + "/" + _loc4_.join("/") : _loc4_.join("/");
      }
      
      protected function onParseError(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      protected function onParseProgress(param1:ProgressEvent) : void
      {
         dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS,this.filename,param1.bytesLoaded,param1.bytesTotal,null,null,true,false));
      }
      
      protected function buildMatrixFromTransform(param1:DaeTransform) : Matrix3D
      {
         var _loc2_:Matrix3D = null;
         var _loc3_:Number = Math.PI / 180;
         var _loc4_:Array = param1.values;
         switch(param1.type)
         {
            case ASCollada.DAE_ROTATE_ELEMENT:
               _loc2_ = Matrix3D.rotationMatrix(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3] * _loc3_);
               break;
            case ASCollada.DAE_SCALE_ELEMENT:
               _loc2_ = Matrix3D.scaleMatrix(_loc4_[0],_loc4_[1],_loc4_[2]);
               break;
            case ASCollada.DAE_TRANSLATE_ELEMENT:
               _loc2_ = Matrix3D.translationMatrix(_loc4_[0],_loc4_[1],_loc4_[2]);
               break;
            case ASCollada.DAE_MATRIX_ELEMENT:
               _loc2_ = new Matrix3D(_loc4_);
               break;
            default:
               throw new Error("Unknown transform type: " + param1.type);
         }
         return _loc2_;
      }
      
      protected function buildMaterials() : void
      {
         var _loc1_:String = null;
         var _loc2_:MaterialObject3D = null;
         var _loc3_:DaeMaterial = null;
         var _loc4_:String = null;
         var _loc5_:MaterialObject3D = null;
         var _loc6_:DaeEffect = null;
         var _loc7_:DaeLambert = null;
         var _loc8_:String = null;
         var _loc9_:DaeImage = null;
         var _loc10_:String = null;
         _queuedMaterials = new Array();
         for(_loc1_ in this.document.materials)
         {
            _loc2_ = null;
            _loc3_ = this.document.materials[_loc1_];
            _loc4_ = this.document.materialTargetToSymbol[_loc3_.id];
            if(useMaterialTargetName)
            {
               _loc5_ = this.materials.getMaterialByName(_loc1_);
            }
            else
            {
               _loc5_ = this.materials.getMaterialByName(_loc4_);
            }
            if(_loc5_ == null)
            {
               _loc8_ = getSymbolName(_loc3_.effect);
               _loc5_ = this.materials.getMaterialByName(_loc8_);
               this.materials.removeMaterial(_loc5_);
               if(_loc5_)
               {
                  if(useMaterialTargetName)
                  {
                     this.materials.addMaterial(_loc5_,_loc1_);
                  }
                  else
                  {
                     this.materials.addMaterial(_loc5_,_loc4_);
                  }
               }
            }
            _loc6_ = document.effects[_loc3_.effect];
            _loc7_ = _loc6_.color as DaeLambert;
            if((Boolean(_loc7_)) && Boolean(_loc7_.diffuse.texture))
            {
               _textureSets[_loc4_] = _loc7_.diffuse.texture.texcoord;
            }
            if(!_loc5_)
            {
               if(Boolean(_loc6_) && Boolean(_loc6_.texture_url))
               {
                  _loc9_ = document.images[_loc6_.texture_url];
                  if(_loc9_)
                  {
                     _loc10_ = buildImagePath(this.baseUrl,_loc9_.init_from);
                     _loc2_ = new BitmapFileMaterial();
                     _loc2_.doubleSided = _loc6_.double_sided;
                     _queuedMaterials.push({
                        "symbol":_loc4_,
                        "url":_loc10_,
                        "material":_loc2_,
                        "target":_loc1_
                     });
                     continue;
                  }
               }
               if(Boolean(_loc7_) && Boolean(_loc7_.diffuse.color))
               {
                  if(_loc6_.wireframe)
                  {
                     _loc2_ = new WireframeMaterial(buildColor(_loc7_.diffuse.color));
                  }
                  else
                  {
                     _loc2_ = new ColorMaterial(buildColor(_loc7_.diffuse.color));
                  }
               }
               else
               {
                  _loc2_ = MaterialObject3D.DEFAULT;
               }
               _loc2_.doubleSided = _loc6_.double_sided;
               if(useMaterialTargetName)
               {
                  this.materials.addMaterial(_loc2_,_loc1_);
               }
               else
               {
                  this.materials.addMaterial(_loc2_,_loc4_);
               }
            }
         }
      }
      
      protected function onMaterialsLoaded() : void
      {
         if(this.parser.hasEventListener(Event.COMPLETE))
         {
            this.parser.removeEventListener(Event.COMPLETE,onParseComplete);
         }
         if(this.parser.hasEventListener(ProgressEvent.PROGRESS))
         {
            this.parser.removeEventListener(ProgressEvent.PROGRESS,onParseProgress);
         }
         if(this.parser.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            this.parser.removeEventListener(IOErrorEvent.IO_ERROR,onParseError);
         }
         if(document.numQueuedGeometries)
         {
            this.parser.addEventListener(Event.COMPLETE,onParseGeometriesComplete);
            this.parser.readGeometries();
         }
         else
         {
            buildScene();
         }
      }
      
      protected function buildAnimationChannel(param1:DisplayObject3D, param2:DaeChannel) : MatrixChannel3D
      {
         var _loc6_:Matrix3D = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc3_:DaeNode = _objectToNode[param1];
         if(!_loc3_)
         {
            throw new Error("Couldn\'t find the targeted object!");
         }
         var _loc4_:MatrixChannel3D = new MatrixChannel3D(param1,param2.syntax.targetSID);
         var _loc5_:DaeTransform = _loc3_.findMatrixBySID(param2.syntax.targetSID);
         if(!_loc5_)
         {
            PaperLogger.warning("Couldn\'t find the targeted object\'s transform: " + param2.syntax.targetSID);
            return null;
         }
         if(param2.syntax.isArrayAccess)
         {
            _loc8_ = param2.syntax.arrayMember.join("");
            switch(_loc8_)
            {
               case "(0)(0)":
                  _loc7_ = "n11";
                  break;
               case "(1)(0)":
                  _loc7_ = "n12";
                  break;
               case "(2)(0)":
                  _loc7_ = "n13";
                  break;
               case "(3)(0)":
                  _loc7_ = "n14";
                  break;
               case "(0)(1)":
                  _loc7_ = "n21";
                  break;
               case "(1)(1)":
                  _loc7_ = "n22";
                  break;
               case "(2)(1)":
                  _loc7_ = "n23";
                  break;
               case "(3)(1)":
                  _loc7_ = "n24";
                  break;
               case "(0)(2)":
                  _loc7_ = "n31";
                  break;
               case "(1)(2)":
                  _loc7_ = "n32";
                  break;
               case "(2)(2)":
                  _loc7_ = "n33";
                  break;
               case "(3)(2)":
                  _loc7_ = "n34";
                  break;
               case "(0)(3)":
                  _loc7_ = "n41";
                  break;
               case "(1)(3)":
                  _loc7_ = "n42";
                  break;
               case "(2)(3)":
                  _loc7_ = "n43";
                  break;
               case "(3)(3)":
                  _loc7_ = "n44";
                  break;
               default:
                  throw new Error(_loc8_);
            }
         }
         switch(_loc5_.type)
         {
            case "matrix":
               if(param2.syntax.isFullAccess)
               {
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc9_ = param2.output[_loc11_];
                     _loc6_ = new Matrix3D(_loc9_);
                     _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                     _loc11_++;
                  }
               }
               else
               {
                  if(!param2.syntax.isArrayAccess)
                  {
                     throw new Error("Don\'t know how to handle this channel: " + param2.syntax);
                  }
                  _loc6_ = Matrix3D.clone(param1.transform);
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc6_[_loc7_] = param2.output[_loc11_];
                     _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                     _loc11_++;
                  }
               }
               break;
            case "rotate":
               if(param2.syntax.isFullAccess)
               {
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc9_ = param2.output[_loc11_];
                     _loc6_ = Matrix3D.rotationMatrix(_loc9_[0],_loc9_[1],_loc9_[2],_loc9_[3] * (Math.PI / 180));
                     _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                     _loc11_++;
                  }
               }
               else
               {
                  if(!param2.syntax.isDotAccess)
                  {
                     throw new Error("Don\'t know how to handle this channel: " + param2.syntax);
                  }
                  switch(param2.syntax.member)
                  {
                     case "ANGLE":
                        _loc11_ = 0;
                        while(_loc11_ < param2.input.length)
                        {
                           _loc12_ = param2.output[_loc11_] * (Math.PI / 180);
                           _loc6_ = Matrix3D.rotationMatrix(_loc5_.values[0],_loc5_.values[1],_loc5_.values[2],_loc12_);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           _loc11_++;
                        }
                        break;
                     default:
                        throw new Error("Don\'t know how to handle this channel: " + param2.syntax);
                  }
               }
               break;
            case "scale":
               if(param2.syntax.isFullAccess)
               {
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc9_ = param2.output[_loc11_];
                     _loc6_ = Matrix3D.scaleMatrix(_loc9_[0],_loc9_[1],_loc9_[2]);
                     _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                     _loc11_++;
                  }
               }
               else
               {
                  if(!param2.syntax.isDotAccess)
                  {
                     throw new Error("Don\'t know how to handle this channel: " + param2.syntax);
                  }
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc10_ = Number(param2.output[_loc11_]);
                     switch(param2.syntax.member)
                     {
                        case "X":
                           _loc6_ = Matrix3D.scaleMatrix(_loc10_,0,0);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                        case "Y":
                           _loc6_ = Matrix3D.scaleMatrix(0,_loc10_,0);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                        case "Z":
                           _loc6_ = Matrix3D.scaleMatrix(0,0,_loc10_);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                     }
                     _loc11_++;
                  }
               }
               break;
            case "translate":
               if(param2.syntax.isFullAccess)
               {
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc9_ = param2.output[_loc11_];
                     _loc6_ = Matrix3D.translationMatrix(_loc9_[0],_loc9_[1],_loc9_[2]);
                     _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                     _loc11_++;
                  }
               }
               else
               {
                  if(!param2.syntax.isDotAccess)
                  {
                     throw new Error("Don\'t know how to handle this channel: " + param2.syntax);
                  }
                  _loc11_ = 0;
                  while(_loc11_ < param2.input.length)
                  {
                     _loc10_ = Number(param2.output[_loc11_]);
                     switch(param2.syntax.member)
                     {
                        case "X":
                           _loc6_ = Matrix3D.translationMatrix(_loc10_,0,0);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                        case "Y":
                           _loc6_ = Matrix3D.translationMatrix(0,_loc10_,0);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                        case "Z":
                           _loc6_ = Matrix3D.translationMatrix(0,0,_loc10_);
                           _loc4_.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + _loc11_,param2.input[_loc11_],[_loc6_]));
                           break;
                     }
                     _loc11_++;
                  }
               }
               break;
            default:
               throw new Error("Unknown transform type!");
         }
         return _loc4_;
      }
      
      protected function onMaterialError(param1:Event) : void
      {
         loadNextMaterial();
      }
      
      protected function onParseComplete(param1:Event) : void
      {
         var _loc2_:DaeReader = param1.target as DaeReader;
         this.document = _loc2_.document;
         _textureSets = new Object();
         _colladaID = new Dictionary(true);
         _colladaSID = new Dictionary(true);
         _colladaIDToObject = new Object();
         _colladaSIDToObject = new Object();
         _objectToNode = new Object();
         _skins = new Dictionary(true);
         buildMaterials();
         loadNextMaterial();
      }
      
      protected function buildVertices(param1:DaeMesh) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.vertices.length)
         {
            _loc2_.push(new Vertex3D(param1.vertices[_loc3_][0],param1.vertices[_loc3_][1],param1.vertices[_loc3_][2]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function buildNode(param1:DaeNode, param2:DisplayObject3D) : void
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:MaterialObject3D = null;
         var _loc5_:int = 0;
         var _loc6_:DaeInstanceController = null;
         var _loc7_:DaeController = null;
         var _loc8_:DaeInstanceGeometry = null;
         var _loc9_:GeometryObject3D = null;
         var _loc10_:Array = null;
         var _loc11_:DaeInstanceMaterial = null;
         var _loc12_:DaeNode = null;
         if(param1.controllers.length)
         {
            _loc5_ = 0;
            if(_loc5_ < param1.controllers.length)
            {
               _loc6_ = param1.controllers[_loc5_];
               _loc7_ = document.controllers[_loc6_.url];
               if(!_loc7_.skin)
               {
                  if(_loc7_.morph)
                  {
                     throw new Error("morph!");
                  }
                  throw new Error("A COLLADA controller should be of type <skin> or <morph>!");
               }
               _loc3_ = new Skin3D(null,[],[],param1.name);
               buildSkin(_loc3_ as Skin3D,_loc7_.skin,_loc6_.skeletons,param1);
            }
         }
         else if(param1.geometries.length)
         {
            _loc3_ = new TriangleMesh3D(null,[],[],param1.name);
            for each(_loc8_ in param1.geometries)
            {
               _loc9_ = _geometries[_loc8_.url];
               if(_loc9_)
               {
                  if(_geometries[_loc8_.url] is Lines3D)
                  {
                     _loc3_.addChild(_geometries[_loc8_.url]);
                  }
                  else
                  {
                     _loc10_ = new Array();
                     if(_loc8_.materials)
                     {
                        for each(_loc11_ in _loc8_.materials)
                        {
                           if(useMaterialTargetName)
                           {
                              _loc4_ = this.materials.getMaterialByName(_loc11_.target);
                           }
                           else
                           {
                              _loc4_ = this.materials.getMaterialByName(_loc11_.symbol);
                           }
                           if(_loc4_)
                           {
                              _bindVertexInputs[_loc4_] = _loc11_;
                              if(_loc4_ is AbstractLightShadeMaterial || _loc4_ is ShadedMaterial)
                              {
                                 _loc4_.registerObject(_loc3_);
                              }
                              _loc10_.push(_loc4_);
                           }
                        }
                     }
                     mergeGeometries(_loc3_.geometry,_loc9_.clone(_loc3_),_loc10_);
                  }
               }
            }
         }
         else
         {
            _loc3_ = new DisplayObject3D(param1.name);
         }
         _loc5_ = 0;
         while(_loc5_ < param1.instance_nodes.length)
         {
            _loc12_ = document.getDaeNodeById(param1.instance_nodes[_loc5_].url);
            buildNode(_loc12_,_loc3_);
            _loc5_++;
         }
         _loc3_.copyTransform(buildMatrix(param1));
         _loc5_ = 0;
         while(_loc5_ < param1.nodes.length)
         {
            buildNode(param1.nodes[_loc5_],_loc3_);
            _loc5_++;
         }
         _colladaID[_loc3_] = param1.id;
         _colladaSID[_loc3_] = param1.sid;
         _colladaIDToObject[param1.id] = _loc3_;
         _colladaSIDToObject[param1.sid] = _loc3_;
         _objectToNode[_loc3_] = param1;
         _loc3_.flipLightDirection = true;
         param2.addChild(_loc3_);
      }
      
      protected function buildGeometries() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DaeGeometry = null;
         var _loc5_:GeometryObject3D = null;
         var _loc6_:Lines3D = null;
         var _loc7_:DaeSpline = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:Line3D = null;
         _geometries = new Object();
         for each(_loc4_ in this.document.geometries)
         {
            if(_loc4_.mesh)
            {
               _loc5_ = new GeometryObject3D();
               _loc5_.vertices = buildVertices(_loc4_.mesh);
               _loc5_.faces = new Array();
               if(_loc5_.vertices.length)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc4_.mesh.primitives.length)
                  {
                     buildFaces(_loc4_.mesh.primitives[_loc1_],_loc5_,0);
                     _loc1_++;
                  }
                  _geometries[_loc4_.id] = _loc5_;
               }
            }
            else if(Boolean(_loc4_.spline) && Boolean(_loc4_.splines))
            {
               _loc6_ = new Lines3D(new LineMaterial(DEFAULT_LINE_COLOR),_loc4_.id);
               _loc1_ = 0;
               while(_loc1_ < _loc4_.splines.length)
               {
                  _loc7_ = _loc4_.splines[_loc1_];
                  _loc2_ = 0;
                  while(_loc2_ < _loc7_.vertices.length)
                  {
                     _loc3_ = (_loc2_ + 1) % _loc7_.vertices.length;
                     _loc8_ = new Vertex3D(_loc7_.vertices[_loc2_][0],_loc7_.vertices[_loc2_][1],_loc7_.vertices[_loc2_][2]);
                     _loc9_ = new Vertex3D(_loc7_.vertices[_loc3_][0],_loc7_.vertices[_loc3_][1],_loc7_.vertices[_loc3_][2]);
                     _loc10_ = new Line3D(_loc6_,_loc6_.material as LineMaterial,DEFAULT_LINE_WIDTH,_loc8_,_loc9_);
                     _loc6_.addLine(_loc10_);
                     _loc2_++;
                  }
                  _loc1_++;
               }
               _geometries[_loc4_.id] = _loc6_;
            }
         }
      }
      
      protected function buildColor(param1:Array) : uint
      {
         var _loc2_:uint = param1[0] * 255;
         var _loc3_:uint = param1[1] * 255;
         var _loc4_:uint = param1[2] * 255;
         return _loc2_ << 16 | _loc3_ << 8 | _loc4_;
      }
      
      public function getAnimationChannelsByClip(param1:String) : Array
      {
         return null;
      }
      
      protected function buildAnimationChannels() : void
      {
         var _loc1_:DisplayObject3D = null;
         var _loc2_:DaeChannel = null;
         var _loc4_:int = 0;
         var _loc5_:DaeAnimation = null;
         var _loc6_:* = undefined;
         var _loc7_:Array = null;
         var _loc8_:DaeNode = null;
         var _loc9_:DaeTransform = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:Object = null;
         var _loc14_:MatrixChannel3D = null;
         var _loc15_:Number = NaN;
         var _loc16_:MatrixChannel3D = null;
         var _loc17_:Number = NaN;
         var _loc18_:Matrix3D = null;
         var _loc19_:int = 0;
         var _loc20_:MatrixChannel3D = null;
         var _loc21_:Number = NaN;
         var _loc3_:Dictionary = new Dictionary(true);
         _channelsByTarget = new Dictionary(true);
         for each(_loc5_ in this.document.animations)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.channels.length)
            {
               _loc2_ = _loc5_.channels[_loc4_];
               _loc1_ = _colladaIDToObject[_loc2_.syntax.targetID];
               if(!_loc1_)
               {
                  throw new Error("damn");
               }
               if(!_loc3_[_loc1_])
               {
                  _loc3_[_loc1_] = new Array();
               }
               _loc3_[_loc1_].push(_loc2_);
               _loc4_++;
            }
         }
         for(_loc6_ in _loc3_)
         {
            _loc1_ = _loc6_ as DisplayObject3D;
            _loc7_ = _loc3_[_loc6_];
            _loc8_ = _objectToNode[_loc1_];
            if(!_loc8_)
            {
               throw new Error("Couldn\'t find the targeted object with name \'" + _loc8_.name + "\'");
            }
            _loc8_.channels = _loc7_;
            if(_loc7_.length)
            {
               _loc2_ = _loc7_[0];
               _loc9_ = _loc8_.findMatrixBySID(_loc2_.syntax.targetSID);
               if(!_loc9_)
               {
                  PaperLogger.warning("Could not find a transform with SID=" + _loc2_.syntax.targetSID);
               }
               else if(_loc7_.length == 1 && _loc9_.type == ASCollada.DAE_MATRIX_ELEMENT)
               {
                  _channelsByTarget[_loc1_] = [buildAnimationChannel(_loc1_,_loc2_)];
               }
               else
               {
                  _loc10_ = new Array();
                  _loc11_ = new Array();
                  for each(_loc2_ in _loc7_)
                  {
                     _loc10_ = _loc10_.concat(_loc2_.input);
                  }
                  _loc10_.sort(Array.NUMERIC);
                  _loc4_ = 0;
                  while(_loc4_ < _loc10_.length)
                  {
                     _loc15_ = Number(_loc10_[_loc4_]);
                     if(_loc4_ == 0)
                     {
                        _loc11_.push(_loc15_);
                     }
                     else if(_loc15_ - _loc12_ > 0.01)
                     {
                        _loc11_.push(_loc15_);
                     }
                     _loc12_ = _loc15_;
                     _loc4_++;
                  }
                  _loc13_ = new Object();
                  for each(_loc2_ in _loc7_)
                  {
                     _loc16_ = buildAnimationChannel(_loc1_,_loc2_);
                     if(_loc16_)
                     {
                        _loc13_[_loc2_.syntax.targetSID] = buildAnimationChannel(_loc1_,_loc2_);
                     }
                  }
                  _loc14_ = new MatrixChannel3D(_loc1_);
                  _loc4_ = 0;
                  while(_loc4_ < _loc11_.length)
                  {
                     _loc17_ = Number(_loc11_[_loc4_]);
                     _loc18_ = Matrix3D.IDENTITY;
                     _loc19_ = 0;
                     while(_loc19_ < _loc8_.transforms.length)
                     {
                        _loc9_ = _loc8_.transforms[_loc19_];
                        _loc20_ = _loc13_[_loc9_.sid];
                        if(_loc20_)
                        {
                           if(_loc17_ < _loc20_.startTime)
                           {
                              _loc21_ = 0;
                           }
                           else if(_loc17_ > _loc20_.endTime)
                           {
                              _loc21_ = 1;
                           }
                           else
                           {
                              _loc21_ = _loc17_ / (_loc20_.endTime - _loc20_.startTime);
                           }
                           _loc20_.updateToTime(_loc21_);
                           _loc18_ = Matrix3D.multiply(_loc18_,_loc1_.transform);
                        }
                        else
                        {
                           _loc18_ = Matrix3D.multiply(_loc18_,buildMatrixFromTransform(_loc9_));
                        }
                        _loc19_++;
                     }
                     _loc14_.addKeyFrame(new AnimationKeyFrame3D("frame_" + _loc4_,_loc17_,[_loc18_]));
                     _loc4_++;
                  }
                  _channelsByTarget[_loc1_] = [_loc14_];
               }
            }
         }
      }
      
      protected function linkSkin(param1:DisplayObject3D, param2:DaeSkin) : void
      {
         var _loc3_:int = 0;
         var _loc6_:String = null;
         var _loc7_:DisplayObject3D = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc4_:Object = new Object();
         var _loc5_:SkinController = new SkinController(param1 as Skin3D);
         _loc5_.bindShapeMatrix = new Matrix3D(param2.bind_shape_matrix);
         _loc5_.joints = new Array();
         _loc5_.vertexWeights = new Array();
         _loc5_.invBindMatrices = new Array();
         _loc3_ = 0;
         while(_loc3_ < param2.joints.length)
         {
            _loc6_ = param2.joints[_loc3_];
            if(!_loc4_[_loc6_])
            {
               _loc7_ = _colladaIDToObject[_loc6_];
               if(!_loc7_)
               {
                  _loc7_ = _colladaSIDToObject[_loc6_];
               }
               if(!_loc7_)
               {
                  throw new Error("Couldn\'t find the joint id = " + _loc6_);
               }
               _loc8_ = param2.findJointVertexWeightsByIDOrSID(_loc6_);
               if(!_loc8_)
               {
                  throw new Error("Could not find vertex weights for joint with id = " + _loc6_);
               }
               _loc9_ = param2.findJointBindMatrix2(_loc6_);
               if(!_loc9_ || _loc9_.length != 16)
               {
                  throw new Error("Could not find inverse bind matrix for joint with id = " + _loc6_);
               }
               _loc5_.joints.push(_loc7_);
               _loc5_.invBindMatrices.push(new Matrix3D(_loc9_));
               _loc5_.vertexWeights.push(_loc8_);
               _loc4_[_loc6_] = true;
            }
            _loc3_++;
         }
         _controllers.push(_loc5_);
      }
      
      protected function buildScene() : void
      {
         _controllers = new Array();
         buildGeometries();
         _rootNode = new DisplayObject3D(ROOTNODE_NAME);
         var _loc1_:int = 0;
         while(_loc1_ < this.document.vscene.nodes.length)
         {
            buildNode(this.document.vscene.nodes[_loc1_],_rootNode);
            _loc1_++;
         }
         linkSkins();
         this.addChild(_rootNode);
         if(!this.yUp)
         {
            _rootNode.rotationX = -90;
            _rootNode.rotationY = 180;
         }
         if(!_rightHanded)
         {
            _rootNode.scaleX = -_rootNode.scaleX;
         }
         _currentFrame = 0;
         _totalFrames = 0;
         _startTime = _endTime = 0;
         _channels = new Array();
         _isAnimated = false;
         _isPlaying = false;
         if(document.numQueuedAnimations)
         {
            _isAnimated = true;
            this.parser.addEventListener(Event.COMPLETE,onParseAnimationsComplete);
            this.parser.addEventListener(ProgressEvent.PROGRESS,onParseAnimationsProgress);
            this.parser.readAnimations();
         }
         dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE,this.filename));
      }
      
      protected function isBakedMatrix(param1:DaeNode) : Boolean
      {
         if(!param1.transforms.length || param1.transforms.length > 1)
         {
            return false;
         }
         var _loc2_:DaeTransform = param1.transforms[0];
         return _loc2_.type == ASCollada.DAE_MATERIAL_ELEMENT;
      }
      
      protected function linkSkins() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:TriangleMesh3D = null;
         _numSkins = 0;
         for(_loc1_ in _skins)
         {
            _loc2_ = _loc1_ as TriangleMesh3D;
            if(!_loc2_)
            {
               throw new Error("Not a Skin3D?");
            }
            linkSkin(_loc2_,_skins[_loc1_]);
            ++_numSkins;
         }
      }
      
      public function getAnimationChannels(param1:DisplayObject3D = null) : Array
      {
         var _loc3_:Array = null;
         var _loc2_:Array = new Array();
         if(param1 == null)
         {
            for each(_loc3_ in _channelsByTarget)
            {
               _loc2_ = _loc2_.concat(_loc3_);
            }
         }
         else
         {
            if(!_channelsByTarget[param1])
            {
               return null;
            }
            _loc2_ = _loc2_.concat(_channelsByTarget[param1]);
         }
         return _loc2_;
      }
      
      protected function buildMatrix(param1:DaeNode) : Matrix3D
      {
         var _loc2_:Array = buildMatrixStack(param1);
         var _loc3_:Matrix3D = Matrix3D.IDENTITY;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.calculateMultiply4x4(_loc3_,_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function findChildBySID(param1:String, param2:DisplayObject3D = null) : DisplayObject3D
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:DisplayObject3D = null;
         param2 ||= this;
         if(_colladaSID[param2] == param1)
         {
            return param2;
         }
         for each(_loc3_ in param2.children)
         {
            _loc4_ = findChildBySID(param1,_loc3_);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function buildFileInfo(param1:*) : void
      {
         var _loc2_:Array = null;
         this.filename = param1 is String ? String(param1) : "./meshes/rawdata_dae";
         this.filename = this.filename.split("\\").join("/");
         if(this.filename.indexOf("/") != -1)
         {
            _loc2_ = this.filename.split("/");
            this.fileTitle = String(_loc2_.pop());
            this.baseUrl = _loc2_.join("/");
         }
         else
         {
            this.fileTitle = this.filename;
            this.baseUrl = "";
         }
      }
      
      public function load(param1:*, param2:MaterialsList = null, param3:Boolean = false) : void
      {
         this.materials = param2 || new MaterialsList();
         buildFileInfo(param1);
         _bindVertexInputs = new Dictionary(true);
         this.parser = new DaeReader(param3);
         this.parser.addEventListener(Event.COMPLETE,onParseComplete);
         this.parser.addEventListener(ProgressEvent.PROGRESS,onParseProgress);
         this.parser.addEventListener(IOErrorEvent.IO_ERROR,onParseError);
         if(param1 is XML)
         {
            this.COLLADA = param1 as XML;
            this.parser.loadDocument(param1);
         }
         else if(param1 is ByteArray)
         {
            this.COLLADA = new XML(ByteArray(param1));
            this.parser.loadDocument(param1);
         }
         else
         {
            if(!(param1 is String))
            {
               throw new Error("load : unknown asset type!");
            }
            this.filename = String(param1);
            this.parser.read(this.filename);
         }
      }
      
      protected function buildFaces(param1:DaePrimitive, param2:GeometryObject3D, param3:uint) : void
      {
         var _loc12_:int = 0;
         var _loc14_:int = 0;
         var _loc19_:DaeInstanceGeometry = null;
         var _loc20_:DaeBindVertexInput = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:Array = null;
         var _loc4_:Array = new Array();
         var _loc5_:MaterialObject3D = this.materials.getMaterialByName(param1.material);
         _loc5_ = (_loc5_) || MaterialObject3D.DEFAULT;
         var _loc6_:DaeInstanceMaterial = _bindVertexInputs[_loc5_];
         var _loc7_:int = this.forceCoordSet;
         var _loc8_:String = _textureSets[param1.material];
         var _loc9_:DaeGeometry = param1.mesh.geometry;
         if(_loc8_ && _loc8_.length && Boolean(_loc9_))
         {
            _loc19_ = this.document.getDaeInstanceGeometry(_loc9_.id);
            if(_loc19_)
            {
               _loc20_ = _loc19_.findBindVertexInput(param1.material,_loc8_);
               if(_loc20_)
               {
                  PaperLogger.info("using input set #" + _loc20_.input_set + " for material " + param1.material);
                  _loc7_ = _loc20_.input_set;
               }
            }
         }
         var _loc10_:Array = param1.getTexCoords(_loc7_);
         var _loc11_:Array = new Array();
         var _loc13_:int = 0;
         _loc12_ = 0;
         while(_loc12_ < _loc10_.length)
         {
            _loc11_.push(new NumberUV(_loc10_[_loc12_][0],_loc10_[_loc12_][1]));
            _loc12_++;
         }
         var _loc15_:* = _loc11_.length == param1.vertices.length;
         var _loc16_:Array = new Array();
         var _loc17_:Array = new Array();
         var _loc18_:Array = new Array();
         switch(param1.type)
         {
            case ASCollada.DAE_LINES_ELEMENT:
               _loc12_ = 0;
               while(_loc12_ < param1.vertices.length)
               {
                  _loc17_[0] = param2.vertices[param1.vertices[_loc12_]];
                  _loc17_[1] = param2.vertices[param1.vertices[_loc12_ + 1]];
                  _loc18_[0] = _loc15_ ? _loc11_[_loc12_] : new NumberUV();
                  _loc18_[1] = _loc15_ ? _loc11_[_loc12_ + 1] : new NumberUV();
                  _loc12_ += 2;
               }
               break;
            case ASCollada.DAE_TRIANGLES_ELEMENT:
               _loc12_ = 0;
               _loc13_ = 0;
               while(_loc12_ < param1.vertices.length)
               {
                  _loc16_[0] = param3 + param1.vertices[_loc12_];
                  _loc16_[1] = param3 + param1.vertices[_loc12_ + 1];
                  _loc16_[2] = param3 + param1.vertices[_loc12_ + 2];
                  _loc17_[0] = param2.vertices[_loc16_[0]];
                  _loc17_[1] = param2.vertices[_loc16_[1]];
                  _loc17_[2] = param2.vertices[_loc16_[2]];
                  _loc18_[0] = _loc15_ ? _loc11_[_loc12_ + 0] : new NumberUV();
                  _loc18_[1] = _loc15_ ? _loc11_[_loc12_ + 1] : new NumberUV();
                  _loc18_[2] = _loc15_ ? _loc11_[_loc12_ + 2] : new NumberUV();
                  param2.faces.push(new Triangle3D(null,[_loc17_[0],_loc17_[1],_loc17_[2]],_loc5_,[_loc18_[0],_loc18_[1],_loc18_[2]]));
                  _loc12_ += 3;
                  _loc13_++;
               }
               break;
            case ASCollada.DAE_POLYLIST_ELEMENT:
               _loc12_ = 0;
               _loc14_ = 0;
               while(_loc12_ < param1.vcount.length)
               {
                  _loc21_ = new Array();
                  _loc22_ = new Array();
                  _loc13_ = 0;
                  while(_loc13_ < param1.vcount[_loc12_])
                  {
                     _loc22_.push(_loc15_ ? _loc11_[_loc14_] : new NumberUV());
                     _loc21_.push(param2.vertices[param1.vertices[_loc14_++]]);
                     _loc13_++;
                  }
                  if(!param2 || !param2.faces || !param2.vertices)
                  {
                     throw new Error("no geometry");
                  }
                  _loc17_[0] = _loc21_[0];
                  _loc18_[0] = _loc22_[0];
                  _loc13_ = 1;
                  while(_loc13_ < _loc21_.length - 1)
                  {
                     _loc17_[1] = _loc21_[_loc13_];
                     _loc17_[2] = _loc21_[_loc13_ + 1];
                     _loc18_[1] = _loc22_[_loc13_];
                     _loc18_[2] = _loc22_[_loc13_ + 1];
                     if(_loc17_[0] is Vertex3D && _loc17_[1] is Vertex3D && _loc17_[2] is Vertex3D)
                     {
                        param2.faces.push(new Triangle3D(null,[_loc17_[0],_loc17_[1],_loc17_[2]],_loc5_,[_loc18_[0],_loc18_[1],_loc18_[2]]));
                     }
                     _loc13_++;
                  }
                  _loc12_++;
               }
               break;
            case ASCollada.DAE_POLYGONS_ELEMENT:
               _loc12_ = 0;
               _loc14_ = 0;
               while(_loc12_ < param1.polygons.length)
               {
                  _loc23_ = param1.polygons[_loc12_];
                  _loc24_ = new Array();
                  _loc25_ = new Array();
                  _loc13_ = 0;
                  while(_loc13_ < _loc23_.length)
                  {
                     _loc25_.push(_loc15_ ? _loc11_[_loc14_] : new NumberUV());
                     _loc24_.push(param2.vertices[param1.vertices[_loc14_++]]);
                     _loc13_++;
                  }
                  _loc17_[0] = _loc24_[0];
                  _loc18_[0] = _loc25_[0];
                  _loc13_ = 1;
                  while(_loc13_ < _loc24_.length - 1)
                  {
                     _loc17_[1] = _loc24_[_loc13_];
                     _loc17_[2] = _loc24_[_loc13_ + 1];
                     _loc18_[1] = _loc25_[_loc13_];
                     _loc18_[2] = _loc25_[_loc13_ + 1];
                     param2.faces.push(new Triangle3D(null,[_loc17_[0],_loc17_[1],_loc17_[2]],_loc5_,[_loc18_[0],_loc18_[1],_loc18_[2]]));
                     _loc13_++;
                  }
                  _loc12_++;
               }
               break;
            default:
               throw new Error("Don\'t know how to create face for a DaePrimitive with type = " + param1.type);
         }
      }
      
      public function get fps() : uint
      {
         return 20;
      }
      
      protected function mergeGeometries(param1:GeometryObject3D, param2:GeometryObject3D, param3:Array = null) : void
      {
         var _loc4_:MaterialObject3D = null;
         var _loc5_:Triangle3D = null;
         var _loc6_:Boolean = false;
         var _loc7_:MaterialObject3D = null;
         if(Boolean(param3) && Boolean(param3.length))
         {
            _loc4_ = param3[0];
            for each(_loc5_ in param2.faces)
            {
               _loc6_ = false;
               for each(_loc7_ in param3)
               {
                  if(_loc7_ === _loc5_.material)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               _loc5_.material = _loc6_ ? _loc5_.material : _loc4_;
            }
         }
         param1.vertices = param1.vertices.concat(param2.vertices);
         param1.faces = param1.faces.concat(param2.faces);
         param1.ready = true;
      }
      
      public function get yUp() : Boolean
      {
         if(this.document)
         {
            return this.document.asset.yUp == ASCollada.DAE_Y_UP;
         }
         return false;
      }
      
      protected function onParseAnimationsProgress(param1:ProgressEvent) : void
      {
         PaperLogger.info("animations #" + param1.bytesLoaded + " of " + param1.bytesTotal);
         dispatchEvent(new FileLoadEvent(FileLoadEvent.ANIMATIONS_PROGRESS,this.filename,param1.bytesLoaded,param1.bytesTotal));
      }
      
      protected function buildMatrixStack(param1:DaeNode) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.transforms.length)
         {
            _loc2_.push(buildMatrixFromTransform(param1.transforms[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function onParseAnimationsComplete(param1:Event) : void
      {
         var _loc2_:AbstractChannel3D = null;
         buildAnimationChannels();
         _channels = this.getAnimationChannels() || new Array();
         _currentFrame = _totalFrames = 0;
         _startTime = _endTime = 0;
         for each(_loc2_ in _channels)
         {
            _totalFrames = Math.max(_totalFrames,_loc2_.keyFrames.length);
            _startTime = Math.min(_startTime,_loc2_.startTime);
            _endTime = Math.max(_endTime,_loc2_.endTime);
            _loc2_.updateToTime(0);
         }
         PaperLogger.info("animations COMPLETE (#channels: " + _channels.length + " #frames: " + _totalFrames + ", startTime: " + _startTime + " endTime: " + _endTime + ")");
         dispatchEvent(new FileLoadEvent(FileLoadEvent.ANIMATIONS_COMPLETE,this.filename));
         if(_autoPlay)
         {
            play();
         }
      }
      
      override public function removeChild(param1:DisplayObject3D) : DisplayObject3D
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:DisplayObject3D = null;
         var _loc2_:DisplayObject3D = getChildByName(param1.name,true);
         if(_loc2_)
         {
            _loc3_ = DisplayObject3D(_loc2_.parent);
            if(_loc3_)
            {
               _loc4_ = _loc3_.removeChild(_loc2_);
               if(_loc4_)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
   }
}

