Extension { #name : #Context }

{ #category : #'*Emergency-Debugger' }
Context >> printWithArgsValueOn: aStream [
	| keywords |
	aStream << self method methodClass name.
	aStream << '>>'.
	self arguments
		ifEmpty: [ aStream << self method name.
			^ self ].
	keywords := self method selector keywords.
	1 to: keywords size
		do: [ :i | 
			| keyword argName argValue |
			keyword := keywords at: i.
			argName := self method argumentNames at: i.
			argValue := self arguments at: i.
			aStream << keyword.
			aStream space.
			aStream << argName.
			aStream space.
			aStream << '('.
			aStream << argValue printString.
			aStream << ')' ]
]
