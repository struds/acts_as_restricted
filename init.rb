require 'acts_as_restricted'

ActiveRecord::Base.class_eval do
    include ActsAsRestricted
end

