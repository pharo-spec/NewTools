Extension { #name : 'OpalCompiler' }

{ #category : '*NewTools-Finder' }
OpalCompiler >> evaluateWithTimeOut: anInteger [ 

	| runner |

	runner := TKTLocalProcessTaskRunner new.
	^ runner 
		schedule: [ self evaluate ] asTask
		timeout: anInteger milliSeconds.

]
