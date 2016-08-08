class Disque

  DEFAULTS = {
    getjob: { count: 16, timeout: 0 }
  }

  def que(method, *attributes)
    @count += 1
    pick_client!
    call method, *attributes
  end

end

class String
  def camelize
    split('/').map{ |word| word.split('_').map(&:capitalize).join }.join('::')
  end

  def constantize
    Object.const_get self
  end
end
