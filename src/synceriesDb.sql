SQLite format 3   @                                                                          z ` s`"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            �?�MtablesheetDatasheetDataCREATE TABLE sheetData (
	id INTEGER PRIMARY KEY,
	sheetId INTEGER,
	itemName VARCHAR(255),
	entryId TEXT,
	checked TINYINT(1)
, uploadEditLink TEXT, eTag TEXT)V#yindexu_sheetDatasheetDataCREATE UNIQUE INDEX u_sheetData ON sheetData (entryId)   ��tablesheetDatasheetDataCREATE TABLE sheetData (
	id INTEGER PRIMARY KEY,
	sheetId INTEGER,
	itemName VARCHAR(255),
	entryId TEXT,
	checked TINYINT(1)
)U�indexu_sheetssheetsCREATE UNIQUE INDEX u_sheets ON sheets (worksheetsLinkUrl)�
�otablesheetssheetsCREATE TABLE sheets (
	id INTEGER PRIMARY KEY,
	worksheetsLinkUrl TEXT,
	title VARCHAR(255),
	lastSave DATETIME
)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              