import os
import random
import string
import time
import threading
import redis

# Redis connection
redis_host = os.getenv("REDIS_HOST", "localhost")
redis_port = int(os.getenv("REDIS_PORT", 6379))
redis_password = os.getenv("REDIS_PASSWORD", None)

r = redis.Redis(
    host=redis_host,
    port=redis_port,
    password=redis_password,
    decode_responses=True
)

# Constants
LEADERBOARD_KEY = "leaderboard:global"
ACTIVITY_STREAM = "activity_log"
MAX_SCORE = 99999

# Helpers
def random_username():
    return ''.join(random.choices(string.ascii_lowercase, k=6))

# Writer: simulate score fluctuations and user metadata updates
def write_loop():
    while True:
        username = random_username()
        user_key = f"user:{username}"

        current_score = r.zscore(LEADERBOARD_KEY, user_key) or 0
        delta = random.randint(100, 5000)

        if random.random() < 0.5:
            new_score = min(current_score + delta, MAX_SCORE)
        else:
            new_score = max(current_score - delta, 0)

        r.zadd(LEADERBOARD_KEY, {user_key: new_score})
        r.hincrby(user_key, "games_played", 1)
        r.hset(user_key, "last_score", new_score)

        r.xadd(ACTIVITY_STREAM, {"user": user_key, "score": new_score}, maxlen=100, approximate=True)

        time.sleep(0.01)

# Reader: simulate app reading leaderboard and user data
def read_loop():
    while True:
        op = random.choice(["view_top", "user_stats", "user_rank"])
        username = random_username()
        user_key = f"user:{username}"

        if op == "view_top":
            r.zrevrange(LEADERBOARD_KEY, 0, 9, withscores=True)
        elif op == "user_stats":
            r.hgetall(user_key)
        elif op == "user_rank":
            r.zrevrank(LEADERBOARD_KEY, user_key)

        time.sleep(0.01)

# Decay: simulate users dropping off the leaderboard
def decay_loop():
    while True:
        username = random_username()
        user_key = f"user:{username}"

        r.zrem(LEADERBOARD_KEY, user_key)
        r.delete(user_key)

        time.sleep(5)

# Run all threads
if __name__ == "__main__":
    threads = [
        threading.Thread(target=write_loop),
        threading.Thread(target=read_loop),
        threading.Thread(target=decay_loop)
    ]

    for t in threads:
        t.daemon = True
        t.start()

    print("🚀 Load generator running: fluctuating scores, reads, and user decay")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[!] Load generator stopped.")
