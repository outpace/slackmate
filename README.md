# slackmate
tmate utilities for slack

* Detached option requires v 1.8.10 or later of tmate 

```brew upgrade tmate```

## Installation

Link the scripts (tm and/or tmslack) into an executable directory on your path (e.g. /usr/local/bin)

On first run, you will be prompted to supply the Slack webhook URL for incoming requests. You need to refer to the Slack home for your organization to set that URL up.

## Scripts

tm: Creates a detached tmate session, posts invites to slack, joins the session. Downside: tmate limitations prevent some tmux commands from operating.

tmslack: Posts invites to slack once you are in a tmate session.

Slack will post an ssh:// link. You will want to configure iTerm 2 to open when clicking on this link:

1. Preferences->Profiles->+  (add a new profile).
1. Under Preferences->Profiles->General->Command, select the Command radio button and enter $$.
1. Under Preferences->Profiles->General->URL Schemes->Schemes handled, select ssh.

## Running

`tm -h` for options:
`tmslack -h` for options:

