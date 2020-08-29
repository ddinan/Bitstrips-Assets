package br.com.stimuli.loading.utils
{
   public class SmartURL
   {
       
      
      public var rawString:String;
      
      public var port:int;
      
      public var path:String;
      
      public var queryObject:Object;
      
      public var queryString:String;
      
      public var host:String;
      
      public var queryLength:int = 0;
      
      public var fileName:String;
      
      public var protocol:String;
      
      public function SmartURL(param1:String)
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         super();
         this.rawString = param1;
         var _loc2_:RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x;
         var _loc3_:* = _loc2_.exec(param1);
         if(_loc3_)
         {
            protocol = !!Boolean(_loc3_.protocol)?_loc3_.protocol:"http://";
            protocol = protocol.substr(0,protocol.indexOf("://"));
            host = _loc3_.host || null;
            port = !!_loc3_.port?int(int(_loc3_.port)):80;
            path = _loc3_.path;
            fileName = path.substring(path.lastIndexOf("/"),path.lastIndexOf("."));
            queryString = _loc3_.query;
            if(queryString)
            {
               queryObject = {};
               queryString = queryString.substr(1);
               for each(_loc6_ in queryString.split("&"))
               {
                  _loc5_ = _loc6_.split("=")[0];
                  _loc4_ = _loc6_.split("=")[1];
                  queryObject[_loc5_] = _loc4_;
                  queryLength++;
               }
            }
         }
         else
         {
            trace("no match");
         }
      }
      
      public function toString(... rest) : String
      {
         if(rest.length > 0 && rest[0] == true)
         {
            return "[URL] rawString :" + rawString + ", protocol: " + protocol + ", port: " + port + ", host: " + host + ", path: " + path + ". queryLength: " + queryLength;
         }
         return rawString;
      }
   }
}
