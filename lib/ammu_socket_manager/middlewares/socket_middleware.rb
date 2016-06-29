module AmmuSocketManager

	module Middleware

		class SocketMiddleware 
			
			KEEPALIVE_TIME = 15

			attr_reader :handler

		  	def initialize(app)
		    	@app     = app
		    	@handler = Rails.application.config.ammu_request_handler.constantize.new
		  	end

		  	def call(env)
		    	# Check if the Request is a Socket request and create new Connection
		    	if Faye::WebSocket.websocket?(env)
		      		ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
		      
			      	ws.on :open do |event|			        
			        	# Add new connection to list of all clients
			        	self.handler.add_client(env, event.current_target)
			      	end

				    ws.on :message do |event|
				        self.handler.run(env, event.current_target, JSON.parse(event.data))
				    end
			        
			      	ws.on :close do |event|
			      		self.handler.remove_client(env, event.current_target)
			        	puts "DELETED CLIENT"
			      	end

		      		ws.rack_response
			    else
			    	# Pass the request to the Rails App
			      	@app.call(env)
			    end
			end

		end
	end
end