-include_lib("eunit/include/eunit.hrl").
 
start_test() ->
    net_kernel:start(['ddmin@test.com']),
    octopus_monitor:start().
get_sub_list_test() ->
    Ret = monitor_server_pubsub:get_sub_list(),
    ?assertEqual([], Ret).

sub_test() ->
    M = io, 
    F = format,
    A = ["~p", [sss]],
    Ret = monitor_server_pubsub:sub(M, F, A),
    ?assertEqual(ok, Ret),
    Ret1 = monitor_server_pubsub:get_sub_list(),
    ?assertEqual([{M,F,A,[]}], Ret1).
    
sub_mnesia_test() ->
    Ret = monitor_server_pubsub:sub(io, format, ["~p", [sss]], [mnesia]),
    ?assertEqual(ok, Ret).

sub_process_test() ->
    Ret = monitor_server_pubsub:sub(io, format, ["~p", [sss]], [process]),
    ?assertEqual(ok, Ret).

get_sub_list1_test() ->
    M = io, 
    F = format,
    A = ["~p", [sss]],
    Exp = [{M, F, A, []},
           {M, F, A, [mnesia]},
           {M, F, A, [process]}
           ],
    Ret = monitor_server_pubsub:get_sub_list(),
    ?assertEqual(Exp, Ret).

unsub_test() ->
    Ret = monitor_server_pubsub:unsub(io, format, ["~p", [sss]]),
    ?assertEqual(ok, Ret).

    
unsub_mnesia_test() ->
    Ret = monitor_server_pubsub:unsub(io, format, ["~p", [sss]], [mnesia]),
    ?assertEqual(ok, Ret).

unsub_process_test() ->
    Ret = monitor_server_pubsub:unsub(io, format, ["~p", [sss]], [process]),
    ?assertEqual(ok, Ret).
    

work_node_test() ->
    Exp = case nodes() of
            [] -> true;
            _Nodes -> false
          end,
    Ret = octopus_monitor_server:work_node(),
    ?assertEqual(Exp, Ret).


