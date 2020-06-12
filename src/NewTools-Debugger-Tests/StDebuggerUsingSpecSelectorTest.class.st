Class {
	#name : #StDebuggerUsingSpecSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'specSelector'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #helpers }
StDebuggerUsingSpecSelectorTest >> defaultSelectorWithExtensions [
	^ StDebuggerUsingSpecSelector
		defaultDebuggerWithExtensionSpecSelector
]

{ #category : #helpers }
StDebuggerUsingSpecSelectorTest >> defaultSelectorWithoutExtensions [
	^ StDebuggerUsingSpecSelector
		defaultDebuggerWithoutExtensionSpecSelector
]

{ #category : #running }
StDebuggerUsingSpecSelectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	specSelector := StDebuggerUsingSpecSelector new
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testCustomSelectExtensionActivationSpecFrom [
	| customSelector mockSelector |
	customSelector := #anySelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: customSelector)
		equals: customSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testCustomSelectSpecSelector [
	| customSelector mockSelector |
	
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsNoneActivated.
	customSelector := mockSelector nonDefaultSelector.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	mockSelector specSelector: customSelector.
	self assert: mockSelector selectSpecSelector equals: customSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
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
		initializeWithExtensionsNoneActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
	mockSelector specSelector: nil.
	self assert: mockSelector selectSpecSelector equals: withExtensionSelector
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectExtensionActivationSpecFrom [
	| withExtensionSelector withoutExtensionSelector mockSelector |
	withExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithExtensionSpecSelector.
	withoutExtensionSelector := StDebuggerUsingSpecSelector defaultDebuggerWithoutExtensionSpecSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock	
		initializeWithExtensionsNoneActivated.
		
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withoutExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withoutExtensionSelector.
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withExtensionSelector)
		equals: withExtensionSelector.
	self
		assert: (mockSelector selectExtensionActivationSpecFrom: withoutExtensionSelector)
		equals: withExtensionSelector.
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectNonDefaultSpecSelector [
	| nonDefaultSelector mockSelector |		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsNoneActivated.
	nonDefaultSelector := mockSelector nonDefaultSelector.
	mockSelector specSelector: nonDefaultSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: nonDefaultSelector.		
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	mockSelector specSelector: nonDefaultSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: nonDefaultSelector.
				
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	mockSelector specSelector: nonDefaultSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: nonDefaultSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
		mockSelector specSelector: nonDefaultSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: nonDefaultSelector
	
]

{ #category : #'tests - spec' }
StDebuggerUsingSpecSelectorTest >> testSelectSpecSelector [
	| withExtensionSelector withoutExtensionSelector mockSelector |
	withExtensionSelector := StDebuggerUsingSpecSelector
		defaultDebuggerWithExtensionSpecSelector.
	withoutExtensionSelector := StDebuggerUsingSpecSelector
		defaultDebuggerWithoutExtensionSpecSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsNoneActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsNoneActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithoutExtensionsAllActivated.
	mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
		
	mockSelector := StDebuggerUsingSpecSelectorMock
		initializeWithExtensionsAllActivated.
		mockSelector specSelector: withExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withExtensionSelector.
		
	mockSelector specSelector: withoutExtensionSelector.	
	self
		assert: mockSelector selectSpecSelector
		equals: withoutExtensionSelector.
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
