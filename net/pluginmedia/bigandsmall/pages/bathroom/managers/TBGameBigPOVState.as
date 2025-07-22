package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   public class TBGameBigPOVState
   {
      
      private var _mouseUp:Function;
      
      private var _mouseDown:Function;
      
      private var _updater:Function;
      
      private var _label:int;
      
      private var _selector:Function;
      
      private var _deselector:Function;
      
      public function TBGameBigPOVState(param1:int, param2:Function = null, param3:Function = null, param4:Function = null, param5:Function = null, param6:Function = null)
      {
         super();
         _label = param1;
         _selector = param2;
         _deselector = param3;
         _updater = param4;
         _mouseDown = param5;
         _mouseUp = param6;
      }
      
      public function select(... rest) : void
      {
         if(_selector is Function)
         {
            _selector.apply(null,rest);
         }
      }
      
      public function update(... rest) : void
      {
         if(_updater is Function)
         {
            _updater.apply(null,rest);
         }
      }
      
      public function stageMouseDown(... rest) : void
      {
         if(_mouseDown is Function)
         {
            _mouseDown.apply(null,rest);
         }
      }
      
      public function stageMouseUp(... rest) : void
      {
         if(_mouseUp is Function)
         {
            _mouseUp.apply(null,rest);
         }
      }
      
      public function get label() : int
      {
         return _label;
      }
      
      public function deselect(... rest) : void
      {
         if(_deselector is Function)
         {
            _deselector.apply(null,rest);
         }
      }
   }
}

