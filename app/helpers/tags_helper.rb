module TagsHelper
  def goal_time_to_total(goal)
    hours = goal.in_seconds / 1.hour.to_i
    mins = (goal.in_seconds / 1.minute.to_i) % 1.minute.to_i
    if mins == 0
      "#{hours}#{t :hours}"
    else
      hours == 0 ? "#{mins}#{t :minutes}" : "#{hours}#{t :hours}#{mins}#{t :minutes}"
    end
  end
end
