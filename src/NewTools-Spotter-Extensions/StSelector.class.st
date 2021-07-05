"
A wrapper for selectors to be used in spotter (so they are something more than just symbols). 
"
Class {
	#name : #StSelector,
	#superclass : #Object,
	#instVars : [
		'name',
		'methods'
	],
	#category : #'NewTools-Spotter-Extensions'
}

{ #category : #adding }
StSelector >> addMethod: aCompiledMethod [
	"this is a private method that can be used by the constructor on the class side
	exclusively within the context of Spotter"
	methods ifNil: [ methods := OrderedCollection new ].
	methods add: aCompiledMethod
]

{ #category : #displaying }
StSelector >> displayStringOn: stream [

	stream nextPutAll: self name
]

{ #category : #private }
StSelector >> implementors [
	^ methods ifNil: [ 
		methods := (SystemNavigation default allImplementorsOf: self name) 
			collect: [ :each | each compiledMethod ] ]
]

{ #category : #accessing }
StSelector >> name [
	^ name
]

{ #category : #accessing }
StSelector >> name: anObject [
	name := anObject
]

{ #category : #private }
StSelector >> senders [
	^ SystemNavigation default allSendersOf: self name
]

{ #category : #spotter }
StSelector >> spotterUsersFor: aStep [
	<stSpotterOrder: 50>

	^ aStep listProcessor
		title: 'Senders';
		filter: StFilterSubstring item: [ :filter :context | 
			self senders do: [ :sender | 
				filter value: sender compiledMethod ] ];
		keyBinding: $n meta
]
