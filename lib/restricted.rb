module Restricted
        module Dependencies

            def load_missing_constant(from, const_name)
                if @loaded != const_name
                    @loaded = const_name
                    base_obj = Object.const_get(const_name)

                    if defined? base_obj.restricted? and base_obj.restricted?

                        c = Class.new(base_obj)
                        c.acts_as_restricted_set_options[:use_restriction] = true
                        return Restricted.const_set(const_name, c)

                    end
                end

                super(from, const_name)
            rescue
                return # hack ?
            end
       end

       Kernel::Dependencies.extend Restricted::Dependencies
end
