CREATE DATABASE bill_mate;

\c bill_mate;

CREATE TABLE bill_group (
  group_id SERIAL PRIMARY KEY,
  description VARCHAR,
  category VARCHAR(64),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  auth_user_id INTEGER not NULL,
  constraint fk_auth_user foreign KEY(auth_user_id) references auth_user(id)
);

CREATE TABLE participant (
  participant_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  group_id INTEGER NOT NULL,
  constraint fk_group foreign KEY(group_id) references bill_group(group_id)
);

CREATE TABLE bill (
  bill_id SERIAL PRIMARY KEY,
  photo BYTEA, -- image storage as byte array
  name VARCHAR(255) NOT NULL,
  sub_total_bill BIGINT NOT NULL,
  total_bill BIGINT NOT NULL,
  tax_rate NUMERIC(4,2) NOT NULL DEFAULT 0.0,
  fee_rate NUMERIC(4,2) DEFAULT 0.0,
  discount_rate NUMERIC(4,2) DEFAULT 0.0,
  description TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  group_id INTEGER NOT NULL,
  paid_by_participant_id INTEGER,
  participant_owes_id INTEGER,
  constraint fk_group foreign KEY(group_id) references bill_group(group_id),
  constraint fk_paid_participant foreign KEY(paid_by_participant_id) references participant(participant_id),
  constraint fk_owes_participant foreign KEY(participant_owes_id) references participant(participant_id)
);


CREATE TABLE transaction (
  transaction_id SERIAL PRIMARY KEY,
  bill_id INTEGER NOT NULL REFERENCES bill(bill_id),
  photo BYTEA, -- image storage as byte array (optional)
  type VARCHAR(64),
  status VARCHAR(64) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  participant_id INTEGER NOT NULL,
  constraint fk_participant foreign KEY(participant_id) references participant(participant_id)
);


CREATE TABLE bill_participant_owes (  -- Many-to-Many relationship table
  PRIMARY KEY (bill_id, participant_id),
  bill_id INTEGER REFERENCES bill(bill_id),
  participant_id INTEGER,
  constraint fk_bill foreign KEY(bill_id) references bill(bill_id),
  constraint fk_participant foreign KEY(participant_id) references participant(participant_id)
);


drop table if exists bill_participant_owes;

drop table if exists transaction;

drop table if exists bill;

drop table if exists participant;

drop table if exists bill_group;

GRANT ALL PRIVILEGES ON DATABASE bill_mate TO yoseph;
