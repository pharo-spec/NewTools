Extension { #name : 'EpPropagateRefactoring' }

{ #category : '*NewTools-Epicea' }
EpPropagateRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."

	aWriteStream
		nextPutAll: 'Propagate '.

	targetRefactoring summaryOn: aWriteStream
]
