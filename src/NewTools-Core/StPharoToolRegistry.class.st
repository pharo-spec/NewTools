Class {
	#name : #StPharoToolRegistry,
	#superclass : #Object,
	#instVars : [
		'tools',
		'announcer'
	],
	#category : #'NewTools-Core-Application'
}

{ #category : #announcer }
StPharoToolRegistry >> announcer [
	announcer ifNil: [ announcer := Announcer new ].
	
	^ announcer
]

{ #category : #misc }
StPharoToolRegistry >> browseDirectToolReferences [
	"Smalltalk tools browseDirectToolReferences"
	"Browse all direct references of all of my registered tools.
	Useful for converting calls like:

		MyTool foo
	into:
		Smalltalk tools myTool foo 	"
	
	| bindings |
	
	bindings := tools values select: [:each | each value isBehavior ]
		thenCollect: [:each | each value binding ].
	bindings := bindings copyWith: (Smalltalk bindingOf: #ToolSet).

	^  SystemNavigation new
		browseMessageList: (
			SystemNavigation new allMethodsSelect: [:m |
				(m literals select: [:lit| lit isVariableBinding ]) includesAnyOf: bindings ] )
		name: 'All direct references to tools to fix'
]

{ #category : #'reflective operations' }
StPharoToolRegistry >> doesNotUnderstand: aMessage [
	"Return a tool identified by a message selector.
	We need to handle special case, when no debugger registered.
	"
	| tool |
	tool := tools at: aMessage selector ifAbsent: nil.
	tool ifNotNil: [ ^ tool value ].

	^super doesNotUnderstand: aMessage

]

{ #category : #testing }
StPharoToolRegistry >> hasToolNamed: aToolName [
	^ tools includesKey: aToolName 
]

{ #category : #initialization }
StPharoToolRegistry >> initDefaultToolSet [
	
	"Query the system for registering tools"
	"we cannot afford to show warnings because not all tools e.g Debugger, Inspector are registered yet"
	
	[	
	Object withAllSubclassesDo: [:ea | 
	"evaluate only for classes which directly implement this message,
	not via subclassing"
		(ea isMeta  and: [
			ea includesSelector: #registerToolsOn: ]) ifTrue: [
			 ea instanceSide registerToolsOn: self  ]].
	] on: Warning do: [:ex | ex resume ]
]

{ #category : #initialization }
StPharoToolRegistry >> initialize [

	"symbols used as keys "
	tools := IdentityDictionary new.  
	
	self initDefaultToolSet
]

{ #category : #tools }
StPharoToolRegistry >> inspector [
	"understand by Object, so we need to work around not getting a DNU"
	^self doesNotUnderstand: (Message selector: #inspector)
]

{ #category : #menu }
StPharoToolRegistry >> menuItems [
	"Answer the menu items available for this tool set"

	^#(
		('System Browser' 			#openClassBrowser)
		-
		('Playground'				#openWorkspace)
		('Transcript' 				#openTranscript)
		('File Browser'				#openFileList)
		-
		('Test Runner'				#openTestRunner)
		('Process Browser' 			#openProcessBrowser)
		-
		('Monticello Browser'		#openMonticelloBrowser)
		('Change Sorter'			#openChangeSorter)
	)

]

{ #category : #menu }
StPharoToolRegistry >> openClassBrowser [
	^ self browser open
]

{ #category : #menu }
StPharoToolRegistry >> openFileList [
	self fileList open
]

{ #category : #menu }
StPharoToolRegistry >> openMonticelloBrowser [
	self monticelloBrowser open
	
]

{ #category : #menu }
StPharoToolRegistry >> openProcessBrowser [
	self using: #processBrowser do: [:tool |
		tool open
		]

]

{ #category : #menu }
StPharoToolRegistry >> openRecentChangesLog [
	self changeList browseRecentLog
]

{ #category : #menu }
StPharoToolRegistry >> openTestRunner [
	self using: #testRunner do: [:tool | tool open ]
]

{ #category : #menu }
StPharoToolRegistry >> openTranscript [
	^ self transcript open
]

{ #category : #menu }
StPharoToolRegistry >> openWorkspace [
	^ self workspace open
]

{ #category : #registration }
StPharoToolRegistry >> register: anObject as: aNameSelector [
	"Register a tool class under given name"
	tools at: aNameSelector put: anObject.
	self announcer announce: (ToolRegistryToolRegistered tool: anObject name: aNameSelector) 
]

{ #category : #registration }
StPharoToolRegistry >> remove: aName [

	| toolToRemove |
	
	"remove tool with given name"
	toolToRemove := tools removeKey: aName ifAbsent: [].
	self announcer announce: (ToolRegistryToolRegistered tool: toolToRemove name: aName) 
]

{ #category : #announcer }
StPharoToolRegistry >> resetAnnouncer [

	"unregister all current weak subscriptions because it can cause a memory leak"
	announcer ifNil: [ ^self ].
	announcer subscriptions subscriptions
 		select: [:each | each isKindOf: WeakAnnouncementSubscription] 
		thenDo: [:each | each weakRegistry remove: each subscriber ifAbsent: []]. 
	Smalltalk garbageCollect.
		
	announcer := nil.
]

{ #category : #tools }
StPharoToolRegistry >> transcript [
	"No need to register transcript. But for uniformity,
	implement this method, so transcript can be accessed via
	Smalltalk tools transcript , as any other tool "
	^ Transcript
]

{ #category : #misc }
StPharoToolRegistry >> using: aToolName do: aBlock [
	"Evaluate a block for tool found under corresponding name or silently ignore if its not found or nil"
	| tool |
	
	tool := tools at: aToolName ifAbsent: [ ^ self ].
	tool ifNotNil: [ ^ aBlock value: tool value ]
]

{ #category : #announcer }
StPharoToolRegistry >> whenToolRegistered: aBlock [

	self announcer weak when: ToolRegistryToolRegistered do: aBlock 
]

{ #category : #announcer }
StPharoToolRegistry >> whenToolUnregistered: aBlock [

	self announcer weak when: ToolRegistryToolUnregistered do: aBlock 
]
