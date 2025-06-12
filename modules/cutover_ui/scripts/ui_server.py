import os
import subprocess
from flask import Flask, render_template_string

app = Flask(__name__)

LEADERBOARD_URL = "http://localhost:5000"
ENV_PATH = "/opt/leaderboard_app/.env"
REDIS_CLOUD_HOST = os.environ.get("REDIS_CLOUD_ENDPOINT") or os.environ.get("REDIS_CLOUD_HOST")
REDIS_CLOUD_PORT = os.environ.get("REDIS_CLOUD_PORT", "6379")
REDIS_CLOUD_PASSWORD = os.environ.get("REDIS_CLOUD_PASSWORD", "")

HTML_TEMPLATE = """
<!doctype html>
<title>Redis Cutover UI</title>
<h2>🧠 Redis Cutover Dashboard</h2>

<p><b>Leaderboard App:</b> <a href="{{ leaderboard_url }}" target="_blank">{{ leaderboard_url }}</a></p>

<h3>Current Redis Config:</h3>
<pre>{{ env_contents }}</pre>

<h3>Actions:</h3>

<form method="post" action="/cutover">
    <button type="submit">🔄 Perform Cutover to Redis Cloud</button>
</form>
<pre>
# Manual Cutover
echo -e "REDIS_HOST={{ redis_host }}\\nREDIS_PORT={{ redis_port }}\\nREDIS_PASSWORD={{ redis_password }}" > /opt/leaderboard_app/.env
</pre>

<form method="post" action="/restart">
    <button type="submit">♻️ Restart Leaderboard App</button>
</form>
<pre>
# Restart Leaderboard App
pkill -f app.py
/opt/leaderboard_app/venv/bin/python /opt/leaderboard_app/app.py > /opt/leaderboard_app/app.log 2>&1 &
</pre>

<h3>Load Generator</h3>
<pre>
# Run Load Generator
nohup /home/ubuntu/run_memtier.sh > /home/ubuntu/memtier.log 2>&1 &
</pre>
"""

def read_env_file():
    try:
        with open(ENV_PATH, "r") as f:
            return f.read()
    except FileNotFoundError:
        return "(No .env file found)"

@app.route("/")
def home():
    return render_template_string(
        HTML_TEMPLATE,
        leaderboard_url=LEADERBOARD_URL,
        env_contents=read_env_file(),
        redis_host=REDIS_CLOUD_HOST,
        redis_port=REDIS_CLOUD_PORT,
        redis_password=REDIS_CLOUD_PASSWORD
    )

@app.route("/cutover", methods=["POST"])
def cutover():
    new_env = f"""REDIS_HOST={REDIS_CLOUD_HOST}
REDIS_PORT={REDIS_CLOUD_PORT}
REDIS_PASSWORD={REDIS_CLOUD_PASSWORD}
"""
    with open(ENV_PATH, "w") as f:
        f.write(new_env)
    subprocess.run(["chown", "ubuntu:ubuntu", ENV_PATH])
    return render_template_string(
        HTML_TEMPLATE,
        leaderboard_url=LEADERBOARD_URL,
        env_contents=new_env,
        redis_host=REDIS_CLOUD_HOST,
        redis_port=REDIS_CLOUD_PORT,
        redis_password=REDIS_CLOUD_PASSWORD
    )

@app.route("/restart", methods=["POST"])
def restart():
    subprocess.run(["pkill", "-f", "app.py"], stderr=subprocess.DEVNULL)
    subprocess.Popen(
        ["/opt/leaderboard_app/venv/bin/python", "/opt/leaderboard_app/app.py"],
        stdout=open("/opt/leaderboard_app/app.log", "a"),
        stderr=subprocess.STDOUT
    )
    return render_template_string(
        HTML_TEMPLATE,
        leaderboard_url=LEADERBOARD_URL,
        env_contents=read_env_file(),
        redis_host=REDIS_CLOUD_HOST,
        redis_port=REDIS_CLOUD_PORT,
        redis_password=REDIS_CLOUD_PASSWORD
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
