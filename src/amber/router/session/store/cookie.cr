module Amber::Router::Session
  # This is the default Cookie Store
  class CookieStore < Store
    property secret : String
    property session_key : String
    property session_expires : Time::Span
    property cookie_store : Amber::Router::Cookies::Store
    property session : Hash(String, String)

    def initialize(@cookie_store, @session_key, @session_expires, @secret)
      @session = current_session
      @session["#{session_key}"] ||= SecureRandom.uuid
    end

    def id
      @session["#{session_key}"]
    end

    def destroy
      @session.clear
    end

    def [](key)
      @session[key]
    end

    def []?(key)
      @session.has_key?(key)
    end

    def []=(key, value)
      @session[key] = value.to_s
    end

    def key?(key)
      @session.has_key?(key)
    end

    def keys
      @session.keys
    end

    def values
      @session.values
    end

    def to_h
      @session
    end

    def update(hash : Hash(String, String))
      @session.update(hash)
    end

    def delete(key)
      @session.delete(key) if has_key?(key)
    end

    def fetch(key, default = nil)
      @session.fetch(key, default)
    end

    def empty?
      @session.empty?
    end

    def set_session
      @cookie_store.encrypted[key] = @session.to_json
    end

    def current_session
      Hash(String, String).from_json(@cookie_store.encrypted[session_key] || "{}")
    rescue e : JSON::ParseException
      Hash(String, String).new
    end
  end
end
