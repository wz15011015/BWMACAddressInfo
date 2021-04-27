
// 打开链接
function open_link(url_str) {
    window.webkit.messageHandlers.click_url.postMessage(url_str)
}
