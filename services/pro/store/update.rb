Service __FILE__ do

  def perform(data)
    model = $models[data['ref'][0].to_sym]

    unless model.immutable
      function = data['transition'].gsub('/', '_')
      data['v'] = data['v'].to_i
      inc_v = data['v'] + 1
      effect = model
        .where(id: data['ref'][1], v: data['v'])
        .update("data = #{function}('#{data['ref'].to_json}', '#{data['params'].to_json}'),
                 v = #{inc_v}")
      broadcast data.merge 'v' => inc_v unless effect.zero?
    end
  end

end
