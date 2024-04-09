"
All Spec presenters using me will be recognised as debugger extensions when opening a debugger.

"
Trait {
	#name : 'TStDebuggerExtension',
	#instVars : [
		'debugger'
	],
	#classInstVars : [
		'showDebuggerExtension',
		'debuggerExtensionDisplayOrder'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'testing' }
TStDebuggerExtension classSide >> acceptsPredicate: aStDebuggerContextPredicate [

	^ true
]

{ #category : 'debugger extension' }
TStDebuggerExtension classSide >> defaultDisplayOrder [

	^ 1
]

{ #category : 'debugger extension' }
TStDebuggerExtension classSide >> displayOrder [

	^ debuggerExtensionDisplayOrder ifNil: [ 
		  debuggerExtensionDisplayOrder := self defaultDisplayOrder ]
]

{ #category : 'debugger extension' }
TStDebuggerExtension classSide >> displayOrder: anInteger [
	debuggerExtensionDisplayOrder := anInteger
]

{ #category : 'testing' }
TStDebuggerExtension classSide >> isOnlyForTests [

	^ false
]

{ #category : 'debugger extension' }
TStDebuggerExtension classSide >> showInDebugger [
	^showDebuggerExtension ifNil: [showDebuggerExtension := false]
]

{ #category : 'debugger extension' }
TStDebuggerExtension classSide >> showInDebugger: aBoolean [

	self showInDebugger = aBoolean ifTrue: [ "The activated state hasn't changed. So we don't announce an extension toggle"
		^ self ].
	showDebuggerExtension := aBoolean.
	SystemAnnouncer uniqueInstance announce:
		(StDebuggerExtensionActivationToggle debuggerExtensionClass: self)
]

{ #category : 'visiting' }
TStDebuggerExtension >> accept: aVisitor [
]

{ #category : 'accessing' }
TStDebuggerExtension >> debugger [
	^debugger
]

{ #category : 'debugger extension' }
TStDebuggerExtension >> debuggerExtensionToolName [
	^self explicitRequirement 
]

{ #category : 'layout' }
TStDebuggerExtension >> debuggerLayout [

	^ self defaultLayout
]

{ #category : 'debugger extension' }
TStDebuggerExtension >> displayOrder [
	^self class displayOrder
]

{ #category : 'initialization' }
TStDebuggerExtension >> setModelBeforeInitialization: aDebugger [
	 debugger := aDebugger
]

{ #category : 'debugger extension' }
TStDebuggerExtension >> showInDebugger [
	^self class showInDebugger 
]

{ #category : 'debugger extension' }
TStDebuggerExtension >> showInDebugger: aBoolean [
	self class showInDebugger: aBoolean 
]
