#!/usr/bin/env ruby

require 'optparse'
require 'json'

def prepend(string, c)
  string.gsub /^([^#{c}])/, "#{c}\\1"
end

def prefixed_array_from(comma_separated_names, prefix)
  comma_separated_names.split(",").map {|name| prepend name, prefix}
end

def send_to_slack(body)
  payload = "payload=#{body.to_json}"
  cmd = "curl -sS -o /dev/null -X POST --data-urlencode '#{payload}' #{SLACK_WEBHOOK_URL}"
  puts cmd if @options[:verbose]
  `#{cmd}`
end

def create_tmate_session
  # detached tmate sessions require tmate 1.8.10
  `tmate -S /tmp/tmate.sock new-session -d`
  `tmate -S /tmp/tmate.sock wait tmate-ready`
  `tmate -S /tmp/tmate.sock display -p '\#{tmate_ssh}'`.split[1]
end

@options = {emoji: ':leftshark:', 
            prefix: 'please join ', 
            verbose: false,
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

if @options[:recipients].empty?
  puts 'at least one channel or user is required'
  exit 1
end

tmate_address = create_tmate_session

author=`whoami`.strip!
text="#{@options[:prefix]}<ssh://#{tmate_address}|tmate session>"
@options[:recipients].each {|recipient| send_to_slack({channel: recipient, username: author, text: text, icon_emoji: @options[:emoji]})}

exec "ssh #{tmate_address}"
