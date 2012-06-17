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
    
    if l_constraint_name IS NULL AND p_error.ora_sqlerrm IS NOT NULL THEN
	--NOT NULL constraints don't display the constraint name in the error, find another way
    --Added check for ora_sqlerrm as if there is a page validation, it still enters the function, but with no sqlerrm
        declare
            l_cons_split APEX_APPLICATION_GLOBAL.VC_ARR2;
            l_owner user_constraints.owner%type;
            l_table_name user_constraints.table_name%type;
            l_column_name user_cons_columns.column_name%type;
            l_table_column varchar2(400);
        BEGIN
        
            --get the section enclodes in parenthesis
            l_table_column := regexp_substr(p_error.ora_sqlerrm, '\([^)]*\)');
            --remove parenthesis and quotes
            l_table_column := regexp_replace(l_table_column, '[(")]');
            --split the data by period
            l_cons_split := apex_util.string_to_table(l_table_column, '.');
            --determine the constraint name by querying user_constraints
            l_table_name := l_cons_split(l_cons_split.COUNT-2);
            l_table_name := l_cons_split(l_cons_split.COUNT-1);
            l_column_name := l_cons_split(l_cons_split.COUNT);
            
            
            
            select uc.constraint_name into l_constraint_name
            from user_constraints uc, user_cons_columns ucc
            where uc.constraint_name = ucc.constraint_name
            and uc.owner = ucc.owner
            and uc.table_name = l_table_name
            and ucc.column_name = l_column_name
            and ts_get_search_condition(uc.constraint_name, uc.owner) like '%IS NOT NULL%';

        END;
    END IF;
    
    select count(*) into l_constraint_count
    from ts_constraint_Error
    where constraint_name = l_constraint_name;
    
    if l_constraint_count > 0 then
      select error_message into l_result.message
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