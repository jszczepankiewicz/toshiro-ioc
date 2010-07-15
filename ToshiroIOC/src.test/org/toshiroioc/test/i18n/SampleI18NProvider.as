package org.toshiroioc.test.i18n
{
	import org.toshiroioc.plugins.i18n.II18NProvider;

	public class SampleI18NProvider implements II18NProvider
	{
		public var objects:Array = new Array;
		public var beanIds:Array = new Array;
		
		public function getString(obj:Object, accessorName:String, beanId:String):String
		{
			objects.push(obj);
			beanIds.push(beanId);
			
			return accessorName+'translation';
		}
		
	}
}