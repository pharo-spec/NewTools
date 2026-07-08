Extension { #name : 'StringTest' }

{ #category : '*NewTools-Inspector-Extensions' }
StringTest >> testStDisplayString [

	| largeString expectedPrintString |
	largeString := String loremIpsum: 1001.
	expectedPrintString :=  '''' , (largeString truncateTo: 995) , '[..]'.

	self assert: 'test' stDisplayString equals: '''test'''.
	self assert: largeString stDisplayString equals: expectedPrintString
]
