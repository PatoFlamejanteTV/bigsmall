package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.fx.DaeEffect;
   import org.ascollada.fx.DaeMaterial;
   import org.ascollada.namespaces.*;
   import org.ascollada.physics.DaePhysicsScene;
   import org.ascollada.utils.Logger;
   
   public class DaeDocument extends DaeEntity
   {
      
      public static const X_UP:uint = 0;
      
      public static const Y_UP:uint = 1;
      
      public static const Z_UP:uint = 2;
      
      public var effects:Object;
      
      public var geometries:Object;
      
      public var COLLADA:XML;
      
      public var pscene:DaePhysicsScene;
      
      private var _waitingAnimations:Array;
      
      public var animation_clips:Object;
      
      public var materialSymbolToTarget:Object;
      
      public var materials:Object;
      
      public var nodes:Object;
      
      public var materialTargetToSymbol:Object;
      
      private var _waitingGeometries:Array;
      
      public var visual_scenes:Object;
      
      public var controllers:Object;
      
      public var vscene:DaeVisualScene;
      
      public var physics_scenes:Object;
      
      public var version:String;
      
      public var yUp:uint;
      
      public var cameras:Object;
      
      public var animations:Object;
      
      public var images:Object;
      
      public function DaeDocument(param1:Object, param2:Boolean = false)
      {
         this.COLLADA = param1 is XML ? param1 as XML : new XML(param1);
         XML.ignoreWhitespace = true;
         super(this.COLLADA,param2);
      }
      
      private function readLibVisualScenes() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeVisualScene = null;
         this.visual_scenes = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_VSCENE_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_VSCENE_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeVisualScene(_loc3_,yUp);
               this.visual_scenes[_loc4_.id] = _loc4_;
               this.vscene = _loc4_;
            }
         }
      }
      
      public function get numQueuedGeometries() : uint
      {
         return _waitingGeometries.length;
      }
      
      private function readLibImages() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeImage = null;
         this.images = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_IMAGE_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_IMAGE_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeImage(_loc3_);
               this.images[_loc4_.id] = _loc4_;
            }
         }
      }
      
      override public function read(param1:XML) : void
      {
         this.version = param1.attribute(ASCollada.DAE_VERSION_ATTRIBUTE).toString();
         Logger.log("version: " + this.version);
         this.asset = new DaeAsset(getNode(this.COLLADA,ASCollada.DAE_ASSET_ELEMENT));
         if(Boolean(this.asset.contributors) && Boolean(this.asset.contributors[0].author))
         {
            Logger.log("author: " + this.asset.contributors[0].author);
         }
         Logger.log("created: " + this.asset.created);
         Logger.log("modified: " + this.asset.modified);
         Logger.log("y-up: " + this.asset.yUp);
         Logger.log("unit_meter: " + this.asset.unit_meter);
         Logger.log("unit_name: " + this.asset.unit_name);
         if(this.asset.yUp == ASCollada.DAE_Y_UP)
         {
            this.yUp = Y_UP;
         }
         else
         {
            this.yUp = Z_UP;
         }
         buildMaterialTable();
         readLibAnimationClips();
         readLibCameras();
         readLibControllers();
         readLibAnimations();
         readLibImages();
         readLibMaterials();
         readLibEffects();
         readLibGeometries(this.async);
         readLibNodes();
         readLibPhysicsScenes();
         readLibVisualScenes();
         readScene();
      }
      
      private function buildMaterialTable() : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         materialSymbolToTarget = new Object();
         materialTargetToSymbol = new Object();
         var _loc1_:XMLList = this.COLLADA..collada::instance_material;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = getAttribute(_loc2_,ASCollada.DAE_TARGET_ATTRIBUTE);
            _loc4_ = getAttribute(_loc2_,ASCollada.DAE_SYMBOL_ATTRIBUTE);
            materialSymbolToTarget[_loc4_] = _loc3_;
            materialTargetToSymbol[_loc3_] = _loc4_;
         }
      }
      
      private function findDaeNodeById(param1:DaeNode, param2:String, param3:Boolean = false) : DaeNode
      {
         var _loc5_:DaeNode = null;
         if(param3)
         {
            if(param1.sid == param2)
            {
               return param1;
            }
         }
         else if(param1.id == param2)
         {
            return param1;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.nodes.length)
         {
            _loc5_ = findDaeNodeById(param1.nodes[_loc4_],param2,param3);
            if(_loc5_)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getDaeNodeByIdOrSID(param1:String) : DaeNode
      {
         var _loc2_:DaeNode = getDaeNodeById(param1,false);
         if(!_loc2_)
         {
            _loc2_ = getDaeNodeById(param1,true);
         }
         return _loc2_;
      }
      
      public function readNextGeometry() : Boolean
      {
         var geometry:DaeGeometry = null;
         var geomLib:XML = null;
         var geomNode:XML = null;
         if(_waitingGeometries.length)
         {
            try
            {
               geometry = _waitingGeometries.shift() as DaeGeometry;
               geomLib = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_GEOMETRY_ELEMENT);
               geomNode = getNodeById(geomLib,ASCollada.DAE_GEOMETRY_ELEMENT,geometry.id);
               geometry.async = false;
               geometry.read(geomNode);
               this.geometries[geometry.id] = geometry;
            }
            catch(e:Error)
            {
               Logger.error("[ERROR] DaeDocument#readNextGeometry : " + e.toString());
            }
            return true;
         }
         return false;
      }
      
      private function readLibPhysicsScenes() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaePhysicsScene = null;
         this.physics_scenes = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_PSCENE_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_PHYSICS_SCENE_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaePhysicsScene(_loc3_);
               this.physics_scenes[_loc4_.id] = _loc4_;
            }
         }
      }
      
      private function readScene() : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_SCENE_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNode(_loc1_,ASCollada.DAE_INSTANCE_VSCENE_ELEMENT);
            if(_loc2_)
            {
               _loc4_ = getAttribute(_loc2_,ASCollada.DAE_URL_ATTRIBUTE);
               if(this.visual_scenes[_loc4_] is DaeVisualScene)
               {
                  Logger.log("found visual scene: " + _loc4_);
                  this.vscene = this.visual_scenes[_loc4_];
                  Logger.log(" -> frameRate: " + this.vscene.frameRate);
                  Logger.log(" -> startTime: " + this.vscene.startTime);
                  Logger.log(" -> endTime: " + this.vscene.endTime);
               }
            }
            _loc3_ = getNode(_loc1_,ASCollada.DAE_INSTANCE_PHYSICS_SCENE_ELEMENT);
            if(_loc3_)
            {
               _loc5_ = getAttribute(_loc3_,ASCollada.DAE_URL_ATTRIBUTE);
               if(this.physics_scenes[_loc5_] is DaePhysicsScene)
               {
                  Logger.log("found physics scene: " + _loc5_);
                  this.pscene = this.physics_scenes[_loc5_];
               }
            }
         }
      }
      
      private function readLibControllers() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeController = null;
         this.controllers = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_CONTROLLER_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_CONTROLLER_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeController(_loc3_);
               this.controllers[_loc4_.id] = _loc4_;
            }
         }
      }
      
      public function getDaeInstanceGeometry(param1:String) : DaeInstanceGeometry
      {
         var _loc2_:DaeNode = null;
         var _loc3_:DaeInstanceGeometry = null;
         for each(_loc2_ in this.vscene.nodes)
         {
            _loc3_ = findDaeInstanceGeometry(_loc2_,param1);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function findDaeInstanceGeometry(param1:DaeNode, param2:String) : DaeInstanceGeometry
      {
         var _loc3_:DaeInstanceGeometry = null;
         var _loc4_:DaeNode = null;
         var _loc5_:DaeInstanceGeometry = null;
         for each(_loc3_ in param1.geometries)
         {
            if(_loc3_.url == param2)
            {
               return _loc3_;
            }
         }
         for each(_loc4_ in param1.nodes)
         {
            _loc5_ = findDaeInstanceGeometry(_loc4_,param2);
            if(_loc5_)
            {
               return _loc5_;
            }
         }
         return null;
      }
      
      public function readNextAnimation() : Boolean
      {
         var animation:DaeAnimation = null;
         var animLib:XML = null;
         var animNode:XML = null;
         if(_waitingAnimations.length)
         {
            try
            {
               animation = _waitingAnimations.shift() as DaeAnimation;
               animLib = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_ANIMATION_ELEMENT);
               animNode = getNodeById(animLib,ASCollada.DAE_ANIMATION_ELEMENT,animation.id);
               animation.read(animNode);
            }
            catch(e:Error)
            {
               Logger.error("[ERROR] DaeDocument#readNextAnimation : " + e.toString());
            }
            return true;
         }
         return false;
      }
      
      private function readLibMaterials() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeMaterial = null;
         this.materials = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_MATERIAL_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_MATERIAL_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeMaterial(_loc3_);
               this.materials[_loc4_.id] = _loc4_;
            }
         }
      }
      
      public function getDaeNodeById(param1:String, param2:Boolean = false) : DaeNode
      {
         var _loc3_:DaeNode = null;
         var _loc4_:int = 0;
         var _loc5_:DaeNode = null;
         var _loc6_:DaeNode = null;
         var _loc7_:DaeNode = null;
         for each(_loc3_ in this.nodes)
         {
            _loc5_ = findDaeNodeById(_loc3_,param1,param2);
            if(_loc5_)
            {
               return _loc5_;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < this.vscene.nodes.length)
         {
            _loc6_ = this.vscene.nodes[_loc4_];
            _loc7_ = findDaeNodeById(_loc6_,param1,param2);
            if(_loc7_)
            {
               return _loc7_;
            }
            _loc4_++;
         }
         return null;
      }
      
      private function readLibNodes() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeNode = null;
         this.nodes = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_NODE_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_NODE_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeNode(_loc3_);
               this.nodes[_loc4_.id] = _loc4_;
            }
         }
      }
      
      private function readLibAnimations() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeAnimation = null;
         _waitingAnimations = new Array();
         this.animations = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_ANIMATION_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_ANIMATION_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeAnimation();
               _loc4_.id = _loc3_.attribute(ASCollada.DAE_ID_ATTRIBUTE).toString();
               this.animations[_loc4_.id] = _loc4_;
               _waitingAnimations.push(_loc4_);
            }
         }
      }
      
      public function get numQueuedAnimations() : uint
      {
         return _waitingAnimations.length;
      }
      
      private function readLibEffects() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeEffect = null;
         this.effects = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_EFFECT_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_EFFECT_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeEffect(_loc3_);
               this.effects[_loc4_.id] = _loc4_;
            }
         }
      }
      
      private function readLibCameras() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeCamera = null;
         this.cameras = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_CAMERA_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_CAMERA_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeCamera(_loc3_);
               this.cameras[_loc4_.id] = _loc4_;
            }
         }
      }
      
      private function readLibAnimationClips() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:DaeAnimationClip = null;
         this.animation_clips = new Object();
         var _loc1_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_ANIMATION_CLIP_ELEMENT);
         if(_loc1_)
         {
            _loc2_ = getNodeList(_loc1_,ASCollada.DAE_ANIMCLIP_ELEMENT);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new DaeAnimationClip(_loc3_);
               this.animation_clips[_loc4_.id] = _loc4_;
            }
         }
      }
      
      private function readLibGeometries(param1:Boolean = false) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:DaeGeometry = null;
         _waitingGeometries = new Array();
         this.geometries = new Object();
         var _loc2_:XML = getNode(this.COLLADA,ASCollada.DAE_LIBRARY_GEOMETRY_ELEMENT);
         if(_loc2_)
         {
            _loc3_ = getNodeList(_loc2_,ASCollada.DAE_GEOMETRY_ELEMENT);
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = new DaeGeometry(_loc4_,param1);
               if(param1)
               {
                  _waitingGeometries.push(_loc5_);
               }
               else
               {
                  this.geometries[_loc5_.id] = _loc5_;
               }
            }
         }
      }
   }
}

