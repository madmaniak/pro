require 'concurrent'
require 'json'
require 'semantic_logger'

SemanticLogger.add_appender('development.log')
SemanticLogger.default_level = :trace

class Service

  SERVICE_POOL = Concurrent::CachedThreadPool.new
  include SemanticLogger::Loggable

  def run(job)
    SERVICE_POOL.post do
      begin
        perform(prepare(job))
        logger.trace "#{job}: OK"
      rescue => reason
        logger.error "#{job}: #{reason}"
      end
    end
  end

  private

  def prepare(message)
    JSON.parse(message)
  end

  def prepare_send(message)
    JSON.fast_unparse(message)
  end

  def perform(data)
  end

  def reply(data)
    $dis.with do |dis|
      dis.que :addjob,
        :send, prepare_send(data), 60,
        :replicate, 1, :retry, 0, :ttl, 2
    end
  end

end
