create table if not exists hsn_code
(
	code      text not null primary key,
	narration text not null
);

insert into hsn_code(code, narration) values (
       '0512',
        'PIGS'', HOGS'' OR BOARS'' BRISTLES AND HAIR; BADGER HAIR AND OTHER BRUSH MAKING HAIR; WASTE OF SUCH BRISTLES OR HAIR'
    );