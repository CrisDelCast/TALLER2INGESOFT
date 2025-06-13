CREATE TABLE verification_tokens (
	v_token_id SERIAL PRIMARY KEY,
	credential_id INT,
	token VARCHAR(255),
	expire_date TIMESTAMP,
	created_at TIMESTAMP DEFAULT LOCALTIMESTAMP,
	updated_at TIMESTAMP
);

