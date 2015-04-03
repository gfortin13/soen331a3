%author: Guillaume Fortin, Emmanuel Tsapekis
%date: 2/4/2015

%Part 1: Overview states
initial_state(dormant, null).
state(dormant).
state(init).
state(idle).
state(monitoring).
state(error_diagnosis).
state(safe_shutdown).

%Part 1: Overview transitions
%transition(state1, state2, event, guard, action)
transition(dormant, init, start, null, null).
transition(init, idle, init_ok, null, null).
transition(idle, monitoring, begin_monitoring, null, null).
transition(init, error_diagnosis, init_crash, null, 'broadcast init_err_msg').
transition(idle, error_diagnosis, idle_crash, null, 'broadcast idle_err_msg').
transition(monitoring, error_diagnosis, monitor_crash, 'inlockdown = false', 'broadcast moni_err_msg').
transition(error_diagnosis, init, retry_init, 'retry < 3', 'retry++').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(error_diagnosis, monitoring, moni_rescue, null, null).
transition(error_diagnosis, safe_shutdown, shutdown, 'retry >= 3', null).
transition(safe_shutdown, dormant, sleep, null, null).
transition(dormant, exit, kill, null, null).

%Part 2, Init states
initial_state(boot_hw, init).
state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).
superstate(init, boot_hw).
superstate(init, senchk).
superstate(init, tchk).
superstate(init, psichk).
superstate(init, ready).

%Part 2: Init transitions
%transition(state1, state2, event, guard, action)
transition(boot_hw, senchk, hw_ok, null, null).
transition(senchk, tchk, sen_ok, null, null).
transition(tchk, psichk, t_ok, null, null).
transition(psichk, ready, psi_ok, null, null).

%Part 3: Monitoring states
initial_state(monidle, monitoring).
state(monidle).
state(regulate_environment).
state(lockdown).
superstate(monitoring, monidle).
superstate(monitoring, regulate_environment).
superstate(monitoring, lockdown).

%Part 3: Monitoring transitions
%transition(state1, state2, event, guard, action)
transition(monidle, regulate_environment, no_contagion, null, null).
transition(monidle, lockdown, contagion_alert, null, 'broadcast FACILITY_CRIT_MESG; inlockdown = true').
transition(regulate_environment, monidle, after_100ms, null, null).
transition(lockdown, monidle, purge_succ, null, 'inlockdown = false').

%Part 4: Lockdown states
initial_state(prep_vpurge, lockdown).
state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).
superstate(lockdown, prep_vpurge).
superstate(lockdown, alt_temp).
superstate(lockdown, alt_psi).
superstate(lockdown, risk_assess).
superstate(lockdown, safe_status).

%Part 4: Lockdown transitions
%transition(state1, state2, event, guard, action)
transition(prep_vpurge, alt_temp, initiate_purge, null, lock_doors).
transition(prep_vpurge, alt_psi, initiate_purge, null, lock_doors).
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, psicyc_comp, null, null).
transition(risk_assess, prep_vpurge, null, 'risk > 1%', null).
transition(risk_assess, safe_status, null, 'risk <= 1%', unlock_doors).
transition(safe_status, exit, null, null, null).

%Part 5: Error states
initial_state(error_rcv, error_diagnosis).
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
superstate(error_diagnosis, error_rcv).
superstate(error_diagnosis, applicable_rescue).
superstate(error_diagnosis, reset_module_data).

%Part 5: Error transitions
%transition(state1, state2, event, guard, action)
transition(error_rcv, applicable_rescue, null, 'err_protocol_def = true', null).
transition(error_rcv, reset_module_data, null, 'err_protocol_def = false', null).
transition(applicable_rescue, exit, apply_protocol_rescues, null, null).
transition(reset_module_data, exit, reset_to_stable, null, null).
