"
The purpose of this class is to select ""the best"" debugger to open a debug session (a.k.a. execution that signalled an uncaught exception).
-> See method #selectDebuggerAndOpen:withFullView:withNotification:
This class finds all the debugger classes present in the image with #getDebuggerClasses and the method testing whether a class is a debugger class or not is #isThisClassADebugger.
This class implements the singleton design pattern. Its singleton can be obtained by executing `DebuggerSelector singleton`.
# Variables
- mainDebuggerClass  | a Class
- subscribersOnMainDebuggerClassUpdate  |  WeakOrderedCollection<Object>
# Long Description
**The Point**
The idea of `DebuggerSelector` is to have a generic system for choosing ""the most suitable"" debugger to open a given DebugSession. A system like this is already in place in some fashion, but it is internal to the GTDebugger (you can see it at play when you debug a test: the debugger looks a bit different and shows test-specific information, because it's actually the GTTestDebugger that was opened), so it is not easy to add new non-GT debuggers.
**Short Description**
`DebuggerSelector` finds all the debugger classes of the system, ask them how they rank the DebugSession to be opened, and opens the DebugSession with the highest-ranking debugger. If this opening fails (because the debugger signals an Error), then `DebuggerSelector` tries to open the DebugSession with the second-highest ranking debugger and so on...
**What is a Debugger class?**
A debugger class is a class that implements all the methods from the AbstractDebugger class that are marked as SubclassResponsibility. For now, that is:
- `iAmADebugger`: This method simply needs to contain the `<iAmADebugger>` pragma, and is just there as a marker.
- `rankDebugSession: aDebugSession`: This method returns the rank of this debugger on the provided DebugSession. If the debugger absolutely cannot open the DebugSession, it should signal the `DebugSessionCannotBeOpenedByThisDebugger` exception. For example, a debugger that is specialised to debug test executions will return a high number if the DebugSession is that of a test execution, and signal the exception if it is not.
- `openOn: aDebugSession withFullView: aBool andNotification: aString`: This method should open the provided DebugSession in that debugger. It is a good place to call `#keepAlive:` on the DebugSession to ensure it does not get terminated by `DebugSessionStorage` while the debugger is open on it.
An important point is that debugger classes do not need to inherit from the `AbstractDebugger` class to be considered as debugger classes. They only need to implement the three (class-side) methods detailed above.
**More Details on the Debugger Selection Algorithm**
The algorithm outlined above gives the main idea. In addition to that:
- Debugger classes that signal the `DebugSessionCannotBeOpenedByThisDebugger` exception when asked to rank the DebugSession cannot be selected
- `DebuggerSelector` has a `mainDebuggerClass` variable. If a debugger class is in this variable, `DebuggerSelector` will always attempt to open the DebugSession with it first, and only if that signals an Error will it fall back on the default algorithm. A use for this is to manually set a specific debugger for images in production mode, for example one that only logs the exception in a file but does not open a graphical debugger allowing the user to modify code.
"
Class {
	#name : #DebuggerSelector,
	#superclass : #Object,
	#instVars : [
		'mainDebuggerClass',
		'subscribersOnMainDebuggerClassUpdate',
		'debuggingLevel'
	],
	#classVars : [
		'singleton'
	],
	#category : #'NewTools-DebuggerSelector'
}

