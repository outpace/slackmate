# slackmate
tmate utility for slack

* Requires v 1.8.10 or later of tmate 

```brew upgrade tmate```

## Installation

Copy/link the script into an executable directory on your path (/usr/local/bin)

On first run, you will be prompted to supply the Slack webhook URL for incoming requests. You need to refer to the Slack home for your organization to set that URL up.

## Running

`tm -h` for options:
```
Usage: tm [options]
    -e, --emoji [EMOJI]              Emoji for the tmate request; default=:two_men_holding_hands:
    -p [INVITATION_MESSAGE],         prefix; default=please join
        --prefix
    -v, --verbose                    verbose; default=false
    -c, --channels CHANNEL_LIST      Channel names (# not required)
    -u, --users USER_LIST            User names (@ not required)
    -h, --help                       print this message
```

# slackmate
