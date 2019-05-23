source ./curlium.sh
start_session -b ie -bv 11 -ov 10 -o windows # -b is browser, -bv is browser_version, -ov is os_version 
open_url "google.com"
element=$(find_element name q)
set_value $element "Browserstack\n"
get_title
stop_session
