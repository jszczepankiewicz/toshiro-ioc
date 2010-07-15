package org.toshiroioc.plugins.i18n
{
	public interface II18NProvider
	{
		function getString(obj:Object, accessorName:String, beanId:String):String;
		
	}
}