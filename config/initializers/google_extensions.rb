# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }

# You can also remove all the silencers if you're trying do debug a problem that might steem from framework code.
# Rails.backtrace_cleaner.remove_silencers!

module ActiveRecord
  class Base
    def options_for(label)
      self.class.google_label.select { | field | field[:id] == label }
    end
    def value_for(label)
      { "v" => self.send(options_for(label)[:method]) }
    end
    def google_value
      {
        "c" => self.class.google_labels.inject([]) do | cumulative , options |
          cumulative << { "v" => self.send(options[:method]) }
        end
      }
    end
    def self.google_label
      google_labels.collect do | options |
        options.except(:method)
      end
    end
    def self.google_labels
      read_inheritable_attribute(:google_labels) || write_inheritable_attribute(:google_labels,[])
    end
    def self.add_google_label(options={})
      options.symbolize_keys!
      google_labels << options
    end
  end
end
