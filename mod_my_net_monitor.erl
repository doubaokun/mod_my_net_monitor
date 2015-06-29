-module(mod_my_net_monitor).

-behavior(gen_mod).
-behaviour(gen_server).

-export([
      start/2,
      stop/1,
      init/1,
      handle_call/3,
      handle_cast/2,
      handle_info/2,
      terminate/2,
      code_change/3
    ]).

-include("ejabberd.hrl").
-include("logger.hrl").

-define(SERVER, ?MODULE).

start(_Host, _Opt) ->
  start_link(),
  ?INFO_MSG("Loading module 'mod_my_net_monitor' ", []).

stop(_Host) ->
        ok.

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  ok = net_kernel:monitor_nodes(true, [nodedown_reason]),
  {ok, []}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({Event, Node, Data}, State) ->
  case Event of
     nodeup ->
       ?INFO_MSG("Status change: ~p is up. (~p)\n", [Node, Data]);
     nodedown ->
       ?INFO_MSG("Status change: ~p is down. (~p)\n", [Node, Data])
  end,
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.