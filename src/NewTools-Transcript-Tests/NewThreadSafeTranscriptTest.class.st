Class {
	#name : 'NewThreadSafeTranscriptTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Transcript-Tests',
	#package : 'NewTools-Transcript-Tests'
}

{ #category : 'tests' }
NewThreadSafeTranscriptTest >> testNextPut [

	| t |
	t := NewThreadSafeTranscript new.
	t nextPut: $a.
	t << 'toto'.
	t cr.
	t nextPutAll: 'tintin'.
	self assert: t contents equals: 'atoto
tintin' 
]

{ #category : 'tests' }
NewThreadSafeTranscriptTest >> testNextPutIsOverMaxEntry [

	| t |
	t := NewThreadSafeTranscript new.
	t maxEntry: 5.
	t << 'abcdefgh'.
	self assert: t contents equals: 'fgh' 
]

{ #category : 'tests' }
NewThreadSafeTranscriptTest >> testNextPutIsUnderMaxEntry [

	| t |
	t := NewThreadSafeTranscript new.
	t maxEntry: 5.
	t << 'toto'.
	self assert: t contents equals: 'toto' 
]

{ #category : 'tests' }
NewThreadSafeTranscriptTest >> testShow [

	| t |
	t := NewThreadSafeTranscript new.
	t show: 'toto'.
	self assert: t contents equals: 'toto' 
]

{ #category : 'tests' }
NewThreadSafeTranscriptTest >> testShowAndClear [

	| t |
	t := NewThreadSafeTranscript new.
	t show: 'toto'.
	self assert: t contents equals: 'toto'.
	t clear.
	self assert: t contents isEmpty
]
