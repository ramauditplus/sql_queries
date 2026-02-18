update member_role m
set perms = (select array_agg(distinct val)
             from (select CASE
                              when elem in ('view_stock_adjustment', 'view_stock_addition', 'view_stock_deduction')
                                  then 'view_stock_journal'
                              when elem in
                                   ('create_stock_adjustment', 'create_stock_addition', 'create_stock_deduction')
                                  then 'create_stock_journal'
                              when elem in
                                   ('update_stock_adjustment', 'update_stock_addition', 'update_stock_deduction')
                                  then 'update_stock_journal'
                              when elem in
                                   ('delete_stock_adjustment', 'delete_stock_addition', 'delete_stock_deduction')
                                  then 'delete_stock_journal'
                              when elem in ('view_material_conversion', 'create_material_conversion',
                                            'update_material_conversion', 'delete_material_conversion',
                                            'cancel_material_conversion', 'cancel_stock_adjustment') then null
                              else elem
                              end as val
                   from unnest(m.perms) as elem) t
             where val is not null);