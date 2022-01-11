# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
# Our Logger general configuration
config :logger,
       backends: [
         :console,
         {Fubars.LogBackend, :ui_event},
         {LoggerFileBackend, :file_log}
       ],
       level: :debug, # this is the most permissive level, no backend can be more inclusive than the level set here.
       compile_time_purge_matching: [
         [level_lower_than: :info]
       ]

# Our Console Backend-specific configuration
# config :logger, :console,
# format: {Fubars.LogFormatter, :format}
# metadata: [:request_id]

config :logger, :ui_event,
       level: :info,
       metadata: :evt_type

config :logger, :file_log,
       path: "/tmp/frobotsLog.log",
       level: :info

# Configure the main viewport for the Scenic application
config :frobots_scenic, :viewport, %{
  name: :main_viewport,
  size: {1000, 1000},
  default_scene: {FrobotsScenic.Scene.Start, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "frobots_scenic"]
    }
  ]
}
# import_config "#{Mix.env}.exs"

