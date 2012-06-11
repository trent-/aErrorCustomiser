create or replace
function ts_get_error(
    p_error in apex_error.t_error )
    return apex_error.t_error_result
is
    l_result          apex_error.t_error_result;
    l_constraint_name user_constraints.constraint_name%type;
    l_constraint_count NUMBER;
begin
    l_result := apex_error.init_error_result (
                    p_error => p_error );


      
    l_constraint_name := apex_error.extract_constraint_name(p_error);
    
    select count(*) into l_constraint_count
    from ts_constraint_Error
    where constraint_name = l_constraint_name;
    
    if l_constraint_count > 0 then
      select constraint_name into l_result.message
      from ts_constraint_error
      where constraint_name = l_constraint_name;
    else
        --fallback incase our testcase doesn't match anything
      if p_error.ora_sqlcode is not null and l_result.message = p_error.message then --no new message yet assigned. Must mean we haven't met the conditions above
        l_result.message := apex_error.get_first_ora_error_text(
                  p_error => p_error);
      end if;
    end if;

 
    return l_result;
end ts_get_error;