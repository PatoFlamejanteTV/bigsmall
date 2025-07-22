package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeController extends DaeEntity
   {
      
      public static const TYPE_SKIN:uint = 0;
      
      public static const TYPE_MORPH:uint = 1;
      
      public var type:uint;
      
      public var morph:DaeMorph;
      
      public var skin:DaeSkin;
      
      public function DaeController(param1:XML = null)
      {
         super(param1);
      }
      
      override public function read(param1:XML) : void
      {
         var _loc3_:XML = null;
         if(param1.localName() != ASCollada.DAE_CONTROLLER_ELEMENT)
         {
            return;
         }
         super.read(param1);
         Logger.log("reading controller: " + this.id);
         var _loc2_:XML = getNode(param1,ASCollada.DAE_CONTROLLER_SKIN_ELEMENT);
         if(_loc2_)
         {
            this.skin = new DaeSkin(_loc2_);
            this.type = TYPE_SKIN;
         }
         else
         {
            _loc3_ = getNode(param1,ASCollada.DAE_CONTROLLER_MORPH_ELEMENT);
            if(_loc3_)
            {
               this.morph = new DaeMorph(_loc3_);
               this.type = TYPE_MORPH;
            }
         }
         if(!this.skin && !this.morph)
         {
            throw new Error("controller element should contain a <skin> or a <morph> element!");
         }
         if(this.type == TYPE_SKIN)
         {
         }
      }
   }
}

