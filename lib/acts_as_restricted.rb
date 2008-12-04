module ActsAsRestricted

    SQL_NO_RESTRICTIONS = "1"
    SQL_NO_ACCESS = "0"

    def self.included(base)
        base.extend(SingletonMethods)
    end

    module SingletonMethods

        def acts_as_restricted(options = {})

            options = { :read => true, :write => true }.merge(options)

            write_inheritable_attribute :acts_as_restricted_set_options, options
            class_inheritable_reader :acts_as_restricted_set_options

            include InstanceMethods
            extend ClassMethods

            if acts_as_restricted_set_options[:write] == false
                named_scope :restricted, lambda { {:conditions => condition, :joins => join, :select => select, :readonly => true} }
            else
                named_scope :restricted, lambda { {:conditions => condition, :joins => join, :select => select, :readonly => restricted_write} }
            end
        end

        module InstanceMethods

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

            def restricted_write
                return false
            end

            def join
                if acts_as_restricted_set_options[:read] == false
                       return nil
                else
                    restricted_join
                end
            end

            def condition
                if acts_as_restricted_set_options[:read] == false
                       return SQL_NO_RESTRICTIONS # effectively do nothing
                else
                    restricted_condition
                end
            end

            def select
                if acts_as_restricted_set_options[:read] == false
                       return nil
                else
                    restricted_select
                end
            end

        end
    end

end
