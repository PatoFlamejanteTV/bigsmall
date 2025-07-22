package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeCamera extends DaeEntity
   {
      
      public static const TYPE_X:uint = 0;
      
      public static const TYPE_Y:uint = 1;
      
      public var type:uint = 0;
      
      public var aspect_ratio:Number;
      
      public var near:Number;
      
      public var fov:Number;
      
      public var target:String;
      
      public var mag:Number;
      
      public var ortho:Boolean = false;
      
      public var far:Number;
      
      public function DaeCamera(param1:XML)
      {
         super(param1);
      }
      
      private function readTechniqueCommon(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_CAMERA_PERSP_ELEMENT:
                  this.ortho = false;
                  readPerspective(_loc5_);
                  break;
               case ASCollada.DAE_CAMERA_ORTHO_ELEMENT:
                  this.ortho = true;
                  readOrthogonal(_loc5_);
                  break;
            }
            _loc4_++;
         }
      }
      
      private function readOrthogonal(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_XMAG_CAMERA_PARAMETER:
                  this.type = TYPE_X;
                  this.fov = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_YMAG_CAMERA_PARAMETER:
                  this.type = TYPE_Y;
                  this.fov = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ASPECT_CAMERA_PARAMETER:
                  this.aspect_ratio = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ZNEAR_CAMERA_PARAMETER:
                  this.near = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ZFAR_CAMERA_PARAMETER:
                  this.far = parseFloat(getNodeContent(_loc5_));
                  break;
            }
            _loc4_++;
         }
      }
      
      private function readExtra(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_TECHNIQUE_ELEMENT:
                  _loc6_ = getNode(_loc5_,ASCollada.DAEMAX_TARGET_CAMERA_PARAMETER);
                  if(_loc6_)
                  {
                     this.target = getNodeContent(_loc6_);
                     this.target = this.target.split("#")[1];
                  }
                  break;
            }
            _loc4_++;
         }
      }
      
      private function readPerspective(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_XFOV_CAMERA_PARAMETER:
                  this.type = TYPE_X;
                  this.fov = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_YFOV_CAMERA_PARAMETER:
                  this.type = TYPE_Y;
                  this.fov = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ASPECT_CAMERA_PARAMETER:
                  this.aspect_ratio = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ZNEAR_CAMERA_PARAMETER:
                  this.near = parseFloat(getNodeContent(_loc5_));
                  break;
               case ASCollada.DAE_ZFAR_CAMERA_PARAMETER:
                  this.far = parseFloat(getNodeContent(_loc5_));
                  break;
            }
            _loc4_++;
         }
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         if(param1.localName() != ASCollada.DAE_CAMERA_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_CAMERA_ELEMENT + "\' element");
         }
         super.read(param1);
         this.target = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_OPTICS_ELEMENT:
                  readOptics(_loc5_);
                  break;
               case ASCollada.DAE_EXTRA_ELEMENT:
                  readExtra(_loc5_);
                  break;
            }
            _loc4_++;
         }
      }
      
      private function readOptics(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(String(_loc5_.localName()))
            {
               case ASCollada.DAE_TECHNIQUE_COMMON_ELEMENT:
                  readTechniqueCommon(_loc5_);
                  break;
            }
            _loc4_++;
         }
      }
   }
}

