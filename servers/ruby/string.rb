class String
  def camelize
    split('/').map{ |word| word.capitalize}.join('::')
  end

  def constantize
    Object.const_get self
  end
end
