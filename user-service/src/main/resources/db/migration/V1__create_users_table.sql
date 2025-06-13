CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	image_url VARCHAR(255) DEFAULT 'https://bootdey.com/img/Content/avatar/avatar7.png',
	email VARCHAR(255) DEFAULT 'springxyzabcboot@gmail.com',
	phone VARCHAR(255) DEFAULT '+21622125144',
	created_at TIMESTAMP DEFAULT LOCALTIMESTAMP,
	updated_at TIMESTAMP
);



