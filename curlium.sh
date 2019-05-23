# vim: set ft=zsh:
alias ccurl="curl -H 'User-Agent: selenium/0.0.1 (curlium)' -H 'Content-Type: application/json'"
alias jq="jq -r"
alias echoe="echo >&2"

open_url(){
  url=${1:=http://google.com}
  [[ $url == http* ]] || url=http://$url
  echo "\n$sessionId: openiing URL: $url"
  ccurl -X POST $URL/session/$sessionId/url -d '{"url":"'$url'"}'
}

get_url(){
  echo "\n$sessionId: getting url"
  ccurl $URL/session/$sessionId/url
}

start_session(){
  local caps

  #while getopts ':b:v:' arg; do
    #case $arg in
      #b) local browserName
        #browserName=$OPTARG
        #;;
      #v) local browser_version
        #browser_version=$OPTARG
        #;;
    #esac
  #done

  caps='{"desiredCapabilities": { "build":"curlium"'
  while [ $# -gt 0 ]
  do
    opt=$1
    case $opt in
       "-b")
         shift ;
         optrg=$1 ;
         local browserName
         browserName=$optrg
         caps+=",\"browserName\":\"$browserName\"";;
       "-bv")
         shift ;
         optrg=$1 ;
         local browser_version
         browser_version=$optrg
         caps+=",\"browser_version\":\"$browser_version\"";;
       "-ov")
         shift ;
         optrg=$1 ;
         local os_version
         os_version=$optrg
         caps+=",\"os_version\":\"$os_version\"";;
       "-o")
         shift ;
         optrg=$1 ;
         local os
         os=$optrg
         caps+=",\"os\":\"$os\"";;
       "-sv")
         shift ;
         optrg=$1 ;
         local selenium_version
         selenium_version=$optrg
         [[ -n $selenium_version ]] && caps+=",\"browserstack.selenium_version\":\"$selenium_version\""
         print "Parameter : $opt Value : $optrg" ;;
     esac
     shift
  done
  caps+='}}'
  #desiredCapabilities=$(jo device='iPad Pro 12.9' realMobile=true)
  echo $caps
  ccurl -X POST $URL/session -d "$caps" | tee /dev/tty | jq -r .sessionId | read sessionId
  echo "\nsession started $sessionId"
  #"browserstack.console":"info","acceptSslCert":false,"detected_language":"selenium/3.14.0 (ruby macosx)"}}
  #"browserstack.idleTimeout":300,
}

get_windows(){
  echoe "\n$sessionId: getting window handles "
  ccurl $URL/session/$sessionId/window/handles
}

switch_window(){
  local data
  data=$(jo handle=$1)
  echoe "\n$sessionId: switching to  window handles $1, data: $data"
  ccurl -X POST $URL/session/$sessionId/window -d "$data"
}

page_source(){
  echoe "\n$sessionId: getting page source"
  ccurl $URL/session/$sessionId/source
}

page_source_for(){
  open_url $1
  page_source
}

find_element_css(){
  #ccurl -X POST $URL/session/$sessionId/element -d '{"using":"css selector","value":"'$1'"}' 
  find_element "css selector" $1
}

find_element(){
  echo '{"using":"'$1'","value":"'$2'"}' 
  ccurl -X POST $URL/session/$sessionId/element -d '{"using":"'$1'","value":"'$2'"}' 
}
find_element_xpath(){
  #ccurl -X POST $URL/session/$sessionId/element -d '{"using":"xpath","value":"'$1'"}' 
  find_element xpath $1
}

click_element(){
  ccurl -X POST $URL/session/$sessionId/element/$1/click
}

stop_session(){
  echo "stopping $sessionId"
  ccurl -X DELETE $URL/session/$sessionId
}

execute_script(){
  local json_string
  json_string=$(jo script=$1 args="[]")
  echo $json_string
  ccurl $URL/session/$sessionId/execute -d $json_string
}

moveto(){
  local json_string
  json_string=$(jo element=$1)
  echo $json_string
  ccurl $URL/session/$sessionId/moveto -d $json_string
}

movetooffset(){
  local json_string
  json_string=$(jo xoffset=$1 yoffset=$2)
  echo $json_string
  ccurl $URL/session/$sessionId/moveto -d $json_string
}

execute_script_sync(){
  local json_string
  json_string=$(jo script=$1 args="[]")
  echo $json_string
  ccurl $URL/session/$sessionId/execute/sync -d "$json_string"
}

set_value(){
  ccurl -X POST $URL/session/$sessionId/element/$1/value -d '{"id":"'$1'","value":["'$2'"]}'
}

