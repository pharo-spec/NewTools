"
I wrap the return elements from the spotter processor. 
As the processor returns different elements I add the behaviour required to show the element. 

Also, I redirect the messages that should be answer by my content
"
Class {
	#name : 'StEntry',
	#superclass : 'Object',
	#instVars : [
		'content'
	],
	#category : 'NewTools-Spotter-Entries',
	#package : 'NewTools-Spotter',
	#tag : 'Entries'
}

{ #category : 'testing' }
StEntry class >> isAbstract [ 

	^ self == StEntry
]

{ #category : 'wrapping' }
StEntry class >> on: aValue [
	
	^ self new
		content: aValue;
		yourself
]

{ #category : 'comparing' }
StEntry >> = anEntry [

	^ self species = anEntry species
		and: [ anEntry content = self content ]
]

{ #category : 'accessing' }
StEntry >> accept: aSpotter [

	aSpotter visitWindowEntry: self
]

{ #category : 'converting' }
StEntry >> asHistoryEntry [

	^ nil
]

{ #category : 'converting' }
StEntry >> asString [ 

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
StEntry >> categoryLabel [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
StEntry >> content [

	^ content
]

{ #category : 'accessing' }
StEntry >> content: anObject [

	content := anObject
]

{ #category : 'spotter-extensions' }
StEntry >> displayString [

	^ self asString
]

{ #category : 'evaluating' }
StEntry >> doEvaluate [ 

	self subclassResponsibility 
]

{ #category : 'evaluating' }
StEntry >> evaluateFor: aSpotter [ 

	self doEvaluate
]

{ #category : 'comparing' }
StEntry >> hash [

	^ self content hash
]

{ #category : 'accessing' }
StEntry >> iconName [
	
	^ self subclassResponsibility
]

{ #category : 'accessing' }
StEntry >> iconOn: anIconProvider [

	^ anIconProvider iconNamed: self iconName
]

{ #category : 'initialization' }
StEntry >> initialize [

	self class initializeSlots: self.
	super initialize
]

{ #category : 'accessing' }
StEntry >> label [

	^ self asString
]

{ #category : 'testing' }
StEntry >> matchesText: aString [

	^ self asString = aString
]

{ #category : 'printing' }
StEntry >> printOn: aStream [

	super printOn: aStream.	
	aStream
		<< '( ';
		print: self content;
		<< ' )'
]

{ #category : 'accessing' }
StEntry >> spotterPreview [

	^ (self content spotterPreview: SpPresenterBuilder new)
		addStyle: 'stSpotterPreview';
		yourself
]

{ #category : 'spotter-extensions' }
StEntry >> stSpotterProcessorsFor: aSpotterStep [

	^ self content stSpotterProcessorsFor: aSpotterStep
]
