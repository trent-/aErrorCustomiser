create or replace function ts_get_error(
    p_error in apex_error.t_error )
    return apex_error.t_error_result
is
    l_result          apex_error.t_error_result;
    l_reference_id    number;
    l_constraint_name varchar2(255);
begin
    l_result := apex_error.init_error_result (
                    p_error => p_error );
 

    --TODO: logic to return a different error message
    
    --fallback incase our testcase doesn't match anything
    if p_error.ora_sqlcode is not null and l_result.message = p_error.message then --no new message yet assigned. Must mean we haven't met the conditions above
        l_result.message := apex_error.get_first_ora_error_text(
                p_error => p_error);
    
    end if;
 
    return l_result;
end ts_get_error;