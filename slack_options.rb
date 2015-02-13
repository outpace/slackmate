require 'optparse'

class SlackOptions
  attr_reader :options

  def initialize(options)
    @options = {verbose: false, recipients: []}.merge(options)
    create_option_parser
  end

  def fail_required_slack_webhook_url
    puts 'slack_webhook_url is required'
    false
  end

  def fail_required_channel_or_user
    puts 'at least one channel or user is required'
    false
  end

  def parse!
    result = @parser.parse!
    return false if !result
    return fail_required_slack_webhook_url if !options[:slack_webhook_url]
    return fail_required_channel_or_user if options[:recipients].empty?
    result
  end

  def [](key)
    @options[key]
  end

  def prepend(string, c)
    string.gsub /^([^#{c}])/, "#{c}\\1"
  end

  def prefixed_array_from(comma_separated_names, prefix)
    comma_separated_names.split(",").map {|name| prepend name, prefix}
  end

  def create_option_parser
    @parser = OptionParser.new do |opts|
      opts.on('-e', '--emoji [EMOJI]', "Emoji to display; default=#{ @options[:emoji] }") {|e| @options[:emoji] = e }
      opts.on('-v', '--verbose', "verbose; default=#{@options[:verbose]}") {|b| @options[:verbose] = b }
      opts.on('-c', '--channels CHANNEL_LIST', 'Channel names') do |names| 
        @options[:recipients].concat(prefixed_array_from(names, '#'))
      end
      opts.on('-u', '--users USER_LIST', 'User names') do |names| 
        @options[:recipients].concat(prefixed_array_from(names, '@'))
      end
      opts.on_tail('-h', '--help', 'print this message') do
        puts opts
        exit 0
      end
    end
  end

  def add_opt_on(short, long, description, key)
    @parser.on(short, long, "#{description}; default=#{@options[key]}") {|v| @options[key] = v}
  end
end
