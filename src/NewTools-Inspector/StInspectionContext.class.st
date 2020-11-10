Class {
	#name : #StInspectionContext,
	#superclass : #Object,
	#instVars : [
		'active',
		'default',
		'title',
		'order',
		'methodSelector'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #'instance creation' }
StInspectionContext class >> fromPragma: aPragma [

	^ self new 
		fromPragma: aPragma;
		yourself
]

{ #category : #accessing }
StInspectionContext >> active: aBoolean [

	active := aBoolean
]

{ #category : #accessing }
StInspectionContext >> beDefault [

	self default: true
]

{ #category : #accessing }
StInspectionContext >> contextMethodSelector [

	^ (self methodSelector, 'Context:') asSymbol
]

{ #category : #accessing }
StInspectionContext >> default: aBoolean [

	default := aBoolean
]

{ #category : #initialization }
StInspectionContext >> fromPragma: aPragma [

	self
		order: (aPragma argumentAt: 1);
		title: (aPragma argumentAt: 2);
		methodSelector: aPragma methodSelector
]

{ #category : #initialization }
StInspectionContext >> initialize [

	super initialize.
	active := true.
	default := false
]

{ #category : #testing }
StInspectionContext >> isActive [

	^ active
]

{ #category : #testing }
StInspectionContext >> isDefault [

	^ default
]

{ #category : #accessing }
StInspectionContext >> methodSelector [
	^ methodSelector
]

{ #category : #accessing }
StInspectionContext >> methodSelector: anObject [
	methodSelector := anObject
]

{ #category : #accessing }
StInspectionContext >> order [
	^ order
]

{ #category : #accessing }
StInspectionContext >> order: anObject [
	order := anObject
]

{ #category : #accessing }
StInspectionContext >> title [
	^ title
]

{ #category : #accessing }
StInspectionContext >> title: anObject [
	title := anObject
]
