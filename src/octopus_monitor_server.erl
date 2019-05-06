-module(octopus_monitor_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-include_lib("eunit/include/eunit.hrl").

-record(state, {list}).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).
-export([task/1,
         get_state/0,
         join_node/1,
         list_nodes/0,
         work_node/0,
         join_nodes/1]).

-export([sub/3,
         sub/4,
         unsub/3,
         unsub/4]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

get_state() ->
    gen_server:call(?SERVER, {get_state}).

sub(Module, Fun, Args) ->
    sub(Module, Fun, Args, []).
sub(Module, Fun, Args, Opts) ->
    gen_server:call(?SERVER, {sub, {Module, Fun, Args, Opts}}).


unsub(Module, Fun, Args ) ->
    unsub(Module, Fun, Args, []).
unsub(Module, Fun, Args, Opts) ->
    gen_server:call(?SERVER, {unsub, {Module, Fun, Args, Opts}}).

list_nodes() ->
    lists:sort([node()|nodes()]). 

work_node() ->
    Node = node(),
    Nodes = list_nodes(),
    %lager:debug("Node = ~p, Nodes = ~p", [Node, Nodes]),
    case hd(Nodes) of
        Node -> true;
        _Other -> false 
    end.
    
-spec join_node(Node::atom()) -> boolean() | ignored.
join_node(Node) when is_atom(Node) ->
    net_kernel:connect(Node).

-spec join_nodes(Node::list()) -> list(). 
join_nodes(Nodes) ->
    [join_node(Node) || Node <- Nodes].
    

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

task({M, F, Arg, _Opts}) -> 
    case work_node() of
        true ->
            lager:debug("Node = ~p", [node()]),
            apply(M, F, Arg);
        false -> ingore
    end.

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(_Args) ->
    process_flag(trap_exit, true),
    net_kernel:monitor_nodes(true, [nodedown_reason]),
    %lager:debug("Pid = ~p", [Pid]),
    {ok, #state{list = []}}.

handle_call({get_state}, _From, #state{list = List} = State) ->
    {reply, List, State};
handle_call({sub, {_Module, _Fun, _Arg, _Opts} = Key}, _From, #state{list = List} = State) ->
    {reply, ok, State#state{list = lists:reverse([Key|lists:reverse(List)])}};
handle_call({unsub, {_Module, _Fun, _Arg, _Opts}} = Key, _From, #state{list = List} = State) ->
    NewList = lists:delete(Key, List),
    {reply, ok, State#state{list = NewList}};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'nodeup', _Node, _Reason} = Info, State) ->
    lager:debug(" join Info = ~p", [Info]),
    {noreply, State};
handle_info({'nodedown', _Node, _Reason} = Info, #state{list = List} = State) ->
    lager:error(" leave Info = ~p", [Info]),
    [spawn_link(?MODULE, task, [E])||E <- List],
    {noreply, State};
handle_info(_Info, State) ->
    lager:warning("_Info = ~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------


-ifdef(TEST).
-include_lib("./test/octopus_monitor_test.hrl").
-endif.
work_node_test() ->
    Ret = work_node(),
    ?assertEqual(true, Ret).
    
join_nodes_test() ->
    io:format("node() = ~p", [node()]),
    join_nodes(['a@test.com','b@test.com','c@test.com']).
    
