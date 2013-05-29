
(require 'moz)

(defun auto-reload ()
  (comint-send-string (inferior-moz-process) "
function reload(){
  var i;
  for(i=0;i<gBrowser.browsers.length;++i){
    var host=gBrowser.getBrowserAtIndex(i).currentURI.host;
    if(host=='localhost')break;
  }
  if(i>=gBrowser.browsers.length)return;
  gBrowser.selectedTab=gBrowser.tabContainer.childNodes[i];
  BrowserReload();
}
reload();
"))

(provide 'auto-reload)
