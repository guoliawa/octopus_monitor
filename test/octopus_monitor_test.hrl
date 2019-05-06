-include_lib("eunit/include/eunit.hrl").
 
 
my_test() ->
    ?assert(1 + 2 =:= 3).
 
simple_test() ->
    %ok = application:start(octopus_monitor),
    net_kernel:start(['ddmin@test.com']),
    octopus_monitor:start(),
    ?assertNot(undefined =:= whereis(octopus_monitor_sup)).

