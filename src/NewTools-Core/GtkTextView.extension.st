Extension { #name : #GtkTextView }

{ #category : #'*NewTools-Core' }
GtkTextView >> expressionText: aString [ 
	| codeBuffer |
	
	codeBuffer := GtkTextBuffer newTable: GtkTextTagTable newForCode.
	codeBuffer text: aString.
	(StStyleVisitor new 
		visitExpression: aString)
		do: [ :each | each acceptTextBuffer: codeBuffer ].
	
	self textBuffer: codeBuffer
]

{ #category : #'*NewTools-Core' }
GtkTextView >> methodText: aString class: aClass [ 
	| codeBuffer |
	
	codeBuffer := GtkTextBuffer newTable: GtkTextTagTable newForCode.
	codeBuffer text: aString.
	(StStyleVisitor new 
		contextClass: aClass;
		visitMethod: aString)
		do: [ :each | each acceptTextBuffer: codeBuffer ].
	
	self textBuffer: codeBuffer
]
