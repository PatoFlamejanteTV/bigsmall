package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeAnimationClip extends DaeEntity
   {
      
      public var start:Number = 0;
      
      public var instance_animation:Array = new Array();
      
      public var end:Number = 0;
      
      public function DaeAnimationClip(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         if(param1.localName() != ASCollada.DAE_ANIMCLIP_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_ANIMCLIP_ELEMENT + "\' element");
         }
         super.read(param1);
         Logger.log("reading animation_clip: " + this.id);
         this.instance_animation = new Array();
         this.start = getAttributeAsFloat(param1,ASCollada.DAE_START_ATTRIBUTE);
         this.end = getAttributeAsFloat(param1,ASCollada.DAE_START_ATTRIBUTE);
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_INSTANCE_ANIMATION_ELEMENT);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = getAttribute(_loc3_,ASCollada.DAE_URL_ATTRIBUTE);
            this.instance_animation.push(_loc4_);
         }
      }
   }
}

