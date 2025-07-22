package fl.video
{
   import flash.net.NetConnection;
   
   use namespace flvplayback_internal;
   
   public class ConnectClient
   {
      
      public var connIndex:uint;
      
      public var nc:NetConnection;
      
      public var pending:Boolean;
      
      public var owner:NCManager;
      
      public function ConnectClient(param1:NCManager, param2:NetConnection, param3:uint = 0)
      {
         super();
         this.owner = param1;
         this.nc = param2;
         this.connIndex = param3;
         this.pending = false;
      }
      
      public function onBWCheck(... rest) : Number
      {
         return ++owner.flvplayback_internal::_payload;
      }
      
      public function onBWDone(... rest) : void
      {
         var _loc2_:Number = NaN;
         if(rest.length > 0)
         {
            _loc2_ = Number(rest[0]);
         }
         owner.flvplayback_internal::onConnected(nc,_loc2_);
      }
      
      public function close() : void
      {
      }
   }
}

