class Item < ActiveRecord::Base
    acts_as_restricted :read => true

    def self.restricted_write
        true
    end

    def self.restricted_condition
        "groups.user_id = 1"
    end

    def self.restricted_select
        "items.name,groups.user_id"
    end

    def self.restricted_join
        "LEFT OUTER JOIN groups on items.group_id = groups.id"
    end
end

