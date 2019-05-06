-module(monitor_server_pubsub).

-include_lib("eunit/include/eunit.hrl").

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([sub/3,
         sub/4,
         unsub/3,
         get_sub_list/0,
         unsub/4
         ]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
get_sub_list() ->
    octopus_monitor_server:get_state().

sub(Module, Fun, Arg) ->
    octopus_monitor_server:sub(Module, Fun, Arg).

unsub(Module, Fun, Arg) ->
    octopus_monitor_server:unsub(Module, Fun, Arg).

sub(Module, Fun, Arg, Opts) ->
    octopus_monitor_server:sub(Module, Fun, Arg, Opts).

unsub(Module, Fun, Arg, Opts) ->
    octopus_monitor_server:unsub(Module, Fun, Arg, Opts).
    

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------


-ifdef(TEST).
-include_lib("./test/monitor_server_pubsub_test.hrl").
-endif.

join_nodes_test() ->
ok.


    
