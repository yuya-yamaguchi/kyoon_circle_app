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
  
  
  def set_out_params
    start_datetime = ""
    end_datetime = ""
    if self.start_datetime.to_date == self.end_datetime.to_date
      start_datetime = self.start_datetime.strftime("%m月%d日 %H:%M")
      end_datetime = self.end_datetime.strftime("%H:%M")
    else
      start_datetime = self.start_datetime.strftime("%m月%d日 %H:%M")
      end_datetime = self.end_datetime.strftime("%m月%d日 %H:%M")
    end
    params = {
      id:             self.id,
      title:          self.title,
      details:          self.details,
      event_type:     self.event_type,
      fee:            self.fee,
      place:          self.place,
      max_entry:          self.max_entry,
      start_datetime: start_datetime,
      end_datetime:   end_datetime
    }
  end
end
