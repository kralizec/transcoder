# FFMpeg transcoding operations.
class Transcoder

  # Transcode a file using ffmpeg and the specified profile.
  def exec_ffmpeg(opts = {})

    # Build ffmpeg command
    cmd = build_command(opts[:infile], opts[:outfile], opts[:profile][:opts])

    # Some pipe vars 
    progress, duration, pipe_pid = nil
    time = 0.0
    p = 0

    IO.popen(cmd) do |pipe|
     
      # Make sure we can kill the process if necessary.
      # A broken pipe can break the terminal.
      pipe_pid = Process.pid
      
      # Mark lines with carriage returns.
      pipe.each("\r") do |line|
        if line =~ /Duration: (\d{2}):(\d{2}):(\d{2}).(\d{1})/
          duration = eval("#{$1.to_i} * 36000 + #{$2.to_i} * 600 + #{$3.to_i} * 10 + #{$4.to_i}")
        elsif line =~ /time=(\d+.\d+)/
          cur_time = eval($1) * 1000 
          STDOUT.print "Status [%s] %6.2f\r" % status_from_time(cur_time, duration)
          #$stdout.flush
          STDOUT.flush
        end
      end
    end

    # End with a newline.
    print "\n"
    
    #end

  rescue => err

    print "Transcoding error!\n"
    print err.to_s + "\n"
    
    # TODO: Use threads to avoid the necessity of killing the entire process.
    Process.kill("KILL", pipe_pid) unless pipe_pid.nil?
    #Thread.kill(thread_pid)
  end


  # Build the ffmpeg command.
  def build_command(infile, outfile, profile)

    # Beginning
    cmd = 'ffmpeg -y -i '

    # infile
    cmd << infile
    cmd << " "

    # Middle
    profile.each_pair do |k,v|
      cmd << "-"
      cmd << k
      cmd << " "
      cmd << v.to_s
      cmd << " "
    end

    # End
    if outfile.nil?
      cmd << infile + ".mp4"
    else
      cmd << outfile
    end
    cmd << ' 2>&1'

  end

  # Extract media file information.
  def stream_info
    
    cmd = 'ffmpeg -v 2 -i '
    cmd << @infile
    cmd << ' 2>&1'
    
    streams = []

    stream_regex = /Stream\s+.(\d+).(\d+),\s+(Video)/
    audio_regex = //
    video_regex = //

    IO.popen(cmd) do |pipe|
      pipe.each do |line|
        if line =~ stream_regex
          temp = {
            :index => $1,
            :sub_index => $2,
            :type => $3
          }
          streams.push temp
        end
      end
    end

    puts streams.inspect

  end

end

