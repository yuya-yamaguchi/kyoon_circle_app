instruments = ['ボーカル', 'ギター', 'ベース', 'ドラム', 'キーボード']
instruments.each do |instrument|
  Instrument.create!(name: instrument)
end