Class {
	#name : #OCBreakpoint,
	#superclass : #Breakpoint,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #links }
OCBreakpoint >> haltOnAccessLink [
	^ MetaLink new
		metaObject: Halt;
		selector: #now
]

{ #category : #install }
OCBreakpoint >> installOn: anObject for: methodName [
	self always.
	anObject link: self link toMethodNamed: methodName
]

{ #category : #install }
OCBreakpoint >> installOn: anObject for: methodName condition: conditionBlock arguments: anArray [
	<debuggerCompleteToSender>
	self always.
	self link
		metaObject: [ :context :selector | 
			"| originalContext |
		
			originalContext := context.
			[ originalContext selector = selector ] whileFalse: [ originalContext := originalContext sender ].
			context terminateTo: originalContext sender."
			Break break.			
			 ];
		selector: #value:value:;
		"condition: conditionBlock" arguments: anArray.
	anObject link: self link toMethodNamed: methodName
]
