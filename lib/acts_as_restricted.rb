module ActsAsRestricted

    def self.included(base)
        base.extend(SingletonMethods)
    end

    module SingletonMethods

        def acts_as_restricted(options = {})

            options = { :read => true, :write => true, :use_restriction => false }.merge(options)

            write_inheritable_attribute :acts_as_restricted_set_options, options
            class_inheritable_reader :acts_as_restricted_set_options

            include InstanceMethods
            extend ClassMethods
        end

        module InstanceMethods

            def before_save
                if acts_as_restricted_set_options[:use_restriction] == false or
                   acts_as_restricted_set_options[:write] == false
                       super # basically do nothing
                else
                    restricted_write_condition
                end
            end

            def method_missing(method_id, *arguments)
                if method_id.to_s == "restricted_write_condition"
                    raise "ActsAsRestricted: save not allowed"
                else
                    super(method_id, *arguments)
                end
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

            def restricted?
                true
            end

            def count(*args)
                clist = [ condition ]
                joins = join || String.new

                options = args.extract_options!
                combined_joins = options[:joins] ? options[:joins] + " " + joins : nil

                self.with_scope( :find => { :joins => combined_joins, :conditions => clist } ) do
                    super(*args)
                end
            end

            def find_every(options)
                clist = [ condition ]
                joins = join || String.new

                combined_joins = options[:joins] ? options[:joins] + " " + joins : nil

                self.with_scope( :find => { :joins => combined_joins, :conditions => clist } ) do
                    super(options)
                end
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
                return "0"
            end

            def restricted_join
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
                       return "1" # effectively do nothing
                else
                    restricted_condition
                end
            end

        end
    end

end
