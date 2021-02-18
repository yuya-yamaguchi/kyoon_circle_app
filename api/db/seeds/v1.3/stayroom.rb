room_names = ['A', 'B']
room_names.each do |name|
  Stayroom.create!(name: name)
end