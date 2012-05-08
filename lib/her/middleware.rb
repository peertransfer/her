module Her
  module Middleware
    autoload :FirstLevelParseJSON,  "her/middleware/first_level_parse_json"

    DefaultParseJSON = FirstLevelParseJSON
  end
end
