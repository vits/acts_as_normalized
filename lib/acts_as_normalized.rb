module ActsAsNormalized
 
  def self.included(base)
    base.extend ClassMethods
  end
 
  module ClassMethods
 
    def acts_as_normalized(*args, &block)
      options = {
        :nilify => false
      }.merge(args.extract_options!)
      
      before_validation do |record|
        record.attributes.each do |attr, value|
          next unless args.include?(attr.to_sym)
          if value.respond_to?(:strip)
            value = value.blank? ? (options[:nilify] ? nil : '') : value.strip
          end
          record[attr] = block_given? ? yield(value) : value
        end
      end
    end
    
  end
end
