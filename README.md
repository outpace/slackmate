# slackmate
tmate utility for slack

* Requires v 1.8.10 or later of tmate 

```brew upgrade tmate```

## Installation

Copy/link the script into an executable directory on your path (/usr/local/bin)

On first run, you will be prompted to supply the Slack webhook URL for incoming requests. You need to refer to the Slack home for your organization to set that URL up.

Slack will post an ssh:// link. You will want to configure iTerm 2 to open when clicking on this link:

1. Preferences->Profiles->+  (add a new profile).
1. Under Preferences->Profiles->General->Command, select the Command radio button and enter $$.
1. Under Preferences->Profiles->General->URL Schemes->Schemes handled, select ssh.

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
