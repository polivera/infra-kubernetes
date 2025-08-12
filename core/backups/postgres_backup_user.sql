CREATE USER backup_reader WITH PASSWORD 'a-long-password';
GRANT pg_read_all_data TO backup_reader;