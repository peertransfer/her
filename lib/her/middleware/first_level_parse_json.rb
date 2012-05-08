module Her
  module Middleware
    class FirstLevelParseJSON < Faraday::Response::Middleware
      def parse(body)
        json = MultiJson.load(body, :symbolize_keys => true)
        errors = json.delete(:errors) || []
        metadata = json.delete(:metadata) || []
        {
          :data => json,
          :errors => errors,
          :metadata => metadata
        }
      end

      def on_complete(env)
        env[:body] = parse(env[:body])
      end
    end
  end
end
