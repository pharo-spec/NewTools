"
I provide utility methods to request protocols from users. 
"
Class {
	#name : #StDebuggerProtocolRequestor,
	#superclass : #Object,
	#category : #'NewTools-Debugger-View'
}

{ #category : #'ui requests' }
StDebuggerProtocolRequestor class >> requestProtocolFor: aMethod [

	| entryCompletion applicants choice |
	applicants := AbstractTool protocolSuggestionsFor: aMethod methodClass.
	entryCompletion := EntryCompletion new
		                   dataSourceBlock: [ :currText | applicants ];
		                   filterBlock: [ :currApplicant :currText | 
			                   currText size > 3 and: [ 
					                   currApplicant asLowercase includesSubstring:
							                   currText asString asLowercase ] ].

	choice := (UIManager default
		           request:
		           'Start typing for suggestions (3 characters minimum)'
		           initialAnswer: (aMethod protocol)
		           title: 'Choose a protocol'
		           entryCompletion: entryCompletion) ifNil: [ Abort signal ].

	^ choice ifEmpty: [ Protocol unclassified ]
]
