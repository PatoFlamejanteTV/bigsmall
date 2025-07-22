package gs
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.*;
   import gs.events.TweenEvent;
   
   public class TweenMax extends TweenFilterLite implements IEventDispatcher
   {
      
      public static var version:Number = 1.46;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killDelayedCallsTo;
      
      public static var removeTween:Function = TweenLite.removeTween;
      
      public static var defaultEase:Function = TweenLite.defaultEase;
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _callbacks:Object;
      
      protected var _pauseTime:int;
      
      public function TweenMax(param1:Object, param2:Number, param3:Object)
      {
         super(param1,param2,param3);
         _pauseTime = -1;
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            initDispatcher();
            if(param2 == 0 && this.delay == 0)
            {
               onUpdateDispatcher();
               onCompleteDispatcher();
            }
         }
         if(TweenFilterLite.version < 7.35 || isNaN(TweenFilterLite.version))
         {
            trace("TweenMax error! Please update your TweenFilterLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
         }
      }
      
      public static function sequence(param1:Object, param2:Array) : Array
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param2.length)
         {
            param2[_loc3_].target = param1;
            _loc3_++;
         }
         return multiSequence(param2);
      }
      
      public static function hexColorsProxy(param1:Object) : void
      {
         param1.info.target[param1.info.prop] = param1.target.r << 16 | param1.target.g << 8 | param1.target.b;
      }
      
      public static function parseBeziers(param1:Object, param2:Boolean = false) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = {};
         if(param2)
         {
            for(_loc6_ in param1)
            {
               _loc4_ = param1[_loc6_];
               _loc7_[_loc6_] = _loc5_ = [];
               if(_loc4_.length > 2)
               {
                  _loc5_[_loc5_.length] = {
                     "s":_loc4_[0],
                     "cp":_loc4_[1] - (_loc4_[2] - _loc4_[0]) / 4,
                     "e":_loc4_[1]
                  };
                  _loc3_ = 1;
                  while(_loc3_ < _loc4_.length - 1)
                  {
                     _loc5_[_loc5_.length] = {
                        "s":_loc4_[_loc3_],
                        "cp":_loc4_[_loc3_] + (_loc4_[_loc3_] - _loc5_[_loc3_ - 1].cp),
                        "e":_loc4_[_loc3_ + 1]
                     };
                     _loc3_++;
                  }
               }
               else
               {
                  _loc5_[_loc5_.length] = {
                     "s":_loc4_[0],
                     "cp":(_loc4_[0] + _loc4_[1]) / 2,
                     "e":_loc4_[1]
                  };
               }
            }
         }
         else
         {
            for(_loc6_ in param1)
            {
               _loc4_ = param1[_loc6_];
               _loc7_[_loc6_] = _loc5_ = [];
               if(_loc4_.length > 3)
               {
                  _loc5_[_loc5_.length] = {
                     "s":_loc4_[0],
                     "cp":_loc4_[1],
                     "e":(_loc4_[1] + _loc4_[2]) / 2
                  };
                  _loc3_ = 2;
                  while(_loc3_ < _loc4_.length - 2)
                  {
                     _loc5_.push({
                        "s":_loc5_[_loc3_ - 2].e,
                        "cp":_loc4_[_loc3_],
                        "e":(_loc4_[_loc3_] + _loc4_[_loc3_ + 1]) / 2
                     });
                     _loc3_++;
                  }
                  _loc5_[_loc5_.length] = {
                     "s":_loc5_[_loc5_.length - 1].e,
                     "cp":_loc4_[_loc4_.length - 2],
                     "e":_loc4_[_loc4_.length - 1]
                  };
               }
               else if(_loc4_.length == 3)
               {
                  _loc5_[_loc5_.length] = {
                     "s":_loc4_[0],
                     "cp":_loc4_[1],
                     "e":_loc4_[2]
                  };
               }
               else if(_loc4_.length == 2)
               {
                  _loc5_[_loc5_.length] = {
                     "s":_loc4_[0],
                     "cp":(_loc4_[0] + _loc4_[1]) / 2,
                     "e":_loc4_[1]
                  };
               }
            }
         }
         return _loc7_;
      }
      
      public static function bezierProxy2(param1:Object) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         bezierProxy(param1);
         var _loc2_:Object = {};
         var _loc3_:Object = param1.info.target;
         param1.info.target = _loc2_;
         param1.target.t += 0.01;
         bezierProxy(param1);
         var _loc4_:Array = param1.info.orientToBezier;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc4_.length)
         {
            _loc8_ = _loc4_[_loc10_];
            _loc9_ = Number(Number(_loc8_[3]) || 0);
            _loc6_ = _loc2_[_loc8_[0]] - _loc3_[_loc8_[0]];
            _loc7_ = _loc2_[_loc8_[1]] - _loc3_[_loc8_[1]];
            _loc3_[_loc8_[2]] = Math.atan2(_loc7_,_loc6_) * _RAD2DEG + _loc9_;
            _loc10_++;
         }
         param1.info.target = _loc3_;
         param1.target.t -= 0.01;
      }
      
      public static function pauseAll(param1:Boolean = true, param2:Boolean = false) : void
      {
         changePause(true,param1,param2);
      }
      
      public static function getTweensOf(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Dictionary = _all[param1];
         var _loc3_:Array = [];
         if(_loc2_ != null)
         {
            for(_loc4_ in _loc2_)
            {
               if(_loc2_[_loc4_].tweens != undefined)
               {
                  _loc3_[_loc3_.length] = _loc2_[_loc4_];
               }
            }
         }
         return _loc3_;
      }
      
      public static function killAllDelayedCalls(param1:Boolean = false) : void
      {
         killAll(param1,false,true);
      }
      
      public static function multiSequence(param1:Array) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Array = [];
         var _loc4_:Number = 0;
         _loc9_ = 0;
         while(_loc9_ < param1.length)
         {
            _loc5_ = param1[_loc9_];
            _loc8_ = Number(Number(_loc5_.time) || 0);
            _loc10_ = {};
            for(_loc11_ in _loc5_)
            {
               _loc10_[_loc11_] = _loc5_[_loc11_];
            }
            delete _loc10_.time;
            _loc7_ = Number(Number(_loc10_.delay) || 0);
            _loc10_.delay = _loc4_ + _loc7_;
            _loc6_ = _loc10_.target;
            delete _loc10_.target;
            if(_loc2_[_loc6_] == undefined)
            {
               if(_loc10_.overwrite == undefined)
               {
                  _loc10_.overwrite = true;
               }
               _loc2_[_loc6_] = _loc10_;
            }
            else
            {
               _loc10_.overwrite = false;
            }
            _loc3_[_loc3_.length] = new TweenMax(_loc6_,_loc8_,_loc10_);
            _loc4_ += _loc8_ + _loc7_;
            _loc9_++;
         }
         return _loc3_;
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenMax
      {
         return new TweenMax(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":false
         });
      }
      
      public static function isTweening(param1:Object) : Boolean
      {
         var _loc2_:Array = getTweensOf(param1);
         var _loc3_:int = int(_loc2_.length - 1);
         while(_loc3_ > -1)
         {
            if(_loc2_[_loc3_].active)
            {
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public static function killAll(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:Array = getAllTweens();
         var _loc5_:int = int(_loc4_.length - 1);
         while(_loc5_ > -1)
         {
            if(_loc4_[_loc5_].target is Function == param3 || _loc4_[_loc5_].target is Function != param2)
            {
               if(param1)
               {
                  _loc4_[_loc5_].complete();
               }
               else
               {
                  TweenLite.removeTween(_loc4_[_loc5_]);
               }
            }
            _loc5_--;
         }
      }
      
      public static function changePause(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc4_:Array = getAllTweens();
         var _loc5_:int = int(_loc4_.length - 1);
         while(_loc5_ > -1)
         {
            if(_loc4_[_loc5_] is TweenMax && (_loc4_[_loc5_].target is Function == param3 || _loc4_[_loc5_].target is Function != param2))
            {
               _loc4_[_loc5_].paused = param1;
            }
            _loc5_--;
         }
      }
      
      public static function bezierProxy(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc2_:Number = Number(param1.target.t);
         var _loc3_:Object = param1.info.props;
         var _loc4_:Object = param1.info.target;
         for(_loc6_ in _loc3_)
         {
            _loc9_ = uint(_loc3_[_loc6_].length);
            if(_loc2_ < 0)
            {
               _loc5_ = 0;
            }
            else if(_loc2_ >= 1)
            {
               _loc5_ = int(_loc9_ - 1);
            }
            else
            {
               _loc5_ = int(_loc9_ * _loc2_);
            }
            _loc8_ = (_loc2_ - _loc5_ * (1 / _loc9_)) * _loc9_;
            _loc7_ = _loc3_[_loc6_][_loc5_];
            _loc4_[_loc6_] = _loc7_.s + _loc8_ * (2 * (1 - _loc8_) * (_loc7_.cp - _loc7_.s) + _loc8_ * (_loc7_.e - _loc7_.s));
         }
      }
      
      public static function callbackProxy(param1:Array, param2:Array = null) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != undefined)
            {
               param1[_loc3_].apply(null,param2[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public static function allFrom(param1:Array, param2:Number, param3:Object) : Array
      {
         param3.runBackwards = true;
         return allTo(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         param3.runBackwards = true;
         return new TweenMax(param1,param2,param3);
      }
      
      public static function killAllTweens(param1:Boolean = false) : void
      {
         killAll(param1,true,false);
      }
      
      public static function getAllTweens() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:Dictionary = _all;
         var _loc2_:Array = [];
         for(_loc3_ in _loc1_)
         {
            for(_loc4_ in _loc1_[_loc3_])
            {
               if(_loc1_[_loc3_][_loc4_] != undefined)
               {
                  _loc2_[_loc2_.length] = _loc1_[_loc3_][_loc4_];
               }
            }
         }
         return _loc2_;
      }
      
      public static function resumeAll(param1:Boolean = true, param2:Boolean = false) : void
      {
         changePause(false,param1,param2);
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         return new TweenMax(param1,param2,param3);
      }
      
      public static function allTo(param1:Array, param2:Number, param3:Object) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Object = null;
         if(param1.length == 0)
         {
            return [];
         }
         var _loc9_:Array = [];
         var _loc10_:Number = Number(Number(param3.delayIncrement) || 0);
         delete param3.delayIncrement;
         if(param3.onCompleteAll == undefined)
         {
            _loc8_ = param3;
         }
         else
         {
            _loc8_ = {};
            for(_loc6_ in param3)
            {
               _loc8_[_loc6_] = param3[_loc6_];
            }
            _loc8_.onCompleteParams = [[param3.onComplete,param3.onCompleteAll],[param3.onCompleteParams,param3.onCompleteAllParams]];
            _loc8_.onComplete = TweenMax.callbackProxy;
            delete param3.onCompleteAll;
         }
         delete param3.onCompleteAllParams;
         if(_loc10_ == 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - 1)
            {
               _loc5_ = {};
               for(_loc6_ in param3)
               {
                  _loc5_[_loc6_] = param3[_loc6_];
               }
               _loc9_[_loc9_.length] = new TweenMax(param1[_loc4_],param2,_loc5_);
               _loc4_++;
            }
         }
         else
         {
            _loc7_ = Number(Number(param3.delay) || 0);
            _loc4_ = 0;
            while(_loc4_ < param1.length - 1)
            {
               _loc5_ = {};
               for(_loc6_ in param3)
               {
                  _loc5_[_loc6_] = param3[_loc6_];
               }
               _loc5_.delay = _loc7_ + _loc4_ * _loc10_;
               _loc9_[_loc9_.length] = new TweenMax(param1[_loc4_],param2,_loc5_);
               _loc4_++;
            }
            _loc8_.delay = _loc7_ + (param1.length - 1) * _loc10_;
         }
         _loc9_[_loc9_.length] = new TweenMax(param1[param1.length - 1],param2,_loc8_);
         if(param3.onCompleteAllListener is Function)
         {
            _loc9_[_loc9_.length - 1].addEventListener(TweenEvent.COMPLETE,param3.onCompleteAllListener);
         }
         return _loc9_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.dispatchEvent(param1);
      }
      
      protected function onStartDispatcher(... rest) : void
      {
         if(_callbacks.onStart != null)
         {
            _callbacks.onStart.apply(null,this.vars.onStartParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
      }
      
      protected function onUpdateDispatcher(... rest) : void
      {
         if(_callbacks.onUpdate != null)
         {
            _callbacks.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(_dispatcher != null)
         {
            _dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      override public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         param2 += " hexColors bezier bezierThrough orientToBezier quaternions onCompleteAll onCompleteAllParams ";
         var _loc8_:Function = bezierProxy;
         if(this.vars.orientToBezier == true)
         {
            this.vars.orientToBezier = [["x","y","rotation",0]];
            _loc8_ = bezierProxy2;
         }
         else if(this.vars.orientToBezier is Array)
         {
            _loc8_ = bezierProxy2;
         }
         if(this.vars.bezier != undefined && this.vars.bezier is Array)
         {
            _loc6_ = {};
            _loc7_ = this.vars.bezier;
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               for(_loc3_ in _loc7_[_loc4_])
               {
                  if(_loc6_[_loc3_] == undefined)
                  {
                     _loc6_[_loc3_] = [this.target[_loc3_]];
                  }
                  if(typeof _loc7_[_loc4_][_loc3_] == "number")
                  {
                     _loc6_[_loc3_].push(_loc7_[_loc4_][_loc3_]);
                  }
                  else
                  {
                     _loc6_[_loc3_].push(this.target[_loc3_] + Number(_loc7_[_loc4_][_loc3_]));
                  }
               }
               _loc4_++;
            }
            for(_loc3_ in _loc6_)
            {
               if(typeof this.vars[_loc3_] == "number")
               {
                  _loc6_[_loc3_].push(this.vars[_loc3_]);
               }
               else
               {
                  _loc6_[_loc3_].push(this.target[_loc3_] + Number(this.vars[_loc3_]));
               }
               delete this.vars[_loc3_];
            }
            addSubTween(_loc8_,{"t":0},{"t":1},{
               "props":parseBeziers(_loc6_,false),
               "target":this.target,
               "orientToBezier":this.vars.orientToBezier
            });
         }
         if(this.vars.bezierThrough != undefined && this.vars.bezierThrough is Array)
         {
            _loc6_ = {};
            _loc7_ = this.vars.bezierThrough;
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               for(_loc3_ in _loc7_[_loc4_])
               {
                  if(_loc6_[_loc3_] == undefined)
                  {
                     _loc6_[_loc3_] = [this.target[_loc3_]];
                  }
                  if(typeof _loc7_[_loc4_][_loc3_] == "number")
                  {
                     _loc6_[_loc3_].push(_loc7_[_loc4_][_loc3_]);
                  }
                  else
                  {
                     _loc6_[_loc3_].push(this.target[_loc3_] + Number(_loc7_[_loc4_][_loc3_]));
                  }
               }
               _loc4_++;
            }
            for(_loc3_ in _loc6_)
            {
               if(typeof this.vars[_loc3_] == "number")
               {
                  _loc6_[_loc3_].push(this.vars[_loc3_]);
               }
               else
               {
                  _loc6_[_loc3_].push(this.target[_loc3_] + Number(this.vars[_loc3_]));
               }
               delete this.vars[_loc3_];
            }
            addSubTween(_loc8_,{"t":0},{"t":1},{
               "props":parseBeziers(_loc6_,true),
               "target":this.target,
               "orientToBezier":this.vars.orientToBezier
            });
         }
         if(this.vars.hexColors != undefined && typeof this.vars.hexColors == "object")
         {
            for(_loc3_ in this.vars.hexColors)
            {
               addSubTween(hexColorsProxy,{
                  "r":this.target[_loc3_] >> 16,
                  "g":this.target[_loc3_] >> 8 & 0xFF,
                  "b":this.target[_loc3_] & 0xFF
               },{
                  "r":this.vars.hexColors[_loc3_] >> 16,
                  "g":this.vars.hexColors[_loc3_] >> 8 & 0xFF,
                  "b":this.vars.hexColors[_loc3_] & 0xFF
               },{
                  "prop":_loc3_,
                  "target":this.target
               });
            }
         }
         super.initTweenVals(true,param2);
      }
      
      override public function get active() : Boolean
      {
         if(_active)
         {
            return true;
         }
         if(_pauseTime != -1)
         {
            return false;
         }
         if((_curTime - this.initTime) / 1000 > this.delay)
         {
            _active = true;
            this.startTime = this.initTime + this.delay * 1000;
            if(!_initted)
            {
               initTweenVals();
            }
            else if(this.vars.visible != undefined && _isDisplayObject)
            {
               this.target.visible = true;
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               --this.startTime;
            }
            return true;
         }
         return false;
      }
      
      protected function initDispatcher() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher(this);
            _callbacks = {
               "onStart":this.vars.onStart,
               "onUpdate":this.vars.onUpdate,
               "onComplete":this.vars.onComplete
            };
            _loc1_ = {};
            for(_loc2_ in this.vars)
            {
               _loc1_[_loc2_] = this.vars[_loc2_];
            }
            this.vars = _loc1_;
            this.vars.onStart = onStartDispatcher;
            this.vars.onUpdate = onUpdateDispatcher;
            this.vars.onComplete = onCompleteDispatcher;
            if(this.vars.onStartListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
            }
            if(this.vars.onUpdateListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
            }
            if(this.vars.onCompleteListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
            }
         }
      }
      
      public function set progress(param1:Number) : void
      {
         var _loc2_:Number = _curTime - this.duration * param1 * 1000;
         this.initTime = _loc2_ - this.delay * 1000;
         var _loc3_:Boolean = this.active;
         this.startTime = _loc2_;
         render(_curTime);
         var _loc4_:* = this.vars.visible;
         if(this.vars.isTV == true)
         {
            _loc4_ = this.vars.exposedProps.visible;
         }
         if(_loc4_ != null && _isDisplayObject && param1 < 1)
         {
            this.target.visible = Boolean(_loc4_);
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(_dispatcher == null)
         {
            initDispatcher();
         }
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.willTrigger(param1);
      }
      
      public function set paused(param1:Boolean) : void
      {
         if(param1)
         {
            this.pause();
         }
         else
         {
            this.resume();
         }
      }
      
      public function resume() : void
      {
         var _loc1_:Number = NaN;
         if(_pauseTime != -1)
         {
            _loc1_ = _curTime - _pauseTime;
            this.initTime += _loc1_;
            if(!isNaN(this.startTime))
            {
               this.startTime += _loc1_;
            }
            _pauseTime = -1;
            if((_curTime - this.initTime) / 1000 > this.delay)
            {
               _active = true;
            }
         }
      }
      
      public function get paused() : Boolean
      {
         if(_pauseTime != -1)
         {
            return true;
         }
         return false;
      }
      
      public function pause() : void
      {
         if(_pauseTime == -1)
         {
            _pauseTime = _curTime;
            _active = false;
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.hasEventListener(param1);
      }
      
      public function get progress() : Number
      {
         var _loc1_:Number = Number((_curTime - this.startTime) / 1000 / this.duration || 0);
         if(_loc1_ > 1)
         {
            return 1;
         }
         return _loc1_;
      }
      
      protected function onCompleteDispatcher(... rest) : void
      {
         if(_callbacks.onComplete != null)
         {
            _callbacks.onComplete.apply(null,this.vars.onCompleteParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
      }
   }
}

