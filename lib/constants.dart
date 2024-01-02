const databaseName = 'local.db';
const databaseVersion = 1;
const contactsTable = 'contacts';
const idField = 'id';
const nameField = 'name';
const createdAtField = 'created_at';
const phoneField = 'phone';
const isSyncedField = 'is_synced';
const wasUpdatedField = 'was_updated';


const createContactTable = '''CREATE TABLE "contacts" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"phone"	TEXT NOT NULL UNIQUE,
	"created_at"	TEXT NOT NULL,
	"is_synced"	BOOLEAN NOT NULL DEFAULT 0 CHECK( is_synced IN (0, 1)),
	"was_updated"	BOOLEAN NOT NULL DEFAULT 0 CHECK( is_synced IN (0, 1)),
	"sql_id"	INTEGER NOT NULL,
	PRIMARY KEY("sql_id" AUTOINCREMENT)
);''';

//
//DATETIME DEFAULT (STRFTIME('%d-%m-%Y   %H:%M', 'NOW','localtime'))
//  "sql_id"	INTEGER NOT NULL UNIQUE,,