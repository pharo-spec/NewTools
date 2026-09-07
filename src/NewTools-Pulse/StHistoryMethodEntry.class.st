"
I wrap a CompiledMethod entry, and store its content printString, then later using OpalCompiler to compile it into an object when needed.
"
Class {
	#name : 'StHistoryMethodEntry',
	#superclass : 'StHistoryEntry',
	#instVars : [
		'contentString'
	],
	#category : 'NewTools-Pulse-Entries',
	#package : 'NewTools-Pulse',
	#tag : 'Entries'
}

{ #category : 'instance creation' }
StHistoryMethodEntry class >> new [

	^ self basicNew
]

{ #category : 'instance creation' }
StHistoryMethodEntry class >> new: aStEntry [

	^ self new 
		contentString: aStEntry content ;
		yourself
]

{ #category : 'visiting' }
StHistoryMethodEntry >> accept: aSpotter [

	aSpotter visitMethodEntry: self
]

{ #category : 'accessing' }
StHistoryMethodEntry >> content [
"You shouldn't use content, use contentString to evade leaking"

	^ self contentEvaluated
]

{ #category : 'accessing' }
StHistoryMethodEntry >> content: aContent [

	self contentString: aContent 
]

{ #category : 'accessing' }
StHistoryMethodEntry >> contentEvaluated [

	^ [ OpalEvaluator new 
			evaluate: self contentString ]
		onErrorDo: [ nil ]
]

{ #category : 'accessing' }
StHistoryMethodEntry >> contentString [

	^ contentString
]

{ #category : 'accessing' }
StHistoryMethodEntry >> contentString: aContent [

	contentString := aContent printString
]

{ #category : 'printing' }
StHistoryMethodEntry >> displayStringOn: aStream [

	aStream nextPutAll: self contentEvaluated selector
]

{ #category : 'evaluating' }
StHistoryMethodEntry >> doEvaluate [

	^ self contentEvaluated browse
]

{ #category : 'accessing' }
StHistoryMethodEntry >> iconName [

	^ self contentEvaluated systemIconName
]

{ #category : 'accessing' }
StHistoryMethodEntry >> label [

	^ contentString 
]
