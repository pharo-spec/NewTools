Class {
	#name : 'StObjectContextModelTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'tests' }
StObjectContextModelTest >> testStringWithoutInitialCommentFrom [
	| model string | 
		
	model := StObjectContextModel new.
	
	self assert: (model stringWithoutInitialCommentFrom: 'self') equals: 'self'. 
	self assert: (model stringWithoutInitialCommentFrom: '"self" 42') equals: '42'. 	
	
	string := '"some thing in 
several 
lines"
42 "other"'.
	self assert: (model stringWithoutInitialCommentFrom: string) equals: '42 "other"'. 		
]
