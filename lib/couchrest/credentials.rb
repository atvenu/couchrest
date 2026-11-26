module CouchRest

  # A CouchDB login. Sent as basic auth, never put in a URL, and filtered from
  # inspect, to_s and JSON so it can't end up in logs or error reports.
  class Credentials

    FILTERED = "[FILTERED]".freeze

    attr_reader :username, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def empty?
      username.to_s.empty?
    end

    def ==(other)
      other.is_a?(Credentials) && username == other.username && password == other.password
    end
    alias eql? ==

    def hash
      [self.class, username, password].hash
    end

    def inspect
      "#<#{self.class} #{FILTERED}>"
    end
    alias to_s inspect

    def as_json(*)
      FILTERED
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

  end
end
