Extension { #name : 'OCProgramNode' }

{ #category : '*NewTools-Inspector-Extensions' }
OCProgramNode >> inspectionAST [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ SpTreePresenter new 
		roots: { self };
		children: [ :aNode | aNode children ];
		display: [ :each | 
			String
				streamContents: [ :stream | 
					stream
						nextPutAll: each class name;
						nextPut: $(;
						nextPutAll: ((each sourceCode truncateTo: 50) copyReplaceAll: String cr with: String space);
						nextPut: $)
			 ] ];
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
OCProgramNode >> inspectionASTDump [

	  <inspectorPresentationOrder: 50 title: 'AST Dump'>
	  ^ SpCodePresenter new
		    text: (OCParser parseExpression: self dump) formattedCode;
		    beForScripting;
		    "this is an expression"yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
OCProgramNode >> inspectionSource [
	<inspectorPresentationOrder: 30 title: 'Method Source'>

	^ SpCodePresenter new 
		beForMethod: self methodNode;
		text: (self source ifNil: [ self formattedCode ]);
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceInterval first to: self sourceInterval last + 1);
			yourself);
		yourself
]
