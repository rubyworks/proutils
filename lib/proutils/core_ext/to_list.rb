class Array

  # Helper method for cleaning list options. This simply returns
  # the array making sure there are no nil elements.
  #
  # @return [Array]
  def to_list
    compact
  end

end

class NilClass

  # Helper method for cleaning list options. This returns an 
  # empty array.
  #
  # @return [Array]
  def to_list
    []
  end

end

class String

  # Helper method for cleaning list options. This will split the
  # a string on `:`, `;` or `,`. --if it is a string, rather than
  # an array. And it will make sure there are no nil elements.
  #
  # @return [Array]
  def to_list
    split(/[:;,\n]/)
  end

end

