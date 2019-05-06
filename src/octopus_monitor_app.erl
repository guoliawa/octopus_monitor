-module(octopus_monitor_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    start_deps(), 
    octopus_monitor_sup:start_link().

stop(_State) ->
    ok.

start_deps() ->
    application:ensure_all_started(lager).
