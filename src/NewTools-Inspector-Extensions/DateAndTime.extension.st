Extension { #name : #DateAndTime }

{ #category : #'*NewTools-Inspector-Extensions' }
DateAndTime >> inspectDateAndTimeIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Details'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #iso value: self printString;
			key: #utc value: self asUTC;
			key: #year value: self year; 
			key: #month value: self monthIndex;
			key: #'month name' value: self monthName;
			key: #weekday value: self dayOfWeekName;
			key: #'day of month' value: self dayOfMonth; 
			key: #'day of week' value: self dayOfWeek; 
			key: #'day of year' value: self dayOfYear;
			key: #hours value: self hours; 
			key: #minutes value: self minutes; 
			key: #seconds value: self seconds; 
			key: #nanoseconds value: self nanoSecond; 
			key: #offset value: self offset;
			key: #'unix time' value: self asUnixTime;
			key: #'julian day' value: self julianDayNumber;
			key: #'julian date' value: (self julianDayNumber + (self nanoSecond / 86400000000000.0));
			key: #date value: self asDate;
			key: #time value: self asTime;
			table
]
