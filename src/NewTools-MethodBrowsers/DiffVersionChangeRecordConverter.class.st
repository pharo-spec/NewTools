"
A converter used to show the diff between two Method references.
"
Class {
	#name : 'DiffVersionChangeRecordConverter',
	#superclass : 'AbstractMethodReferenceConverter',
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'private' }
DiffVersionChangeRecordConverter >> internalGetText [
	| priorSource |
	priorSource := (self priorVersionOfAMethod: method) ifNotNil: [ :m | m sourceCode ] ifNil: [ '' ].
	^ Array with: priorSource with: method sourceCode
]

{ #category : 'private' }
DiffVersionChangeRecordConverter >> priorVersionOfAMethod: aChangeRecord [
	| index |
	index := referencesList identityIndexOf: aChangeRecord .
	^ referencesList at: index+1 ifAbsent: [ nil ]
]

{ #category : 'updating' }
DiffVersionChangeRecordConverter >> updateContent: content on: aVersionBrowser [

	self subclassResponsibility
]
