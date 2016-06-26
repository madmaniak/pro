module Front::Services::Pro
  module Store
    class Update < Service

      def perform(data)
        function = data['transition'].gsub('/', '_')
        $db[data['ref'][0].to_sym]
          .where(id: data['ref'][1])
          .update("data = #{function}('#{data['ref'].to_json}', '#{data['params'].to_json}')")
        reply broadcast: true, sid: data['sid'], event: data.delete('event'), data: data
      end

    end
  end
end
