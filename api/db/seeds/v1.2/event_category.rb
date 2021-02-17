categories_name = ['ライブ', 'セッション', '飲み会・懇親会', '合宿', 'その他']
categories_name.each do |category_name|
  EventCategory.create!(name: category_name)
end
