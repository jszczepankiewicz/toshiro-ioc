package org.toshiroioc.test
{
	import flexunit.framework.TestCase;
	
	import mx.core.ByteArrayAsset;
	
	public class BaseTestCase  extends TestCase{
		
		public function BaseTestCase(methodName:String){
			super(methodName);
		}
		
		public function constructXMLFromEmbed(clazz:Class):XML{		
			var byteArrayAsset:ByteArrayAsset = ByteArrayAsset(new clazz());			
			return new XML(byteArrayAsset.toString());
		}
		
		

	}
}