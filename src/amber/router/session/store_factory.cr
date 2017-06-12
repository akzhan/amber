require "redis"

module Amber::Router::Session
  # This is a factory method to build a session store
  # It returns the correct Session::Store object based on the parameters
  # passed in.
  class StoreFactory

    def self.build(store, session_key, session_store, session_expires, secret)
      @@session_store ||= case session_store
                            when :redis
                              CookieStore.new(store, session_key, session_expires, secret)
                            else
                              redis_store = Redis.new
                              RedisStore.new(redis_store, session_key, session_expires)
                            end
                          end
    end
end
