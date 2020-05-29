Class {
	#name : #StDebuggerUsingSpecSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'specSelector'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #running }
StDebuggerUsingSpecSelectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	specSelector := StDebuggerUsingSpecSelector new
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testCustomSelectExtensionActivationSpecFrom [
	| customSelector mockSelector |
	customSelector := #columnInspectorsSpec.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testCustomSelectSpecSelector [
	| customSelector mockSelector |
	customSelector := #columnInspectorsSpec.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsNoneActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsNoneActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testDebuggerClass [
	self assert: specSelector debuggerClass identicalTo: StDebugger
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testDefaultSelector [
	self
		assert: StDebuggerUsingSpecSelector defaultSelector specSelector
		equals: specSelector class defaultDebuggerWithExtensionSpecSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testIsDefaultSelector [
	self deny: (specSelector isDefaultSelector: #anySelector).
	self
		assert:
			(specSelector
				isDefaultSelector: specSelector class defaultDebuggerWithExtensionSpecSelector).
	self
		assert:
			(specSelector
				isDefaultSelector: specSelector class defaultDebuggerWithoutExtensionSpecSelector)
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testNilSelectSpecSelector [
	| withExtensionSelector withoutExtensionSelector  mockSelector |
	withExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithExtensionSpecSelector.
	withoutExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithoutExtensionSpecSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsNoneActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsNoneActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withExtensionSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectExtensionActivationSpecFrom [
	| withExtensionSelector withoutExtensionSelector mockSelector |
	withExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithExtensionSpecSelector.
	withoutExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithoutExtensionSpecSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock	
		initializeExtensionsNoneActivated.
		
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withExtensionSelector.
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectSpecSelector [
	| withExtensionSelector withoutExtensionSelector mockSelector |
	withExtensionSelector := StDebuggerUsingSpecSelector
		defaultDebuggerWithExtensionSpecSelector.
	withoutExtensionSelector := StDebuggerUsingSpecSelector
		defaultDebuggerWithoutExtensionSpecSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsNoneActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsNoneActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeNoExtensionsActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeExtensionsActivated.
		mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withExtensionSelector.
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectorForDebuggerStatusExtensionsStatus [
	| selector |
	selector := specSelector
		selectorForDebuggerStatus: false
		extensionsStatus: false.
	self
		assert: selector
		equals: specSelector class defaultDebuggerWithoutExtensionSpecSelector.
		
	selector := specSelector
		selectorForDebuggerStatus: true
		extensionsStatus: false.
	self
		assert: selector
		equals: specSelector class defaultDebuggerWithoutExtensionSpecSelector.
		
	selector := specSelector
		selectorForDebuggerStatus: false
		extensionsStatus: true.
	self
		assert: selector
		equals: specSelector class defaultDebuggerWithoutExtensionSpecSelector.
		
	selector := specSelector
		selectorForDebuggerStatus: true
		extensionsStatus: true.
	self
		assert: selector
		equals: specSelector class defaultDebuggerWithExtensionSpecSelector
]
