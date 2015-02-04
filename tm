#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'yaml'

def prepend(string, c)
  string.gsub /^([^#{c}])/, "#{c}\\1"
end

def prefixed_array_from(comma_separated_names, prefix)
  comma_separated_names.split(",").map {|name| prepend name, prefix}
end

def send_to_slack(slack_webhook_url, body)
  payload = "payload=#{body.to_json}"
  cmd = "curl -sS -o /dev/null -X POST --data-urlencode '#{payload}' #{slack_webhook_url}"
  puts cmd if @options[:verbose]
  `#{cmd}`
end

def create_tmate_session
  # detached tmate sessions require tmate 1.8.10
  `tmate -S /tmp/tmate.sock new-session -d`
  `tmate -S /tmp/tmate.sock wait tmate-ready`
  `tmate -S /tmp/tmate.sock display -p '\#{tmate_ssh}'`.split[1]
end

@options = {verbose: false,
            recipients: []}

OptionParser.new do |opts|
  opts.on('-e', '--emoji [EMOJI]', "Emoji for the tmate request; default=#{ @options[:emoji] }") {|e| @options[:emoji] = e }
  opts.on('-p', '--prefix [INVITATION_MESSAGE]', "prefix; default=#{@options[:prefix]}") {|prefix| @options[:prefix] = prefix }
  opts.on('-v', '--verbose', "verbose; default=#{@options[:verbose]}") {|b| @options[:verbose] = b }
  opts.on('-c', '--channels CHANNEL_LIST', 'Channel names (# not required)') do |names| 
    @options[:recipients].concat(prefixed_array_from(names, '#'))
  end
  opts.on('-u', '--users USER_LIST', 'User names (@ not required)') do |names| 
    @options[:recipients].concat(prefixed_array_from(names, '@'))
  end
  opts.on_tail('-h', '--help', 'print this message') do
    puts opts
    exit 0
  end
end.parse!

yaml_file="#{ENV['HOME']}/.slackmate"
until File.exist? yaml_file do
  print "#{yaml_file} does not exist. Enter the Slack webhook URL to be used (or <enter> to exit): " 
  slack_webhook_url = gets
  exit if slack_webhook_url.strip.empty?
  
  File.open(yaml_file, 'w') do |f| 
    f << {prefix: 'please join ', 
          slack_webhook_url: slack_webhook_url.strip,
          emoji: ':two_men_holding_hands:'}.to_yaml
  end
end
config = YAML.load(File.open(yaml_file))
config = config.each_with_object({}) {|(k, v), h| h[k.to_sym] = v }

@options.merge!(config)

if !@options[:slack_webhook_url]
  puts 'slack_webhook_url is required'
  exit 1
end

if @options[:recipients].empty?
  puts 'at least one channel or user is required'
  exit 1
end

tmate_address = create_tmate_session

author=`whoami`.strip!
text="#{@options[:prefix]}<ssh://#{tmate_address}|tmate session>"
@options[:recipients].each {|recipient| send_to_slack(@options[:slack_webhook_url],
                                                      {channel: recipient, username: author, text: text, icon_emoji: @options[:emoji]})}

exec "ssh #{tmate_address}"
