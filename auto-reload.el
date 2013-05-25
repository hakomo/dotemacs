
(require 'moz)

(defun auto-reload-after-save ()
  (add-hook 'after-save-hook
            '(lambda ()
               (interactive)
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
"))))

(add-hook 'web-mode-hook 'auto-reload-after-save)
(add-hook 'css-mode-hook 'auto-reload-after-save)
(add-hook 'js-mode-hook 'auto-reload-after-save)
