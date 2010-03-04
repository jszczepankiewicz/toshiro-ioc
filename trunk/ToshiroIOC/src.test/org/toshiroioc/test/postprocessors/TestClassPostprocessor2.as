package org.toshiroioc.test.postprocessors
{
	import org.toshiroioc.core.IClassPostprocessor;
	import org.toshiroioc.test.beans.SimpleBeanWithPostprocessor;
	

	public class TestClassPostprocessor2 implements IClassPostprocessor
	{
		private var classVector: Vector.<Class>;
		
		public function TestClassPostprocessor2():void{
			classVector = new Vector.<Class>();
			classVector.push(SimpleBeanWithPostprocessor);
		}
		public function listClassInterests():Vector.<Class>
		{
			return classVector;
			
		}
		
		public function postprocessObject(object:*):*
		{
			var obj:SimpleBeanWithPostprocessor = object as SimpleBeanWithPostprocessor;
			if(obj.testField)
				obj.testField2 = true;
			obj.commonField = obj.commonField+1;
		}
		public function onContextLoaded():void{
		}
	}
}