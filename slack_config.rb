require 'yaml'

class SlackConfig
  def self.load
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
    yaml = YAML.load(File.open(yaml_file))
    yaml.each_with_object({}) {|(k, v), h| h[k.to_sym] = v.strip }
  end
end 
