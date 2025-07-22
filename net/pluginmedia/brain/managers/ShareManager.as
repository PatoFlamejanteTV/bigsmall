package net.pluginmedia.brain.managers
{
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.Manager;
   import net.pluginmedia.brain.core.events.ShareReferenceEvent;
   import net.pluginmedia.brain.core.events.ShareRequestEvent;
   import net.pluginmedia.brain.core.interfaces.ISharer;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   
   public class ShareManager extends Manager
   {
      
      public static var references:Dictionary = new Dictionary(true);
      
      private var referenceRequestList:Array = [];
      
      private var i:uint;
      
      private var referenceRequestListSpaces:Array = [];
      
      public function ShareManager()
      {
         super();
      }
      
      override public function register(param1:Object) : void
      {
         var _loc2_:ISharer = param1 as ISharer;
         super.register(param1);
         param1.addEventListener(ShareReferenceEvent.SHARE_REFERENCE,handleShareReferenceEvent);
         param1.addEventListener(ShareRequestEvent.SHARE_REQUEST,handleShareRequestEvent);
         _loc2_.onShareableRegistration();
      }
      
      private function addReferenceRequest(param1:ShareRequest) : void
      {
         var _loc3_:SharerInfo = null;
         var _loc2_:Boolean = referenceExists(param1.id);
         if(_loc2_)
         {
            _loc3_ = getReference(param1.id);
            if(param1.callback != null)
            {
               param1.callback(_loc3_);
            }
            param1.sharer.receiveShareable(_loc3_);
         }
         if(_loc2_ && param1.autoDelete)
         {
            return;
         }
         addRequestToList(param1);
      }
      
      private function handleShareReferenceEvent(param1:ShareReferenceEvent) : void
      {
         addReference(param1.sharerInfo);
      }
      
      public function referenceExists(param1:String) : Boolean
      {
         return references[param1] is Object;
      }
      
      public function addReference(param1:SharerInfo) : void
      {
         if(referenceExists(param1.id))
         {
         }
         references[param1.id] = param1.reference;
         checkRequestList();
      }
      
      override public function unregister(param1:Object) : Boolean
      {
         var _loc2_:ISharer = param1 as ISharer;
         param1.removeEventListener(ShareReferenceEvent.SHARE_REFERENCE,handleShareReferenceEvent);
         param1.removeEventListener(ShareRequestEvent.SHARE_REQUEST,handleShareRequestEvent);
         return super.unregister(param1);
      }
      
      private function checkRequestList() : void
      {
         var _loc1_:ShareRequest = null;
         var _loc2_:Boolean = false;
         var _loc3_:SharerInfo = null;
         i = 0;
         while(i < referenceRequestList.length)
         {
            if(referenceRequestList[i] != undefined)
            {
               _loc1_ = referenceRequestList[i] as ShareRequest;
               _loc2_ = referenceExists(_loc1_.id);
               if(_loc2_)
               {
                  _loc3_ = getReference(_loc1_.id);
                  _loc1_.callback(_loc3_);
                  _loc1_.sharer.receiveShareable(_loc3_);
               }
               if(_loc2_ && _loc1_.autoDelete)
               {
                  referenceRequestListSpaces.push(i);
                  referenceRequestList[i] = undefined;
               }
            }
            ++i;
         }
      }
      
      public function removeReference(param1:String) : void
      {
         if(referenceExists(param1))
         {
            delete references[param1];
         }
      }
      
      private function handleShareRequestEvent(param1:ShareRequestEvent) : void
      {
         addReferenceRequest(param1.shareRequest);
      }
      
      public function getReference(param1:String) : SharerInfo
      {
         return new SharerInfo(param1,references[param1]);
      }
      
      private function addRequestToList(param1:ShareRequest) : void
      {
         if(referenceRequestListSpaces.length < 1)
         {
            referenceRequestList.push(param1);
         }
         else
         {
            referenceRequestList[referenceRequestListSpaces.pop()] = param1;
         }
      }
      
      private function handleRemoveRequestEvent(param1:ShareRequestEvent) : void
      {
         removeRequest(param1.shareRequest);
      }
      
      public function removeRequest(param1:ShareRequest) : void
      {
         var _loc2_:ShareRequest = null;
         i = 0;
         while(i < referenceRequestList.length)
         {
            if(referenceRequestList[i] != undefined)
            {
               _loc2_ = referenceRequestList[i];
               if(_loc2_.id == param1.id && _loc2_.sharer == param1.sharer && _loc2_.callback == param1.callback)
               {
                  referenceRequestList[i] = undefined;
                  referenceRequestListSpaces.push(i);
               }
            }
            ++i;
         }
      }
      
      private function handleRemoveReferenceEvent(param1:ShareReferenceEvent) : void
      {
         removeReference(param1.sharerInfo.id);
      }
   }
}

