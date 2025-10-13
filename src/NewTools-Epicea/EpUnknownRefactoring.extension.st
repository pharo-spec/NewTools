Extension { #name : 'EpUnknownRefactoring' }

{ #category : '*NewTools-Epicea' }
EpUnknownRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."

	aWriteStream
		nextPutAll: printString
]
