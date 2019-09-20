Class {
	#name : #StInspectorCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #'instance creation' }
StInspectorCommand class >> instantiateCommands: commandClasses forInspector: inspector [
	
	^ commandClasses
		collect: [ :commandClass | commandClass forSpecContext: inspector  ]
		thenSelect: [ :debugCommand | 
			debugCommand decoratedCommand appliesToInspector: inspector ]
]

{ #category : #'instance creation' }
StInspectorCommand class >> toolbarCommandsFor: inspector [

	^ self
		instantiateCommandsFromPragma: #toolbarInspectCommand:
		for: inspector
]

{ #category : #'as yet unclassified' }
StInspectorCommand >> appliesTo: anInspector [

	^ true
]

{ #category : #initialization }
StInspectorCommand >> initialize [

	super initialize.
	self description: (String streamContents: [ :stream | 
		stream 
			<< self class defaultName
			<< ': '
			<< self class defaultDescription ])	
]
