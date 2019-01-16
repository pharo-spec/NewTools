Class {
	#name : #StInspectorHelpCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #accessing }
StInspectorHelpCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StInspectorHelpCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 10;
		bePositionRight;
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
		addGroup: StInspectorCommandGroup uniqueInstance;
		name: 'Help';
		description: 'Open help browser.';
		iconName: #glamorousHelp
]
