Extension { #name : #Date }

{ #category : #'*NewTools-Inspector-Extensions' }
Date >> inspectDateIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Details'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #iso value: self yyyymmdd;
			key: #year value: self year; 
			key: #month value: self monthIndex;
			key: #'month name' value: self monthName;
			key: #weekday value: self dayOfWeekName;
			key: #'day of month' value: self dayOfMonth; 
			key: #'day of week' value: self dayOfWeek; 
			key: #'day of year' value: self dayOfYear; 
			table
]
