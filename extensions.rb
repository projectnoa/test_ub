
class NilClass
  def blank?
    true
  end
end

class String
  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true
  #
  def blank?
    # The regexp that matches blank strings is expensive. For the case of empty
    # strings we can speed up this method (~3.5x) with an empty? call. The
    # penalty for the rest of strings is marginal.
    empty? || /\A[[:space:]]*\z/x.match?(self)
  end

  def truncate(max)
    self.length > max ? "#{self[0...max]}..." : self
  end
end

class Array
  #   [].blank?      # => true
  #   [1,2,3].blank? # => false
  alias_method :blank?, :empty?
end

class Hash
  #   {}.blank?                # => true
  #   { key: 'value' }.blank?  # => false
  alias_method :blank?, :empty?
end
