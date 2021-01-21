"
I wrap the return elements from the spotter processor. 
As the processor returns different elements I add the behaviour required to show the element. 

Also, I redirect the messages that should be answer by my content
"
Class {
	#name : #StEntry,
	#superclass : #DisplayableObject,
	#instVars : [
		'content'
	],
	#category : #'NewTools-Spotter-Processors-Entries'
}

{ #category : #wrapping }
StEntry class >> on: aValue [
	
	^ self new
		content: aValue;
		yourself
]

{ #category : #comparing }
StEntry >> = anEntry [

	^ self species = anEntry species
		and: [ anEntry content = self content ]
]

{ #category : #converting }
StEntry >> asString [ 

	^ self subclassResponsibility 
]

{ #category : #accessing }
StEntry >> content [
	^ content
]

{ #category : #accessing }
StEntry >> content: anObject [
	content := anObject
]

{ #category : #evaluating }
StEntry >> doEvaluate [ 

	self subclassResponsibility 
]

{ #category : #evaluating }
StEntry >> evaluateFor: aGTSpotterStep [ 

	self doEvaluate.
	aGTSpotterStep exit.
]

{ #category : #'spotter-extensions' }
StEntry >> gtDisplayString [

	^ self asString
]

{ #category : #comparing }
StEntry >> hash [

	^ content hash
]

{ #category : #accessing }
StEntry >> icon [
	
	^ self subclassResponsibility
]

{ #category : #accessing }
StEntry >> label [

	^ self asString
]

{ #category : #printing }
StEntry >> printOn: aStream [
	aStream
		<< self class name;
		<< '( ';
		print: content;
		<< ' )'
]

{ #category : #showing }
StEntry >> render [ 

	^ GTSpotterItemBrick new
		icon: self icon;
		text: self asString
]

{ #category : #'spotter-extensions' }
StEntry >> spotterActDefault [
	^ content spotterActDefault 
]

{ #category : #'spotter-extensions' }
StEntry >> spotterPreviewIn: aComposite [

	^ content spotterPreviewIn: aComposite
]

{ #category : #'spotter-extensions' }
StEntry >> spotterPreviewIn: aComposite inContext: aSpotter [

	^ self spotterPreviewIn: aComposite
]

{ #category : #'spotter-extensions' }
StEntry >> spotterProcessorsFor: aSpotterStep [

	^ content spotterProcessorsFor: aSpotterStep
]

{ #category : #'spotter-extensions' }
StEntry >> spotterProcessorsFor: aSpotterStep pragma: aPragma [

	^ content spotterProcessorsFor: aSpotterStep pragma: aPragma
]
