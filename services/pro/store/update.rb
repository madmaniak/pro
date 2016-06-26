module Front::Services::Pro
  module Store
    class Update < Service

      def perform(data)
        function = data['transition'].gsub('/', '_')
        $db[data['ref'][0].to_sym]
          .where(id: data['ref'][1])
          .update("data = #{function}('#{data['ref'].to_json}', '#{data['params'].to_json}')")
        reply data.merge(broadcast: true)
      end

    end
  end
end
