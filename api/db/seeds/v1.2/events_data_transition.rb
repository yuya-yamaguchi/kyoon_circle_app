events = Event.all
events.each do |event|
  event.update(event_category_id: event.event_type + 1)
end
