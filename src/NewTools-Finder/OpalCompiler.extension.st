Extension { #name : 'OpalCompiler' }

{ #category : '*NewTools-Finder' }
OpalCompiler >> evaluateWithTimeOut: anInteger [ 

	"| runner |

	runner := TKTLocalProcessTaskRunner new.
	^ runner 
		schedule: [ self evaluate ] asTask
		timeout: anInteger milliSeconds."
		
	"See issue https://github.com/pharo-project/pharo/issues/16759"
	self flag: #ToDo.
	^ self evaluate

]
