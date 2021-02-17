vo = 2
gt = 2
other = 1
instruments = Instrument.all.order('id')
instruments.each do |instrument|
  if instrument.name == 'ボーカル'
    vo.times do |i|
      PartCategory.create!(instrument_id: instrument.id, name: 'Vo' + (i + 1).to_s)
    end
  elsif instrument.name == 'ギター'
    gt.times do |i|
      PartCategory.create!(instrument_id: instrument.id, name: 'Gt' + (i + 1).to_s)
    end
  elsif instrument.name == 'ベース'
    other.times do |_i|
      PartCategory.create!(instrument_id: instrument.id, name: 'Ba')
    end
  elsif instrument.name == 'ドラム'
    other.times do |_i|
      PartCategory.create!(instrument_id: instrument.id, name: 'Dr')
    end
  elsif instrument.name == 'キーボード'
    other.times do |_i|
      PartCategory.create!(instrument_id: instrument.id, name: 'Key')
    end
  end
end
