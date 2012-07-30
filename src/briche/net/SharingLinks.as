package briche.net {
        import flash.net.URLRequest;
        import flash.net.navigateToURL;
        
        public class SharingLinks {
                
                public static function Facebook(url:String,title:String):void {
                        var _title:String = parseTitle(title);
                        var _uri:String = "http://www.facebook.com/share.php?u=" + url +"&title=" + _title;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function StumbleUpon(url:String,title:String):void {
                        var _title:String = parseTitle(title);
                        var _uri:String = "http://www.stumbleupon.com/submit?url=" + url +"&title=" + _title;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function Digg(url:String,title:String):void {
                        var _title:String = parseTitle(title);
                        var _uri:String = "http://digg.com/submit/?phase=2&url=" + url +"&title=" + _title;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function Reddit(url:String):void {
                        var _uri:String = "http://www.reddit.com/submit?url=" + url;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function DelIcioUs(url:String,title:String):void {
                        var _title:String = parseTitle(title);
                        var _uri:String = "http://delicious.com/save?jump=yes&url=" + url +"&title=" + _title;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function Twitter(tweet:String):void {
                        var _uri:String = "http://twitter.com/home?status=" + escape(tweet);
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                public static function MySpace(url:String,title:String,content:String="",location:uint=3):void {
                        var _params:String = "t=" + escape(title) + "&c=" + content + "&u=" + escape(url) + "&l=" + location;
                        var _uri:String = "http://www.myspace.com/Modules/PostTo/Pages/?" + _params;
                        try {
                                navigateToURL(new URLRequest(_uri), "_blank");
                        } catch (e:Error) {
                               trace("Unable to navigate to url!");
                        }
                }
                
                private static function parseTitle(title:String):String {
                        var _pattern:RegExp = / /g;
                        return title.replace(_pattern, "+");
                }
        }       
}
