package org.toshiroioc.test.postprocessors
{
	import org.toshiroioc.core.IClassPostprocessor;
	import org.toshiroioc.test.beans.SimpleBeanWithPostprocessor;
	

	public class TestClassPostprocessor implements IClassPostprocessor
	{
		private var classVector: Vector.<Class>;
		
		public function TestClassPostprocessor():void{
			classVector = new Vector.<Class>();
			classVector.push(SimpleBeanWithPostprocessor);
		}
		public function listClassInterests():Vector.<Class>
		{
			return classVector;
			
		}
		
		public function postprocessObject(object:*):*
		{
			var obj:SimpleBeanWithPostprocessor = object;
			if(!obj.testField2)
				obj.testField = true;
			obj.commonField = 1;
			return object;
		}
		
		public function onContextLoaded():void{
		}
		
		
	}
}