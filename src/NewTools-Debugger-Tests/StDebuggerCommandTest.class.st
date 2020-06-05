Class {
	#name : #StDebuggerCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'session'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithDNUContext [
	[ Object new toto ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithErrorContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithFailingTestContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithMissingClassContext [
	[ MissingClass new]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext copy.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithMissingSubclassResponsibilityContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithRunnableContext [
	[ Halt now ]
		on: Halt
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> newDebugger [
	^ StDebugger basicNew
		session: session;
		yourself
]

{ #category : #helpers }
StDebuggerCommandTest >> sessionFor: aContext [
	| process |
	process := Process
		forContext: aContext
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: aContext
]

{ #category : #running }
StDebuggerCommandTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp
]

{ #category : #running }
StDebuggerCommandTest >> tearDown [ 
	session ifNotNil:[session terminate].
	super tearDown
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInDNUContext [

	|debugger|
	debugger := self debuggerWithDNUContext.
	
	"Executable commands relative to context"
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInErrorContext [

	|debugger|
	debugger := self debuggerWithErrorContext.
		
	"Executable commands relative to context"	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInFailingTestContext [

	|debugger|
	debugger := self debuggerWithDNUContext.
	self fail.
	
	"Executable commands relative to context"
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self deny: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self deny: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self deny: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self deny: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.   
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInMissingClassContext [
	"When a class is missing, it is possible we are trying to send it a message.
	Define new class and define new method must be possible. "

	|debugger|
	debugger := self debuggerWithMissingClassContext.
	
	"Executable commands relative to context"	
	self assert: (StDefineClassCommand forContext: debugger) canBeExecuted.	
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted. 
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInMissingSubclassResponsibilityContext [

	|debugger|
	self fail.
	debugger := self debuggerWithRunnableContext.
	
	"Executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self assert: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted. 	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.	
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.  	 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInRunnableContext [

	|debugger|
	debugger := self debuggerWithRunnableContext.
	
	"Executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self assert: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted. 	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.	
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.  	 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStCopyStackToClipboardCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StCopyStackToClipboardCommand forContext: debugger.
	"StCopyStackToClipboardCommand command calls the #copyStackToClipboard action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #copyStackToClipboard
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStDefineClassCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineClassCommand forContext: debugger.
	"StDefineClassCommand command calls the #createMissingClass action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #createMissingClass
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStDefineMethodCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineMethodCommand forContext: debugger.
	"StDefineMethodCommand command calls the #createMissingMethod action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #createMissingMethod
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStDefineSubclassResponsabilityCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StDefineSubclassResponsabilityCommand forContext: debugger.
	"StDefineSubclassResponsabilityCommand command calls the #createSubclassResponsibility action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #createSubclassResponsibility
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStFileOutMethodCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StFileOutMethodCommand forContext: debugger.
	"StFileOutMethodCommand command calls the #fileOutSelectedContext action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #fileOutSelectedContext
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStPeelToFirstCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StPeelToFirstCommand forContext: debugger.
	"StPeelToFirstCommand command calls the #copyStackToClipboard action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #copyStackToClipboard
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStProceedCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StProceedCommand forContext: debugger.
	"StProceedCommand command calls the #proceedDebugSession action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #proceedDebugSession
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStRestartCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StRestartCommand forContext: debugger.
	"StRestartCommand command calls the #restartCurrentContext action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #restartCurrentContext
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStReturnValueCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StReturnValueCommand forContext: debugger.
	"StReturnValueCommand command calls the #returnEnteredValue action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #returnEnteredValue
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStRunToSelectionCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StRunToSelectionCommand forContext: debugger.
	"StRunToSelectionCommand command calls the #runToSelection action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #runToSelection
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStShowFullStackCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StShowFullStackCommand forContext: debugger.
	"StShowFullStackCommand command calls the #showFullStack action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #showFullStack
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStStepIntoCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepIntoCommand forContext: debugger.
	"StStepIntoCommand command calls the #stepInto action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepInto
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStStepOverCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepOverCommand forContext: debugger.
	"StStepOverCommand command calls the #stepOver action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepOver
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStStepThroughCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StStepThroughCommand forContext: debugger.
	"StStepThroughCommand command calls the #stepThrough action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #stepThrough
]

{ #category : #'tests - execution' }
StDebuggerCommandTest >> testStWhereIsCommandExecution [
	"Generated 5 June 2020"
	|debugger command|
	debugger := StDummyDebuggerPresenter new.
	command := StWhereIsCommand forContext: debugger.
	"StWhereIsCommand command calls the #selectNextExecutedExpression action interface of the debugger object"
	command execute.
	self assert: debugger tag equals: #selectNextExecutedExpression
]
