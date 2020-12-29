class Event < ApplicationRecord

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
      title:          self.title,
      event_type:     self.event_type,
      fee:            self.fee,
      start_datetime: start_datetime,
      end_datetime:   end_datetime
    }
  end
end
