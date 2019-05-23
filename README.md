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

