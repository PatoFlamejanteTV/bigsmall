package gs
{
   import flash.filters.*;
   
   public class TweenFilterLite extends TweenLite
   {
      
      public static var version:Number = 7.35;
      
      public static var delayedCall:Function = TweenLite.delayedCall;
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.defaultEase;
      
      private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      private static var _lumR:Number = 0.212671;
      
      private static var _lumG:Number = 0.71516;
      
      private static var _lumB:Number = 0.072169;
      
      private var _matrix:Array;
      
      private var _hf:Boolean = false;
      
      private var _cmf:ColorMatrixFilter;
      
      private var _filters:Array = [];
      
      private var _endMatrix:Array;
      
      private var _clrsa:Array;
      
      public function TweenFilterLite(param1:Object, param2:Number, param3:Object)
      {
         super(param1,param2,param3);
         if(TweenLite.version < 7.04 || isNaN(TweenLite.version))
         {
            trace("TweenFilterLite error! Please update your TweenLite class or try deleting your ASO files. TweenFilterLite requires a more recent version. Download updates at http://www.TweenLite.com.");
         }
         if(param3.type != undefined)
         {
            trace("TweenFilterLite error: " + param1 + " is using deprecated syntax. Please update to the new syntax. See http://www.TweenFilterLite.com for details.");
         }
      }
      
      public static function setContrast(param1:Array, param2:Number) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         param2 += 0.01;
         var _loc3_:Array = [param2,0,0,0,128 * (1 - param2),0,param2,0,0,128 * (1 - param2),0,0,param2,0,128 * (1 - param2),0,0,0,1,0];
         return applyMatrix(_loc3_,param1);
      }
      
      public static function colorize(param1:Array, param2:Number, param3:Number = 1) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         if(isNaN(param3))
         {
            param3 = 1;
         }
         var _loc4_:Number = (param2 >> 16 & 0xFF) / 255;
         var _loc5_:Number = (param2 >> 8 & 0xFF) / 255;
         var _loc6_:Number = (param2 & 0xFF) / 255;
         var _loc7_:Number = 1 - param3;
         var _loc8_:Array = [_loc7_ + param3 * _loc4_ * _lumR,param3 * _loc4_ * _lumG,param3 * _loc4_ * _lumB,0,0,param3 * _loc5_ * _lumR,_loc7_ + param3 * _loc5_ * _lumG,param3 * _loc5_ * _lumB,0,0,param3 * _loc6_ * _lumR,param3 * _loc6_ * _lumG,_loc7_ + param3 * _loc6_ * _lumB,0,0,0,0,0,1,0];
         return applyMatrix(_loc8_,param1);
      }
      
      public static function setBrightness(param1:Array, param2:Number) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         param2 = param2 * 100 - 100;
         return applyMatrix([1,0,0,0,param2,0,1,0,0,param2,0,0,1,0,param2,0,0,0,1,0,0,0,0,0,1],param1);
      }
      
      public static function setSaturation(param1:Array, param2:Number) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         var _loc3_:Number = 1 - param2;
         var _loc4_:Number = _loc3_ * _lumR;
         var _loc5_:Number = _loc3_ * _lumG;
         var _loc6_:Number = _loc3_ * _lumB;
         var _loc7_:Array = [_loc4_ + param2,_loc5_,_loc6_,0,0,_loc4_,_loc5_ + param2,_loc6_,0,0,_loc4_,_loc5_,_loc6_ + param2,0,0,0,0,0,1,0];
         return applyMatrix(_loc7_,param1);
      }
      
      public static function applyMatrix(param1:Array, param2:Array) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!(param1 is Array) || !(param2 is Array))
         {
            return param2;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < 4)
         {
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
               if(_loc7_ == 4)
               {
                  _loc5_ = int(param1[_loc4_ + 4]);
               }
               else
               {
                  _loc5_ = 0;
               }
               _loc3_[_loc4_ + _loc7_] = param1[_loc4_] * param2[_loc7_] + param1[_loc4_ + 1] * param2[_loc7_ + 5] + param1[_loc4_ + 2] * param2[_loc7_ + 10] + param1[_loc4_ + 3] * param2[_loc7_ + 15] + _loc5_;
               _loc7_++;
            }
            _loc4_ += 5;
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenFilterLite
      {
         param3.runBackwards = true;
         return new TweenFilterLite(param1,param2,param3);
      }
      
      public static function setThreshold(param1:Array, param2:Number) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         var _loc3_:Array = [_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * param2,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * param2,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * param2,0,0,0,1,0];
         return applyMatrix(_loc3_,param1);
      }
      
      public static function setHue(param1:Array, param2:Number) : Array
      {
         if(isNaN(param2))
         {
            return param1;
         }
         param2 *= Math.PI / 180;
         var _loc3_:Number = Math.cos(param2);
         var _loc4_:Number = Math.sin(param2);
         var _loc5_:Array = [_lumR + _loc3_ * (1 - _lumR) + _loc4_ * -_lumR,_lumG + _loc3_ * -_lumG + _loc4_ * -_lumG,_lumB + _loc3_ * -_lumB + _loc4_ * (1 - _lumB),0,0,_lumR + _loc3_ * -_lumR + _loc4_ * 0.143,_lumG + _loc3_ * (1 - _lumG) + _loc4_ * 0.14,_lumB + _loc3_ * -_lumB + _loc4_ * -0.283,0,0,_lumR + _loc3_ * -_lumR + _loc4_ * -(1 - _lumR),_lumG + _loc3_ * -_lumG + _loc4_ * _lumG,_lumB + _loc3_ * (1 - _lumB) + _loc4_ * _lumB,0,0,0,0,0,1,0,0,0,0,0,1];
         return applyMatrix(_loc5_,param1);
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenFilterLite
      {
         return new TweenFilterLite(param1,param2,param3);
      }
      
      public static function HEXtoRGB(param1:Number) : Object
      {
         return {
            "rb":param1 >> 16,
            "gb":param1 >> 8 & 0xFF,
            "bb":param1 & 0xFF
         };
      }
      
      override public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         _clrsa = [];
         _filters = [];
         _matrix = _idMatrix.slice();
         param2 += " blurFilter glowFilter colorMatrixFilter dropShadowFilter bevelFilter ";
         if(_isDisplayObject)
         {
            if(this.vars.blurFilter != null)
            {
               _loc4_ = this.vars.blurFilter;
               addFilter("blur",_loc4_,BlurFilter,["blurX","blurY","quality"],new BlurFilter(0,0,int(_loc4_.quality) || 2));
            }
            if(this.vars.glowFilter != null)
            {
               _loc4_ = this.vars.glowFilter;
               addFilter("glow",_loc4_,GlowFilter,["alpha","blurX","blurY","color","quality","strength","inner","knockout"],new GlowFilter(16777215,0,0,0,Number(_loc4_.strength) || 1,int(_loc4_.quality) || 2,_loc4_.inner,_loc4_.knockout));
            }
            if(this.vars.colorMatrixFilter != null)
            {
               _loc4_ = this.vars.colorMatrixFilter;
               _loc5_ = addFilter("colorMatrix",_loc4_,ColorMatrixFilter,[],new ColorMatrixFilter(_matrix));
               _cmf = _loc5_.filter;
               _matrix = ColorMatrixFilter(_cmf).matrix;
               if(_loc4_.matrix != null && _loc4_.matrix is Array)
               {
                  _endMatrix = _loc4_.matrix;
               }
               else
               {
                  if(_loc4_.relative == true)
                  {
                     _endMatrix = _matrix.slice();
                  }
                  else
                  {
                     _endMatrix = _idMatrix.slice();
                  }
                  _endMatrix = setBrightness(_endMatrix,_loc4_.brightness);
                  _endMatrix = setContrast(_endMatrix,_loc4_.contrast);
                  _endMatrix = setHue(_endMatrix,_loc4_.hue);
                  _endMatrix = setSaturation(_endMatrix,_loc4_.saturation);
                  _endMatrix = setThreshold(_endMatrix,_loc4_.threshold);
                  if(!isNaN(_loc4_.colorize))
                  {
                     _endMatrix = colorize(_endMatrix,_loc4_.colorize,_loc4_.amount);
                  }
                  else if(!isNaN(_loc4_.color))
                  {
                     _endMatrix = colorize(_endMatrix,_loc4_.color,_loc4_.amount);
                  }
               }
               _loc3_ = 0;
               while(_loc3_ < _endMatrix.length)
               {
                  if(_matrix[_loc3_] != _endMatrix[_loc3_] && _matrix[_loc3_] != undefined)
                  {
                     this.tweens[this.tweens.length] = {
                        "o":_matrix,
                        "p":_loc3_.toString(),
                        "s":_matrix[_loc3_],
                        "c":_endMatrix[_loc3_] - _matrix[_loc3_]
                     };
                  }
                  _loc3_++;
               }
            }
            if(this.vars.dropShadowFilter != null)
            {
               _loc4_ = this.vars.dropShadowFilter;
               addFilter("dropShadow",_loc4_,DropShadowFilter,["alpha","angle","blurX","blurY","color","distance","quality","strength","inner","knockout","hideObject"],new DropShadowFilter(0,45,0,0,0,0,1,int(_loc4_.quality) || 2,_loc4_.inner,_loc4_.knockout,_loc4_.hideObject));
            }
            if(this.vars.bevelFilter != null)
            {
               _loc4_ = this.vars.bevelFilter;
               addFilter("bevel",_loc4_,BevelFilter,["angle","blurX","blurY","distance","highlightAlpha","highlightColor","quality","shadowAlpha","shadowColor","strength"],new BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,int(_loc4_.quality) || 2));
            }
            if(this.vars.runBackwards == true)
            {
               _loc3_ = int(_clrsa.length - 1);
               while(_loc3_ > -1)
               {
                  _loc6_ = _clrsa[_loc3_];
                  _loc6_.sr += _loc6_.cr;
                  _loc6_.cr *= -1;
                  _loc6_.sg += _loc6_.cg;
                  _loc6_.cg *= -1;
                  _loc6_.sb += _loc6_.cb;
                  _loc6_.cb *= -1;
                  _loc6_.f[_loc6_.p] = _loc6_.sr << 16 | _loc6_.sg << 8 | _loc6_.sb;
                  _loc3_--;
               }
            }
            super.initTweenVals(true,param2);
         }
         else
         {
            super.initTweenVals(param1,param2);
         }
      }
      
      override public function render(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc2_:Number = (param1 - this.startTime) / 1000;
         if(_loc2_ >= this.duration)
         {
            _loc2_ = this.duration;
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = Number(this.vars.ease(_loc2_,0,1,this.duration));
         }
         _loc5_ = int(this.tweens.length - 1);
         while(_loc5_ > -1)
         {
            _loc4_ = this.tweens[_loc5_];
            _loc4_.o[_loc4_.p] = _loc4_.s + _loc3_ * _loc4_.c;
            _loc5_--;
         }
         if(_hf)
         {
            _loc5_ = int(_clrsa.length - 1);
            while(_loc5_ > -1)
            {
               _loc4_ = _clrsa[_loc5_];
               _loc6_ = _loc4_.sr + _loc3_ * _loc4_.cr;
               _loc7_ = _loc4_.sg + _loc3_ * _loc4_.cg;
               _loc8_ = _loc4_.sb + _loc3_ * _loc4_.cb;
               _loc4_.f[_loc4_.p] = _loc6_ << 16 | _loc7_ << 8 | _loc8_;
               _loc5_--;
            }
            if(_cmf != null)
            {
               ColorMatrixFilter(_cmf).matrix = _matrix;
            }
            _loc10_ = this.target.filters;
            _loc5_ = 0;
            while(_loc5_ < _filters.length)
            {
               _loc9_ = int(_loc10_.length - 1);
               while(_loc9_ > -1)
               {
                  if(_loc10_[_loc9_] is _filters[_loc5_].type)
                  {
                     _loc10_.splice(_loc9_,1,_filters[_loc5_].filter);
                     break;
                  }
                  _loc9_--;
               }
               _loc5_++;
            }
            this.target.filters = _loc10_;
         }
         if(_hst)
         {
            _loc5_ = int(_subTweens.length - 1);
            while(_loc5_ > -1)
            {
               _subTweens[_loc5_].proxy(_subTweens[_loc5_]);
               _loc5_--;
            }
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            super.complete(true);
         }
      }
      
      private function addFilter(param1:String, param2:Object, param3:Class, param4:Array, param5:BitmapFilter) : Object
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc6_:Object = {"type":param3};
         var _loc7_:Array = this.target.filters;
         _loc8_ = 0;
         while(_loc8_ < _loc7_.length)
         {
            if(_loc7_[_loc8_] is param3)
            {
               _loc6_.filter = _loc7_[_loc8_];
               break;
            }
            _loc8_++;
         }
         if(_loc6_.filter == undefined)
         {
            _loc6_.filter = param5;
            _loc7_[_loc7_.length] = _loc6_.filter;
            this.target.filters = _loc7_;
         }
         _loc8_ = 0;
         while(_loc8_ < param4.length)
         {
            _loc9_ = param4[_loc8_];
            if(param2[_loc9_] != undefined)
            {
               if(_loc9_ == "color" || _loc9_ == "highlightColor" || _loc9_ == "shadowColor")
               {
                  _loc11_ = HEXtoRGB(_loc6_.filter[_loc9_]);
                  _loc12_ = HEXtoRGB(param2[_loc9_]);
                  _clrsa[_clrsa.length] = {
                     "f":_loc6_.filter,
                     "p":_loc9_,
                     "sr":_loc11_.rb,
                     "cr":_loc12_.rb - _loc11_.rb,
                     "sg":_loc11_.gb,
                     "cg":_loc12_.gb - _loc11_.gb,
                     "sb":_loc11_.bb,
                     "cb":_loc12_.bb - _loc11_.bb
                  };
               }
               else if(_loc9_ == "quality" || _loc9_ == "inner" || _loc9_ == "knockout" || _loc9_ == "hideObject")
               {
                  _loc6_.filter[_loc9_] = param2[_loc9_];
               }
               else
               {
                  if(typeof param2[_loc9_] == "number")
                  {
                     _loc10_ = param2[_loc9_] - _loc6_.filter[_loc9_];
                  }
                  else
                  {
                     _loc10_ = Number(param2[_loc9_]);
                  }
                  this.tweens[this.tweens.length] = {
                     "o":_loc6_.filter,
                     "p":_loc9_,
                     "s":_loc6_.filter[_loc9_],
                     "c":_loc10_
                  };
               }
            }
            _loc8_++;
         }
         _filters[_filters.length] = _loc6_;
         _hf = true;
         return _loc6_;
      }
   }
}

