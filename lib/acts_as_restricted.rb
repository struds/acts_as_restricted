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
            #  - overide named_scope to see if restricted and set attr_accessor :is_restricted
            #  - on instantiate set is_restricted true on all new objects?
            #  - then overrite before_save to check if is_restricted?
            # possibly use after_initialize callback to set attr_acessor is_restricted

            named_scope :restricted, lambda { {:conditions => condition, :joins => join, :select => select} }
        end

        module InstanceMethods

	    def after_initialize
                self.is_restricted = true
	    end

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
