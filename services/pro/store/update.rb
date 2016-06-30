module Front::Services::Pro
  module Store
    class Update < Service

      def perform(data)
        function = data['transition'].gsub('/', '_')

        model = $models[data['ref'][0].to_sym]

        unless model.immutable
          inc_v = data['v'] + 1
          effect = model
            .where(id: data['ref'][1], v: data['v'])
            .update("data = #{function}('#{data['ref'].to_json}', '#{data['params'].to_json}'),
                     v = #{inc_v}")
          reply data.merge(broadcast: true, v: inc_v) unless effect.zero?
        end
      end

    end
  end
end
