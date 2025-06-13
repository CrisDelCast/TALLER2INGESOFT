CREATE TABLE credentials (
	credential_id SERIAL PRIMARY KEY,
	user_id INT,
	username VARCHAR(255),
	password VARCHAR(255),
	is_enabled BOOLEAN,
	is_account_non_expired BOOLEAN,
	is_account_non_locked BOOLEAN,
	is_credentials_non_expired BOOLEAN,
	created_at TIMESTAMP DEFAULT LOCALTIMESTAMP,
	updated_at TIMESTAMP
);

