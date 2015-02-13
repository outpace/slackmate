#!/usr/bin/env ruby

require 'json'

class Slack
  def initialize(slack_options)
    @options = slack_options
  end

  def send(payload)
    cmd = "curl -sS -o /dev/null -X POST --data-urlencode '#{payload}' #{@options[:slack_webhook_url]}"
    puts cmd if @options[:verbose]
    `#{cmd}`
  end

  def send_all(text, from)
    @options[:recipients].each do |recipient| 
      body = {channel: recipient, username: from, text: text, icon_emoji: @options[:emoji]}
      send("payload=#{body.to_json}")
    end
  end


end
