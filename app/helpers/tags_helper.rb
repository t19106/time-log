module TagsHelper
  def goal_time_to_total(goal)
    hours = goal.in_seconds / 3600
    mins = (goal.in_seconds / 60) % 60
    if mins == 0
      "#{hours}#{t :hours}"
    else
      hours == 0 ? "#{mins}#{t :minutes}" : "#{hours}#{t :hours}#{mins}#{t :minutes}"
    end
  end
end
