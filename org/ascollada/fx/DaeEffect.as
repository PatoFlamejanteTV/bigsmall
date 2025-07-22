package org.ascollada.fx
{
   import org.ascollada.ASCollada;
   import org.ascollada.core.DaeEntity;
   import org.ascollada.types.DaeColorOrTexture;
   import org.ascollada.utils.Logger;
   
   public class DaeEffect extends DaeEntity
   {
      
      public var color:DaeConstant;
      
      public var wireframe:Boolean;
      
      public var texture_url:String;
      
      public var newparams:Object;
      
      public var double_sided:Boolean;
      
      public function DaeEffect(param1:XML = null)
      {
         super(param1);
      }
      
      private function readExtra(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_EXTRA_ELEMENT);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = getNode(_loc3_,ASCollada.DAE_TECHNIQUE_ELEMENT);
            _loc5_ = _loc4_.@profile.toString();
            switch(_loc5_)
            {
               case "MAX3D":
                  _loc6_ = getNode(_loc4_,"double_sided");
                  if(_loc6_)
                  {
                     _loc7_ = getNodeContent(_loc6_);
                     this.double_sided = _loc7_ == "1" || _loc7_ == "true";
                  }
                  _loc6_ = getNode(_loc4_,"wireframe");
                  if(_loc6_)
                  {
                     _loc7_ = getNodeContent(_loc6_);
                     this.wireframe = _loc7_ == "1" || _loc7_ == "true";
                  }
                  break;
            }
         }
      }
      
      override public function read(param1:XML) : void
      {
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:XML = null;
         var _loc15_:DaeNewParam = null;
         super.read(param1);
         this.double_sided = false;
         this.wireframe = false;
         var _loc2_:XML = getNode(param1,ASCollada.DAE_PROFILE_COMMON_ELEMENT);
         if(!_loc2_)
         {
            Logger.error("Can\'t handle profiles other then profile_COMMON!");
            return;
         }
         var _loc3_:XMLList = getNodeList(_loc2_,ASCollada.DAE_IMAGE_ELEMENT);
         var _loc4_:XMLList = getNodeList(_loc2_,ASCollada.DAE_FXCMN_NEWPARAM_ELEMENT);
         var _loc5_:XML = getNode(_loc2_,ASCollada.DAE_TECHNIQUE_ELEMENT);
         var _loc6_:String = _loc5_.attribute(ASCollada.DAE_SID_ATTRIBUTE);
         Logger.log("reading effect: " + this.id);
         Logger.log(" => #images: " + _loc3_.length());
         Logger.log(" => #newparams: " + _loc4_.length());
         Logger.log(" => technique sid: " + _loc6_);
         this.newparams = new Object();
         for each(_loc7_ in _loc4_)
         {
            _loc15_ = new DaeNewParam(_loc7_);
            this.newparams[_loc15_.type] = _loc15_;
         }
         _loc8_ = getNode(_loc5_,ASCollada.DAE_FXSTD_PHONG_ELEMENT);
         _loc9_ = getNode(_loc5_,ASCollada.DAE_FXSTD_LAMBERT_ELEMENT);
         _loc10_ = getNode(_loc5_,ASCollada.DAE_FXSTD_BLINN_ELEMENT);
         _loc11_ = getNode(_loc5_,ASCollada.DAE_FXSTD_CONSTANT_ELEMENT);
         if(_loc8_)
         {
            Logger.log(" => shader: phong");
            this.color = new DaePhong(_loc8_);
         }
         else if(_loc9_)
         {
            Logger.log(" => shader: lambert");
            this.color = new DaeLambert(_loc9_);
         }
         else if(_loc10_)
         {
            Logger.log(" => shader: blinn");
            this.color = new DaeBlinn(_loc10_);
         }
         else if(_loc11_)
         {
            Logger.log(" => shader: constant");
            this.color = new DaeConstant(_loc11_);
         }
         var _loc12_:DaeNewParam = this.newparams[ASCollada.DAE_FXCMN_SURFACE_ELEMENT];
         var _loc13_:DaeNewParam = this.newparams[ASCollada.DAE_FXCMN_SAMPLER2D_ELEMENT];
         var _loc14_:DaeLambert = this.color as DaeLambert;
         if((_loc14_) && _loc14_.diffuse.type == DaeColorOrTexture.TYPE_TEXTURE && _loc13_ && Boolean(_loc12_))
         {
            if(_loc13_.sid == _loc14_.diffuse.texture.texture && _loc13_.sampler2D.source == _loc12_.sid)
            {
               this.texture_url = _loc12_.surface.init_from;
            }
         }
         readExtra(param1);
      }
   }
}

