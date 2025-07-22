package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.fx.DaeInstanceMaterial;
   import org.ascollada.utils.Logger;
   
   public class DaeInstanceController extends DaeEntity
   {
      
      public var materials:Array;
      
      public var skeletons:Array;
      
      public var skeleton:String;
      
      public var url:String;
      
      public function DaeInstanceController(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc4_:String = null;
         var _loc6_:XML = null;
         super.read(param1);
         this.url = getAttribute(param1,ASCollada.DAE_URL_ATTRIBUTE);
         this.materials = new Array();
         Logger.log(" => " + this.url);
         this.skeleton = null;
         this.skeletons = new Array();
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc5_];
            switch(_loc6_.localName())
            {
               case ASCollada.DAE_SKELETON_ELEMENT:
                  _loc4_ = getNodeContent(_loc6_).toString();
                  _loc4_ = _loc4_.indexOf("#") != -1 ? _loc4_.substr(1) : _loc4_;
                  this.skeletons.push(_loc4_);
                  if(!this.skeleton)
                  {
                     this.skeleton = _loc4_;
                  }
                  Logger.log(" => skeleton: " + _loc4_);
                  break;
               case ASCollada.DAE_BINDMATERIAL_ELEMENT:
                  this.materials = parseBindMaterial(_loc6_);
                  break;
               case ASCollada.DAE_EXTRA_ELEMENT:
                  break;
            }
            _loc5_++;
         }
      }
      
      private function parseBindMaterial(param1:XML) : Array
      {
         var _loc6_:XML = null;
         var _loc7_:Array = null;
         var _loc8_:XMLList = null;
         var _loc9_:XML = null;
         var _loc2_:Array = new Array();
         var _loc3_:XMLList = param1.children();
         var _loc4_:int = int(_loc3_.length());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            switch(_loc6_.localName())
            {
               case ASCollada.DAE_TECHNIQUE_COMMON_ELEMENT:
                  _loc8_ = _loc6_.children();
                  for each(_loc9_ in _loc8_)
                  {
                     _loc2_.push(new DaeInstanceMaterial(_loc9_));
                  }
                  break;
            }
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

