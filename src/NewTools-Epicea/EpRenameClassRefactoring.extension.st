Extension { #name : 'EpRenameClassRefactoring' }

{ #category : '*NewTools-Epicea' }
EpRenameClassRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."

	aWriteStream
		nextPutAll: 'Rename ';
		nextPutAll: oldName;
		nextPutAll: ' into ';
		nextPutAll: newName
]
