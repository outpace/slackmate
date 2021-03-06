#!/usr/bin/env ruby

require_relative 'slack'
require_relative 'slack_config'
require_relative 'tmate'
require_relative 'slack_options'

options = SlackOptions.new(SlackConfig.load)
options.add_opt_on('-p', '--prefix [INVITE_MSG]', 'prefix', :prefix)
exit 1 if !options.parse!

slack = Slack.new(options)

TMate.create_detached_session
tmate_address = TMate.detached_address
author=`whoami`.strip!
text="#{options[:prefix]} <ssh://#{tmate_address}|tmate session>"

slack.send_all(text, author)

exec "ssh #{tmate_address}"
