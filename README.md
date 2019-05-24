# Curlium
Contains curl implementation of few selenium commands for quick debugging selenium hub while I was working at Browsertack

## Dependancies

jo, jq
Install them by running

`brew install jo jq`

## Installation

simply download ./curlium.sh file and source it in your enviroment (`.zshrc`, `.bashrc`)

## Usage
export selenium hub URL in your enviroment, Example

```
export URL=http://$BROWSERSTACK_USER:$BROWSERSTACK_ACCESS_KEY@hub.browserstack.com/wd/hub
```

either you can commands directly from shell or write shell script like following

```
source ./curlium.sh
start_session -b ie -bv 11 -ov 10 -o windows # -b is browser, -bv is browser_version, -ov is os_version
open_url "google.com"
element=$(find_element name q)
set_value $element "Browserstack\n"
get_title
stop_session
```

