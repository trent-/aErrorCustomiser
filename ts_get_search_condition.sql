create or replace
function  ts_get_search_condition( p_constraint_name in user_constraints.constraint_name%type, p_owner in user_constraints.owner%type ) return varchar2
as
  l_return varchar2(4000);
begin
  select search_condition into l_return
  from user_constraints
  where constraint_name = p_constraint_name
  and owner = p_owner;
  
  return l_return;
end ts_get_search_condition;