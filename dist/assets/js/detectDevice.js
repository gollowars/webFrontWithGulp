var ua = USERAGENT.analyze(navigator.userAgent);
if(ua.os.name.indexOf('iOS') > -1 || ua.os.name.indexOf('Android') > -1 ){
  window.location.href = "/sp/"
}else{
  window.location.href = "/"
};

document.getElementById("useragent").innerHTML = ua.ua;
document.getElementById("browser").innerHTML = ua.browser.full + " (" + ua.browser.name + " VERSION = "  + ua.browser.version + " )";
document.getElementById("os").innerHTML = ua.os.full + " (" + ua.os.name + " VERSION = "  + ua.os.version + " )";
document.getElementById("device").innerHTML = ua.device.full;