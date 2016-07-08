class String
  def camelize
    split('/').map{ |word| word.split('_').map(&:capitalize).join }.join('::')
  end

  def constantize
    Object.const_get self
  end
end
