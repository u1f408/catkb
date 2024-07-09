create function generate_id() returns text as $$
    select string_agg(substr('0123456789abcdefghjkmnpqrstvwxyz', ceil(random() * 32)::integer, 1), '') from generate_series(1, 20)
$$ language sql volatile;
