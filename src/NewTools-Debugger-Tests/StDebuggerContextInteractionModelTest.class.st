Class {
	#name : #StDebuggerContextInteractionModelTest,
	#superclass : #TestCase,
	#instVars : [
		'instanceVariableForTest',
		'model'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #running }
StDebuggerContextInteractionModelTest >> setUp [

	| context |
	super setUp.
	context := [ self helperMethodForBindings ] asContext.
	context := context stepToCallee.
	model := StDebuggerContextInteractionModel new.
	model context: context.
	model addBinding: (WorkspaceVariable key: 'toto' value: 41)

	"Put here a common initialization logic for tests"
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testAddBinding [

	self assert: (model bindingOf: 'tata') equals: nil.

	model addBinding: (WorkspaceVariable key: 'tata' value: 'titi').

	self
		assert: ((model bindingOf: 'tata') readInContext: model context)
		equals: 'titi'
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testAddBindingDeletesOldBindingIfSameKey [

	self
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 41.

	model addBinding: (WorkspaceVariable key: 'toto' value: 42).

	self
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 42
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testBindingOf [

	"These are values given in the setUp method and in the helper method"

	self
		assert:
			((model bindingOf: 'tempVariableForTest') readInContext:
					 model context)
		equals: nil;
		assert:
			((model bindingOf: 'instanceVariableForTest') readInContext:
					 model context)
		equals: nil;
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 41.
	"we step until variables are assigned in context"
	model context
		step;
		step;
		step;
		step.

	self
		assert:
			((model bindingOf: 'tempVariableForTest') readInContext:
					 model context)
		equals: 43;
		assert:
			((model bindingOf: 'instanceVariableForTest') readInContext:
					 model context)
		equals: 42;
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 41
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testBindingOfPrioritizesContextBindingsToInteractionModelBindings [

	"These are values given in the setUp method and in the helper method"

	"we step until variables are assigned in context"

	model context
		step;
		step;
		step;
		step.

	self
		assert:
			((model bindingOf: 'instanceVariableForTest') readInContext:
				 model context)
		equals: 42.
		
	model addBinding: (WorkspaceVariable key: 'instanceVariableForTest' value: 'toto').
	
	self
		assert:
			((model bindingOf: 'instanceVariableForTest') readInContext:
				 model context)
		equals: 42.
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testHasBindingsInContextOf [

	self
		assert: (model hasBindingInContextOf: 'tempVariableForTest');
		assert: (model hasBindingInContextOf: 'instanceVariableForTest');
		assert: (model hasBindingInContextOf: 'toto') not;
		assert: (model hasBindingInContextOf: 'tata') not
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testHasBindingsInInteractionModelOf [

	self
		assert:
			(model hasBindingInInteractionModelOf: 'tempVariableForTest') not;
		assert:
			(model hasBindingInInteractionModelOf: 'instanceVariableForTest')
				not;
		assert: (model hasBindingInInteractionModelOf: 'toto');
		assert: (model hasBindingInInteractionModelOf: 'tata') not
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testHasBindingsReturnsTrueWhenVariableIsInContextOrInInteractionModel [

	self
		assert: (model hasBindingOf: 'tempVariableForTest');
		assert: (model hasBindingOf: 'instanceVariableForTest');
		assert: (model hasBindingOf: 'toto');
		assert: (model hasBindingOf: 'tata') not
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testHasUnsavedCodeChanges [

	| code |
	model context: [  ] asContext.
	code := SpCodePresenter new text: [  ] asContext sourceCode.
	model owner: code.
	
	self deny: model hasUnsavedCodeChanges.
	
	code text: 'changed source'.
	self assert: model hasUnsavedCodeChanges
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testInteractionModelArePreservedAfterChangingContext [

	self
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 41.
	self assert: (model hasBindingOf: 'tempVariableForTest').

	model context: [  ] asContext.

	self
		assert: ((model bindingOf: 'toto') readInContext: model context)
		equals: 41.
	self assert: (model hasBindingOf: 'tempVariableForTest') not
]

{ #category : #tests }
StDebuggerContextInteractionModelTest >> testNilContextModel [

	self deny:
		StDebuggerContextInteractionModel new hasUnsavedCodeChanges
]
