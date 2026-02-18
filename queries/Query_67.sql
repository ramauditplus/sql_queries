CREATE SEQUENCE udm_member_id_seq;
-- SELECT setval('udm_member_id_seq', COALESCE((SELECT MAX(id) FROM udm_member), 0));
ALTER TABLE udm_member
ALTER COLUMN id SET DEFAULT nextval('udm_member_id_seq');


ALTER SEQUENCE udm_member_id_seq OWNED BY udm_member.id;
