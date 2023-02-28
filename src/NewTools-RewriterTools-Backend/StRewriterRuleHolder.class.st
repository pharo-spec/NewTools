"
I am a class that is used only to store the information of a rule
"
Class {
	#name : #StRewriterRuleHolder,
	#superclass : #Object,
	#instVars : [
		'lhs',
		'rhs',
		'isForMethod',
		'name',
		'pharoCode'
	],
	#category : #'NewTools-RewriterTools-Backend-DataStructure'
}

{ #category : #'instance creation' }
StRewriterRuleHolder class >> lhs: lhs rhs: rhs [

	^ self new
		lhs: lhs;
		rhs: rhs;
		yourself
]

{ #category : #'instance creation' }
StRewriterRuleHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isRuleForMethod: isForMethod;
		yourself
]

{ #category : #'instance creation' }
StRewriterRuleHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod pharoCode: inputCode [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isRuleForMethod: isForMethod;
		pharoCode: inputCode;
		yourself
]

{ #category : #'instance creation' }
StRewriterRuleHolder class >> lhs: lhs rhs: rhs name: aName [

	^ self new
		lhs: lhs;
		rhs: rhs;
		name: aName;
		yourself
]

{ #category : #'instance creation' }
StRewriterRuleHolder class >> lhs: lhs rhs: rhs pharoCode: aString [

	^ self new
		lhs: lhs;
		rhs: rhs;
		pharoCode: aString;
		yourself
]

{ #category : #initialization }
StRewriterRuleHolder >> initialize [

	super initialize.
	isForMethod := false.
	pharoCode := ''
]

{ #category : #accessing }
StRewriterRuleHolder >> isRuleForMethod [

	^ isForMethod
]

{ #category : #accessing }
StRewriterRuleHolder >> isRuleForMethod: anObject [

	isForMethod := anObject
]

{ #category : #accessing }
StRewriterRuleHolder >> lhs [

	^ lhs
]

{ #category : #accessing }
StRewriterRuleHolder >> lhs: anObject [

	lhs := anObject
]

{ #category : #accessing }
StRewriterRuleHolder >> name [

	^ name
]

{ #category : #accessing }
StRewriterRuleHolder >> name: aString [

	name := aString
]

{ #category : #accessing }
StRewriterRuleHolder >> pharoCode [

	^ pharoCode
]

{ #category : #accessing }
StRewriterRuleHolder >> pharoCode: anObject [

	pharoCode := anObject
]

{ #category : #accessing }
StRewriterRuleHolder >> rhs [

	^ rhs
]

{ #category : #accessing }
StRewriterRuleHolder >> rhs: anObject [

	rhs := anObject
]
