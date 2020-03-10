module ActiveRecord
  class Base
    class << self
      def sequence_name
        "#{table_name}_#{primary_key}_seq" 
      end
    end
  end

  module ConnectionAdapters
    class PostgreSQLAdapter
      private

      def last_insert_id( table, column = id )
        begin
          klass = Object.const_get( Inflector.classify( table ) )
          sequence_name = klass.sequence_name
        rescue
        end
        0
      end
    end
  end
end