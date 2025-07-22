package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.types.DaeTransform;
   
   public class DaeNode extends DaeEntity
   {
      
      public static const TYPE_NODE:uint = 0;
      
      public static const TYPE_JOINT:uint = 1;
      
      public var instance_cameras:Array;
      
      public var transforms:Array;
      
      public var geometries:Array;
      
      public var nodes:Array;
      
      public var instance_nodes:Array;
      
      public var controllers:Array;
      
      public var type:uint;
      
      private var _yUp:uint;
      
      public var channels:Array;
      
      public function DaeNode(param1:XML = null, param2:uint = 1)
      {
         _yUp = param2;
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc6_:XML = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:DaeTransform = null;
         this.nodes = new Array();
         this.controllers = new Array();
         this.geometries = new Array();
         this.instance_nodes = new Array();
         this.instance_cameras = new Array();
         this.transforms = new Array();
         if(param1.localName() != ASCollada.DAE_NODE_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_NODE_ELEMENT + "\' element");
         }
         super.read(param1);
         this.name = Boolean(this.name) && Boolean(this.name.length) ? this.name : this.id;
         this.type = getAttribute(param1,ASCollada.DAE_TYPE_ATTRIBUTE) == "JOINT" ? TYPE_JOINT : TYPE_NODE;
         var _loc2_:* = this._yUp == DaeDocument.Y_UP;
         var _loc3_:XMLList = param1.children();
         var _loc4_:int = int(_loc3_.length());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc8_ = getAttribute(_loc6_,ASCollada.DAE_SID_ATTRIBUTE);
            switch(_loc6_.localName())
            {
               case ASCollada.DAE_ASSET_ELEMENT:
                  break;
               case ASCollada.DAE_ROTATE_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  _loc9_ = new DaeTransform(ASCollada.DAE_ROTATE_ELEMENT,_loc8_,_loc7_);
                  this.transforms.push(_loc9_);
                  break;
               case ASCollada.DAE_TRANSLATE_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  _loc9_ = new DaeTransform(ASCollada.DAE_TRANSLATE_ELEMENT,_loc8_,_loc7_);
                  this.transforms.push(_loc9_);
                  break;
               case ASCollada.DAE_SCALE_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  _loc9_ = new DaeTransform(ASCollada.DAE_SCALE_ELEMENT,_loc8_,_loc7_);
                  this.transforms.push(_loc9_);
                  break;
               case ASCollada.DAE_SKEW_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  break;
               case ASCollada.DAE_LOOKAT_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  break;
               case ASCollada.DAE_MATRIX_ELEMENT:
                  _loc7_ = getFloats(_loc6_);
                  _loc9_ = new DaeTransform(ASCollada.DAE_MATRIX_ELEMENT,_loc8_,_loc7_);
                  this.transforms.push(_loc9_);
                  break;
               case ASCollada.DAE_NODE_ELEMENT:
                  this.nodes.push(new DaeNode(_loc6_,_yUp));
                  break;
               case ASCollada.DAE_INSTANCE_CAMERA_ELEMENT:
                  this.instance_cameras.push(getAttribute(_loc6_,ASCollada.DAE_URL_ATTRIBUTE));
                  break;
               case ASCollada.DAE_INSTANCE_CONTROLLER_ELEMENT:
                  this.controllers.push(new DaeInstanceController(_loc6_));
                  break;
               case ASCollada.DAE_INSTANCE_GEOMETRY_ELEMENT:
                  this.geometries.push(new DaeInstanceGeometry(_loc6_));
                  break;
               case ASCollada.DAE_INSTANCE_LIGHT_ELEMENT:
                  break;
               case ASCollada.DAE_INSTANCE_NODE_ELEMENT:
                  this.instance_nodes.push(new DaeInstanceNode(_loc6_));
                  break;
               case ASCollada.DAE_EXTRA_ELEMENT:
                  break;
            }
            _loc5_++;
         }
      }
      
      public function findMatrixBySID(param1:String) : DaeTransform
      {
         var _loc2_:DaeTransform = null;
         for each(_loc2_ in this.transforms)
         {
            if(param1 == _loc2_.sid)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function findController(param1:String) : DaeInstanceController
      {
         var _loc2_:DaeInstanceController = null;
         for each(_loc2_ in this.controllers)
         {
            if(param1 == _loc2_.id)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

