Service __FILE__ do

  def perform(data)
    effect = $models[data['ref'][0].to_sym]
      .where(id: data['ref'][1])
      .delete

    reply data.merge broadcast: true unless effect.zero?
  end

end
