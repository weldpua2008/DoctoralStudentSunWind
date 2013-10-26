-- Table: 3C144
CREATE TABLE [3C144] ( 
    id           INTEGER PRIMARY KEY,
    date         DATE,
    files        TEXT    UNIQUE ON CONFLICT REPLACE,
    dots         TEXT,
    chennels     TEXT,
    time_period  TEXT,
    time_middle  TEXT,
    file_complex INTEGER NOT NULL
                         DEFAULT ( 0 ),
    not_calc     BOOLEAN NOT NULL
                         DEFAULT ( 0 ) 
);
INSERT INTO [3C144] ([id], [date], [files], [dots], [chennels], [time_period], [time_middle], [file_complex], [not_calc]) VALUES (1, 1, null, null, null, null, null, 0, 0);


