/// SQLite schema version 1; kept in sync with docs/data_schema.md.
const databaseSchema = <String>[
  '''CREATE TABLE persons (
    id TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
  )''',
  '''CREATE TRIGGER protect_my_person BEFORE DELETE ON persons
    WHEN OLD.id = 'me-id'
    BEGIN SELECT RAISE(ABORT, 'Cannot delete the current user'); END''',
  '''CREATE TABLE locations (
    id TEXT NOT NULL PRIMARY KEY,
    google_place_id TEXT,
    name TEXT NOT NULL,
    country_code TEXT CHECK (country_code IS NULL OR
      (length(country_code) = 2 AND country_code GLOB '[A-Z][A-Z]')),
    address TEXT,
    latitude REAL,
    longitude REAL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    CHECK ((latitude IS NULL AND longitude IS NULL) OR
      (latitude IS NOT NULL AND longitude IS NOT NULL AND
       latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180))
  )''',
  '''CREATE TABLE person_locations (
    person_id TEXT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    location_id TEXT NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    sort_order INTEGER NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    PRIMARY KEY (person_id, location_id)
  )''',
  '''CREATE TABLE postcards (
    id TEXT NOT NULL PRIMARY KEY,
    title TEXT,
    orientation TEXT NOT NULL CHECK (orientation IN ('portrait', 'landscape')),
    front_image_path TEXT CHECK (front_image_path IS NULL OR length(trim(front_image_path)) > 0),
    back_image_path TEXT CHECK (back_image_path IS NULL OR length(trim(back_image_path)) > 0),
    sender_id TEXT REFERENCES persons(id) ON DELETE RESTRICT,
    recipient_id TEXT REFERENCES persons(id) ON DELETE RESTRICT,
    send_from_id TEXT REFERENCES locations(id) ON DELETE RESTRICT,
    send_to_id TEXT REFERENCES locations(id) ON DELETE RESTRICT,
    sent_at TEXT CHECK (sent_at IS NULL OR sent_at GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    received_at TEXT CHECK (received_at IS NULL OR received_at GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    notes TEXT NOT NULL DEFAULT '',
    is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1)),
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    CHECK (front_image_path IS NOT NULL OR back_image_path IS NOT NULL)
  )''',
  '''CREATE TABLE collections (
    id TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
  )''',
  '''CREATE TABLE collection_postcards (
    collection_id TEXT NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    postcard_id TEXT NOT NULL REFERENCES postcards(id) ON DELETE CASCADE,
    PRIMARY KEY (collection_id, postcard_id)
  )''',
  'CREATE INDEX postcards_sender_sent ON postcards(sender_id, sent_at)',
  'CREATE INDEX postcards_recipient_received ON postcards(recipient_id, received_at)',
  'CREATE INDEX postcards_sent ON postcards(sent_at)',
  'CREATE INDEX postcards_created ON postcards(created_at)',
  'CREATE INDEX postcards_favorite ON postcards(is_favorite)',
  'CREATE INDEX postcards_from ON postcards(send_from_id)',
  'CREATE INDEX postcards_to ON postcards(send_to_id)',
  'CREATE INDEX locations_country ON locations(country_code)',
  'CREATE INDEX person_locations_location ON person_locations(location_id)',
  'CREATE INDEX collection_postcards_postcard ON collection_postcards(postcard_id)',
];