get_value(){
  ccurl -X GET $URL/session/$sessionId/element/$1/attribute/value
}

get_title(){
  ccurl -X GET $URL/session/$sessionId/title | jq .value
}
#curl -X POST $URL/session/$s_id/url -d '{"url":"http://www.google.com"}'
#curl -X POST $URL/session/$s_id/element -d '{"using":"name","value":"q"}'
#curl -X POST $URL/$s_id/element/0/value -d {"value":["selenium"]}
#curl -X GET $URL/session/$s_id/screenshot
#curl -X POST $URL/session/$s_id/element -d '{"using":"id","value":"gbqfb"}'
#curl -X POST $URL/session/$s_id/element/1/click
#curl -X POST $URL/session/$s_id/execute/sync -d '{"script": "return window.location"}'
#curl -X DELETE $URL/session/$s_id
#https://github.com/SeleniumHQ/selenium/blob/07a18746ff756e90fd79ef253a328bd7dfa9e6dc/java/client/src/org/openqa/selenium/remote/http/JsonHttpCommandCodec.java
#https://github.com/SeleniumHQ/selenium/blob/2abd80f236d1a7459ef638e96af8c4efd86b4abd/rb/lib/selenium/webdriver/remote/w3c/commands.rb
#
#
#=================== ruby ===================
#post, 'session'],
#delete, 'session/:session_id'],
#post, 'session/:session_id/url'],
#get, 'session/:session_id/url'],
#post, 'session/:session_id/back'],
#post, 'session/:session_id/forward'],
#post, 'session/:session_id/refresh'],
#get, 'session/:session_id/title'],
#get, 'session/:session_id/window'],
#delete, 'session/:session_id/window'],
#post, 'session/:session_id/window'],
#get, 'session/:session_id/window/handles'],
#post, 'session/:session_id/window/fullscreen'],
#post, 'session/:session_id/window/minimize'],
#post, 'session/:session_id/window/maximize'],
#post, 'session/:session_id/window/size'],
#get, 'session/:session_id/window/size'],
#post, 'session/:session_id/window/position'],
#get, 'session/:session_id/window/position'],
#post, 'session/:session_id/window/rect'],
#get, 'session/:session_id/window/rect'],
#post, 'session/:session_id/frame'],
#post, 'session/:session_id/frame/parent'],
#post, 'session/:session_id/element'],
#post, 'session/:session_id/elements'],
#post, 'session/:session_id/element/:id/element'],
#post, 'session/:session_id/element/:id/elements'],
#get, 'session/:session_id/element/active'],
#get, 'session/:session_id/element/:id/selected'],
#get, 'session/:session_id/element/:id/attribute/:name'],
#get, 'session/:session_id/element/:id/property/:name'],
#get, 'session/:session_id/element/:id/css/:property_name'],
#get, 'session/:session_id/element/:id/text'],
#get, 'session/:session_id/element/:id/name'],
#get, 'session/:session_id/element/:id/rect'],
#get, 'session/:session_id/element/:id/enabled'],
#get, 'session/:session_id/source'],
#post, 'session/:session_id/execute/sync'],
#post, 'session/:session_id/execute/async'],
#get, 'session/:session_id/cookie'],
#get, 'session/:session_id/cookie/:name'],
#post, 'session/:session_id/cookie'],
#delete, 'session/:session_id/cookie/:name'],
#delete, 'session/:session_id/cookie'],
#post, 'session/:session_id/timeouts'],
#post, 'session/:session_id/actions'],
#delete, 'session/:session_id/actions'],
#post, 'session/:session_id/element/:id/click'],
#post, 'session/:session_id/element/:id/tap'],
#post, 'session/:session_id/element/:id/clear'],
#post, 'session/:session_id/element/:id/value'],
#post, 'session/:session_id/alert/dismiss'],
#post, 'session/:session_id/alert/accept'],
#get, 'session/:session_id/alert/text'],
#post, 'session/:session_id/alert/text'],
#get, 'session/:session_id/screenshot'],
#get, 'session/:session_id/element/:id/screenshot'],
#post, 'session/:session_id/se/file']
#=================== ruby ===================
#https://github.com/SeleniumHQ/selenium/blob/07a18746ff756e90fd79ef253a328bd7dfa9e6dc/java/client/src/org/openqa/selenium/remote/http/JsonHttpCommandCodec.java
#https://github.com/SeleniumHQ/selenium/blob/aa041a8f9ed39014734510c347d307756b179493/java/client/src/org/openqa/selenium/remote/http/AbstractHttpCommandCodec.java
