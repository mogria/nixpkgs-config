# c.content.proxy = "http://localhost:8090"
from qutebrowser.api import interceptor

config.load_autoconfig(False)

# reopen tabs from previous session
c.auto_save.session = True

c.content.blocking.enabled = True
c.content.blocking.method = "adblock"
c.content.blocking.adblock.lists = [
  "https://easylist.to/easylist/easylist.txt",
  "https://easylist.to/easylist/easyprivacy.txt",
  "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
  "https://easylist.to/easylist/fanboy-social.txt",
  "https://easylist.to/easylistgermany/easylistgermany.txt",
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt",
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
  "https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt"
]

# block youtube ads from playing. still have to skip them however.
def filter_yt(info: interceptor.Request):
	url = info.request_url
	if (url.host() == "www.youtube.com" 
		and url.path() == "/get_video_info"
		and "&adformat=" in url.query()
	):
		info.block()

interceptor.register(filter_yt)

# spawn mpv
config.bind('w', 'spawn -d mpv {url}', mode='normal')
