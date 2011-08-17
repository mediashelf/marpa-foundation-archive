module ActiveFedora
  module Associations
    class AssociationProxy
       def initialize(owner, reflection)
        @owner, @reflection = owner, reflection
        @updated = false
        # reflection.check_validity!
        # Array.wrap(reflection.options[:extend]).each { |ext| proxy_extend(ext) }
        reset
      end

      # Resets the \loaded flag to +false+ and sets the \target to +nil+.
      def reset
        @loaded = false
        @target = nil
      end

      # Reloads the \target and returns +self+ on success.
      def reload
        reset
        load_target
        self unless @target.nil?
      end

      # Has the \target been already \loaded?
      def loaded?
        @loaded
      end

      # Asserts the \target has been loaded setting the \loaded flag to +true+.
      def loaded
        @loaded = true
      end

      # Returns the target of this proxy, same as +proxy_target+.
      def target
        @target
      end

      # Sets the target of this proxy to <tt>\target</tt>, and the \loaded flag to +true+.
      def target=(target)
        @target = target
        loaded
      end

      # # Forwards the call to the target. Loads the \target if needed.
      # def inspect
      #   load_target
      #   @target.inspect
      # end

      protected


        # Assigns the ID of the owner to the corresponding foreign key in +record+.
        # If the association is polymorphic the type of the owner is also set.
        def set_belongs_to_association_for(record)
          unless @owner.new_record?
            record.add_relationship(@reflection.options[:property], @owner)
          end
        end


      private
        def method_missing(method, *args)
          if load_target
            unless @target.respond_to?(method)
              message = "undefined method `#{method.to_s}' for \"#{@target}\":#{@target.class.to_s}"
              raise NoMethodError, message
            end

            if block_given?
              @target.send(method, *args)  { |*block_args| yield(*block_args) }
            else
              @target.send(method, *args)
            end
          end
        end


        # Loads the \target if needed and returns it.
        #
        # This method is abstract in the sense that it relies on +find_target+,
        # which is expected to be provided by descendants.
        #
        # If the \target is already \loaded it is just returned. Thus, you can call
        # +load_target+ unconditionally to get the \target.
        #
        # ActiveRecord::RecordNotFound is rescued within the method, and it is
        # not reraised. The proxy is \reset and +nil+ is the return value.
        def load_target
          return nil unless defined?(@loaded)

          if !loaded? and (!@owner.new_record? || foreign_key_present)
            @target = find_target
          end

          @loaded = true
          @target
        rescue ActiveRecord::RecordNotFound
          reset
        end




        # Raises ActiveRecord::AssociationTypeMismatch unless +record+ is of
        # the kind of the class of the associated objects. Meant to be used as
        # a sanity check when you are about to assign an associated record.
        def raise_on_type_mismatch(record)
          unless record.is_a?(@reflection.klass) || record.is_a?(@reflection.class_name.constantize)
            message = "#{@reflection.class_name}(##{@reflection.klass.object_id}) expected, got #{record.class}(##{record.class.object_id})"
            raise ActiveRecord::AssociationTypeMismatch, message
          end
        end


        if RUBY_VERSION < '1.9.2'
          # Array#flatten has problems with recursive arrays before Ruby 1.9.2.
          # Going one level deeper solves the majority of the problems.
          def flatten_deeper(array)
            array.collect { |element| (element.respond_to?(:flatten) && !element.is_a?(Hash)) ? element.flatten : element }.flatten
          end
        else
          def flatten_deeper(array)
            array.flatten
          end
        end

    end
  end
end
