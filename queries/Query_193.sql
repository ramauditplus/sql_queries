select *
from model_metadata
where name = 'udm_employee';
select *
from field_metadata
where model = 'udm_employee';
select *
from relation_metadata
where to_model = 'udm_employee';

select
    u.id as "employee_id",
    u.name as "employee_name",
    u.reports_to as "employee_reports_to"
from udm_employee
         join udm_employee as "u" on udm_employee.id = u.reports_to
order by u.id;