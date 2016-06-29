Gem.find_files("ammu_socket_manager/**/*.rb").each { |path| require path }

module AmmuSocketManager

	class AmmuRailtie < Rails::Railtie
		
		initializer "ammu_railtie.configure_rails_initialization" do | app |
			app.middleware.use AmmuSocketManager::Middleware::SocketMiddleware
		end

	end

end
