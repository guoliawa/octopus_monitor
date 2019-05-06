-module(octopus_monitor).
-export([start/0, stop/0]).
start() ->
    application:start(octopus_monitor).

stop() ->
    application:stop(octopus_monitor).
