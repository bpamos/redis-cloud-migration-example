import os
import random
import time
from flask import Flask, request, jsonify, render_template
import redis
from dotenv import load_dotenv

# ✅ Load environment variables from the .env file
load_dotenv("/opt/leaderboard_app/.env")

# Get Redis connection info from environment variables
redis_host = os.environ.get("REDIS_HOST")
redis_port = int(os.environ.get("REDIS_PORT", 6379))
redis_password = os.environ.get("REDIS_PASSWORD", "")


r = redis.Redis(
    host=redis_host,
    port=redis_port,
    password=redis_password,
    socket_connect_timeout=5,
    socket_timeout=5,
    decode_responses=True
)

app = Flask(__name__, template_folder='templates')

# Leaderboard key and stream key
LEADERBOARD_KEY = "leaderboard:global"
STREAM_KEY = "activity_log"

@app.route("/healthz")
def healthz():
    try:
        r.ping()
        return jsonify({"status": "ok"})
    except redis.exceptions.RedisError:
        return jsonify({"status": "unhealthy"}), 500

@app.route("/add")
def add_score():
    user = request.args.get("user")
    score = request.args.get("score")
    if not user or not score:
        return jsonify({"error": "Missing user or score"}), 400

    score = float(score)

    # Update global leaderboard
    r.zadd(LEADERBOARD_KEY, {user: score})

    # Track user stats in a hash
    user_key = f"user:{user}"
    r.hincrby(user_key, "games_played", 1)
    r.hset(user_key, "last_score", score)

    # Add to recent activity stream
    r.xadd(STREAM_KEY, {"user": user, "score": score}, maxlen=100, approximate=True)

    return jsonify({"message": f"Score updated for {user}", "score": score})

@app.route("/top")
def top_players():
    entries = r.zrevrange(LEADERBOARD_KEY, 0, 9, withscores=True)
    results = []
    for user, score in entries:
        user_key = f"user:{user}"
        last_score = r.hget(user_key, "last_score") or "N/A"
        games_played = r.hget(user_key, "games_played") or "0"
        results.append({
            "user": user,
            "score": score,
            "last_score": last_score,
            "games_played": games_played
        })
    return jsonify(results)

@app.route("/activity")
def recent_activity():
    entries = r.xrevrange(STREAM_KEY, count=10)
    formatted = [{"user": e[1]["user"], "score": e[1]["score"], "id": e[0]} for e in entries]
    return jsonify(formatted)

@app.route("/")
def home():
    top_players_data = r.zrevrange(LEADERBOARD_KEY, 0, 9, withscores=True)
    leaderboard = []
    for user, score in top_players_data:
        user_key = f"user:{user}"
        last_score = r.hget(user_key, "last_score") or "N/A"
        games_played = r.hget(user_key, "games_played") or "0"
        leaderboard.append({
            "user": user,
            "score": score,
            "last_score": last_score,
            "games_played": games_played
        })

    recent = r.xrevrange(STREAM_KEY, count=10)
    activity = [{"user": e[1]["user"], "score": e[1]["score"], "id": e[0]} for e in recent]

    return render_template("index.html", top_players=leaderboard, recent_activity=activity)

if __name__ == "__main__":
    print(f"✅ Connected to Redis at {redis_host}:{redis_port}")
    app.run(host="0.0.0.0", port=5000)
