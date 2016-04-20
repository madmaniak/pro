require 'disque'

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
