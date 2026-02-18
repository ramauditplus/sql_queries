alter table print_template
    drop constraint if exists unique_name_per_layout;
--##
alter table print_template
    drop constraint if exists print_template_layout_name_key;
--##
update print_layout set template = 'eyJwYWdlV2lkdGgiOjQwLCJwYWdlSGVpZ2h0IjoxMCwibGFiZWxXaWR0aCI6MCwibGFiZWxIZWlnaHQiOjEwLCJub09mQ29sdW1ucyI6Mywibm9PZlJvd3MiOjEsIml0ZW1zIjpbeyJ0b3AiOjIsImxlZnQiOjIsImNoaWxkIjp7Im5hbWUiOiJCYXJjb2RlIiwiZmllbGQiOiJCYXJjb2RlIiwidHlwZSI6ImNvZGUxMjgiLCJ3aWR0aCI6MzAsImhlaWdodCI6MTB9fSx7InRvcCI6NiwibGVmdCI6MiwiY2hpbGQiOnsibmFtZSI6IlRleHQiLCJmaWVsZCI6IkludmVudG9yeSBOYW1lIiwic3R5bGUiOnsiZm9udFNpemUiOjUsImZvbnQiOiJDb3VyaWVyUHJpbWUiLCJmb250U3R5bGUiOiJSZWd1bGFyIn19fV19' where id = 'BATCH';
--##
update print_layout set template = 'eyJwYWdlV2lkdGgiOjIwNCwicGFnZUhlaWdodCI6OTIsImxhYmVsV2lkdGgiOjAsImxhYmVsSGVpZ2h0Ijo5Miwibm9PZkNvbHVtbnMiOjEsIm5vT2ZSb3dzIjoxLCJpdGVtcyI6W3sidG9wIjoxMCwibGVmdCI6NzAsImNoaWxkIjp7Im5hbWUiOiJUZXh0IiwiZmllbGQiOiJBQyBQYXllZSIsInN0eWxlIjp7ImZvbnRTaXplIjoxMiwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IkJvbGQifX19LHsidG9wIjoyMiwibGVmdCI6MjEsImNoaWxkIjp7Im5hbWUiOiJUZXh0IiwiZmllbGQiOiJQYXllZSIsInN0eWxlIjp7ImZvbnRTaXplIjoxMiwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IkJvbGQifX19LHsidG9wIjozNywibGVmdCI6MTYwLCJjaGlsZCI6eyJuYW1lIjoiVGV4dCIsImZpZWxkIjoiQW1vdW50IEluIEZpZ3VyZXMiLCJzdHlsZSI6eyJmb250U2l6ZSI6MTIsImZvbnQiOiJDb3VyaWVyUHJpbWUiLCJmb250U3R5bGUiOiJCb2xkIn19fSx7InRvcCI6MzEsImxlZnQiOjI1LCJjaGlsZCI6eyJuYW1lIjoiVGV4dCIsImZpZWxkIjoiQW1vdW50IEluIFdvcmRzIiwibWF4TGluZXMiOjIsInN0eWxlIjp7ImZvbnRTaXplIjoxMiwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IkJvbGQiLCJsaW5lU3BhY2luZyI6NH19fSx7InRvcCI6OCwibGVmdCI6MTU4LCJjaGlsZCI6eyJuYW1lIjoiVGV4dCIsImZpZWxkIjoiRGF0ZSIsInN0eWxlIjp7ImZvbnRTaXplIjoxMiwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IkJvbGQiLCJsZXR0ZXJTcGFjaW5nIjo1fX19XX0' where id = 'CHEQUE_BOOK';
--##
update print_layout set template = 'eyJwYWdlV2lkdGgiOjIxMCwicGFnZUhlaWdodCI6Mjk3LCJsYWJlbFdpZHRoIjoxMDUsImxhYmVsSGVpZ2h0Ijo3NCwibm9PZkNvbHVtbnMiOjIsIm5vT2ZSb3dzIjo0LCJpdGVtcyI6W3sidG9wIjoyLCJsZWZ0Ijo0MCwiY2hpbGQiOnsibmFtZSI6IlRleHQiLCJmaWVsZCI6IlJhY2siLCJzdHlsZSI6eyJmb250U2l6ZSI6MTUsImZvbnQiOiJDb3VyaWVyUHJpbWUiLCJmb250U3R5bGUiOiJCb2xkIn19fSx7InRvcCI6MTAsImxlZnQiOjEwLCJjaGlsZCI6eyJuYW1lIjoiQ29udGFpbmVyIiwiaGVpZ2h0IjoxNTAsIndpZHRoIjoyNTAsImNoaWxkIjp7Im5hbWUiOiJDb2x1bW4iLCJjcm9zc0F4aXNBbGlnbm1lbnQiOiJzdGFydCIsImZpZWxkIjoiSW52ZW50b3JpZXMiLCJyb3dLZXkiOiJpIiwiY2hpbGQiOnsibmFtZSI6IlRleHQiLCJmaWVsZCI6ImkubmFtZSIsInN0eWxlIjp7ImZvbnRTaXplIjoxMiwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IlJlZ3VsYXIifX19fX1dfQ' where id = 'RACK';
--##
update print_layout set template = 'eyJwYWdlV2lkdGgiOjgwLCJwYWdlSGVpZ2h0Ijo0MCwibGFiZWxXaWR0aCI6MCwibGFiZWxIZWlnaHQiOjQwLCJub09mQ29sdW1ucyI6MSwibm9PZlJvd3MiOjEsIml0ZW1zIjpbeyJ0b3AiOjEsImxlZnQiOjI1LCJjaGlsZCI6eyJuYW1lIjoiVGV4dCIsImZpZWxkIjoiR2lmdCBWb3VjaGVyIE5hbWUiLCJzdHlsZSI6eyJmb250U2l6ZSI6MTQsImZvbnQiOiJDb3VyaWVyUHJpbWUiLCJmb250U3R5bGUiOiJSZWd1bGFyIn19fSx7InRvcCI6MTAsImxlZnQiOjUsImNoaWxkIjp7Im5hbWUiOiJCYXJjb2RlIiwiZmllbGQiOiJCYXJjb2RlIiwidHlwZSI6InFyIiwid2lkdGgiOjU1LCJoZWlnaHQiOjU1fX0seyJ0b3AiOjIwLCJsZWZ0IjozNSwiY2hpbGQiOnsibmFtZSI6IlRleHQiLCJjb250ZW50IjoiQW1vdW50IDogIiwic3R5bGUiOnsiZm9udFNpemUiOjE0LCJmb250IjoiQ291cmllclByaW1lIiwiZm9udFN0eWxlIjoiUmVndWxhciJ9fX0seyJ0b3AiOjIwLCJsZWZ0Ijo2MCwiY2hpbGQiOnsibmFtZSI6IlRleHQiLCJmaWVsZCI6IkFtb3VudCIsInN0eWxlIjp7ImZvbnRTaXplIjoxNCwiZm9udCI6IkNvdXJpZXJQcmltZSIsImZvbnRTdHlsZSI6IlJlZ3VsYXIifX19XX0=' where id = 'GIFT_VOUCHER_COUPON';
--##
delete
from print_template
where type = 'LABEL';
--##
insert into print_template(name, layout, template, type, is_default, created_at, updated_at, changed_at, created_by, updated_by)
select concat('default ',replace(lower(id), '_',' ')), id, template, type, true, current_timestamp, current_timestamp, current_timestamp, 1, 1
from print_layout where type = 'LABEL';
--##
alter table drug_classification
    add if not exists customer_doctor_required bool      not null default false,
    add if not exists highlight_sale_bill      bool      not null default false,
    add if not exists changed_at               timestamp not null default current_timestamp;
--##
alter table drug_classification
    alter customer_doctor_required drop default,
    alter highlight_sale_bill drop default,
    alter changed_at drop default;
--##
do
$$
    declare
        _table_name  text;
        _table_names text[] = array ['account', 'account_type', 'approval_tag', 'batch', 'branch', 'country','category', 'category_option',
            'division', 'doctor', 'drug_classification', 'gst_registration','inventory', 'inventory_branch_detail', 'member', 'member_role','organization',
            'offer_management', 'pos_counter', 'price_list', 'price_list_condition', 'sales_person', 'unit', 'voucher_type', 'warehouse'];
    begin
        foreach _table_name in array _table_names
            loop
                execute format('drop trigger if exists tg_notify_%1$s on %1$s', _table_name);
                execute format('create or replace trigger tg_notify_%1$s
                                after insert or update or delete on %1$s
                                for each row execute function fn_notify_pos_sync();', _table_name);
            end loop;
    end;
$$;
