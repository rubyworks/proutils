class Object

  # Same as `#to_yaml` but removes the initial `---` line.
  #
  # @return [String]
  def to_yamlfrag
    str = to_yaml
    if /\A--- !/ =~ str
      str = str.sub(/\A--- !.*?$/,'') #.lstrip
    else
      str = str.sub(/\A---\s*/,'')
    end
    str.chomp("\n...\n")
  end

end

