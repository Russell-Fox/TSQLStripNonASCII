# TSQLStripNonASCII
Strips a string leaving only ASCII characters between 32 (space) and 126 (tilde (~)).

Usage - create as an inline table-valued function, fGetASCIIOnlyString_32to126:

	SELECT 
		y.StringColumn
		, NewStringColumn = NewStr.CleanedString
	FROM YourTable y
	OUTER APPLY dbo.fGetASCIIOnlyString_32to126(y.StringColumn) NewStr
