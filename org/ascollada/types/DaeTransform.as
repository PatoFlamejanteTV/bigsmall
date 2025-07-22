package org.ascollada.types
{
   import org.ascollada.ASCollada;
   import org.ascollada.utils.Logger;
   
   public class DaeTransform
   {
      
      public var values:Array;
      
      public var animated:Boolean;
      
      public var type:String;
      
      public var sid:String;
      
      public function DaeTransform(param1:String, param2:String, param3:Array)
      {
         super();
         this.type = param1;
         this.sid = param2;
         this.values = param3;
         this.animated = false;
         if(!validateValues())
         {
            Logger.log("[ERROR] invalid values for this transform!");
            throw new Error("[ERROR] invalid values for this transform!");
         }
      }
      
      public function validateValues() : Boolean
      {
         var _loc1_:* = false;
         if(!this.values || !this.values.length)
         {
            return false;
         }
         switch(this.type)
         {
            case ASCollada.DAE_ROTATE_ELEMENT:
               _loc1_ = this.values.length == 4;
               break;
            case ASCollada.DAE_TRANSLATE_ELEMENT:
               _loc1_ = this.values.length == 3;
               break;
            case ASCollada.DAE_SCALE_ELEMENT:
               _loc1_ = this.values.length == 3;
               break;
            case ASCollada.DAE_MATRIX_ELEMENT:
               _loc1_ = this.values.length == 16;
         }
         return _loc1_;
      }
   }
}

