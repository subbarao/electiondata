# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }

# You can also remove all the silencers if you're trying do debug a problem that might steem from framework code.
# Rails.backtrace_cleaner.remove_silencers!

module ActiveRecord
  class Base

    def options_for( name )
      self.class.google_labels.find { | ops | ops[:id] == name }
    end

    def value_for( name, instance )
      { "v" => options_for(name)[:method].call(instance) }
    end

    def google_value( instance )
      { "c" => self.class.google_labels.inject([]) { | col , ops | col << value_for(ops[:id],instance) } }
    end

    class<<self

      def google_columns
        google_labels.collect { | options | options.except(:method) }
      end

      def google_labels
        read_inheritable_attribute(:google_labels) || write_inheritable_attribute(:google_labels,[])
      end

      def add_google_label(options={})
        options.symbolize_keys!
        google_labels << options.merge(:label => options[:id].camelize )
      end

    end

  end

end
