# General utilities for the transcoding operations.
class Transcoder

  # Takes the current time and the total duration.
  # Returns the percentage of completion and a status bar.
  def status_from_time(dt, duration)
    per = dt / duration
	 per = 100 if per > 100

    completion = "#" * (50 * per * 0.01).round
	 completion << " " * (50 * (100 - per) * 0.01).round

	 return completion, per

  end

end
