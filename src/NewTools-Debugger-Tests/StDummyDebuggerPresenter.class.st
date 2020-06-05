"
I am a dummy debugger presenter for tests.
I'm used in tests to easily ensure that commands or other clients call the correct interface on their debugger object.
The debugger interface itself is tested in the debugger test class.
"
Class {
	#name : #StDummyDebuggerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tag'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - views'
}

{ #category : #accessing }
StDummyDebuggerPresenter class >> debuggerExtensionTestPragma [
	<debuggerExtensionTestPragma>
	
]

{ #category : #accessing }
StDummyDebuggerPresenter class >> debuggingExtensionToolName [
	^'Test extendedDebuggingToolTitle'
	
]

{ #category : #mocks }
StDummyDebuggerPresenter >> copyStackToClipboard [
tag := #copyStackToClipboard.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createMissingClass [
tag := #createMissingClass.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createMissingMethod [
tag := #createMissingMethod.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createSubclassResponsibility [
tag := #createSubclassResponsibility.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> fileOutSelectedContext [
tag := #fileOutSelectedContext.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> proceedDebugSession [
tag := #proceedDebugSession.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> restartCurrentContext [
tag := #restartCurrentContext.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> returnEnteredValue [
tag := #returnEnteredValue.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> runToSelection [
tag := #runToSelection.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> selectNextExecutedExpression [
tag := #selectNextExecutedExpression.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> showFullStack [
tag := #showFullStack.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepInto [
tag := #stepInto.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepOver [
tag := #stepOver.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepThrough [
tag := #stepThrough.
^true
]

{ #category : #accessing }
StDummyDebuggerPresenter >> tag [
	^ tag
]
