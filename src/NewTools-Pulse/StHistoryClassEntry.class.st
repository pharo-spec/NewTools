"
I wrap a Class or Trait entry, and store its content printString, then later using OpalCompiler to compile it into an object when needed.
"
Class {
	#name : 'StHistoryClassEntry',
	#superclass : 'StHistoryEntry',
	#instVars : [
		'contentString'
	],
	#category : 'NewTools-Pulse-Entries',
	#package : 'NewTools-Pulse',
	#tag : 'Entries'
}

{ #category : 'instance creation' }
StHistoryClassEntry class >> new [

	^ self basicNew
	
]

{ #category : 'instance creation' }
StHistoryClassEntry class >> new: aStEntry [

	^ self new 
		contentString: aStEntry content ;
		yourself
	
]

{ #category : 'visiting' }
StHistoryClassEntry >> accept: aSpotter [

	aSpotter visitClassEntry: self
]

{ #category : 'accessing' }
StHistoryClassEntry >> content [
"You shouldn't use content, use contentString to evade leaking"

	^ self contentEvaluated
]

{ #category : 'accessing' }
StHistoryClassEntry >> content: aContent [

	self contentString: aContent 
]

{ #category : 'accessing' }
StHistoryClassEntry >> contentEvaluated [

	^ [ 
		OpalCompiler new 
			source: self contentString;
			evaluate ]
	onErrorDo: [ nil ]
]

{ #category : 'accessing' }
StHistoryClassEntry >> contentString [

	^ contentString
]

{ #category : 'accessing' }
StHistoryClassEntry >> contentString: aContent [

	contentString := aContent printString
]

{ #category : 'printing' }
StHistoryClassEntry >> displayStringOn: aStream [

	aStream nextPutAll: self contentEvaluated name
]

{ #category : 'evaluating' }
StHistoryClassEntry >> doEvaluate [
	
	self contentEvaluated browse
]

{ #category : 'accessing' }
StHistoryClassEntry >> iconName [

	^ self contentEvaluated systemIconName
]
