

module Amber::Router::Session
  class RedisStore < Store
    getter store : Redis
    getter key : String
    getter expires : Time::Span

    def initialize(@store , @key, @expires = 2.hours)
      @id = SecureRandom.uuid
      @session_id = "#{@key}:#{@id}"
    end

    def id
      @store.hget(@session_id, "id")
    end

    def destroy
      self[id] = nil
    end

    def [](key)
      @store.hget(@session_id, key)
    end

    def []?(key)
      key?(key)
    end

    def []=(key, value)
      @store.hset(@session_id, key, value)
    end

    def key?(key)
      @store.hexists(@session_id, key)
    end

    def keys
      @store.hkeys(@session_id)
    end

    def values
      @store.hvals(@session_id)
    end

    def to_h
      @store.hmget(@session_id).each_slice(2).to_h
    end

    def update(hash : Hash(String, String))
      @store.hmset(@session_id, hash)
    end

    def delete(key)
      @store.hmset(@session_id, key) if key?(key)
    end

    def fetch(key, default = nil)
      self[key] || @store.hset(key, default)
    end

    def empty?
      @store.hlen(@session_id) <= 0
    end

    def set_session
      @store.hset(@session_id, "id", id)
    end

    def current_session
      @store.hget(@session_id, "id", @id)
    end
  end
end
