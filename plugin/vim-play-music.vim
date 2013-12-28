function! PlayYoutubeMusic(name) 
    let searchString = a:name
python << EOF
import os
import signal
import subprocess
import urllib2
import vim

VLC_APP = "/Applications/VLC.app/Contents/MacOS/VLC"
TO_WATCH_URL = "http://www.youtube.com"

# close any existing instances of VLC
p = subprocess.Popen(['ps', '-A'], stdout=subprocess.PIPE)
out, err = p.communicate()
for line in out.splitlines():
    if (VLC_APP in line):
        pid = int(line.split(None, 1)[0])
        os.kill(pid, signal.SIGKILL)

# play the new search
search_str = vim.eval("searchString")
url_str = "http://www.youtube.com/results?search_query=" + urllib2.quote(search_str) 
webpage = urllib2.urlopen(url_str)
website_html = webpage.read()
start_idx = website_html.find("/watch?");
idx = start_idx
while website_html[idx] != "\"":
    TO_WATCH_URL += website_html[idx]
    idx += 1
args = [VLC_APP, TO_WATCH_URL]
DEVNULL = open(os.devnull, 'wb')
p = subprocess.Popen(args, stdout=DEVNULL, stderr=DEVNULL)
EOF
endfunction
