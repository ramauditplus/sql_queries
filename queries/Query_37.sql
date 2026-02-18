with a as (select id,template from print_layout)
update print_template set template=a.template from a where layout=a.id and is_default=false and type='VOUCHER';