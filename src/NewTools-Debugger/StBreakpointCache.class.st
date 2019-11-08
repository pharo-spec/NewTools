"
I cache all message nodes that:
- are halts
- have a breakpoint on them

The cache is built when I am initialized, then I register to the method changes system announcement to update the cache each time a method is added, modified or removed.
"
Class {
	#name : #StBreakpointCache,
	#superclass : #Object,
	#instVars : [
		'haltNodes',
		'breakpointNodes'
	],
	#category : #'NewTools-Debugger-Model'
}
