package org.toshiroioc.core
{
	import __AS3__.vec.Vector;
	
	public interface IClassPostprocessor
	{
		function listClassInterests():Vector.<Class>;
		
		function postprocessObject(object:*):*;
		
		function onContextLoaded():void;
		
	}
}