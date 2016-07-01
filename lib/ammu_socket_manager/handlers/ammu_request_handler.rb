module AmmuSocketManager
	module Handler

		class AmmuRequestHandler

			@@event_map = {}
			attr_accessor :clients
			

			def initialize
				self.clients = []
			end

			def run (env, request_by_connection, data)				
				request = {
					:env => env,
					:connection => request_by_connection,
					:json_data => data['payload']
				}
				self.send(@@event_map[data["event"].to_sym], request)
			end

		end
	
	end
end