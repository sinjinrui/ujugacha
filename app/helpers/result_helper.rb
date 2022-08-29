module ResultHelper

  def rarity_weight(item)
    (item.rarity.weight.to_f / item.rarity.items.length.to_f).round(2)
  end

end