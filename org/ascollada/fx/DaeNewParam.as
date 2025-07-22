package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.utils.Logger;
   
   public class DaeNewParam extends DaeEntity
   {
      
      public var type:String;
      
      public var sampler2D:DaeSampler2D;
      
      public var surface:DaeSurface;
      
      public function DaeNewParam(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc5_:XML = null;
         if(param1.localName() != ASCollada.DAE_FXCMN_NEWPARAM_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_FXCMN_NEWPARAM_ELEMENT + "\' element");
         }
         super.read(param1);
         Logger.log(" => newparam @sid=" + this.sid);
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            switch(_loc5_.localName())
            {
               case ASCollada.DAE_FXCMN_SURFACE_ELEMENT:
                  this.type = ASCollada.DAE_FXCMN_SURFACE_ELEMENT;
                  this.surface = new DaeSurface(_loc5_);
                  break;
               case ASCollada.DAE_FXCMN_SAMPLER2D_ELEMENT:
                  this.type = ASCollada.DAE_FXCMN_SAMPLER2D_ELEMENT;
                  this.sampler2D = new DaeSampler2D(_loc5_);
                  break;
            }
            _loc4_++;
         }
      }
   }
}

