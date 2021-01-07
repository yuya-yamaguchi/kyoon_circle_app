class Event < ApplicationRecord
  
  has_many :event_entries
  
  validates :title, presence: true
  validates :title, length: { maximum: 40, message: "は40文字以下で入力してください" }, allow_blank: true
  validates :event_type,
    numericality: {greater_than_or_equal_to: 1,
                   less_than_or_equal_to:    4,
                   message: "選択してください"
                  }
  validates :details, presence: true
  validates :details, length: { maximum: 1000, message: "は1000文字以下で入力してください" }, allow_blank: true
  validates :fee, presence: true
  validates :place, presence: true
  
  def set_out_params
    week = ['Sun', 'Mon', 'Tue', 'Web', 'Thu', 'Fri', 'Sat']
    params = {
      id:         self.id,
      title:      self.title,
      details:    self.details,
      event_type: self.event_type,
      fee:        self.fee,
      place:      self.place,
      max_entry:  self.max_entry,
      start_date: self.start_datetime,
      end_date:   self.end_datetime,
      start_week: week[self.start_datetime.to_date.wday]
    }
  end

  def set_edit_params
    params = {
      id:         self.id,
      title:      self.title,
      details:    self.details,
      event_type: self.event_type,
      fee:        self.fee,
      place:      self.place,
      max_entry:  self.max_entry,
      start_date: self.start_datetime.strftime("%Y-%m-%d"),
      start_hour: self.start_datetime.strftime("%H"),
      start_min:  self.start_datetime.strftime("%M"),
      end_hour:   self.end_datetime.strftime("%H"),
      end_min:    self.end_datetime.strftime("%M")
    }
  end
end
