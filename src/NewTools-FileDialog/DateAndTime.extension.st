Extension { #name : #DateAndTime }

{ #category : #'*NewTools-FileDialog' }
DateAndTime >> fileDialogFormat [
	^ '{1} {2} {3} {4}' format:
		{self dayOfMonth asString.
		self monthAbbreviation.
		self year asString.
		(self asTime print24 first: 5)}
]
