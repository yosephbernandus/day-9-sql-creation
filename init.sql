CREATE DATABASE bill_mate;

\c bill_mate;

CREATE TABLE auth_user (
  auth_user_id SERIAL PRIMARY KEY,
  username VARCHAR(64) UNIQUE NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR NOT NULL, 
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE participant (
  participant_id SERIAL PRIMARY KEY,
  group_id INTEGER NOT NULL REFERENCES bill_group(group_id),
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bill_group (
  group_id SERIAL PRIMARY KEY,
  auth_user_id INTEGER NOT NULL REFERENCES auth_user(auth_user_id),
  description VARCHAR,
  category VARCHAR(64),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bill (
  bill_id SERIAL PRIMARY KEY,
  photo BYTEA, -- image storage as byte array
  group_id INTEGER NOT NULL REFERENCES bill_group(group_id),
  paid_by_participant_id INTEGER REFERENCES participant(participant_id),
  participant_owes_id INTEGER REFERENCES participant(participant_id),
  name VARCHAR(255) NOT NULL,
  sub_total_bill BIGINT NOT NULL,
  total_bill BIGINT NOT NULL,
  tax_rate NUMERIC(4,2) NOT NULL DEFAULT 0.0,
  fee_rate NUMERIC(4,2) DEFAULT 0.0,
  discount_rate NUMERIC(4,2) DEFAULT 0.0,
  description TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transaction (
  transaction_id SERIAL PRIMARY KEY,
  bill_id INTEGER NOT NULL REFERENCES bill(bill_id),
  photo BYTEA, -- image storage as byte array (optional)
  type VARCHAR(64),
  status VARCHAR(64) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  participant_id INTEGER NOT NULL REFERENCES participant(participant_id)
);

CREATE TABLE bill_participant_owes (  -- Many-to-Many relationship table
  bill_id INTEGER REFERENCES bill(bill_id),
  participant_id INTEGER REFERENCES participant(participant_id),
  PRIMARY KEY (bill_id, participant_id)
);

GRANT ALL PRIVILEGES ON DATABASE bill_mate TO yoseph;
