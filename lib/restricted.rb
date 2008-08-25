module Restricted
        module Dependencies

            def load_missing_constant(from, const_name)

                if from == Restricted
                    if ::Object.const_defined?(const_name)
                        base_obj = Object.const_get(const_name)
                    else
                        super(from, const_name)
                        base_obj = Object.const_get(const_name)
                    end
                end

                if base_obj
                    if defined? base_obj.restricted? and base_obj.restricted?

                        c = Class.new(base_obj)
                        c.acts_as_restricted_set_options[:use_restriction] = true
                        return c

                    end
                end

                super(from, const_name)
            end
       end

       Kernel::Dependencies.extend Restricted::Dependencies
end
