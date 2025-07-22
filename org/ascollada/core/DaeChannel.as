package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.types.DaeAddressSyntax;
   
   public class DaeChannel extends DaeEntity
   {
      
      public var output:Array;
      
      public var syntax:DaeAddressSyntax;
      
      public var curves:Array;
      
      public var input:Array;
      
      public var interpolations:Array;
      
      public var target:String;
      
      public var source:String;
      
      public function DaeChannel(param1:XML)
      {
         super(param1);
         this.curves = new Array();
      }
      
      public function update(param1:Number) : Array
      {
         if(!this.curves)
         {
            return null;
         }
         var _loc2_:Array = new Array(this.curves.length);
         var _loc3_:int = 0;
         while(_loc3_ < this.curves.length)
         {
            _loc2_[_loc3_] = this.curves[_loc3_].evaluate(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_CHANNEL_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_CHANNEL_ELEMENT + "\' element");
         }
         super.read(param1);
         this.source = getAttribute(param1,ASCollada.DAE_SOURCE_ATTRIBUTE);
         this.target = getAttribute(param1,ASCollada.DAE_TARGET_ATTRIBUTE);
         this.syntax = DaeAddressSyntax.parseAnimationTarget(this.target);
      }
   }
}

