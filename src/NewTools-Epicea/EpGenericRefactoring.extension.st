Extension { #name : 'EpGenericRefactoring' }

{ #category : '*NewTools-Epicea' }
EpGenericRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."

	aWriteStream
		nextPutAll: storeString
]
