package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.fx.DaeBindVertexInput;
   import org.ascollada.fx.DaeInstanceMaterial;
   
   public class DaeInstanceGeometry extends DaeEntity
   {
      
      public var materials:Array;
      
      public var url:String;
      
      public function DaeInstanceGeometry(param1:XML = null)
      {
         super(param1);
      }
      
      public function findBindVertexInput(param1:String, param2:String) : DaeBindVertexInput
      {
         var _loc3_:DaeInstanceMaterial = null;
         for each(_loc3_ in this.materials)
         {
            if(param1 == _loc3_.symbol)
            {
               return _loc3_.findBindVertexInput(param2);
            }
         }
         return null;
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         super.read(param1);
         this.url = getAttribute(param1,ASCollada.DAE_URL_ATTRIBUTE);
         this.materials = new Array();
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(_loc5_.localName())
            {
               case ASCollada.DAE_BINDMATERIAL_ELEMENT:
                  this.materials = parseBindMaterial(_loc5_);
                  break;
            }
            _loc4_++;
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

