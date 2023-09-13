from subprocess import Popen
import time
import os

start_time = time.strftime("%Y-%m-%d_%H%M%S")

dir_name = f"data-{start_time}"

os.mkdir(dir_name)

lwir0_filename = f"{dir_name}/lwir0.mkv"
lwir1_filename = f"{dir_name}/lwir1.mkv"
zed_filename = f"{dir_name}/zed.svo"

ffmpeg_cmd0 = ["ffmpeg", "-f", "v4l2", "-framerate", "60", "-video_size", "640x512", "-i", "/dev/video0", f"{lwir0_filename}"]
ffmpeg_cmd1 = ["ffmpeg", "-f", "v4l2", "-framerate", "60", "-video_size", "640x512", "-i", "/dev/video2", f"{lwir1_filename}"] 
zed_cmd = ["python", "/usr/local/zed/samples/recording/recording/mono/python/svo_recording.py", "--output", f"{zed_filename}"]

commands = [ffmpeg_cmd0, ffmpeg_cmd1, zed_cmd]
procs = [ Popen(i) for i in commands ]
time.sleep(10)
for p in procs:
       p.wait()

