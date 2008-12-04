module ActsAsRestricted

    SQL_NO_RESTRICTIONS = "1"
    SQL_NO_ACCESS = "0"

    def self.included(base)
        base.extend(SingletonMethods)
    end

    module SingletonMethods

        def acts_as_restricted(options = {})
            attr_accessor :is_restricted

            options = { :read => true, :write => true, :use_restriction => true }.merge(options)

            write_inheritable_attribute :acts_as_restricted_set_options, options
            class_inheritable_reader :acts_as_restricted_set_options

            include InstanceMethods
            extend ClassMethods

            # todo: we need instantiate any records with restricted == true if called from restricted named_scope
# overwrite find_every to set restricted on every instantiate object where options[:is_restricted]

            named_scope :restricted, lambda { {:conditions => condition, :joins => join, :select => select, :readonly => true} }
        end

        module InstanceMethods

	    def is_restricted?
                is_restricted
	    end

            def restricted?
                return true
            end

            def current_user
                if Thread.current['user']
                    return Thread.current['user']
                else
                    return nil
                end
            end

        end

        module ClassMethods

def find_every(options)
    records = super(options)
    records.each { |record| record.is_restricted = true } if options[:readonly]
    records
end

            def current_user
                if Thread.current['user']
                    return Thread.current['user']
                else
                    return nil
                end
            end

        private

            def restricted_condition
                return SQL_NO_RESTRICTIONS
            end

            def restricted_join
                return nil
            end

            def restricted_select
                return nil
            end

            def join
                if acts_as_restricted_set_options[:use_restriction] == false or
                   acts_as_restricted_set_options[:read] == false
                       return nil
                else
                    restricted_join
                end
            end

            def condition
                if acts_as_restricted_set_options[:use_restriction] == false or
                   acts_as_restricted_set_options[:read] == false
                       return SQL_NO_RESTRICTIONS # effectively do nothing
                else
                    restricted_condition
                end
            end

            def select
                if acts_as_restricted_set_options[:use_restriction] == false or
                   acts_as_restricted_set_options[:read] == false
                       return nil
                else
                    restricted_select
                end
            end

        end
    end

end
