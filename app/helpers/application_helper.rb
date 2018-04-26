module ApplicationHelper
  def achievement_time_format(time)
    hours = time / 1.hour.to_i
    mins = (time / 1.minute.to_i) % 1.minute.to_i
    if mins == 0
      "#{hours}#{I18n.t :hours}"
    else
      hours == 0 ? "#{mins}#{I18n.t :minutes}" : "#{hours}#{I18n.t :hours}#{mins}#{I18n.t :minutes}"
    end
  end
end
