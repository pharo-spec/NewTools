Class {
	#name : #StInspectorHelpCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #converting }
StInspectorHelpCommand >> asSpecCommand [
	
	^ super asSpecCommand
		iconName: #glamorousHelp;
		yourself
]

{ #category : #execution }
StInspectorHelpCommand >> execute [ 

	HelpBrowser open selectTopicSatisfying: [:each |
		each owner notNil 
			and: [ (each owner key = GTInspectorHelp key) 
			and: [ each title = 'Overview' ] ] ]
]

{ #category : #initialization }
StInspectorHelpCommand >> initialize [
	super initialize.
	self
		name: 'Help';
		description: 'Open help browser.'
]
