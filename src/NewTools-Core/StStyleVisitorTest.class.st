Class {
	#name : #StStyleVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #'NewTools-Core'
}

{ #category : #accessing }
StStyleVisitorTest class >> syntaxInAPostcard [

	^ 'exampleWithNumber: x

"A method that illustrates every part of Smalltalk method syntax
except primitives. It has unary, binary, and keyword messages,
declares arguments and temporaries, accesses a global variable
(but not and instance variable), uses literals (array, character,
symbol, string, integer, float), uses the pseudo variables
true false, nil, self, and super, and has sequence, assignment,
return and cascade. It has both zero argument and one argument blocks."	

    |y|
    true & false not & (nil isNil) ifFalse: [self halt].
    y := self size + super size.
    #($a #a "a" 1 1.0)
        do: [:each | 
				Transcript 
					show: (each class name);
     				show: '' ''].
    ^ x < y'
]

{ #category : #running }
StStyleVisitorTest >> setUp [
	
	super setUp.
	visitor := StStyleVisitor new
]

{ #category : #tests }
StStyleVisitorTest >> testVisitMethod [
	| tags |

	"smoke test"
	visitor 
		contextClass: Object;
		visitMethod: self class syntaxInAPostcard.
	"basic test"
	tags := visitor 
		contextClass: Object;
		visitMethod: 'self asString'.
	
	self assert: tags size equals: 2
]