{ #category : #singleton }
DebuggerSelector class >> initialize [
	Smalltalk tools debuggerTool: self singleton
]

{ #category : #singleton }
DebuggerSelector class >> singleton [
	singleton ifNil: [ singleton := self new ].
	^ singleton
]

{ #category : #'publish events' }
DebuggerSelector >> addSubscriberOnMainDebuggerClassUpdate: anObject [
	self subscribersOnMainDebuggerClassUpdate add: anObject
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> closeAllDebuggers [
	self flag: 'Ugly temporary hack: Thomas can you fix this?'.
	self flag: 'GTGenericStackDebugger is ultra slow to close its windows...'.
	self getDebuggerClasses
		do: [ :dbgClass | 
			(dbgClass respondsTo: #closeAllDebuggers)
				ifTrue: [ dbgClass closeAllDebuggers ] ]


]

{ #category : #'debugging - levels' }
DebuggerSelector >> decreaseDebuggingLevel [
	debuggingLevel := debuggingLevel - 1
]

{ #category : #debuggers }
DebuggerSelector >> getDebuggerClasses [
	| result classesWithDummyDebuggerPragma |
	result := ((PragmaCollector
		filter: [ :prg | prg selector = #iAmADebugger ]) reset collected
		collect: [ :debuggerMethod | debuggerMethod methodClass soleInstance ])
		select: [ :aClass | self isThisClassADebugger: aClass ] yourself.
	self ignoreDummyDebuggerForTests
		ifTrue:
			[ "If we have to remove dummy debuggers from the list (typically during normal uses of this class), remove all debugger classes that have the #iAmADummyDebuggerForTest pragma from the list. Those dummy debuggers are there for testing purposes"
			classesWithDummyDebuggerPragma := (PragmaCollector
				filter: [ :prg | prg selector = #iAmADummyDebuggerForTest ]) reset
				collected
				collect: [ :debuggerMethod | debuggerMethod methodClass soleInstance ].
			"result removeAll: classesWithDummyDebuggerPragma "].
	^ result
]

{ #category : #debuggers }
DebuggerSelector >> ignoreDummyDebuggerForTests [
	"If true, this class will ignore the DummyDebuggerForTests class when selecting a debugger. This is intended to be overriden for testing purposes"

	^ true
]

{ #category : #'debugging - levels' }
DebuggerSelector >> increaseDebuggingLevel [
	debuggingLevel := debuggingLevel + 1
]

{ #category : #initialize }
DebuggerSelector >> initialize [ 
	super initialize.
	debuggingLevel := 0
]

{ #category : #'system - integration' }
DebuggerSelector >> isObsolete [
	"Method required for DebuggerSelector to be set as the debugger tool in 'Smalltalk tools'
	I do not really know what it means"
	self flag: 'Thomas, you cannot code stuff that you do not know what it means.
	Please investigate.'.
	^ false
]

{ #category : #debuggers }
DebuggerSelector >> isThisClassADebugger: aClass [
	"Returns whether @aClass implements the required methods to be considered a debugger class. It must:
	- have a #iAmADebugger method, with the #iAmADebugger pragma
	- implement all the class methods from class AbstractDebugger that are marked as being subclass responsibility
	- implement all the instance-side methods from class AbstractDebugger that are marked as being subclass responsibility"

	| requiredClassMethods aClassClassMethods requiredMethods aClassMethods |
	(aClass class allMethods
		anySatisfy:
			[ :meth | meth selector = #iAmADebugger & (meth hasPragmaNamed: #iAmADebugger) ])
		ifFalse: [ ^ false ].	"aClass must have a class method named #iAmADebugger and having the #iAmADebugger pragma"
	requiredClassMethods := (AbstractDebugger class allMethods
		select: [ :aMethod | aMethod methodClass = AbstractDebugger class ])
		select: [ :aMethod | aMethod isSubclassResponsibility ].	"Lists all class methods exactly (i.e. not inherited) on class AbstractDebugger that are marked as being subclass responsibility"
	aClassClassMethods := aClass class allMethods.	"List all class methods on class aClass (including inherited class methods)"
	aClassClassMethods := aClassClassMethods
		reject: [ :aMethod | aMethod isSubclassResponsibility ].	"Remove class methods that are marked as being subclass responsibility. In particular, this removes methods inherited from the AbstractDebugger class if aClass inherits from it"
	((aClassClassMethods collect: [ :aMethod | aMethod selector ])
		includesAll: (requiredClassMethods collect: [ :aMethod | aMethod selector ]))
		ifFalse: [ ^ false ].	"Requires that aClass implements all the methods from the requiredClassMethods list"

	"Then we do the same thing, but for methods on the instance side"
	requiredMethods := (AbstractDebugger allMethods
		select: [ :aMethod | aMethod methodClass = AbstractDebugger ])
		select: [ :aMethod | aMethod isSubclassResponsibility ].
	aClassMethods := aClass class allMethods.
	aClassMethods := aClassMethods
		reject: [ :aMethod | aMethod isSubclassResponsibility ].
	((aClassMethods collect: [ :aMethod | aMethod selector ])
		includesAll: (requiredMethods collect: [ :aMethod | aMethod selector ]))
		ifFalse: [ ^ false ].
	^ true
]

{ #category : #'debuggers - lookup' }
DebuggerSelector >> lookupDebuggerAndOpen: aDebugSession notification: notificationString [
	| debuggerClasses |
	"Exclude all debugger classes that signal the DebugSessionCannotBeOpenedByThisDebugger exception when asked to rank @aDebugSession, as these cannot open @aDebugSession"
	debuggerClasses := self getDebuggerClasses
		select: [ :aDebuggerClass | 
			[ aDebuggerClass rankDebugSession: aDebugSession.
			true ]
				on: DebugSessionCannotBeOpenedByThisDebugger
				do: [ false ] ].	

	"Ask each debugger class to rank @aDebugSession, and sort them from highest rank to lowest."
	debuggerClasses := ((debuggerClasses
		collect: [ :aDebuggerClass | 
			{aDebuggerClass.
			(aDebuggerClass rankDebugSession: aDebugSession)} ])
		sort: [ :val1 :val2 | (val1 at: 2) >= (val2 at: 2) ])
		collect: [ :couple | couple at: 1 ].	
		
	debuggerClasses
		do: [ :aDebuggerClass | 
			(self
				tryToOpenDebugSession: aDebugSession
				withDebuggerClass: aDebuggerClass
				andNotification: notificationString)
				ifTrue:
					[ ^ self	"We opened @aDebugSession with a suitable debugger. We are done here" ] ].

	"Try to open @aDebugSession with the highest ranking debugger. If this raises an Error, try with the second highest ranking debugger instead. If this raises an Error, try with the third highest..."
	self inform: 'No debugger could open this debug session'
]

{ #category : #accessing }
DebuggerSelector >> mainDebuggerClass [
	^ mainDebuggerClass
]

{ #category : #accessing }
DebuggerSelector >> mainDebuggerClass: aClass [
	(aClass isNil or: [ self isThisClassADebugger: aClass ])
		ifFalse: [ CannotSetAsMainDebuggerAClassThatIsNotADebuggerClass signal ].
	mainDebuggerClass := aClass.
	self notifySubscribersOfAMainDebuggerClassUpdate
]

{ #category : #'debugging - levels' }
DebuggerSelector >> maximumDebuggingLevel [
	^1
]

{ #category : #'publish events' }
DebuggerSelector >> notifySubscribersOfAMainDebuggerClassUpdate [
	self subscribersOnMainDebuggerClassUpdate
		do: [ :subscriber_ | 
			subscriber_
				ifNotNil: [ :subscriber | subscriber onMainDebuggerClassUpdate ] ]
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> openOn: aDebugSession withFullView: aBoolean [
	"This method makes DebuggerSelector compatible with the rubric text editor. More specifically, the 'Debug it' option of Rubric's right-click menu will send #openOn:withFullView: to 'Smalltalk tools debugger' (see RubSmalltalkEditor>>#debug:receiver:in:. So to be able to set DebuggerSelector as the main debugger tool of 'Smalltalk tools', it needs to understand this message"

	self selectAndOpenDebuggerFor: aDebugSession withNotification: nil
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> openWithMainDebugger: aDebugSession andNotification: notificationString [
	"Open aDebugSession with the main debugger class in the system. Look at the comments below for the detailed algorithm selecting the most suitable debugger"

	[ self
		tryToOpenDebugSession: aDebugSession
		withDebuggerClass: self mainDebuggerClass
		andNotification: notificationString ]
		on: Error
		do: [ self
				lookupDebuggerAndOpen: aDebugSession
				notification: notificationString ]
]

{ #category : #'publish events' }
DebuggerSelector >> removeSubscriberOnMainDebuggerClassUpdate: anObject [
	self subscribersOnMainDebuggerClassUpdate
		remove: anObject
		ifAbsent:
			[ "It's a weak collection, its elements can be nilled by the garbage collector at any time if they are not referenced elsewhere, so it can happen not to find the object to remove because it has already been nilled" ]
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> requestActionOnDebuggerError: error [
	^ (UIManager default
		chooseFrom:
			{'Open the original exception in another debugger?'.
			'Open the debugger exception in another debugger?'}
		values: {true . false}
		message:
			'An exception occured while opening your debugger:'
				, error printString
		title: 'Your debugger is broken...') ifNil: [ false ]
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> selectAndOpenDebuggerFor: aDebugSession withNotification: notificationString [
	"Open aDebugSession with the most suitable debugger class in the system. "

	self mainDebuggerClass
		ifNil: [ ^ self
				lookupDebuggerAndOpen: aDebugSession
				notification: notificationString ].
	self
		openWithMainDebugger: aDebugSession
		andNotification: notificationString
]

{ #category : #debuggers }
DebuggerSelector >> setNoMainDebuggerClass [
	"Removes the main debugger class if there was any"

	self mainDebuggerClass: nil
]

{ #category : #debuggers }
DebuggerSelector >> sortedDebuggerClassesFor: aDebugSession [
	^ (self getDebuggerClasses
		select:
			[ :aDebuggerClass |  (aDebuggerClass rankDebugSession: aDebugSession) > 0  ])
		sort: [ :dbgClass1 :dbgClass2 | 
			(dbgClass1 rankDebugSession: aDebugSession)
				>= (dbgClass2 rankDebugSession: aDebugSession) ]
]

{ #category : #'publish events' }
DebuggerSelector >> subscribersOnMainDebuggerClassUpdate [
	subscribersOnMainDebuggerClassUpdate
		ifNil: [ subscribersOnMainDebuggerClassUpdate := WeakOrderedCollection new ].
	^ subscribersOnMainDebuggerClassUpdate
]

{ #category : #'debuggers - opening' }
DebuggerSelector >> tryToOpenDebugSession: aDebugSession withDebuggerClass: aDebuggerClass andNotification: aString [
	"Tries to open @aDebugSession with debugger @aDebuggerClass. If an Error is raised doing so, returns false, otherwise return true"

	[ aDebuggerClass
		openOn: aDebugSession
		withFullView: true
		andNotification: aString ]
		on: Error
		do: [ :err | 
			(self requestActionOnDebuggerError: err) ifFalse: [ ^ false ].
			self increaseDebuggingLevel.
			err debug.
			self decreaseDebuggingLevel ].
	^ true
]
